schema "main" {}

table "timer_item" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "timer_id" {
    type = int
    null = false
  }

  column "name" {
    type = varchar
    null = true
  }

  column "value_from" {
    type = varchar
    null = true
  }

  column "value_to" {
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
