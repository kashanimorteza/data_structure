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
