#!/usr/bin/env python3
"""
SQLite to HCL Generator
Converts SQLite database to Atlas HCL schema format
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
    """Converts SQLite database to HCL format"""
    
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
            'time': 'time',
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
        
        # Add columns
        for column in table.columns:
            lines.extend(self._generate_column_hcl(column))
            lines.append('')
        
        # Add primary key if there are multiple primary key columns
        if len(table.primary_keys) > 1:
            lines.append('  primary_key {')
            pk_columns = ', '.join(f'column.{pk}' for pk in table.primary_keys)
            lines.append(f'    columns = [{pk_columns}]')
            lines.append('  }')
        elif len(table.primary_keys) == 1:
            # Single primary key is already handled in column definition
            lines.append('  primary_key {')
            lines.append(f'    columns = [column.{table.primary_keys[0]}]')
            lines.append('  }')
        
        lines.append('}')
        return lines
    
    def _generate_column_hcl(self, column: SQLiteColumn) -> List[str]:
        """Generate HCL for a single column"""
        lines = [f'  column "{column.name}" {{']
        
        # Type
        hcl_type = self.map_sqlite_type_to_hcl(column.type)
        lines.append(f'    type = {hcl_type}')
        
        # Null constraint
        null_value = "false" if column.notnull else "true"
        lines.append(f'    null = {null_value}')
        
        # Default value
        if column.default is not None:
            # Handle different default value types
            default_val = column.default
            if default_val.upper() in ['NULL']:
                lines.append('    default = null')
            elif default_val.upper() in ['TRUE', 'FALSE']:
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
                print(f"  - {table_name} ({len(table.columns)} columns)")
            
            # Generate HCL schema
            hcl_content = self.generate_hcl_schema(tables, schema_name)
            
            # Write to output file
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(hcl_content)
            
            print(f"\nHCL schema generated successfully!")
            print(f"Output file: {output_path}")
            
        finally:
            conn.close()


def main():
    """Main function"""
    # Default paths based on the requirement
    db_path = "/Volumes/data/documents/data_structure/database/sqlite/db.sqlite"
    output_path = "/Volumes/data/documents/data_structure/database/sqlite/db.hcl"
    
    # Check if database file exists
    if not os.path.exists(db_path):
        print(f"Error: SQLite database file not found: {db_path}")
        print("Please make sure the db.sqlite file exists in the database/sqlite/ directory")
        return 1
    
    try:
        converter = SQLiteToHCLConverter()
        converter.convert_database(db_path, output_path)
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
