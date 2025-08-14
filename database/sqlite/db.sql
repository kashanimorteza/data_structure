-- SQL DDL generated from SQLite database
-- Using SELECT sql FROM sqlite_master approach
-- Contains CREATE TABLE statements only (no DROP tables)

CREATE TABLE config (
	id INTEGER NOT NULL, 
	name VARCHAR, 
	"timeZone" VARCHAR, 
	path_api VARCHAR, 
	path_gui VARCHAR, 
	webapi_title VARCHAR, 
	webapi_description VARCHAR, 
	webapi_version VARCHAR, 
	webapi_openapi_url VARCHAR, 
	webapi_docs_url VARCHAR, 
	webapi_redoc_url VARCHAR, 
	webapi_key VARCHAR, 
	webapi_host VARCHAR, 
	webapi_port INTEGER, 
	webapi_workers INTEGER, 
	nginx_api_host VARCHAR, 
	nginx_api_port INTEGER, 
	nginx_api_key VARCHAR, 
	nginx_gui_host VARCHAR, 
	nginx_gui_port INTEGER, 
	nginx_gui_key VARCHAR, 
	git_email VARCHAR, 
	git_name VARCHAR, 
	git_key VARCHAR, 
	hotspod_ssid VARCHAR, 
	hotspod_ip VARCHAR, 
	hotspod_pass VARCHAR, 
	wifi_ssid VARCHAR, 
	wifi_ip VARCHAR, 
	wifi_pass VARCHAR, 
	debug BOOLEAN, 
	log BOOLEAN, 
	verbose BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE device (
	id INTEGER NOT NULL, 
	zone_id INTEGER NOT NULL, 
	port_id INTEGER NOT NULL, 
	power_id INTEGER NOT NULL, 
	command_id INTEGER NOT NULL, 
	value INTEGER NOT NULL, 
	tune INTEGER NOT NULL, 
	date TIME, 
	address VARCHAR, 
	name VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE device_command (
	id INTEGER NOT NULL, 
	device_id INTEGER NOT NULL, 
	name VARCHAR, 
	value_from INTEGER, 
	value_to INTEGER, 
	delay INTEGER, 
	description VARCHAR, 
	reload BOOLEAN, 
	enable BOOLEAN, 
	type VARCHAR(7) NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE log (
	id INTEGER NOT NULL, 
	date VARCHAR, 
	name VARCHAR, 
	status BOOLEAN, 
	data VARCHAR, 
	PRIMARY KEY (id)
);

CREATE TABLE port (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	name VARCHAR, 
	pin INTEGER, 
	port INTEGER, 
	value INTEGER, 
	description VARCHAR, 
	enable BOOLEAN, 
	protocol VARCHAR(8) NOT NULL, 
	type VARCHAR(4) NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE timer (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	name VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE timer_device (
	id INTEGER NOT NULL, 
	timer_id INTEGER NOT NULL, 
	device_id INTEGER NOT NULL, 
	command_id INTEGER NOT NULL, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE timer_item (
	id INTEGER NOT NULL, 
	timer_id INTEGER NOT NULL, 
	name VARCHAR, 
	value_from VARCHAR, 
	value_to VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE timer_limit (
	id INTEGER NOT NULL, 
	device_id INTEGER NOT NULL, 
	command_from_id INTEGER NOT NULL, 
	command_to_id INTEGER NOT NULL, 
	value INTEGER NOT NULL, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE user (
	id INTEGER NOT NULL, 
	name VARCHAR, 
	username VARCHAR, 
	password VARCHAR, 
	"key" VARCHAR, 
	email VARCHAR, 
	phone VARCHAR, 
	tg_id VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE zone (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	name VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE zone_command (
	id INTEGER NOT NULL, 
	zone_id INTEGER NOT NULL, 
	name VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE zone_command_action (
	id INTEGER NOT NULL, 
	name VARCHAR, 
	zone_command_id INTEGER NOT NULL, 
	device_id INTEGER NOT NULL, 
	command_id INTEGER, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);

CREATE TABLE zone_command_if (
	id INTEGER NOT NULL, 
	name VARCHAR, 
	zone_command_id INTEGER NOT NULL, 
	device_id INTEGER NOT NULL, 
	command_id INTEGER NOT NULL, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);
