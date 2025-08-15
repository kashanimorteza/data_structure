table "log" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "date" {
    null = true
    type = varchar
  }
  column "name" {
    null = true
    type = varchar
  }
  column "status" {
    null = true
    type = boolean
  }
  column "data" {
    null = true
    type = varchar
  }
  primary_key {
    columns = [column.id]
  }
}
table "config" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "timeZone" {
    null = true
    type = varchar
  }
  column "path_api" {
    null = true
    type = varchar
  }
  column "path_gui" {
    null = true
    type = varchar
  }
  column "webapi_title" {
    null = true
    type = varchar
  }
  column "webapi_description" {
    null = true
    type = varchar
  }
  column "webapi_version" {
    null = true
    type = varchar
  }
  column "webapi_openapi_url" {
    null = true
    type = varchar
  }
  column "webapi_docs_url" {
    null = true
    type = varchar
  }
  column "webapi_redoc_url" {
    null = true
    type = varchar
  }
  column "webapi_key" {
    null = true
    type = varchar
  }
  column "webapi_host" {
    null = true
    type = varchar
  }
  column "webapi_port" {
    null = true
    type = integer
  }
  column "webapi_workers" {
    null = true
    type = integer
  }
  column "nginx_api_host" {
    null = true
    type = varchar
  }
  column "nginx_api_port" {
    null = true
    type = integer
  }
  column "nginx_api_key" {
    null = true
    type = varchar
  }
  column "nginx_gui_host" {
    null = true
    type = varchar
  }
  column "nginx_gui_port" {
    null = true
    type = integer
  }
  column "nginx_gui_key" {
    null = true
    type = varchar
  }
  column "git_email" {
    null = true
    type = varchar
  }
  column "git_name" {
    null = true
    type = varchar
  }
  column "git_key" {
    null = true
    type = varchar
  }
  column "hotspod_ssid" {
    null = true
    type = varchar
  }
  column "hotspod_ip" {
    null = true
    type = varchar
  }
  column "hotspod_pass" {
    null = true
    type = varchar
  }
  column "wifi_ssid" {
    null = true
    type = varchar
  }
  column "wifi_ip" {
    null = true
    type = varchar
  }
  column "wifi_pass" {
    null = true
    type = varchar
  }
  column "debug" {
    null = true
    type = boolean
  }
  column "log" {
    null = true
    type = boolean
  }
  column "verbose" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "user" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "username" {
    null = true
    type = varchar
  }
  column "password" {
    null = true
    type = varchar
  }
  column "key" {
    null = true
    type = varchar
  }
  column "email" {
    null = true
    type = varchar
  }
  column "phone" {
    null = true
    type = varchar
  }
  column "tg_id" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "timer" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "user_id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "timer_item" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "timer_id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "value_from" {
    null = true
    type = varchar
  }
  column "value_to" {
    null = true
    type = varchar
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "timer_device" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "timer_id" {
    null = false
    type = integer
  }
  column "device_id" {
    null = false
    type = integer
  }
  column "command_id" {
    null = false
    type = integer
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "timer_limit" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "device_id" {
    null = false
    type = integer
  }
  column "command_from_id" {
    null = false
    type = integer
  }
  column "command_to_id" {
    null = false
    type = integer
  }
  column "value" {
    null = false
    type = integer
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "device" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "zone_id" {
    null = false
    type = integer
  }
  column "port_id" {
    null = false
    type = integer
  }
  column "power_id" {
    null = false
    type = integer
  }
  column "command_id" {
    null = false
    type = integer
  }
  column "value" {
    null = false
    type = integer
  }
  column "tune" {
    null = false
    type = integer
  }
  column "date" {
    null = true
    type = sql("time")
  }
  column "address" {
    null = true
    type = varchar
  }
  column "name" {
    null = true
    type = varchar
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "port" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "user_id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "pin" {
    null = true
    type = integer
  }
  column "port" {
    null = true
    type = integer
  }
  column "value" {
    null = true
    type = integer
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  column "protocol" {
    null = false
    type = varchar(8)
  }
  column "type" {
    null = false
    type = varchar(4)
  }
  primary_key {
    columns = [column.id]
  }
}
table "device_command" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "device_id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "value_from" {
    null = true
    type = integer
  }
  column "value_to" {
    null = true
    type = integer
  }
  column "delay" {
    null = true
    type = integer
  }
  column "description" {
    null = true
    type = varchar
  }
  column "reload" {
    null = true
    type = boolean
  }
  column "enable" {
    null = true
    type = boolean
  }
  column "type" {
    null = false
    type = varchar(7)
  }
  primary_key {
    columns = [column.id]
  }
}
table "zone" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "user_id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "zone_command" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "zone_id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "zone_command_if" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "zone_command_id" {
    null = false
    type = integer
  }
  column "device_id" {
    null = false
    type = integer
  }
  column "command_id" {
    null = false
    type = integer
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "zone_command_action" {
  schema = schema.main
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = varchar
  }
  column "zone_command_id" {
    null = false
    type = integer
  }
  column "device_id" {
    null = false
    type = integer
  }
  column "command_id" {
    null = true
    type = integer
  }
  column "description" {
    null = true
    type = varchar
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
schema "main" {
}
