schema "main" {}

table "device_command" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "device_id" {
    type = int
    null = false
  }

  column "name" {
    type = varchar
    null = true
  }

  column "value_from" {
    type = int
    null = true
  }

  column "value_to" {
    type = int
    null = true
  }

  column "delay" {
    type = int
    null = true
  }

  column "description" {
    type = varchar
    null = true
  }

  column "reload" {
    type = bool
    null = true
  }

  column "enable" {
    type = bool
    null = true
  }

  column "type" {
    type = varchar(7)
    null = false
  }

  primary_key {
    columns = [column.id]
  }
}
