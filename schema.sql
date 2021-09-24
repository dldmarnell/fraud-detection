DROP TABLE IF EXISTS cardholder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;
DROP TABLE IF EXISTS merch_transaction CASCADE;

--Creating tables for database
CREATE TABLE cardholder (
	cardholder_id INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	PRIMARY KEY (cardholder_id)
);

CREATE TABLE credit_card (
	card VARCHAR(20) NOT NULL,
	cardholder_id INT NOT NULL,
	FOREIGN KEY (cardholder_id) REFERENCES cardholder(cardholder_id)
);

CREATE TABLE merchant_category (
	merchant_category_id INT NOT NULL,
	category_name VARCHAR(50),
	PRIMARY KEY (merchant_category_id)
);

CREATE TABLE merchant (
	merchant_id INT NOT NULL,
	name VARCHAR(100),
	merchant_category_id INT NOT NULL,
	PRIMARY KEY (merchant_id),
	FOREIGN KEY (merchant_category_id) REFERENCES merchant_category(merchant_category_id)
);

CREATE TABLE transaction (
	transaction_id INT NOT NULL,
	date TIMESTAMP,
	amount FLOAT4,
	card VARCHAR(20),
	merchant_id INT NOT NULL,
	PRIMARY KEY (transaction_id),
	FOREIGN KEY (merchant_id) REFERENCES merchant(merchant_id)	
);

--View tables to check data import
SELECT * FROM credit_card;
SELECT * FROM cardholder;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM transaction;

--Adding card_id column to credit_card table to replace card column
ALTER TABLE credit_card
ADD card_id SERIAL PRIMARY KEY;

ALTER TABLE merch_transaction
DROP card;

--Creating merch_transaction table to replace transaction table and ensure database in 3rd normal form
SELECT t.transaction_id, t.date, t.amount, t.merchant_id, t.card, c.card_id
INTO TABLE merch_transaction
FROM transaction AS t JOIN 
credit_card AS c ON t.card = c.card;

--Adding primary and foreign keys to merch_transaction table
ALTER TABLE merch_transaction
ADD PRIMARY KEY (transaction_id);

ALTER TABLE merch_transaction
ADD FOREIGN KEY (card_id) REFERENCES credit_card(card_id);

ALTER TABLE merch_transaction
ADD FOREIGN KEY (merchant_id) REFERENCES merchant(merchant_id);

--View final databse tables
SELECT * FROM credit_card;
SELECT * FROM cardholder;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM merch_transaction;