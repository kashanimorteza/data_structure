<!--------------------------------------------------------------------------------- Description -->
# Data Structure
    using Atlas



<!--------------------------------------------------------------------------------- Resource -->
<br><br>  

## Install
Mac
```bash
brew install ariga/tap/atlas
atlas version
```



<!--------------------------------------------------------------------------------- Resource -->
<br><br>  

## Migration
Create
```bash
atlas migrate new user
atlas migrate new user --edit
atlas migrate new user --dir "file://migrationsq"
```



<!--------------------------------------------------------------------------------- Init -->
<br><br>

## Init
SQLite
```bash
atlas migrate diff init_sqlite --env sqlite
```

Postgres
```bash
atlas migrate diff init_pg --env pg
```

MySQL
```bash
atlas migrate diff init_mysql --env mysql
```



<!--------------------------------------------------------------------------------- Apply to database -->
<br><br>

## Apply to database
SQLite
```bash
atlas migrate apply --env sqlite
```

Postgres
```bash
atlas migrate apply --env pg
```

MySQL
```bash
atlas migrate apply --env mysql
```


<!--------------------------------------------------------------------------------- HCL To DDL -->
<br><br>

## HCL To DDL

SQLite
```bash
atlas migrate diff user --to "file://hcl/user.hcl" --dev-url "sqlite://dev?mode=memory" --dir "file://ddl/sqlite"
atlas migrate diff user --to "file://hcl/user.hcl" --dev-url "sqlite://dev?mode=memory" --dir "file://ddl/sqlite"   --format "{{ sql . }}" > user.sqlc
```

Postgres
```bash
atlas migrate diff user --to "file://hcl/user.hcl" --dev-url "postgres://raspberrypi_api:123456@localhost:5432/raspberrypi_api?search_path=public&sslmode=disable" --dir "file://ddl/pg"
```

Mysql
```bash
```


<!--------------------------------------------------------------------------------- Script -->
<br><br>

## Script

### SQLite
sqlite_to_sql.sh
    Read sqlite database and generate DDL of all tables and store to sql folder

sqlite_to_hcl.sh
    Read sqlite database and generate HCL of all tables and store to hcl folder

hcl_to_ddl.sh
    Read all file on hcl folder and generate DDL and store to ddl folder