CREATE TABLE timer (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	name VARCHAR, 
	description VARCHAR, 
	enable BOOLEAN, 
	PRIMARY KEY (id)
);
