#!/bin/bash

# SQLite to HCL Generator Script
# Converts db.sqlite to db.hcl in Atlas HCL format

echo "🔄 Converting SQLite database to HCL schema..."
echo "📁 Working directory: $(pwd)"
echo

# Check if db.sqlite exists
if [ ! -f "db.sqlite" ]; then
    echo "❌ Error: db.sqlite file not found in current directory"
    echo "   Please make sure db.sqlite exists in database/sqlite/ directory"
    exit 1
fi

# Run the Python conversion script
python3 sqlite_to_hcl.py

if [ $? -eq 0 ]; then
    echo
    echo "✅ Conversion completed successfully!"
    echo "📄 Generated: db.hcl"
    echo
    echo "📊 File sizes:"
    ls -lh db.sqlite db.hcl
else
    echo "❌ Conversion failed!"
    exit 1
fi
