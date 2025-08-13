#!/bin/bash
set -euo pipefail

DB_PATH="database.db"         # Path to your SQLite database file
OUT_DIR="hcl"                 # Output folder for HCL files
SCHEMA_NAME="main"            # Adjust if your schema name is different

mkdir -p "$OUT_DIR"

# Map SQLite type to HCL type
map_type() {
  local t
  t=$(echo "$1" | tr '[:upper:]' '[:lower:]')  # lowercase safely
  t="${t//,/}"
  t="${t//  / }"

  case "$t" in
    integer|int|tinyint|smallint|mediumint|bigint)
      echo "int"; return;;
    boolean|bool)
      echo "bool"; return;;
    text)
      echo "text"; return;;
  esac

  if [[ "$t" =~ ^(var)?char\([0-9]+\)$ ]]; then
    echo "$t"; return;
  fi

  case "$t" in
    real|double|float|numeric|decimal*)
      echo "numeric"; return;;
    blob)
      echo "blob"; return;;
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

  [[ "${dflt^^}" == "NULL" ]] && { echo ""; return; }

  echo "$dflt"
}

# Get all user tables
tables=$(sqlite3 "$DB_PATH" "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;")

while IFS= read -r table; do
  [[ -z "$table" ]] && continue
  outfile="$OUT_DIR/$table.hcl"
  : > "$outfile"

  {
    echo "schema \"$SCHEMA_NAME\" {}"
    echo
    echo "table \"$table\" {"
    echo "  schema = schema.$SCHEMA_NAME"
    echo
  } >> "$outfile"

  sqlite3 -separator '|' "$DB_PATH" "PRAGMA table_info('$table');" | while IFS='|' read -r cid name type notnull dflt pk; do
    hcl_type=$(map_type "$type")
    nullable="true"
    [[ "$notnull" -eq 1 ]] && nullable="false"

    echo "  column \"$name\" {" >> "$outfile"
    echo "    type = $hcl_type" >> "$outfile"
    echo "    null = $nullable" >> "$outfile"

    fmt_def="$(format_default "$dflt" "$hcl_type")"
    [[ -n "$fmt_def" ]] && echo "    default = $fmt_def" >> "$outfile"

    echo "  }" >> "$outfile"
    echo >> "$outfile"
  done

  pk_cols=$(sqlite3 -separator '|' "$DB_PATH" \
    "SELECT name FROM pragma_table_info('$table') WHERE pk>0 ORDER BY pk;")

  if [[ -n "$pk_cols" ]]; then
    printf "  primary_key {\n" >> "$outfile"
    printf "    columns = [" >> "$outfile"
    first=1
    while IFS= read -r pkc; do
      [[ -z "$pkc" ]] && continue
      if [[ $first -eq 1 ]]; then
        printf "column.%s" "$pkc" >> "$outfile"
        first=0
      else
        printf ", column.%s" "$pkc" >> "$outfile"
      fi
    done <<< "$pk_cols"
    printf "]\n" >> "$outfile"
    printf "  }\n" >> "$outfile"
  fi

  echo "}" >> "$outfile"
  echo "Wrote $outfile"
done <<< "$tables"

echo "Done. HCL files are in $OUT_DIR/"
