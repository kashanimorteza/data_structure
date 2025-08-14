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
