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
