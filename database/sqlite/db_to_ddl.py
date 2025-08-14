#!/usr/bin/env python3
"""
SQLite to DDL Generator
Converts SQLite database to SQL DDL (Data Definition Language) statements
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
        self.type = type_.upper() if type_ else "TEXT"
        self.notnull = bool(notnull)
        self.default = default
        self.pk = bool(pk)


class SQLiteTable:
    """Represents a table from SQLite"""
    def __init__(self, name: str, columns: List[SQLiteColumn]):
        self.name = name
        self.columns = columns
        self.primary_keys = [col.name for col in columns if col.pk]


class SQLiteToDDLConverter:
    """Converts SQLite database to SQL DDL statements"""
    
    def __init__(self):
        self.type_mapping = {
            'integer': 'INTEGER',
            'int': 'INTEGER',
            'bigint': 'BIGINT',
            'smallint': 'SMALLINT',
            'tinyint': 'TINYINT',
            'text': 'TEXT',
            'varchar': 'VARCHAR',
            'char': 'CHAR',
            'string': 'VARCHAR',
            'real': 'REAL',
            'float': 'FLOAT',
            'double': 'DOUBLE',
            'decimal': 'DECIMAL',
            'numeric': 'NUMERIC',
            'boolean': 'BOOLEAN',
            'bool': 'BOOLEAN',
            'date': 'DATE',
            'datetime': 'DATETIME',
            'timestamp': 'TIMESTAMP',
            'time': 'TIME',
            'blob': 'BLOB',
            'binary': 'BLOB'
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
    
    def map_sqlite_type_to_sql(self, sqlite_type: str) -> str:
        """Map SQLite type to SQL type"""
        # Handle types with parameters like VARCHAR(50)
        if '(' in sqlite_type:
            return sqlite_type.upper()
        
        base_type = sqlite_type.lower().strip()
        return self.type_mapping.get(base_type, sqlite_type.upper())
    
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
            modified_column.type = 'INTEGER'  # Ensure it's integer for AUTOINCREMENT
        
        # Rule 2: All enable fields must be boolean with true default value
        elif column.name.lower() == 'enable':
            modified_column.type = 'BOOLEAN'
            modified_column.default = 'true'
        
        # Rule 3: All time fields (type or name containing 'time') should be varchar
        elif 'time' in column.type.lower() or 'time' in column.name.lower():
            modified_column.type = 'VARCHAR'
        
        return modified_column
    
    def generate_ddl_schema(self, tables: List[SQLiteTable]) -> str:
        """Generate SQL DDL from SQLite tables"""
        ddl_lines = []
        
        # Add header comment
        ddl_lines.append("-- SQL DDL generated from SQLite database")
        ddl_lines.append("-- Generated with special rules:")
        ddl_lines.append("--   * All 'id' fields → PRIMARY KEY + AUTOINCREMENT")
        ddl_lines.append("--   * All 'enable' fields → BOOLEAN with default TRUE")
        ddl_lines.append("--   * All 'time' fields → VARCHAR")
        ddl_lines.append("")
        
        for table in tables:
            ddl_lines.extend(self._generate_table_ddl(table))
            ddl_lines.append("")
        
        return '\n'.join(ddl_lines)
    
    def _generate_table_ddl(self, table: SQLiteTable) -> List[str]:
        """Generate SQL DDL for a single table"""
        lines = [f"CREATE TABLE {table.name} ("]
        
        # Apply special rules to columns
        modified_columns = [self.apply_special_rules(col) for col in table.columns]
        
        # Add column definitions
        column_defs = []
        for column in modified_columns:
            col_def = self._generate_column_ddl(column)
            column_defs.append(f"    {col_def}")
        
        # Add primary key constraint if there are multiple primary key columns
        primary_keys = [col.name for col in modified_columns if col.pk]
        if len(primary_keys) > 1:
            pk_constraint = f"    PRIMARY KEY ({', '.join(primary_keys)})"
            column_defs.append(pk_constraint)
        
        lines.append(',\n'.join(column_defs))
        lines.append(");")
        
        return lines
    
    def _generate_column_ddl(self, column: SQLiteColumn) -> str:
        """Generate SQL DDL for a single column"""
        # Map type
        sql_type = self.map_sqlite_type_to_sql(column.type)
        
        # Handle special VARCHAR cases
        if sql_type == 'VARCHAR' and '(' not in sql_type:
            sql_type = 'VARCHAR(255)'  # Default length for VARCHAR
        
        definition = f"{column.name} {sql_type}"
        
        # Add constraints
        constraints = []
        
        # Primary key (only for single primary keys)
        if column.pk and column.name.lower() == 'id':
            constraints.append("PRIMARY KEY")
        
        # Auto increment for id fields
        if column.name.lower() == 'id' and column.pk:
            constraints.append("AUTOINCREMENT")
        
        # NOT NULL constraint
        if column.notnull or column.pk:
            constraints.append("NOT NULL")
        
        # Default value
        if column.default is not None:
            default_val = column.default
            if default_val.upper() in ['NULL']:
                constraints.append("DEFAULT NULL")
            elif default_val.upper() in ['TRUE', 'FALSE'] or default_val.lower() in ['true', 'false']:
                constraints.append(f"DEFAULT {default_val.upper()}")
            elif default_val.isdigit() or (default_val.startswith('-') and default_val[1:].isdigit()):
                constraints.append(f"DEFAULT {default_val}")
            else:
                # String default
                constraints.append(f"DEFAULT '{default_val}'")
        
        # Add constraints to definition
        if constraints:
            definition += " " + " ".join(constraints)
        
        return definition
    
    def get_foreign_keys(self, conn: sqlite3.Connection, table_name: str) -> List[Dict[str, Any]]:
        """Get foreign key information for a table"""
        cursor = conn.cursor()
        cursor.execute(f"PRAGMA foreign_key_list({table_name})")
        
        fk_info = []
        for row in cursor.fetchall():
            fk_info.append({
                'id': row[0],
                'seq': row[1],
                'table': row[2],
                'from': row[3],
                'to': row[4],
                'on_update': row[5],
                'on_delete': row[6],
                'match': row[7]
            })
        
        return fk_info
    
    def generate_foreign_keys_ddl(self, conn: sqlite3.Connection, tables: List[SQLiteTable]) -> List[str]:
        """Generate ALTER TABLE statements for foreign keys"""
        fk_statements = []
        
        for table in tables:
            fk_list = self.get_foreign_keys(conn, table.name)
            
            for fk in fk_list:
                fk_name = f"fk_{table.name}_{fk['from']}"
                alter_sql = (
                    f"ALTER TABLE {table.name} "
                    f"ADD CONSTRAINT {fk_name} "
                    f"FOREIGN KEY ({fk['from']}) "
                    f"REFERENCES {fk['table']}({fk['to']}) "
                    f"ON UPDATE {fk['on_update']} "
                    f"ON DELETE {fk['on_delete']};"
                )
                fk_statements.append(alter_sql)
        
        return fk_statements
    
    def convert_database(self, db_path: str, output_path: str) -> None:
        """Convert SQLite database to DDL file"""
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
            
            # Generate DDL schema
            ddl_content = self.generate_ddl_schema(tables)
            
            # Add foreign keys if any
            fk_statements = self.generate_foreign_keys_ddl(conn, tables)
            if fk_statements:
                ddl_content += "\n-- Foreign Key Constraints\n"
                ddl_content += "\n".join(fk_statements)
            
            # Write to output file
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(ddl_content)
            
            print(f"\nSQL DDL generated successfully!")
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
    parser = argparse.ArgumentParser(description="Convert SQLite database to SQL DDL format")
    parser.add_argument('--input', '-i', help='Input SQLite database file path')
    parser.add_argument('--output', '-o', help='Output SQL DDL file path')
    
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
        output_path = os.path.join(script_dir, "db.sql")
    
    # Check if database file exists
    if not os.path.exists(db_path):
        print(f"Error: SQLite database file not found: {db_path}")
        print(f"Please make sure the db.sqlite file exists in the script directory: {script_dir}")
        return 1
    
    try:
        converter = SQLiteToDDLConverter()
        converter.convert_database(db_path, output_path)
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
