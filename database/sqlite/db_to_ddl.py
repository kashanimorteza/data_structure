#!/usr/bin/env python3
"""
SQLite to DDL Generator
Based on sql_single.sh approach using SELECT sql FROM sqlite_master
Generates single DDL file with CREATE TABLE statements (no DROP tables)
"""

import sqlite3
import os
import sys


class SQLiteToDDLGenerator:
    """Simple SQLite to DDL generator based on sql_single.sh approach"""
    
    def __init__(self, db_path: str, output_path: str):
        self.db_path = db_path
        self.output_path = output_path
    
    def connect_to_database(self) -> sqlite3.Connection:
        """Connect to SQLite database"""
        if not os.path.exists(self.db_path):
            raise FileNotFoundError(f"Database file not found: {self.db_path}")
        
        return sqlite3.connect(self.db_path)
    
    def get_user_tables(self, conn: sqlite3.Connection) -> list[str]:
        """Get all user tables (skip sqlite internal tables)"""
        cursor = conn.cursor()
        cursor.execute("""
            SELECT name FROM sqlite_master 
            WHERE type='table' AND name NOT LIKE 'sqlite_%'
            ORDER BY name
        """)
        
        return [row[0] for row in cursor.fetchall()]
    
    def get_create_statement(self, conn: sqlite3.Connection, table_name: str) -> str:
        """Get the CREATE TABLE statement using sql_single.sh approach"""
        cursor = conn.cursor()
        cursor.execute("SELECT sql FROM sqlite_master WHERE type='table' AND name=?", (table_name,))
        result = cursor.fetchone()
        return result[0] if result else ""
    
    def generate_ddl_file(self) -> None:
        """Generate single DDL file with CREATE TABLE statements only"""
        # Connect to database
        conn = self.connect_to_database()
        
        try:
            # Get all user tables
            tables = self.get_user_tables(conn)
            
            if not tables:
                print("No user tables found in the database")
                return
            
            print(f"Found {len(tables)} tables:")
            for table in tables:
                print(f"  - {table}")
            
            # Generate DDL content
            ddl_lines = []
            
            # Add header comment
            ddl_lines.append("-- SQL DDL generated from SQLite database")
            ddl_lines.append("-- Using SELECT sql FROM sqlite_master approach")
            ddl_lines.append("-- Contains CREATE TABLE statements only (no DROP tables)")
            ddl_lines.append("")
            
            # Add CREATE TABLE statements for each table
            for table_name in tables:
                # Skip empty table names
                if not table_name.strip():
                    continue
                
                # Get CREATE TABLE statement
                create_sql = self.get_create_statement(conn, table_name)
                
                if create_sql:
                    ddl_lines.append(f"{create_sql};")
                    ddl_lines.append("")
                else:
                    print(f"Warning: Could not get CREATE statement for table '{table_name}'")
            
            # Write to output file
            with open(self.output_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(ddl_lines))
            
            print(f"\n✅ DDL file generated successfully!")
            print(f"Output file: {self.output_path}")
            print("📋 Contents: CREATE TABLE statements only (no DROP tables)")
            
        finally:
            conn.close()


def main():
    """Main function"""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Generate DDL file from SQLite database (CREATE TABLE only)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Based on sql_single.sh approach using:
  SELECT sql FROM sqlite_master WHERE type='table' AND name='$table';

Examples:
  # Use default paths
  %(prog)s
  
  # Custom database and output file
  %(prog)s --input /path/to/database.sqlite --output /path/to/output.sql
        """
    )
    parser.add_argument('--input', '-i', help='Input SQLite database file path (default: db.sqlite)')
    parser.add_argument('--output', '-o', help='Output DDL file path (default: db.sql)')
    
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
    
    print("🔄 SQLite to DDL Generator")
    print("=" * 40)
    print(f"Database: {os.path.abspath(db_path)}")
    print(f"Output: {os.path.abspath(output_path)}")
    print("Method: SELECT sql FROM sqlite_master")
    print()
    
    # Check if database file exists
    if not os.path.exists(db_path):
        print(f"❌ Error: SQLite database file not found: {db_path}")
        print("Please make sure the db.sqlite file exists.")
        return 1
    
    try:
        generator = SQLiteToDDLGenerator(db_path, output_path)
        generator.generate_ddl_file()
        return 0
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())