<!--------------------------------------------------------------------------------- Description -->
# Data Structure
    using Atlas



<!--------------------------------------------------------------------------------- Install -->
<br><br>  

# Install
<!--------------------------------------------------- Mac -->
Mac
```bash
brew install ariga/tap/atlas
atlas version
```
<!--------------------------------------------------- Linux -->
Linux
```bash
```



<!--------------------------------------------------------------------------------- Migration -->
<br><br>  

# Migration
<!--------------------------------------------------- Create -->
Create
```bash
atlas migrate new user
atlas migrate new user --edit
atlas migrate new user --dir "file://migrationsq"
```



<!--------------------------------------------------------------------------------- Generate -->
<br><br>

# Generate
<!--------------------------------------------------- DB To DDL -->
### DB To DDL
SQLite
```bash
atlas schema inspect -u "sqlite://sqlite.db" --format '{{ sql . }}' > sqlite.sql
```
Postgresql
```bash
atlas schema inspect --url "postgres://raspberrypi:123456@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" --format '{{ sql . }}' > postgresql.sql
```
MySQL
```bash
```
<!--------------------------------------------------- DB To HCL -->
### DB To HCL
SQLite
```bash
atlas schema inspect -u "sqlite://sqlite.db" > sqlite.hcl
```
Postgresql
```bash
atlas schema inspect --url "postgres://raspberrypi:123456@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" > postgresql.hcl
```
MySQL
```bash
```
<!--------------------------------------------------- HCL To DDL -->
### HCL To DDL
SQLite
```bash
atlas schema inspect --url "file://sqlite.hcl" --dev-url "sqlite://:memory:" --format '{{ sql . }}' > sqlite.sql
```
Postgresql
```bash
atlas schema inspect --url "file://postgresql.hcl" --dev-url "postgres://raspberrypi:123456@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" --format '{{ sql . }}' > postgresql.sql
```
MySQL
```bash
```
<!--------------------------------------------------- DDL To DB -->
### DDL To DB
SQLite
```bash
sqlite3 sqlite.db < sqlite.sql
```
Postgresql
```bash
PGPASSWORD='123456' psql -U raspberrypi -h 192.168.64.7 -d raspberrypi -f postgresql.sql
```
MySQL
```bash
```



<!--------------------------------------------------------------------------------- Convert -->
<br><br>

# Convert
<!--------------------------------------------------- Sqlite to Postgresql -->
# Sqlite to Postgresql
```bash
PGPASSWORD='123456' psql -h 192.168.64.7 -U postgres -d postgres -c "DROP DATABASE raspberrypi;"
PGPASSWORD='123456' psql -h 192.168.64.7 -U postgres -d postgres -c "CREATE DATABASE raspberrypi;"
atlas schema inspect -u "sqlite://sqlite.db" > sqlite.hcl
PGPASSWORD='123456' atlas schema inspect --url "file://sqlite.hcl" --dev-url "postgres://postgres@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" --format '{{ sql . }}' > postgresql.sql
PGPASSWORD='123456' psql -U postgres -h 192.168.64.7 -d raspberrypi -f postgresql.sql
```
<!--------------------------------------------------- Postgresql to SQLite -->
# Postgresql to SQLite
```bash
```