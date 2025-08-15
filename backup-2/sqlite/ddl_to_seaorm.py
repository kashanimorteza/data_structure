#!/usr/bin/env python3
"""
DDL to Sea-ORM Migration Generator
Converts SQL DDL files to Sea-ORM migration format
"""

import re
import os
import sys
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass


@dataclass
class DDLColumn:
    """Represents a column from DDL"""
    name: str
    type: str
    nullable: bool = True
    primary_key: bool = False
    auto_increment: bool = False
    default: Optional[str] = None


@dataclass
class DDLTable:
    """Represents a table from DDL"""
    name: str
    columns: List[DDLColumn]
    primary_keys: List[str]


class DDLParser:
    """Parser for SQL DDL files"""
    
    def __init__(self):
        self.tables: List[DDLTable] = []
    
    def parse_file(self, file_path: str) -> List[DDLTable]:
        """Parse DDL file and extract table definitions"""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return self.parse_content(content)
    
    def parse_content(self, content: str) -> List[DDLTable]:
        """Parse DDL content and extract table definitions"""
        self.tables = []
        
        # Remove comments
        content = re.sub(r'--.*?\n', '\n', content)
        
        # Find all CREATE TABLE statements
        table_pattern = r'CREATE\s+TABLE\s+(\w+)\s*\((.*?)\);'
        table_matches = re.finditer(table_pattern, content, re.DOTALL | re.IGNORECASE)
        
        for table_match in table_matches:
            table_name = table_match.group(1)
            table_content = table_match.group(2)
            
            table = self._parse_table(table_name, table_content)
            if table:
                self.tables.append(table)
        
        return self.tables
    
    def _parse_table(self, table_name: str, table_content: str) -> Optional[DDLTable]:
        """Parse individual table content"""
        columns = []
        primary_keys = []
        
        # Split by comma, but be careful with nested parentheses
        lines = []
        current_line = ""
        paren_count = 0
        
        for char in table_content:
            if char == '(':
                paren_count += 1
            elif char == ')':
                paren_count -= 1
            elif char == ',' and paren_count == 0:
                lines.append(current_line.strip())
                current_line = ""
                continue
            current_line += char
        
        if current_line.strip():
            lines.append(current_line.strip())
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
            
            # Check if it's a PRIMARY KEY constraint
            if line.upper().startswith('PRIMARY KEY'):
                pk_match = re.search(r'PRIMARY\s+KEY\s*\(([^)]+)\)', line, re.IGNORECASE)
                if pk_match:
                    pk_columns = [col.strip() for col in pk_match.group(1).split(',')]
                    primary_keys.extend(pk_columns)
                continue
            
            # Parse column definition
            column = self._parse_column(line)
            if column:
                columns.append(column)
                if column.primary_key:
                    primary_keys.append(column.name)
        
        return DDLTable(
            name=table_name,
            columns=columns,
            primary_keys=primary_keys
        )
    
    def _parse_column(self, column_def: str) -> Optional[DDLColumn]:
        """Parse individual column definition"""
        # Split column definition into parts
        parts = column_def.split()
        if len(parts) < 2:
            return None
        
        column_name = parts[0]
        column_type = parts[1]
        
        # Parse constraints
        constraints = ' '.join(parts[2:]).upper()
        
        nullable = 'NOT NULL' not in constraints
        primary_key = 'PRIMARY KEY' in constraints
        auto_increment = 'AUTOINCREMENT' in constraints
        
        # Extract default value
        default = None
        default_match = re.search(r'DEFAULT\s+([^,\s]+)', constraints)
        if default_match:
            default = default_match.group(1)
        
        return DDLColumn(
            name=column_name,
            type=column_type,
            nullable=nullable,
            primary_key=primary_key,
            auto_increment=auto_increment,
            default=default
        )


class DDLToSeaORMGenerator:
    """Generates Sea-ORM migration code from DDL tables"""
    
    def __init__(self):
        self.type_mapping = {
            'INTEGER': 'INTEGER',
            'VARCHAR': 'VARCHAR',
            'VARCHAR(7)': 'VARCHAR',
            'VARCHAR(8)': 'VARCHAR',
            'VARCHAR(4)': 'VARCHAR',
            'VARCHAR(255)': 'VARCHAR',
            'BOOLEAN': 'BOOLEAN',
            'TEXT': 'TEXT',
            'DATETIME': 'DATETIME',
            'DATE': 'DATE',
            'REAL': 'REAL',
            'FLOAT': 'REAL',
            'DECIMAL': 'DECIMAL',
            'JSON': 'JSON',
            'BLOB': 'BLOB'
        }
    
    def generate_migration(self, tables: List[DDLTable], migration_name: str = "Migration") -> str:
        """Generate Sea-ORM migration code"""
        
        # Generate the migration structure
        migration_code = f"""use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct {migration_name};

#[async_trait::async_trait]
impl MigrationTrait for {migration_name} {{
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {{
        // Create all tables
{self._generate_up_migrations(tables)}
        Ok(())
    }}

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {{
        // Drop all tables in reverse order
{self._generate_down_migrations(tables)}
        Ok(())
    }}
}}"""
        
        return migration_code
    
    def _generate_up_migrations(self, tables: List[DDLTable]) -> str:
        """Generate UP migration SQL for all tables"""
        migrations = []
        
        for table in tables:
            sql_lines = [f'        let sql_{table.name} = r#"']
            sql_lines.append(f'            CREATE TABLE {table.name} (')
            
            # Generate column definitions
            column_defs = []
            for column in table.columns:
                col_def = self._generate_column_definition(column)
                column_defs.append(f'                {col_def}')
            
            sql_lines.append(',\n'.join(column_defs))
            sql_lines.append('            );')
            sql_lines.append('        "#;')
            sql_lines.append(f'        manager.get_connection().execute_unprepared(sql_{table.name}).await?;')
            sql_lines.append('')
            
            migrations.extend(sql_lines)
        
        return '\n'.join(migrations)
    
    def _generate_down_migrations(self, tables: List[DDLTable]) -> str:
        """Generate DOWN migration SQL for all tables"""
        migrations = []
        
        # Drop tables in reverse order to handle dependencies
        for table in reversed(tables):
            migrations.append(f'        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS {table.name};").await?;')
        
        return '\n'.join(migrations)
    
    def _generate_column_definition(self, column: DDLColumn) -> str:
        """Generate SQL column definition"""
        # Map DDL type to SQL type
        sql_type = self.type_mapping.get(column.type.upper(), column.type.upper())
        
        # Handle varchar with length
        if column.type.upper().startswith('VARCHAR'):
            if '(' in column.type:
                # Keep the length specification
                sql_type = column.type.upper()
            else:
                sql_type = 'VARCHAR'
        
        definition = f'{column.name} {sql_type}'
        
        # Add constraints
        if column.primary_key:
            definition += ' PRIMARY KEY'
        
        if column.auto_increment:
            definition += ' AUTOINCREMENT'
        
        if not column.nullable:
            definition += ' NOT NULL'
        
        if column.default is not None:
            if column.default.upper() in ['TRUE', 'FALSE']:
                definition += f' DEFAULT {column.default.upper()}'
            elif column.default.isdigit() or (column.default.startswith('-') and column.default[1:].isdigit()):
                definition += f' DEFAULT {column.default}'
            elif column.default.upper() == 'NULL':
                definition += ' DEFAULT NULL'
            else:
                # String default
                default_val = column.default.strip("'\"")
                definition += f" DEFAULT '{default_val}'"
        
        return definition
    
    def convert_file(self, ddl_file: str, output_file: str) -> None:
        """Convert DDL file to Sea-ORM migration file"""
        # Parse DDL file
        parser = DDLParser()
        tables = parser.parse_file(ddl_file)
        
        if not tables:
            print("No tables found in DDL file")
            return
        
        print(f"Found {len(tables)} tables:")
        for table in tables:
            print(f"  - {table.name} ({len(table.columns)} columns)")
        
        # Generate Sea-ORM migration
        migration_code = self.generate_migration(tables, "Migration")
        
        # Write to output file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(migration_code)
        
        print(f"\nSea-ORM migration generated successfully!")
        print(f"Output file: {output_file}")


def main():
    """Main function to convert DDL to Sea-ORM migration"""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Convert SQL DDL to Sea-ORM migration format")
    parser.add_argument('--input', '-i', help='Input SQL DDL file path')
    parser.add_argument('--output', '-o', help='Output Sea-ORM migration file path')
    
    args = parser.parse_args()
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Determine paths
    if args.input:
        ddl_file = args.input
    else:
        # Default to script directory
        ddl_file = os.path.join(script_dir, "db.sql")
    
    if args.output:
        output_file = args.output
    else:
        # Default to script directory
        output_file = os.path.join(script_dir, "sea-orm.rs")
    
    # Check if DDL file exists
    if not os.path.exists(ddl_file):
        print(f"Error: DDL file not found: {ddl_file}")
        print(f"Please make sure the db.sql file exists in the script directory: {script_dir}")
        return 1
    
    try:
        generator = DDLToSeaORMGenerator()
        generator.convert_file(ddl_file, output_file)
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
