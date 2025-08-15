table "config" {
  schema = schema.public
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = character_varying
  }
  column "timeZone" {
    null = true
    type = character_varying
  }
  column "path_api" {
    null = true
    type = character_varying
  }
  column "path_gui" {
    null = true
    type = character_varying
  }
  column "webapi_title" {
    null = true
    type = character_varying
  }
  column "webapi_description" {
    null = true
    type = character_varying
  }
  column "webapi_version" {
    null = true
    type = character_varying
  }
  column "webapi_openapi_url" {
    null = true
    type = character_varying
  }
  column "webapi_docs_url" {
    null = true
    type = character_varying
  }
  column "webapi_redoc_url" {
    null = true
    type = character_varying
  }
  column "webapi_key" {
    null = true
    type = character_varying
  }
  column "webapi_host" {
    null = true
    type = character_varying
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
    type = character_varying
  }
  column "nginx_api_port" {
    null = true
    type = integer
  }
  column "nginx_api_key" {
    null = true
    type = character_varying
  }
  column "nginx_gui_host" {
    null = true
    type = character_varying
  }
  column "nginx_gui_port" {
    null = true
    type = integer
  }
  column "nginx_gui_key" {
    null = true
    type = character_varying
  }
  column "git_email" {
    null = true
    type = character_varying
  }
  column "git_name" {
    null = true
    type = character_varying
  }
  column "git_key" {
    null = true
    type = character_varying
  }
  column "hotspod_ssid" {
    null = true
    type = character_varying
  }
  column "hotspod_ip" {
    null = true
    type = character_varying
  }
  column "hotspod_pass" {
    null = true
    type = character_varying
  }
  column "wifi_ssid" {
    null = true
    type = character_varying
  }
  column "wifi_ip" {
    null = true
    type = character_varying
  }
  column "wifi_pass" {
    null = true
    type = character_varying
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
table "device" {
  schema = schema.public
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
    type = time
  }
  column "address" {
    null = true
    type = character_varying
  }
  column "name" {
    null = true
    type = character_varying
  }
  column "description" {
    null = true
    type = character_varying
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "device_command" {
  schema = schema.public
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
    type = character_varying
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
    type = character_varying
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
    type = character_varying(7)
  }
  primary_key {
    columns = [column.id]
  }
}
table "log" {
  schema = schema.public
  column "id" {
    null = false
    type = integer
  }
  column "date" {
    null = true
    type = character_varying
  }
  column "name" {
    null = true
    type = character_varying
  }
  column "status" {
    null = true
    type = boolean
  }
  column "data" {
    null = true
    type = character_varying
  }
  primary_key {
    columns = [column.id]
  }
}
table "port" {
  schema = schema.public
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
    type = character_varying
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
    type = character_varying
  }
  column "enable" {
    null = true
    type = boolean
  }
  column "protocol" {
    null = false
    type = character_varying(8)
  }
  column "type" {
    null = false
    type = character_varying(4)
  }
  primary_key {
    columns = [column.id]
  }
}
table "timer" {
  schema = schema.public
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
    type = character_varying
  }
  column "description" {
    null = true
    type = character_varying
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
  schema = schema.public
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
    type = character_varying
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
  schema = schema.public
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
    type = character_varying
  }
  column "value_from" {
    null = true
    type = character_varying
  }
  column "value_to" {
    null = true
    type = character_varying
  }
  column "description" {
    null = true
    type = character_varying
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
  schema = schema.public
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
    type = character_varying
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "user" {
  schema = schema.public
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = character_varying
  }
  column "username" {
    null = true
    type = character_varying
  }
  column "password" {
    null = true
    type = character_varying
  }
  column "key" {
    null = true
    type = character_varying
  }
  column "email" {
    null = true
    type = character_varying
  }
  column "phone" {
    null = true
    type = character_varying
  }
  column "tg_id" {
    null = true
    type = character_varying
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
table "zone" {
  schema = schema.public
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
    type = character_varying
  }
  column "description" {
    null = true
    type = character_varying
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
  schema = schema.public
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
    type = character_varying
  }
  column "description" {
    null = true
    type = character_varying
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
  schema = schema.public
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = character_varying
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
    type = character_varying
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
  schema = schema.public
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = true
    type = character_varying
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
    type = character_varying
  }
  column "enable" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
}
schema "public" {
  comment = "standard public schema"
}
