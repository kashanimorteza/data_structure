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
Postgres
```bash
atlas migrate diff init_pg --env pg
```

MySQL
```bash
atlas migrate diff init_mysql --env mysql
```

SQLite
```bash
atlas migrate diff init_sqlite --env sqlite
```



<!--------------------------------------------------------------------------------- Apply to database -->
<br><br>

### Apply to database
Postgres
```bash
atlas migrate apply --env pg
```

MySQL
```bash
atlas migrate apply --env mysql
```

SQLite
```bash
atlas migrate apply --env sqlite
```