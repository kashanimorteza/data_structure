#!/bin/bash

DB_PATH="./sqlite/sqlite.db" # Path to your SQLite database file
ROOT="./sqlite/sql"          # Where to put the migration folders

# Make sure the root migration directory exists
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
