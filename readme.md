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
cd ./database/sqlite/
atlas schema inspect -u "sqlite://db.sqlite" --format '{{ sql . }}' > db.sql
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
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
cd ./database/sqlite/
atlas schema inspect -u "sqlite://db.sqlite" > db.hcl
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
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
cd ./database/sqlite/
atlas schema inspect --url "file://db.hcl" --dev-url "sqlite://:memory:" --format '{{ sql . }}' > db.sql
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
```
<!--------------------------------------------------- MySQL -->
### MySQL
```bash
```



<!--------------------------------------------------------------------------------- DDL To DB -->
<br><br>

# DDL To HCL
<!--------------------------------------------------- SQLite -->
### SQLite
```bash
cd ./database/sqlite/
sqlite3 db.sqlite < db.sql
```
<!--------------------------------------------------- Postgresql -->
### Postgresql
```bash
```
<!--------------------------------------------------- MySQL -->
### MySQL
```bash
```
