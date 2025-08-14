-- Create "config" table
CREATE TABLE `config` (
  `id` int NOT NULL,
  `name` varchar NULL,
  `timeZone` varchar NULL,
  `path_api` varchar NULL,
  `path_gui` varchar NULL,
  `webapi_title` varchar NULL,
  `webapi_description` varchar NULL,
  `webapi_version` varchar NULL,
  `webapi_openapi_url` varchar NULL,
  `webapi_docs_url` varchar NULL,
  `webapi_redoc_url` varchar NULL,
  `webapi_key` varchar NULL,
  `webapi_host` varchar NULL,
  `webapi_port` int NULL,
  `webapi_workers` int NULL,
  `nginx_api_host` varchar NULL,
  `nginx_api_port` int NULL,
  `nginx_api_key` varchar NULL,
  `nginx_gui_host` varchar NULL,
  `nginx_gui_port` int NULL,
  `nginx_gui_key` varchar NULL,
  `git_email` varchar NULL,
  `git_name` varchar NULL,
  `git_key` varchar NULL,
  `hotspod_ssid` varchar NULL,
  `hotspod_ip` varchar NULL,
  `hotspod_pass` varchar NULL,
  `wifi_ssid` varchar NULL,
  `wifi_ip` varchar NULL,
  `wifi_pass` varchar NULL,
  `debug` bool NULL,
  `log` bool NULL,
  `verbose` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "device" table
CREATE TABLE `device` (
  `id` int NOT NULL,
  `zone_id` int NOT NULL,
  `port_id` int NOT NULL,
  `power_id` int NOT NULL,
  `command_id` int NOT NULL,
  `value` int NOT NULL,
  `tune` int NOT NULL,
  `date` varchar NULL,
  `address` varchar NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "device_command" table
CREATE TABLE `device_command` (
  `id` int NOT NULL,
  `device_id` int NOT NULL,
  `name` varchar NULL,
  `value_from` int NULL,
  `value_to` int NULL,
  `delay` int NULL,
  `description` varchar NULL,
  `reload` bool NULL,
  `enable` bool NULL,
  `type` varchar NOT NULL,
  PRIMARY KEY (`id`)
);
-- Create "log" table
CREATE TABLE `log` (
  `id` int NOT NULL,
  `date` varchar NULL,
  `name` varchar NULL,
  `status` bool NULL,
  `data` varchar NULL,
  PRIMARY KEY (`id`)
);
-- Create "port" table
CREATE TABLE `port` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `name` varchar NULL,
  `pin` int NULL,
  `port` int NULL,
  `value` int NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  `protocol` varchar NOT NULL,
  `type` varchar NOT NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer" table
CREATE TABLE `timer` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer_device" table
CREATE TABLE `timer_device` (
  `id` int NOT NULL,
  `timer_id` int NOT NULL,
  `device_id` int NOT NULL,
  `command_id` int NOT NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer_item" table
CREATE TABLE `timer_item` (
  `id` int NOT NULL,
  `timer_id` int NOT NULL,
  `name` varchar NULL,
  `value_from` varchar NULL,
  `value_to` varchar NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer_limit" table
CREATE TABLE `timer_limit` (
  `id` int NOT NULL,
  `device_id` int NOT NULL,
  `command_from_id` int NOT NULL,
  `command_to_id` int NOT NULL,
  `value` int NOT NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "user" table
CREATE TABLE `user` (
  `id` int NOT NULL,
  `name` varchar NULL,
  `username` varchar NULL,
  `password` varchar NULL,
  `key` varchar NULL,
  `email` varchar NULL,
  `phone` varchar NULL,
  `tg_id` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone" table
CREATE TABLE `zone` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone_command" table
CREATE TABLE `zone_command` (
  `id` int NOT NULL,
  `zone_id` int NOT NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone_command_action" table
CREATE TABLE `zone_command_action` (
  `id` int NOT NULL,
  `name` varchar NULL,
  `zone_command_id` int NOT NULL,
  `device_id` int NOT NULL,
  `command_id` int NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone_command_if" table
CREATE TABLE `zone_command_if` (
  `id` int NOT NULL,
  `name` varchar NULL,
  `zone_command_id` int NOT NULL,
  `device_id` int NOT NULL,
  `command_id` int NOT NULL,
  `description` varchar NULL,
  `enable` bool NULL,
  PRIMARY KEY (`id`)
);
