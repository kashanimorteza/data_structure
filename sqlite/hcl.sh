#!/bin/bash
set -euo pipefail

DB_PATH="./sqlite/sqlite.db"   # Path to your SQLite database file
OUT_DIR="./sqlite/hcl"         # Output directory for HCL
SCHEMA_NAME="main"             # Change if needed
COMBINED="$OUT_DIR/hcl.hcl"    # Single output file for all tables

mkdir -p "$OUT_DIR"

# Map SQLite type to HCL type
map_type() {
  local t
  t=$(echo "$1" | tr '[:upper:]' '[:lower:]')  # lowercase safely
  t="${t//,/}"
  t="${t//  / }"

  # If the type is exactly "time", change to varchar
  if [[ "$t" == "time" ]]; then
    echo "varchar"
    return
  fi

  case "$t" in
    integer|int|tinyint|smallint|mediumint|bigint) echo "int"; return;;
    boolean|bool) echo "bool"; return;;
    text) echo "text"; return;;
  esac

  if [[ "$t" =~ ^(var)?char\([0-9]+\)$ ]]; then
    echo "$t"; return
  fi

  case "$t" in
    real|double|float|numeric|decimal*) echo "numeric"; return;;
    blob) echo "blob"; return;;
  esac

  [[ -z "$t" ]] && echo "text" || echo "$t"
}

# Format default value for HCL
format_default() {
  local dflt="$1"
  local hcl_type="$2"
  [[ -z "$dflt" ]] && { echo ""; return; }

  # trim
  dflt="$(echo -n "$dflt" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

  # Already-quoted strings stay as-is
  if [[ "$dflt" =~ ^\'.*\'$ || "$dflt" =~ ^\".*\"$ ]]; then
    echo "$dflt"; return
  fi

  # Booleans 0/1 → false/true
  if [[ "$hcl_type" == "bool" ]]; then
    [[ "$dflt" == "1" ]] && echo "true" && return
    [[ "$dflt" == "0" ]] && echo "false" && return
  fi

  # NULL → omit
  if [[ "$(printf '%s' "$dflt" | tr '[:lower:]' '[:upper:]')" == "NULL" ]]; then
    echo ""
    return
  fi

  # Functions/numerics keep as-is
  echo "$dflt"
}

# Start combined file with a single schema header
{
  echo "schema \"$SCHEMA_NAME\" {}"
  echo
} > "$COMBINED"

# Get all user tables (skip SQLite internals)
tables=$(sqlite3 "$DB_PATH" \
  "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;")

# Append each table block to the combined file
while IFS= read -r table; do
  [[ -z "$table" ]] && continue

  {
    echo "table \"$table\" {"
    echo "  schema = schema.$SCHEMA_NAME"
    echo

    # Columns: cid|name|type|notnull|dflt_value|pk
    sqlite3 -separator '|' "$DB_PATH" "PRAGMA table_info('$table');" \
    | while IFS='|' read -r cid name type notnull dflt pk; do
        hcl_type=$(map_type "$type")
        nullable="true"
        [[ "$notnull" -eq 1 ]] && nullable="false"

        echo "  column \"$name\" {"
        echo "    type = $hcl_type"
        echo "    null = $nullable"

        fmt_def="$(format_default "$dflt" "$hcl_type")"
        [[ -n "$fmt_def" ]] && echo "    default = $fmt_def"

        echo "  }"
        echo
      done

    # Primary key (ordered)
    pk_cols=$(sqlite3 -separator '|' "$DB_PATH" \
      "SELECT name FROM pragma_table_info('$table') WHERE pk>0 ORDER BY pk;")

    if [[ -n "$pk_cols" ]]; then
      printf "  primary_key {\n"
      printf "    columns = ["
      first=1
      while IFS= read -r pkc; do
        [[ -z "$pkc" ]] && continue
        if [[ $first -eq 1 ]]; then
          printf "column.%s" "$pkc"
          first=0
        else
          printf ", column.%s" "$pkc"
        fi
      done <<< "$pk_cols"
      printf "]\n"
      printf "  }\n"
    fi

    echo "}"
    echo
  } >> "$COMBINED"

  echo "Added table '$table' to $COMBINED"
done <<< "$tables"

echo "Done. Combined HCL written to: $COMBINED"
