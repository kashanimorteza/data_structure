#!/usr/bin/env python3
"""
DDL to HCL Generator
Converts SQL DDL files to Atlas HCL schema format
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
        # Remove extra whitespace and quotes
        column_def = re.sub(r'\s+', ' ', column_def.strip())
        column_def = column_def.replace('"', '')
        
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


class DDLToHCLConverter:
    """Converts DDL tables to HCL schema format"""
    
    def __init__(self):
        self.type_mapping = {
            'INTEGER': 'int',
            'VARCHAR': 'varchar',
            'VARCHAR(7)': 'varchar(7)',
            'VARCHAR(8)': 'varchar(8)',
            'VARCHAR(4)': 'varchar(4)',
            'VARCHAR(255)': 'varchar',
            'BOOLEAN': 'bool',
            'TEXT': 'text',
            'DATETIME': 'datetime',
            'DATE': 'date',
            'TIME': 'time',
            'REAL': 'float',
            'FLOAT': 'float',
            'DECIMAL': 'decimal',
            'JSON': 'json',
            'BLOB': 'blob'
        }
    
    def generate_hcl_schema(self, tables: List[DDLTable], schema_name: str = "main") -> str:
        """Generate HCL schema from DDL tables"""
        hcl_lines = [f'schema "{schema_name}" {{}}', '']
        
        for table in tables:
            hcl_lines.extend(self._generate_table_hcl(table, schema_name))
            hcl_lines.append('')
        
        return '\n'.join(hcl_lines)
    
    def _generate_table_hcl(self, table: DDLTable, schema_name: str) -> List[str]:
        """Generate HCL for a single table"""
        lines = [f'table "{table.name}" {{']
        lines.append(f'  schema = schema.{schema_name}')
        lines.append('')
        
        # Add columns
        for column in table.columns:
            lines.extend(self._generate_column_hcl(column))
            lines.append('')
        
        # Add primary key if there are any primary key columns
        if table.primary_keys:
            lines.append('  primary_key {')
            if len(table.primary_keys) == 1:
                lines.append(f'    columns = [column.{table.primary_keys[0]}]')
            else:
                pk_columns = ', '.join(f'column.{pk}' for pk in table.primary_keys)
                lines.append(f'    columns = [{pk_columns}]')
            lines.append('  }')
        
        lines.append('}')
        return lines
    
    def _generate_column_hcl(self, column: DDLColumn) -> List[str]:
        """Generate HCL for a single column"""
        lines = [f'  column "{column.name}" {{']
        
        # Map DDL type to HCL type
        hcl_type = self.type_mapping.get(column.type.upper(), column.type.lower())
        
        # Handle varchar with length
        if column.type.upper().startswith('VARCHAR'):
            if '(' in column.type:
                # Keep the length specification
                length_match = re.search(r'VARCHAR\((\d+)\)', column.type.upper())
                if length_match:
                    length = length_match.group(1)
                    if length in ['7', '8', '4']:
                        hcl_type = f'varchar({length})'
                    else:
                        hcl_type = 'varchar'
                else:
                    hcl_type = 'varchar'
            else:
                hcl_type = 'varchar'
        
        lines.append(f'    type = {hcl_type}')
        
        # Null constraint
        null_value = "true" if column.nullable else "false"
        lines.append(f'    null = {null_value}')
        
        # Auto increment for id fields
        if column.auto_increment:
            lines.append('    auto_increment = true')
        
        # Default value
        if column.default is not None:
            if column.default.upper() in ['TRUE', 'FALSE']:
                lines.append(f'    default = {column.default.lower()}')
            elif column.default.isdigit() or (column.default.startswith('-') and column.default[1:].isdigit()):
                lines.append(f'    default = {column.default}')
            elif column.default.upper() == 'NULL':
                lines.append('    default = null')
            else:
                # String default (remove quotes if present)
                default_val = column.default.strip("'\"")
                lines.append(f'    default = "{default_val}"')
        
        lines.append('  }')
        return lines
    
    def convert_file(self, ddl_file: str, output_file: str, schema_name: str = "main") -> None:
        """Convert DDL file to HCL file"""
        # Parse DDL file
        parser = DDLParser()
        tables = parser.parse_file(ddl_file)
        
        if not tables:
            print("No tables found in DDL file")
            return
        
        print(f"Found {len(tables)} tables:")
        for table in tables:
            print(f"  - {table.name} ({len(table.columns)} columns)")
        
        # Generate HCL schema
        hcl_content = self.generate_hcl_schema(tables, schema_name)
        
        # Write to output file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(hcl_content)
        
        print(f"\nHCL schema generated successfully!")
        print(f"Output file: {output_file}")


def main():
    """Main function to convert DDL to HCL"""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Convert SQL DDL to HCL schema format",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use default paths
  %(prog)s
  
  # Custom paths
  %(prog)s --input custom.sql --output custom.hcl
  
  # Different schema name
  %(prog)s --schema production
        """
    )
    parser.add_argument('--input', '-i', help='Input SQL DDL file path (default: db.sql)')
    parser.add_argument('--output', '-o', help='Output HCL file path (default: db.hcl)')
    parser.add_argument('--schema', '-s', default='main', help='Schema name (default: main)')
    
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
        output_file = os.path.join(script_dir, "db.hcl")
    
    print("🔄 DDL to HCL Generator")
    print("=" * 30)
    print(f"Input: {os.path.abspath(ddl_file)}")
    print(f"Output: {os.path.abspath(output_file)}")
    print(f"Schema: {args.schema}")
    print()
    
    # Check if DDL file exists
    if not os.path.exists(ddl_file):
        print(f"❌ Error: DDL file not found: {ddl_file}")
        print("Please make sure the db.sql file exists.")
        return 1
    
    try:
        converter = DDLToHCLConverter()
        converter.convert_file(ddl_file, output_file, args.schema)
        return 0
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
