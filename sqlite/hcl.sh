#!/bin/bash
set -euo pipefail

# Database configuration
DB_ENGIN="sqlite"                             # Database engine
DB_Name="database"                            # Database name
DB_FILE="./${DB_ENGIN}/${DB_Name}.db"         # Path to database file
OUT_DIR="./${DB_ENGIN}/hcl"                   # Output directory for HCL
SCHEMA_NAME="main"                            # Schema name
COMBINED="$OUT_DIR/${DB_Name}.hcl"            # Single output HCL file

echo -e "\n"
echo "Database Engine: $DB_ENGIN"
echo "Database Name: $DB_Name"
echo "Database File: $DB_FILE"
echo "Done. Combined HCL written to: $COMBINED"
echo -e "\n"

mkdir -p "$OUT_DIR"

# Map SQLite type to HCL type
map_type() {
  local t
  t=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  t="${t//,/}"
  t="${t//  / }"

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

  dflt="$(echo -n "$dflt" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

  if [[ "$dflt" =~ ^\'.*\'$ || "$dflt" =~ ^\".*\"$ ]]; then
    echo "$dflt"; return
  fi

  if [[ "$hcl_type" == "bool" ]]; then
    [[ "$dflt" == "1" ]] && echo "true" && return
    [[ "$dflt" == "0" ]] && echo "false" && return
  fi

  if [[ "$(printf '%s' "$dflt" | tr '[:lower:]' '[:upper:]')" == "NULL" ]]; then
    echo ""
    return
  fi

  echo "$dflt"
}

# Start combined file
{
  echo "schema \"$SCHEMA_NAME\" {}"
  echo
} > "$COMBINED"

# Get all user tables
tables=$(sqlite3 "$DB_FILE" \
  "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;")

# Append each table block
while IFS= read -r table; do
  [[ -z "$table" ]] && continue

  {
    echo "table \"$table\" {"
    echo "  schema = schema.$SCHEMA_NAME"
    echo

    sqlite3 -separator '|' "$DB_FILE" "PRAGMA table_info('$table');" \
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

    pk_cols=$(sqlite3 -separator '|' "$DB_FILE" \
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

echo -e "\n"