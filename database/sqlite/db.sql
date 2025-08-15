-- Create "log" table
CREATE TABLE `log` (
  `id` integer NOT NULL,
  `date` varchar NULL,
  `name` varchar NULL,
  `status` boolean NULL,
  `data` varchar NULL,
  PRIMARY KEY (`id`)
);
-- Create "config" table
CREATE TABLE `config` (
  `id` integer NOT NULL,
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
  `webapi_port` integer NULL,
  `webapi_workers` integer NULL,
  `nginx_api_host` varchar NULL,
  `nginx_api_port` integer NULL,
  `nginx_api_key` varchar NULL,
  `nginx_gui_host` varchar NULL,
  `nginx_gui_port` integer NULL,
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
  `debug` boolean NULL,
  `log` boolean NULL,
  `verbose` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "user" table
CREATE TABLE `user` (
  `id` integer NOT NULL,
  `name` varchar NULL,
  `username` varchar NULL,
  `password` varchar NULL,
  `key` varchar NULL,
  `email` varchar NULL,
  `phone` varchar NULL,
  `tg_id` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer" table
CREATE TABLE `timer` (
  `id` integer NOT NULL,
  `user_id` integer NOT NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer_item" table
CREATE TABLE `timer_item` (
  `id` integer NOT NULL,
  `timer_id` integer NOT NULL,
  `name` varchar NULL,
  `value_from` varchar NULL,
  `value_to` varchar NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer_device" table
CREATE TABLE `timer_device` (
  `id` integer NOT NULL,
  `timer_id` integer NOT NULL,
  `device_id` integer NOT NULL,
  `command_id` integer NOT NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "timer_limit" table
CREATE TABLE `timer_limit` (
  `id` integer NOT NULL,
  `device_id` integer NOT NULL,
  `command_from_id` integer NOT NULL,
  `command_to_id` integer NOT NULL,
  `value` integer NOT NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "device" table
CREATE TABLE `device` (
  `id` integer NOT NULL,
  `zone_id` integer NOT NULL,
  `port_id` integer NOT NULL,
  `power_id` integer NOT NULL,
  `command_id` integer NOT NULL,
  `value` integer NOT NULL,
  `tune` integer NOT NULL,
  `date` time NULL,
  `address` varchar NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "port" table
CREATE TABLE `port` (
  `id` integer NOT NULL,
  `user_id` integer NOT NULL,
  `name` varchar NULL,
  `pin` integer NULL,
  `port` integer NULL,
  `value` integer NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  `protocol` varchar NOT NULL,
  `type` varchar NOT NULL,
  PRIMARY KEY (`id`)
);
-- Create "device_command" table
CREATE TABLE `device_command` (
  `id` integer NOT NULL,
  `device_id` integer NOT NULL,
  `name` varchar NULL,
  `value_from` integer NULL,
  `value_to` integer NULL,
  `delay` integer NULL,
  `description` varchar NULL,
  `reload` boolean NULL,
  `enable` boolean NULL,
  `type` varchar NOT NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone" table
CREATE TABLE `zone` (
  `id` integer NOT NULL,
  `user_id` integer NOT NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone_command" table
CREATE TABLE `zone_command` (
  `id` integer NOT NULL,
  `zone_id` integer NOT NULL,
  `name` varchar NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone_command_if" table
CREATE TABLE `zone_command_if` (
  `id` integer NOT NULL,
  `name` varchar NULL,
  `zone_command_id` integer NOT NULL,
  `device_id` integer NOT NULL,
  `command_id` integer NOT NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "zone_command_action" table
CREATE TABLE `zone_command_action` (
  `id` integer NOT NULL,
  `name` varchar NULL,
  `zone_command_id` integer NOT NULL,
  `device_id` integer NOT NULL,
  `command_id` integer NULL,
  `description` varchar NULL,
  `enable` boolean NULL,
  PRIMARY KEY (`id`)
);
-- Create "atlas_schema_revisions" table
CREATE TABLE `atlas_schema_revisions` (
  `version` text NOT NULL,
  `description` text NOT NULL,
  `type` integer NOT NULL DEFAULT 2,
  `applied` integer NOT NULL DEFAULT 0,
  `total` integer NOT NULL DEFAULT 0,
  `executed_at` datetime NOT NULL,
  `execution_time` integer NOT NULL,
  `error` text NULL,
  `error_stmt` text NULL,
  `hash` text NOT NULL,
  `partial_hashes` json NULL,
  `operator_version` text NOT NULL,
  PRIMARY KEY (`version`)
);
