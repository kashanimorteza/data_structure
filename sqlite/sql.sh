#!/bin/bash
set -euo pipefail

# Database configuration
DB_ENGIN="sqlite"            # Database engine
DB_Name="database"           # Database name

# Derived paths
DB_DIR="./${DB_ENGIN}"
DB_PATH="${DB_DIR}/${DB_Name}.db"   # Path to your SQLite database file
ROOT="${DB_DIR}/sql"                # Where to put the migration folders

echo -e "\n"
echo "Done. SQL migrations under: $ROOT"
echo "DB engine: $DB_ENGIN"
echo "DB name:   $DB_Name"
echo "DB file:   $DB_PATH"
echo -e "\n"


# Ensure prerequisites
command -v sqlite3 >/dev/null 2>&1 || { echo "Error: sqlite3 not found in PATH" >&2; exit 1; }
mkdir -p "$ROOT"

# Get all user tables (skip sqlite internal tables)
tables=$(sqlite3 "$DB_PATH" "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';")

# For each table...
while IFS= read -r table; do
    [ -z "$table" ] && continue  # skip empty lines

    dir="$ROOT/$table"
    mkdir -p "$dir"

    # Get the CREATE TABLE statement
    create_sql=$(sqlite3 "$DB_PATH" "SELECT sql FROM sqlite_master WHERE type='table' AND name='$table';")

    # Write CREATE TABLE statement to up.sql
    echo "$create_sql;" > "$dir/up.sql"

    # Write DROP TABLE statement to down.sql
    echo "DROP TABLE $table;" > "$dir/down.sql"

    echo "Created $dir/up.sql and $dir/down.sql"
done <<< "$tables"

echo -e "\n"