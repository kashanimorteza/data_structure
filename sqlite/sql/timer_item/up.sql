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
