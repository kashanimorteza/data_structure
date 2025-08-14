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
