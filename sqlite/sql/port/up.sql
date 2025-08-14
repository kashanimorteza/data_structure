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
