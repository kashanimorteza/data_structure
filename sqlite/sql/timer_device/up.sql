CREATE TABLE timer_device (
	id INTEGER NOT NULL, 
	timer_id INTEGER NOT NULL, 
	device_id INTEGER NOT NULL, 
	command_id INTEGER NOT NULL, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);
