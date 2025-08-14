schema "main" {}

table "port" {
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

  column "pin" {
    type = int
    null = true
  }

  column "port" {
    type = int
    null = true
  }

  column "value" {
    type = int
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

  column "protocol" {
    type = varchar(8)
    null = false
  }

  column "type" {
    type = varchar(4)
    null = false
  }

  primary_key {
    columns = [column.id]
  }
}
