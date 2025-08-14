#!/usr/bin/env python3
"""
SQLite to HCL Generator
Converts SQLite database to Atlas HCL schema format with specific requirements:
- All id fields must be PRIMARY KEY and AUTOINCREMENT
- All enable fields must be boolean with true default value
"""

import sqlite3
import os
import sys
from typing import List, Dict, Any, Optional, Tuple


class SQLiteColumn:
    """Represents a column from SQLite"""
    def __init__(self, cid: int, name: str, type_: str, notnull: int, default: Optional[str], pk: int):
        self.cid = cid
        self.name = name
        self.type = type_.lower() if type_ else "text"
        self.notnull = bool(notnull)
        self.default = default
        self.pk = bool(pk)


class SQLiteTable:
    """Represents a table from SQLite"""
    def __init__(self, name: str, columns: List[SQLiteColumn]):
        self.name = name
        self.columns = columns
        self.primary_keys = [col.name for col in columns if col.pk]


class SQLiteToHCLConverter:
    """Converts SQLite database to HCL format with specific requirements"""
    
    def __init__(self):
        self.type_mapping = {
            'integer': 'int',
            'int': 'int',
            'bigint': 'int',
            'smallint': 'int',
            'tinyint': 'int',
            'text': 'varchar',
            'varchar': 'varchar',
            'char': 'varchar',
            'string': 'varchar',
            'real': 'float',
            'float': 'float',
            'double': 'float',
            'decimal': 'decimal',
            'numeric': 'decimal',
            'boolean': 'bool',
            'bool': 'bool',
            'date': 'date',
            'datetime': 'datetime',
            'timestamp': 'datetime',
            'time': 'varchar',
            'blob': 'blob',
            'binary': 'blob'
        }
    
    def connect_to_database(self, db_path: str) -> sqlite3.Connection:
        """Connect to SQLite database"""
        if not os.path.exists(db_path):
            raise FileNotFoundError(f"Database file not found: {db_path}")
        
        return sqlite3.connect(db_path)
    
    def get_tables(self, conn: sqlite3.Connection) -> List[str]:
        """Get list of all tables in the database"""
        cursor = conn.cursor()
        cursor.execute("""
            SELECT name FROM sqlite_master 
            WHERE type='table' AND name NOT LIKE 'sqlite_%'
            ORDER BY name
        """)
        
        return [row[0] for row in cursor.fetchall()]
    
    def get_table_info(self, conn: sqlite3.Connection, table_name: str) -> SQLiteTable:
        """Get detailed information about a table"""
        cursor = conn.cursor()
        
        # Get column information
        cursor.execute(f"PRAGMA table_info({table_name})")
        columns_data = cursor.fetchall()
        
        columns = []
        for col_data in columns_data:
            column = SQLiteColumn(*col_data)
            columns.append(column)
        
        return SQLiteTable(table_name, columns)
    
    def map_sqlite_type_to_hcl(self, sqlite_type: str) -> str:
        """Map SQLite type to HCL type"""
        # Handle types with parameters like VARCHAR(50)
        base_type = sqlite_type.split('(')[0].lower().strip()
        
        # Check for varchar with length
        if 'varchar' in sqlite_type.lower() and '(' in sqlite_type:
            # Extract length
            try:
                length_part = sqlite_type.split('(')[1].split(')')[0]
                return f"varchar({length_part})"
            except (IndexError, ValueError):
                return "varchar"
        
        return self.type_mapping.get(base_type, 'varchar')
    
    def apply_special_rules(self, column: SQLiteColumn) -> SQLiteColumn:
        """Apply special rules for id, enable, and time fields"""
        # Create a copy to avoid modifying the original
        modified_column = SQLiteColumn(
            column.cid, column.name, column.type, 
            column.notnull, column.default, column.pk
        )
        
        # Rule 1: All id fields must be PRIMARY KEY and AUTOINCREMENT
        if column.name.lower() == 'id':
            modified_column.pk = True
            modified_column.notnull = True
            modified_column.type = 'integer'  # Ensure it's integer for AUTOINCREMENT
            # Note: AUTOINCREMENT will be handled in HCL generation
        
        # Rule 2: All enable fields must be boolean with true default value
        elif column.name.lower() == 'enable':
            modified_column.type = 'boolean'
            modified_column.default = 'true'
        
        # Rule 3: All time fields (type or name containing 'time') should be varchar
        elif 'time' in column.type.lower() or 'time' in column.name.lower():
            modified_column.type = 'varchar'
        
        return modified_column
    
    def generate_hcl_schema(self, tables: List[SQLiteTable], schema_name: str = "main") -> str:
        """Generate HCL schema from SQLite tables"""
        hcl_lines = [f'schema "{schema_name}" {{}}', '']
        
        for table in tables:
            hcl_lines.extend(self._generate_table_hcl(table, schema_name))
            hcl_lines.append('')
        
        return '\n'.join(hcl_lines)
    
    def _generate_table_hcl(self, table: SQLiteTable, schema_name: str) -> List[str]:
        """Generate HCL for a single table"""
        lines = [f'table "{table.name}" {{']
        lines.append(f'  schema = schema.{schema_name}')
        lines.append('')
        
        # Apply special rules to columns
        modified_columns = [self.apply_special_rules(col) for col in table.columns]
        
        # Add columns
        for column in modified_columns:
            lines.extend(self._generate_column_hcl(column))
            lines.append('')
        
        # Update primary keys after applying rules
        primary_keys = [col.name for col in modified_columns if col.pk]
        
        # Add primary key if there are any primary key columns
        if primary_keys:
            lines.append('  primary_key {')
            if len(primary_keys) == 1:
                lines.append(f'    columns = [column.{primary_keys[0]}]')
            else:
                pk_columns = ', '.join(f'column.{pk}' for pk in primary_keys)
                lines.append(f'    columns = [{pk_columns}]')
            lines.append('  }')
        
        lines.append('}')
        return lines
    
    def _generate_column_hcl(self, column: SQLiteColumn) -> List[str]:
        """Generate HCL for a single column with special rules applied"""
        lines = [f'  column "{column.name}" {{']
        
        # Type
        hcl_type = self.map_sqlite_type_to_hcl(column.type)
        lines.append(f'    type = {hcl_type}')
        
        # Null constraint
        null_value = "false" if column.notnull else "true"
        lines.append(f'    null = {null_value}')
        
        # Auto increment for id fields
        if column.name.lower() == 'id' and column.pk:
            lines.append('    auto_increment = true')
        
        # Default value
        if column.default is not None:
            # Handle different default value types
            default_val = column.default
            if default_val.upper() in ['NULL']:
                lines.append('    default = null')
            elif default_val.upper() in ['TRUE', 'FALSE'] or default_val.lower() in ['true', 'false']:
                lines.append(f'    default = {default_val.lower()}')
            elif default_val.isdigit() or (default_val.startswith('-') and default_val[1:].isdigit()):
                lines.append(f'    default = {default_val}')
            else:
                # String default
                lines.append(f'    default = "{default_val}"')
        
        lines.append('  }')
        return lines
    
    def convert_database(self, db_path: str, output_path: str, schema_name: str = "main") -> None:
        """Convert SQLite database to HCL file"""
        # Connect to database
        conn = self.connect_to_database(db_path)
        
        try:
            # Get all tables
            table_names = self.get_tables(conn)
            
            if not table_names:
                print("No tables found in the database")
                return
            
            print(f"Found {len(table_names)} tables:")
            
            # Get detailed information for each table
            tables = []
            for table_name in table_names:
                table = self.get_table_info(conn, table_name)
                tables.append(table)
                
                # Count special fields
                id_fields = [col.name for col in table.columns if col.name.lower() == 'id']
                enable_fields = [col.name for col in table.columns if col.name.lower() == 'enable']
                time_fields = [col.name for col in table.columns if 'time' in col.type.lower() or 'time' in col.name.lower()]
                
                special_info = ""
                if id_fields:
                    special_info += f" [ID: {', '.join(id_fields)}]"
                if enable_fields:
                    special_info += f" [ENABLE: {', '.join(enable_fields)}]"
                if time_fields:
                    special_info += f" [TIME→VARCHAR: {', '.join(time_fields)}]"
                
                print(f"  - {table_name} ({len(table.columns)} columns){special_info}")
            
            # Generate HCL schema
            hcl_content = self.generate_hcl_schema(tables, schema_name)
            
            # Write to output file
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(hcl_content)
            
            print(f"\nHCL schema generated successfully!")
            print(f"Output file: {output_path}")
            print("\n📋 Applied Rules:")
            print("  ✅ All 'id' fields → PRIMARY KEY + AUTOINCREMENT")
            print("  ✅ All 'enable' fields → BOOLEAN with default TRUE")
            print("  ✅ All 'time' fields → VARCHAR")
            
        finally:
            conn.close()


def main():
    """Main function"""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Convert SQLite database to HCL schema format")
    parser.add_argument('--input', '-i', help='Input SQLite database file path')
    parser.add_argument('--output', '-o', help='Output HCL file path')
    parser.add_argument('--schema', '-s', default='main', help='Schema name (default: main)')
    
    args = parser.parse_args()
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Determine paths
    if args.input:
        db_path = args.input
    else:
        # Default to script directory
        db_path = os.path.join(script_dir, "db.sqlite")
    
    if args.output:
        output_path = args.output
    else:
        # Default to script directory
        output_path = os.path.join(script_dir, "db.hcl")
    
    # Check if database file exists
    if not os.path.exists(db_path):
        print(f"Error: SQLite database file not found: {db_path}")
        print(f"Please make sure the db.sqlite file exists in the script directory: {script_dir}")
        return 1
    
    try:
        converter = SQLiteToHCLConverter()
        converter.convert_database(db_path, output_path, args.schema)
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())