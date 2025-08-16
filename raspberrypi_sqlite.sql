-- Create "log" table
CREATE TABLE `log` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `date` TEXT NOT NULL DEFAULT '',
  `name` TEXT NOT NULL DEFAULT '',
  `status` BOOLEAN NOT NULL DEFAULT 0,
  `data` TEXT NOT NULL DEFAULT ''
);

-- Create "config" table
CREATE TABLE `config` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `timeZone` TEXT NOT NULL DEFAULT '',
  `path_api` TEXT NOT NULL DEFAULT '',
  `path_gui` TEXT NOT NULL DEFAULT '',
  `webapi_title` TEXT NOT NULL DEFAULT '',
  `webapi_description` TEXT NOT NULL DEFAULT '',
  `webapi_version` TEXT NOT NULL DEFAULT '',
  `webapi_openapi_url` TEXT NOT NULL DEFAULT '',
  `webapi_docs_url` TEXT NOT NULL DEFAULT '',
  `webapi_redoc_url` TEXT NOT NULL DEFAULT '',
  `webapi_key` TEXT NOT NULL DEFAULT '',
  `webapi_host` TEXT NOT NULL DEFAULT '',
  `webapi_port` INTEGER NULL,
  `webapi_workers` INTEGER NULL,
  `nginx_api_host` TEXT NOT NULL DEFAULT '',
  `nginx_api_port` INTEGER NULL,
  `nginx_api_key` TEXT NOT NULL DEFAULT '',
  `nginx_gui_host` TEXT NOT NULL DEFAULT '',
  `nginx_gui_port` INTEGER NULL,
  `nginx_gui_key` TEXT NOT NULL DEFAULT '',
  `git_email` TEXT NOT NULL DEFAULT '',
  `git_name` TEXT NOT NULL DEFAULT '',
  `git_key` TEXT NOT NULL DEFAULT '',
  `hotspod_ssid` TEXT NOT NULL DEFAULT '',
  `hotspod_ip` TEXT NOT NULL DEFAULT '',
  `hotspod_pass` TEXT NOT NULL DEFAULT '',
  `wifi_ssid` TEXT NOT NULL DEFAULT '',
  `wifi_ip` TEXT NOT NULL DEFAULT '',
  `wifi_pass` TEXT NOT NULL DEFAULT '',
  `debug` BOOLEAN NOT NULL DEFAULT 0,
  `log` BOOLEAN NOT NULL DEFAULT 0,
  `verbose` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "user" table
CREATE TABLE `user` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `username` TEXT NOT NULL DEFAULT '',
  `password` TEXT NOT NULL DEFAULT '',
  `key` TEXT NOT NULL DEFAULT '',
  `email` TEXT NOT NULL DEFAULT '',
  `phone` TEXT NOT NULL DEFAULT '',
  `tg_id` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "timer" table
CREATE TABLE `timer` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` INTEGER NOT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "timer_item" table
CREATE TABLE `timer_item` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `timer_id` INTEGER NOT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `value_from` TEXT NOT NULL DEFAULT '',
  `value_to` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "timer_device" table
CREATE TABLE `timer_device` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `timer_id` INTEGER NOT NULL,
  `device_id` INTEGER NOT NULL,
  `command_id` INTEGER NOT NULL,
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "timer_limit" table
CREATE TABLE `timer_limit` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `device_id` INTEGER NOT NULL,
  `command_from_id` INTEGER NOT NULL,
  `command_to_id` INTEGER NOT NULL,
  `value` INTEGER NOT NULL,
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "device" table
CREATE TABLE `device` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `zone_id` INTEGER NOT NULL,
  `port_id` INTEGER NOT NULL,
  `power_id` INTEGER NOT NULL,
  `command_id` INTEGER NOT NULL,
  `value` INTEGER NOT NULL,
  `tune` INTEGER NOT NULL,
  `date` TEXT NOT NULL DEFAULT '',
  `address` TEXT NOT NULL DEFAULT '',
  `name` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "port" table
CREATE TABLE `port` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` INTEGER NOT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `pin` INTEGER NULL,
  `port` INTEGER NULL,
  `value` INTEGER NULL,
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0,
  `protocol` TEXT NOT NULL DEFAULT '',
  `type` TEXT NOT NULL DEFAULT ''
);

-- Create "device_command" table
CREATE TABLE `device_command` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `device_id` INTEGER NOT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `value_from` INTEGER NULL,
  `value_to` INTEGER NULL,
  `delay` INTEGER NULL,
  `description` TEXT NOT NULL DEFAULT '',
  `reload` BOOLEAN NOT NULL DEFAULT 0,
  `enable` BOOLEAN NOT NULL DEFAULT 0,
  `type` TEXT NOT NULL DEFAULT ''
);

-- Create "zone" table
CREATE TABLE `zone` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` INTEGER NOT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "zone_command" table
CREATE TABLE `zone_command` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `zone_id` INTEGER NOT NULL,
  `name` TEXT NOT NULL DEFAULT '',
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "zone_command_if" table
CREATE TABLE `zone_command_if` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `zone_command_id` INTEGER NOT NULL,
  `device_id` INTEGER NOT NULL,
  `command_id` INTEGER NOT NULL,
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);

-- Create "zone_command_action" table
CREATE TABLE `zone_command_action` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL DEFAULT '',
  `zone_command_id` INTEGER NOT NULL,
  `device_id` INTEGER NOT NULL,
  `command_id` INTEGER NULL,
  `description` TEXT NOT NULL DEFAULT '',
  `enable` BOOLEAN NOT NULL DEFAULT 0
);
