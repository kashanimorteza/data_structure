#!/usr/bin/env python3
"""
HCL to DDL Generator
Converts Atlas HCL schema files to SQL DDL (Data Definition Language) statements
"""

import re
import os
import sys
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass


@dataclass
class HCLColumn:
    """Represents a column in HCL format"""
    name: str
    type: str
    null: bool
    default: Optional[str] = None
    auto_increment: bool = False
    

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
        default_match = re.search(r'default\s*=\s*([^\n]+)', column_content)
        default = None
        if default_match:
            default = default_match.group(1).strip()
        
        # Extract auto_increment
        auto_increment_match = re.search(r'auto_increment\s*=\s*(true|false)', column_content)
        auto_increment = False
        if auto_increment_match:
            auto_increment = auto_increment_match.group(1) == 'true'
        
        return HCLColumn(
            name=column_name,
            type=column_type,
            null=null,
            default=default,
            auto_increment=auto_increment
        )


class HCLToDDLConverter:
    """Converts HCL schema to SQL DDL statements"""
    
    def __init__(self):
        self.type_mapping = {
            'int': 'INTEGER',
            'varchar': 'VARCHAR',
            'varchar(7)': 'VARCHAR(7)',
            'varchar(8)': 'VARCHAR(8)', 
            'varchar(4)': 'VARCHAR(4)',
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
    
    def generate_ddl(self, tables: List[HCLTable]) -> str:
        """Generate SQL DDL from HCL tables"""
        
        ddl_lines = []
        
        # Add header comment
        ddl_lines.append("-- SQL DDL generated from HCL schema")
        ddl_lines.append("-- Generated with HCL to DDL converter")
        ddl_lines.append("")
        
        # Generate CREATE TABLE statements
        for table in tables:
            ddl_lines.extend(self._generate_table_ddl(table))
            ddl_lines.append("")
        
        return '\n'.join(ddl_lines)
    
    def _generate_table_ddl(self, table: HCLTable) -> List[str]:
        """Generate SQL DDL for a single table"""
        lines = [f"CREATE TABLE {table.name} ("]
        
        # Generate column definitions
        column_defs = []
        for column in table.columns:
            col_def = self._generate_column_definition(column, table.primary_key)
            column_defs.append(f"    {col_def}")
        
        # Add primary key constraint if multiple columns
        if len(table.primary_key) > 1:
            pk_constraint = f"    PRIMARY KEY ({', '.join(table.primary_key)})"
            column_defs.append(pk_constraint)
        
        lines.append(',\n'.join(column_defs))
        lines.append(");")
        
        return lines
    
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
                sql_type = 'VARCHAR(255)'  # Default length
        
        definition = f'{column.name} {sql_type}'
        
        # Add constraints
        constraints = []
        
        # Primary key (for single column primary keys)
        if column.name in primary_keys and len(primary_keys) == 1:
            constraints.append('PRIMARY KEY')
        
        # Auto increment
        if column.auto_increment:
            constraints.append('AUTOINCREMENT')
        
        # NOT NULL constraint
        if not column.null:
            constraints.append('NOT NULL')
        
        # Default value
        if column.default is not None:
            if column.default.lower() in ['true', 'false']:
                # Boolean defaults
                constraints.append(f'DEFAULT {column.default.upper()}')
            elif column.default.isdigit() or (column.default.startswith('-') and column.default[1:].isdigit()):
                # Numeric defaults
                constraints.append(f'DEFAULT {column.default}')
            elif column.default.lower() == 'null':
                constraints.append('DEFAULT NULL')
            else:
                # String defaults (remove quotes if present)
                default_val = column.default.strip('"\'')
                constraints.append(f"DEFAULT '{default_val}'")
        
        # Add constraints to definition
        if constraints:
            definition += ' ' + ' '.join(constraints)
        
        return definition
    
    def convert_file(self, hcl_file: str, output_file: str) -> None:
        """Convert HCL file to DDL file"""
        # Parse HCL file
        parser = HCLParser()
        tables = parser.parse_file(hcl_file)
        
        if not tables:
            print("No tables found in HCL file")
            return
        
        print(f"Found {len(tables)} tables:")
        for table in tables:
            print(f"  - {table.name} ({len(table.columns)} columns)")
        
        # Generate DDL
        ddl_content = self.generate_ddl(tables)
        
        # Write to output file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(ddl_content)
        
        print(f"\nSQL DDL generated successfully!")
        print(f"Output file: {output_file}")


def main():
    """Main function to convert HCL to DDL"""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Convert HCL schema to SQL DDL format")
    parser.add_argument('--input', '-i', help='Input HCL schema file path')
    parser.add_argument('--output', '-o', help='Output SQL DDL file path')
    
    args = parser.parse_args()
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Determine paths
    if args.input:
        hcl_file = args.input
    else:
        # Default to script directory
        hcl_file = os.path.join(script_dir, "db.hcl")
    
    if args.output:
        output_file = args.output
    else:
        # Default to script directory with db.sql name as per requirements
        output_file = os.path.join(script_dir, "db.sql")
    
    # Check if HCL file exists
    if not os.path.exists(hcl_file):
        print(f"Error: HCL file not found: {hcl_file}")
        print(f"Please make sure the db.hcl file exists in the script directory: {script_dir}")
        return 1
    
    try:
        converter = HCLToDDLConverter()
        converter.convert_file(hcl_file, output_file)
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
