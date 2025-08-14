schema "main" {}

table "user" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "name" {
    type = varchar
    null = true
  }

  column "username" {
    type = varchar
    null = true
  }

  column "password" {
    type = varchar
    null = true
  }

  column "key" {
    type = varchar
    null = true
  }

  column "email" {
    type = varchar
    null = true
  }

  column "phone" {
    type = varchar
    null = true
  }

  column "tg_id" {
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
