schema "main" {}

table "device" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "zone_id" {
    type = int
    null = false
  }

  column "port_id" {
    type = int
    null = false
  }

  column "power_id" {
    type = int
    null = false
  }

  column "command_id" {
    type = int
    null = false
  }

  column "value" {
    type = int
    null = false
  }

  column "tune" {
    type = int
    null = false
  }

  column "date" {
    type = time
    null = true
  }

  column "address" {
    type = varchar
    null = true
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
