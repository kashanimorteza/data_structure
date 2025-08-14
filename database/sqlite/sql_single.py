#!/usr/bin/env python3
"""
SQLite to Individual SQL Migration Files Generator
Similar to sql_single.sh but in Python
Creates separate migration folders for each table with up.sql and down.sql files
"""

import sqlite3
import os
import sys
from pathlib import Path


class SQLiteMigrationGenerator:
    """Generates individual migration files for each table"""
    
    def __init__(self, db_path: str, root_dir: str = "./sql"):
        self.db_path = db_path
        self.root_dir = root_dir
    
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
        """Get the CREATE TABLE statement for a specific table"""
        cursor = conn.cursor()
        cursor.execute("""
            SELECT sql FROM sqlite_master 
            WHERE type='table' AND name=?
        """, (table_name,))
        
        result = cursor.fetchone()
        return result[0] if result else ""
    
    def create_migration_files(self, table_name: str, create_sql: str) -> None:
        """Create up.sql and down.sql files for a table"""
        # Create table directory
        table_dir = Path(self.root_dir) / table_name
        table_dir.mkdir(parents=True, exist_ok=True)
        
        # Write up.sql (CREATE TABLE statement)
        up_file = table_dir / "up.sql"
        with open(up_file, 'w', encoding='utf-8') as f:
            f.write(f"{create_sql};\n")
        
        # Write down.sql (DROP TABLE statement)
        down_file = table_dir / "down.sql"
        with open(down_file, 'w', encoding='utf-8') as f:
            f.write(f"DROP TABLE {table_name};\n")
        
        print(f"Created {table_dir}/up.sql and {table_dir}/down.sql")
    
    def generate_migrations(self) -> None:
        """Generate migration files for all tables"""
        # Create root migration directory
        Path(self.root_dir).mkdir(parents=True, exist_ok=True)
        print(f"Migration root directory: {os.path.abspath(self.root_dir)}")
        
        # Connect to database
        conn = self.connect_to_database()
        
        try:
            # Get all user tables
            tables = self.get_user_tables(conn)
            
            if not tables:
                print("No user tables found in the database")
                return
            
            print(f"\nFound {len(tables)} tables:")
            for table in tables:
                print(f"  - {table}")
            
            print(f"\nGenerating migration files...")
            
            # Generate migration files for each table
            for table_name in tables:
                # Skip empty table names
                if not table_name.strip():
                    continue
                
                # Get CREATE TABLE statement
                create_sql = self.get_create_statement(conn, table_name)
                
                if create_sql:
                    self.create_migration_files(table_name, create_sql)
                else:
                    print(f"Warning: Could not get CREATE statement for table '{table_name}'")
            
            print(f"\n✅ Migration files generated successfully in: {os.path.abspath(self.root_dir)}")
            
        finally:
            conn.close()


def main():
    """Main function"""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Generate individual SQL migration files for each table",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use default paths
  %(prog)s
  
  # Custom database and output directory
  %(prog)s --input /path/to/database.sqlite --output ./migrations
  
  # Use current directory structure
  %(prog)s --input db.sqlite --output ./sql
        """
    )
    parser.add_argument('--input', '-i', help='Input SQLite database file path (default: db.sqlite)')
    parser.add_argument('--output', '-o', help='Output root directory for migrations (default: ./sql)')
    
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
        root_dir = args.output
    else:
        # Default to sql directory in script location
        root_dir = os.path.join(script_dir, "sql")
    
    print("🔄 SQLite to Individual Migration Files Generator")
    print("=" * 50)
    print(f"Database: {os.path.abspath(db_path)}")
    print(f"Output: {os.path.abspath(root_dir)}")
    print()
    
    # Check if database file exists
    if not os.path.exists(db_path):
        print(f"❌ Error: SQLite database file not found: {db_path}")
        print(f"Please make sure the database file exists.")
        return 1
    
    try:
        generator = SQLiteMigrationGenerator(db_path, root_dir)
        generator.generate_migrations()
        return 0
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
