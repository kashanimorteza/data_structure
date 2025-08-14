schema "main" {}

table "log" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "date" {
    type = varchar
    null = true
  }

  column "name" {
    type = varchar
    null = true
  }

  column "status" {
    type = bool
    null = true
  }

  column "data" {
    type = varchar
    null = true
  }

  primary_key {
    columns = [column.id]
  }
}
