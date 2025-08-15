<!--------------------------------------------------------------------------------- Description -->
# Data Structure
    using Atlas



<!--------------------------------------------------------------------------------- Install -->
<br><br>  

# Install
<!--------------------------------------------------- Mac -->
### Mac
```bash
brew install ariga/tap/atlas
atlas version
```
<!--------------------------------------------------- Linux -->
### Linux
```bash
```



<!--------------------------------------------------------------------------------- Migration -->
<br><br>  

# Migration
<!--------------------------------------------------- Mac -->
### Create
```bash
atlas migrate new user
atlas migrate new user --edit
atlas migrate new user --dir "file://migrationsq"
```



<!--------------------------------------------------------------------------------- DB To DDL -->
<br><br>

# DB To DDL
<!--------------------------------------------------- SQLite -->
### SQLite
```bash
atlas schema inspect -u "sqlite://sqlite.db" --format '{{ sql . }}' > sqlite.sql
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
atlas schema inspect --url "postgres://raspberrypi:123456@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" --format '{{ sql . }}' > postgresql.sql
```
<!--------------------------------------------------- MySQL -->
### MySQL
```bash
```



<!--------------------------------------------------------------------------------- DB To HCL -->
<br><br>

# DB To HCL
<!--------------------------------------------------- SQLite -->
### SQLite
```bash
atlas schema inspect -u "sqlite://sqlite.db" > sqlite.hcl
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
atlas schema inspect --url "postgres://raspberrypi:123456@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" > postgresql.hcl
```
<!--------------------------------------------------- MySQL -->
### MySQL
```bash
```



<!--------------------------------------------------------------------------------- HCL To DDL -->
<br><br>

# HCL To DDL
<!--------------------------------------------------- SQLite -->
### SQLite
```bash
atlas schema inspect --url "file://sqlite.hcl" --dev-url "sqlite://:memory:" --format '{{ sql . }}' > sqlite.sql
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
atlas schema inspect --url "file://postgresql.hcl" --dev-url "postgres://raspberrypi:123456@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" --format '{{ sql . }}' > postgresql.sql
```
<!--------------------------------------------------- MySQL -->
### MySQL
```bash
```



<!--------------------------------------------------------------------------------- DDL To DB -->
<br><br>

# DDL To DB
<!--------------------------------------------------- SQLite -->
### SQLite
```bash
sqlite3 sqlite.db < sqlite.sql
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
PGPASSWORD='123456' psql -U raspberrypi -h 192.168.64.7 -d raspberrypi -f postgresql.sql
```
<!--------------------------------------------------- MySQL -->
### MySQL
```bash
```


<!--------------------------------------------------------------------------------- Convert sqlite to postgresql -->
<br><br>

# Convert sqlite to postgresql
```bash
PGPASSWORD='123456' psql -h 192.168.64.7 -U postgres -d postgres -c "DROP DATABASE raspberrypi;"
PGPASSWORD='123456' psql -h 192.168.64.7 -U postgres -d postgres -c "CREATE DATABASE raspberrypi;"
atlas schema inspect -u "sqlite://sqlite.db" > sqlite.hcl
PGPASSWORD='123456' atlas schema inspect --url "file://sqlite.hcl" --dev-url "postgres://postgres@192.168.64.7:5432/raspberrypi?sslmode=disable&search_path=public" --format '{{ sql . }}' > postgresql.sql
PGPASSWORD='123456' psql -U postgres -h 192.168.64.7 -d raspberrypi -f postgresql.sql
```