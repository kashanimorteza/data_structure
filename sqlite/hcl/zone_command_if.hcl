schema "main" {}

table "zone_command_if" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "name" {
    type = varchar
    null = true
  }

  column "zone_command_id" {
    type = int
    null = false
  }

  column "device_id" {
    type = int
    null = false
  }

  column "command_id" {
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
