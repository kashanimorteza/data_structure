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



<!--------------------------------------------------------------------------------- DB To DDL -->
<br><br>

## DB To DDL

### SQLite
```bash
cd ./database/sqlite/
atlas schema inspect -u "sqlite://db.sqlite" --format '{{ sql . }}' > db.sql
```

### Postgres
```bash
```

### MySQL
```bash
```



<!--------------------------------------------------------------------------------- DB To HCL -->
<br><br>

## DB To HCL

### SQLite
```bash
cd ./database/sqlite/
atlas schema inspect -u "sqlite://db.sqlite" > db.hcl
```

### Postgres
```bash
```

### MySQL
```bash
```




<!--------------------------------------------------------------------------------- HCL To DDL -->
<br><br>

## HCL To DDL

### SQLite
```bash
cd ./database/sqlite/
atlas schema inspect --url "file://db.hcl" --dev-url "sqlite://:memory:" --format '{{ sql . }}' > db.sql
```

### Postgres
```bash
```

### MySQL
```bash
```


<!--------------------------------------------------------------------------------- DDL To DB -->
<br><br>

## DDL To HCL

### SQLite
```bash
cd ./database/sqlite/
sqlite3 db.sqlite < db.sql
```

### Postgres
```bash
```

### MySQL
```bash
```
