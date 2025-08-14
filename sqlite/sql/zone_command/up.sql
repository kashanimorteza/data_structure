CREATE TABLE zone_command (
	id INTEGER NOT NULL, 
	zone_id INTEGER NOT NULL, 
	name VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);
