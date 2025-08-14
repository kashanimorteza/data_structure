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
