--View final databse tables
SELECT * FROM credit_card;
SELECT * FROM cardholder;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM merch_transaction;

--Part One

--Isolate (or group) the transactions of each cardholder
SELECT c.cardholder_id, COUNT(m.transaction_id) AS num_transactions
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
GROUP BY c.cardholder_id
ORDER BY c.cardholder_id ASC;

--Creating view
CREATE VIEW cardholder_transactions AS
SELECT c.cardholder_id, COUNT(m.transaction_id) AS num_transactions
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
GROUP BY c.cardholder_id
ORDER BY c.cardholder_id ASC;

--Testing view
SELECT *
FROM cardholder_transactions;

--Count the transactions that are less than $2.00 per cardholder
SELECT c.cardholder_id, COUNT(m.transaction_id) AS num_small_transactions
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
WHERE amount < 2.00
GROUP BY c.cardholder_id
ORDER BY num_small_transactions ASC;

--Creating view
CREATE VIEW small_transactions AS
SELECT c.cardholder_id, COUNT(m.transaction_id) AS num_small_transactions
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
WHERE amount < 2.00
GROUP BY c.cardholder_id
ORDER BY num_small_transactions;

--Testing view
SELECT *
FROM small_transactions;

--Looking at individual transactions and amounts for cardholders
SELECT c.cardholder_id, m.transaction_id, m.date, m.amount
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
ORDER BY c.cardholder_id ASC;

--Top 100 highest transactions made between 7:00 am and 9:00 am
SELECT * FROM (
SELECT m.transaction_id, c.cardholder_id, date_part('hour',m.date), m.amount, m.date
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
) AS a
WHERE a.date_part >= 7
AND a.date_part <= 9
ORDER BY amount DESC
LIMIT 100;

--Creating view
CREATE VIEW top_morning_transactions AS 
SELECT * FROM (
SELECT m.transaction_id, c.cardholder_id, date_part('hour',m.date), m.amount, m.date
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
) AS a
WHERE a.date_part >= 7
AND a.date_part <= 9
ORDER BY amount DESC
LIMIT 100;

--Testing view
SELECT *
FROM top_morning_transactions;

--Top 5 merchants prone to being hacked using small transactions
SELECT t.merchant_id, m.name, COUNT(transaction_id) AS num_transaction
FROM merch_transaction AS t
JOIN merchant AS m
ON t.merchant_id = m.merchant_id
WHERE amount < 2.00
GROUP BY t.merchant_id, m.name
ORDER BY num_transaction DESC
LIMIT 5;

--Creating view
CREATE VIEW top_merchants_hacked AS
SELECT t.merchant_id, m.name, COUNT(transaction_id) AS num_transaction
FROM merch_transaction AS t
JOIN merchant AS m
ON t.merchant_id = m.merchant_id
WHERE amount < 2.00
GROUP BY t.merchant_id, m.name
ORDER BY num_transaction DESC
LIMIT 5;

--Testing View
SELECT *
FROM top_merchants_hacked;

--Merchants with owner names
SELECT a.name AS owner_name, m.name AS merchant_name
FROM merch_transaction AS t
JOIN credit_card AS c
ON c.card_id = t.card_id
JOIN cardholder as a
ON a.cardholder_id = c.cardholder_id
JOIN merchant as m
ON t.merchant_id = m.merchant_id
ORDER BY owner_name

--Creating view
CREATE VIEW merchant_owner AS
SELECT a.name AS owner_name, m.name AS merchant_name
FROM merch_transaction AS t
JOIN credit_card AS c
ON c.card_id = t.card_id
JOIN cardholder as a
ON a.cardholder_id = c.cardholder_id
JOIN merchant as m
ON t.merchant_id = m.merchant_id
ORDER BY owner_name

--Testing view
SELECT * FROM merchant_owner


--Data for cardholder IDs 2 and 18
SELECT c.cardholder_id, m.date, m.amount
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
WHERE c.cardholder_id = 18
OR c.cardholder_id = 2;

--Data from January 2018 to June 2018 for cardholder ID 25
SELECT c.cardholder_id, date_part('month', m.date) as month, date_part('day', m.date) as day, m.amount
FROM merch_transaction AS m
JOIN credit_card AS c
ON c.card_id = m.card_id
WHERE c.cardholder_id = 25
AND date_part('month', m.date) >= 1 
AND date_part('month', m.date) <= 6;
