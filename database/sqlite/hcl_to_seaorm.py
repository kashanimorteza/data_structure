#!/usr/bin/env python3
"""
HCL to Sea-ORM Migration Generator
Converts Atlas HCL schema files to Sea-ORM migration format
"""

import re
import json
import sys
import os
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass


@dataclass
class HCLColumn:
    """Represents a column in HCL format"""
    name: str
    type: str
    null: bool
    default: Optional[str] = None
    
    
@dataclass 
class HCLTable:
    """Represents a table in HCL format"""
    name: str
    schema: str
    columns: List[HCLColumn]
    primary_key: List[str]


class HCLParser:
    """Parser for Atlas HCL schema files"""
    
    def __init__(self):
        self.tables: List[HCLTable] = []
    
    def parse_file(self, file_path: str) -> List[HCLTable]:
        """Parse HCL file and extract table definitions"""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return self.parse_content(content)
    
    def parse_content(self, content: str) -> List[HCLTable]:
        """Parse HCL content and extract table definitions"""
        self.tables = []
        
        # Find all table blocks using a more robust approach
        # This regex handles nested braces properly
        table_start_pattern = r'table\s+"([^"]+)"\s*\{'
        
        pos = 0
        while True:
            match = re.search(table_start_pattern, content[pos:])
            if not match:
                break
            
            table_name = match.group(1)
            start_pos = pos + match.end() - 1  # Position of opening brace
            
            # Find the matching closing brace
            brace_count = 0
            end_pos = start_pos
            for i, char in enumerate(content[start_pos:], start_pos):
                if char == '{':
                    brace_count += 1
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        end_pos = i
                        break
            
            if brace_count == 0:
                table_content = content[start_pos + 1:end_pos]  # Skip opening brace
                table = self._parse_table(table_name, table_content)
                if table:
                    self.tables.append(table)
            
            pos = end_pos + 1
        
        return self.tables
    
    def _parse_table(self, table_name: str, table_content: str) -> Optional[HCLTable]:
        """Parse individual table content"""
        columns = []
        primary_key = []
        schema = "main"
        
        # Extract schema
        schema_match = re.search(r'schema\s*=\s*schema\.(\w+)', table_content)
        if schema_match:
            schema = schema_match.group(1)
        
        # Find all column blocks using robust parsing
        column_start_pattern = r'column\s+"([^"]+)"\s*\{'
        
        pos = 0
        while True:
            match = re.search(column_start_pattern, table_content[pos:])
            if not match:
                break
            
            column_name = match.group(1)
            start_pos = pos + match.end() - 1  # Position of opening brace
            
            # Find the matching closing brace
            brace_count = 0
            end_pos = start_pos
            for i, char in enumerate(table_content[start_pos:], start_pos):
                if char == '{':
                    brace_count += 1
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        end_pos = i
                        break
            
            if brace_count == 0:
                column_content = table_content[start_pos + 1:end_pos]  # Skip opening brace
                column = self._parse_column(column_name, column_content)
                if column:
                    columns.append(column)
            
            pos = end_pos + 1
        
        # Find primary key
        pk_pattern = r'primary_key\s*\{([^}]*)\}'
        pk_match = re.search(pk_pattern, table_content, re.DOTALL)
        if pk_match:
            pk_content = pk_match.group(1)
            # Extract column names from primary key
            col_pattern = r'column\.(\w+)'
            pk_columns = re.findall(col_pattern, pk_content)
            primary_key = pk_columns
        
        return HCLTable(
            name=table_name,
            schema=schema,
            columns=columns,
            primary_key=primary_key
        )
    
    def _parse_column(self, column_name: str, column_content: str) -> Optional[HCLColumn]:
        """Parse individual column content"""
        # Extract type
        type_match = re.search(r'type\s*=\s*(\w+(?:\(\d+\))?)', column_content)
        if not type_match:
            return None
        
        column_type = type_match.group(1)
        
        # Extract null constraint
        null_match = re.search(r'null\s*=\s*(true|false)', column_content)
        null = True  # default
        if null_match:
            null = null_match.group(1) == 'true'
        
        # Extract default value
        default_match = re.search(r'default\s*=\s*([^\\n]+)', column_content)
        default = None
        if default_match:
            default = default_match.group(1).strip()
        
        return HCLColumn(
            name=column_name,
            type=column_type,
            null=null,
            default=default
        )


class SeaORMMigrationGenerator:
    """Generates Sea-ORM migration code from HCL tables"""
    
    def __init__(self):
        self.type_mapping = {
            'int': 'INTEGER',
            'varchar': 'VARCHAR',
            'varchar(7)': 'VARCHAR',
            'varchar(8)': 'VARCHAR', 
            'varchar(4)': 'VARCHAR',
            'bool': 'BOOLEAN',
            'text': 'TEXT',
            'datetime': 'DATETIME',
            'date': 'DATE',
            'float': 'REAL',
            'double': 'REAL',
            'decimal': 'DECIMAL',
            'json': 'JSON',
            'blob': 'BLOB'
        }
    
    def generate_migration(self, tables: List[HCLTable], migration_name: str = "Migration") -> str:
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
    
    def _generate_up_migrations(self, tables: List[HCLTable]) -> str:
        """Generate UP migration SQL for all tables"""
        migrations = []
        
        for table in tables:
            sql_lines = [f'        let sql_{table.name} = r#"']
            sql_lines.append(f'            CREATE TABLE {table.name} (')
            
            # Generate column definitions
            column_defs = []
            for column in table.columns:
                col_def = self._generate_column_definition(column, table.primary_key)
                column_defs.append(f'                {col_def}')
            
            sql_lines.append(',\n'.join(column_defs))
            sql_lines.append('            );')
            sql_lines.append('        "#;')
            sql_lines.append(f'        manager.get_connection().execute_unprepared(sql_{table.name}).await?;')
            sql_lines.append('')
            
            migrations.extend(sql_lines)
        
        return '\n'.join(migrations)
    
    def _generate_down_migrations(self, tables: List[HCLTable]) -> str:
        """Generate DOWN migration SQL for all tables"""
        migrations = []
        
        # Drop tables in reverse order to handle dependencies
        for table in reversed(tables):
            migrations.append(f'        manager.get_connection().execute_unprepared("DROP TABLE IF EXISTS {table.name};").await?;')
        
        return '\n'.join(migrations)
    
    def _generate_column_definition(self, column: HCLColumn, primary_keys: List[str]) -> str:
        """Generate SQL column definition"""
        # Map HCL type to SQL type
        sql_type = self.type_mapping.get(column.type, column.type.upper())
        
        # Handle varchar with length
        if column.type.startswith('varchar'):
            if '(' in column.type:
                # Extract length from varchar(n)
                length_match = re.search(r'varchar\((\d+)\)', column.type)
                if length_match:
                    length = length_match.group(1)
                    sql_type = f'VARCHAR({length})'
                else:
                    sql_type = 'VARCHAR'
            else:
                sql_type = 'VARCHAR'
        
        definition = f'{column.name} {sql_type}'
        
        # Add constraints
        if column.name in primary_keys:
            definition += ' PRIMARY KEY'
        
        if not column.null:
            definition += ' NOT NULL'
        
        if column.default is not None:
            if column.type == 'bool':
                # Convert boolean defaults
                if column.default.lower() in ['true', '1']:
                    definition += ' DEFAULT 1'
                else:
                    definition += ' DEFAULT 0'
            elif column.type in ['int']:
                definition += f' DEFAULT {column.default}'
            else:
                definition += f" DEFAULT '{column.default}'"
        
        return definition
    

    
    def _pascal_case(self, name: str) -> str:
        """Convert snake_case to PascalCase"""
        return ''.join(word.capitalize() for word in name.split('_'))


def main():
    """Main function to convert HCL to Sea-ORM migration"""
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Default paths (relative to script location)
    hcl_file = os.path.join(script_dir, "db.hcl")
    output_file = os.path.join(script_dir, "sea-orm.rs")
    
    # Check if HCL file exists
    if not os.path.exists(hcl_file):
        print(f"Error: HCL file not found: {hcl_file}")
        return 1
    
    try:
        # Parse HCL file
        parser = HCLParser()
        tables = parser.parse_file(hcl_file)
        
        if not tables:
            print("No tables found in HCL file")
            return 1
        
        print(f"Found {len(tables)} tables:")
        for table in tables:
            print(f"  - {table.name} ({len(table.columns)} columns)")
        
        # Generate Sea-ORM migration
        generator = SeaORMMigrationGenerator()
        migration_code = generator.generate_migration(tables, "Migration")
        
        # Write to output file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(migration_code)
        
        print(f"\nSea-ORM migration generated successfully!")
        print(f"Output file: {output_file}")
        
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
