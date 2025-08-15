env "pg" {
  url     = "postgres://USER:PASS@localhost:5432/APPDB?search_path=public&sslmode=disable"
  dev_url = "docker://postgres/15/dev?search_path=public"
  dir     = "file://migrations_pg"
  // منبع حقیقت:
  to      = "file://schema.hcl"
}

env "mysql" {
  url     = "mysql://USER:PASS@localhost:3306/appdb"
  dev_url = "docker://mysql/8/dev"
  dir     = "file://migrations_mysql"
  // اگر schema.hcl را بدون پیش‌فرض UUID نگه می‌دارید، همین را استفاده کنید.
  to      = "file://schema_mysql.hcl"
}

env "sqlite" {
  url     = "sqlite://./app.db"
  dev_url = "sqlite://dev?mode=memory"
  dir     = "file://migrations_sqlite"
  to      = "file://schema_sqlite.hcl"
}
