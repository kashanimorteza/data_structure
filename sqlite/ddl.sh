#!/bin/bash
set -euo pipefail

# Config
DB_ENGIN="sqlite"                             # Database engine
DB_Name="database"                            # Database name
HCL_DIR="./${DB_ENGIN}/hcl"
OUT_DIR="./${DB_ENGIN}/ddl"
DEV_URL='sqlite://dev?mode=memory'

# Checks
command -v atlas >/dev/null 2>&1 || { echo "Error: atlas CLI not found in PATH" >&2; exit 1; }
mkdir -p "$OUT_DIR"

shopt -s nullglob
files=( "$HCL_DIR"/*.hcl )

if (( ${#files[@]} == 0 )); then
  echo "No .hcl files found in $HCL_DIR"
  exit 0
fi

for file in "${files[@]}"; do
  base="${file##*/}"      # e.g., user.hcl or hcl.hcl
  name="${base%.hcl}"     # e.g., user or hcl

  echo "==> Generating DDL for '$name' from '$file' into '$OUT_DIR/'"
  atlas migrate diff "$name" \
    --to "file://$file" \
    --dev-url "$DEV_URL" \
    --dir "file://$OUT_DIR"
done

echo "All done. Migrations written to $OUT_DIR"
