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
