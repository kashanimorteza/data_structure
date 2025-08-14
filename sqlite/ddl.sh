#!/bin/bash
set -euo pipefail

# Config
HCL_DIR="hcl"
OUT_DIR="ddl/sqlite"
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
  base="${file##*/}"      # e.g., user.hcl
  name="${base%.hcl}"     # e.g., user
  table_dir="$OUT_DIR/$name"

  # Make a dedicated folder per file
  mkdir -p "$table_dir"

  echo "==> Generating DDL for '$name' from '$file' into '$table_dir/'"
  atlas migrate diff "$name" \
    --to "file://$file" \
    --dev-url "$DEV_URL" \
    --dir "file://$table_dir"
done

echo "All done. Migrations written under $OUT_DIR/, one folder per HCL file."
