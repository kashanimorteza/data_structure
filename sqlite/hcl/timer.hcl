schema "main" {}

table "timer" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "user_id" {
    type = int
    null = false
  }

  column "name" {
    type = varchar
    null = true
  }

  column "description" {
    type = varchar
    null = true
  }

  column "enable" {
    type = bool
    null = true
  }

  primary_key {
    columns = [column.id]
  }
}
