#!/bin/bash
set -euo pipefail

# Config
DB_ENGIN="sqlite"                             # Database engine
DB_NAME="db"                            # Database name
HCL_DIR="./${DB_ENGIN}"
OUT_DIR="./${DB_ENGIN}"
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

mv ./${DB_ENGIN}/*_${DB_NAME}.sql ./${DB_ENGIN}/${DB_NAME}.sql
rm -fr ./${DB_ENGIN}/atlas.sum


echo "All done. Migrations written to $OUT_DIR"
