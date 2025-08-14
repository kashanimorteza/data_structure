schema "main" {}

table "timer_limit" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "device_id" {
    type = int
    null = false
  }

  column "command_from_id" {
    type = int
    null = false
  }

  column "command_to_id" {
    type = int
    null = false
  }

  column "value" {
    type = int
    null = false
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
