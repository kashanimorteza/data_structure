schema "main" {}

table "config" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "name" {
    type = varchar
    null = true
  }

  column "timeZone" {
    type = varchar
    null = true
  }

  column "path_api" {
    type = varchar
    null = true
  }

  column "path_gui" {
    type = varchar
    null = true
  }

  column "webapi_title" {
    type = varchar
    null = true
  }

  column "webapi_description" {
    type = varchar
    null = true
  }

  column "webapi_version" {
    type = varchar
    null = true
  }

  column "webapi_openapi_url" {
    type = varchar
    null = true
  }

  column "webapi_docs_url" {
    type = varchar
    null = true
  }

  column "webapi_redoc_url" {
    type = varchar
    null = true
  }

  column "webapi_key" {
    type = varchar
    null = true
  }

  column "webapi_host" {
    type = varchar
    null = true
  }

  column "webapi_port" {
    type = int
    null = true
  }

  column "webapi_workers" {
    type = int
    null = true
  }

  column "nginx_api_host" {
    type = varchar
    null = true
  }

  column "nginx_api_port" {
    type = int
    null = true
  }

  column "nginx_api_key" {
    type = varchar
    null = true
  }

  column "nginx_gui_host" {
    type = varchar
    null = true
  }

  column "nginx_gui_port" {
    type = int
    null = true
  }

  column "nginx_gui_key" {
    type = varchar
    null = true
  }

  column "git_email" {
    type = varchar
    null = true
  }

  column "git_name" {
    type = varchar
    null = true
  }

  column "git_key" {
    type = varchar
    null = true
  }

  column "hotspod_ssid" {
    type = varchar
    null = true
  }

  column "hotspod_ip" {
    type = varchar
    null = true
  }

  column "hotspod_pass" {
    type = varchar
    null = true
  }

  column "wifi_ssid" {
    type = varchar
    null = true
  }

  column "wifi_ip" {
    type = varchar
    null = true
  }

  column "wifi_pass" {
    type = varchar
    null = true
  }

  column "debug" {
    type = bool
    null = true
  }

  column "log" {
    type = bool
    null = true
  }

  column "verbose" {
    type = bool
    null = true
  }

  primary_key {
    columns = [column.id]
  }
}

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

table "timer_device" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "timer_id" {
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

table "zone" {
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

table "zone_command" {
  schema = schema.main

  column "id" {
    type = int
    null = false
  }

  column "zone_id" {
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

table "zone_command_action" {
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
