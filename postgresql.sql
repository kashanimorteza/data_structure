-- Create "config" table
CREATE TABLE "config" (
  "id" integer NOT NULL,
  "name" character varying NULL,
  "timeZone" character varying NULL,
  "path_api" character varying NULL,
  "path_gui" character varying NULL,
  "webapi_title" character varying NULL,
  "webapi_description" character varying NULL,
  "webapi_version" character varying NULL,
  "webapi_openapi_url" character varying NULL,
  "webapi_docs_url" character varying NULL,
  "webapi_redoc_url" character varying NULL,
  "webapi_key" character varying NULL,
  "webapi_host" character varying NULL,
  "webapi_port" integer NULL,
  "webapi_workers" integer NULL,
  "nginx_api_host" character varying NULL,
  "nginx_api_port" integer NULL,
  "nginx_api_key" character varying NULL,
  "nginx_gui_host" character varying NULL,
  "nginx_gui_port" integer NULL,
  "nginx_gui_key" character varying NULL,
  "git_email" character varying NULL,
  "git_name" character varying NULL,
  "git_key" character varying NULL,
  "hotspod_ssid" character varying NULL,
  "hotspod_ip" character varying NULL,
  "hotspod_pass" character varying NULL,
  "wifi_ssid" character varying NULL,
  "wifi_ip" character varying NULL,
  "wifi_pass" character varying NULL,
  "debug" boolean NULL,
  "log" boolean NULL,
  "verbose" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "device" table
CREATE TABLE "device" (
  "id" integer NOT NULL,
  "zone_id" integer NOT NULL,
  "port_id" integer NOT NULL,
  "power_id" integer NOT NULL,
  "command_id" integer NOT NULL,
  "value" integer NOT NULL,
  "tune" integer NOT NULL,
  "date" time NULL,
  "address" character varying NULL,
  "name" character varying NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "device_command" table
CREATE TABLE "device_command" (
  "id" integer NOT NULL,
  "device_id" integer NOT NULL,
  "name" character varying NULL,
  "value_from" integer NULL,
  "value_to" integer NULL,
  "delay" integer NULL,
  "description" character varying NULL,
  "reload" boolean NULL,
  "enable" boolean NULL,
  "type" character varying(7) NOT NULL,
  PRIMARY KEY ("id")
);
-- Create "log" table
CREATE TABLE "log" (
  "id" integer NOT NULL,
  "date" character varying NULL,
  "name" character varying NULL,
  "status" boolean NULL,
  "data" character varying NULL,
  PRIMARY KEY ("id")
);
-- Create "port" table
CREATE TABLE "port" (
  "id" integer NOT NULL,
  "user_id" integer NOT NULL,
  "name" character varying NULL,
  "pin" integer NULL,
  "port" integer NULL,
  "value" integer NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  "protocol" character varying(8) NOT NULL,
  "type" character varying(4) NOT NULL,
  PRIMARY KEY ("id")
);
-- Create "timer" table
CREATE TABLE "timer" (
  "id" integer NOT NULL,
  "user_id" integer NOT NULL,
  "name" character varying NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "timer_device" table
CREATE TABLE "timer_device" (
  "id" integer NOT NULL,
  "timer_id" integer NOT NULL,
  "device_id" integer NOT NULL,
  "command_id" integer NOT NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "timer_item" table
CREATE TABLE "timer_item" (
  "id" integer NOT NULL,
  "timer_id" integer NOT NULL,
  "name" character varying NULL,
  "value_from" character varying NULL,
  "value_to" character varying NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "timer_limit" table
CREATE TABLE "timer_limit" (
  "id" integer NOT NULL,
  "device_id" integer NOT NULL,
  "command_from_id" integer NOT NULL,
  "command_to_id" integer NOT NULL,
  "value" integer NOT NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "user" table
CREATE TABLE "user" (
  "id" integer NOT NULL,
  "name" character varying NULL,
  "username" character varying NULL,
  "password" character varying NULL,
  "key" character varying NULL,
  "email" character varying NULL,
  "phone" character varying NULL,
  "tg_id" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "zone" table
CREATE TABLE "zone" (
  "id" integer NOT NULL,
  "user_id" integer NOT NULL,
  "name" character varying NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "zone_command" table
CREATE TABLE "zone_command" (
  "id" integer NOT NULL,
  "zone_id" integer NOT NULL,
  "name" character varying NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "zone_command_action" table
CREATE TABLE "zone_command_action" (
  "id" integer NOT NULL,
  "name" character varying NULL,
  "zone_command_id" integer NOT NULL,
  "device_id" integer NOT NULL,
  "command_id" integer NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
-- Create "zone_command_if" table
CREATE TABLE "zone_command_if" (
  "id" integer NOT NULL,
  "name" character varying NULL,
  "zone_command_id" integer NOT NULL,
  "device_id" integer NOT NULL,
  "command_id" integer NOT NULL,
  "description" character varying NULL,
  "enable" boolean NULL,
  PRIMARY KEY ("id")
);
