# need to finish 5 and 7a
# Selecting Database
USE sakila;

# Selecting Table and viewing to see columns
SELECT * FROM actor;

# Selecting First and Last Name of all Actors -- 1a
SELECT first_name, last_name 
FROM actor;

# combining First and Last Name into one column as Actor Name -- 1b
SELECT concat(first_name," ", last_name) AS 'Actor Name'
FROM actor;

# Selecting actor with first name of Joe -- 2a
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'JOE';

# Selecting last names with GEN -- 2B
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

# Selecting actors with last name containing LI, changing order to last name than first name -- 2c
SELECT last_name, first_name 
FROM actor
WHERE last_name LIKE '%LI%';

# Selecting Table and viewing to see columns -- 2d
SELECT * FROM country;

# Selecting countries using IN statment -- 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')

# Add new column and view -- 3a
ALTER TABLE actor
ADD COLUMN description BLOB;
SELECT * FROM actor;

# Delete description column and view -- 3b
ALTER TABLE actor
DROP COLUMN description;
SELECT * FROM actor;

# Counting how many actors have same last name -- 4a
SELECT last_name, COUNT(last_name) AS 'Actor_Count'
FROM actor
GROUP BY last_name;

# Counting how many actors have same last name and displaying Last names with more than 1 matches -- 4b
SELECT last_name, COUNT(last_name) AS 'Actor_Count'
FROM actor
GROUP BY last_name
HAVING Actor_Count > 1;

# Turn off safe mode and update actor names -- 4c
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO";

# Turn off safe mode and change actor names back -- 4d
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

# Safe mode back on -- 4d
SET SQL_SAFE_UPDATES = 1;

# Which query can be used to recreate the schema of the address table? -- 5a 
SHOW CREATE TABLE address; 

# Checking staff information -- 6a
SELECT * FROM staff;
# Checking address information -- 6a
SELECT * FROM address;

# Joining staff and address tables to get addresses of staff members -- 6a
SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id);

# Checking payment information -- 6b
SELECT * FROM payment;

# payment in August -- 6b
# Selecting tables and viewing
SELECT staff.first_name,
staff.last_name,
SUM(payment.amount) AS'Total Payments'
FROM staff
JOIN payment ON payment.staff_id = staff.staff_id
WHERE payment.payment_date BETWEEN "2005-08-01" AND "2005-08-31"
GROUP BY first_name,last_name;

# Viewing table -- 6c
SELECT * FROM film_actor;
SELECT * FROM film;

# Counting Actors per movie -- 6c
SELECT film.title,
COUNT(film_actor.actor_id) AS'Actor Count'
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

# Viewing tables -- 6d
SELECT * FROM inventory;
SELECT * FROM film;

# Counting inventory for Hunchback movie -- 6d
SELECT film.title,
COUNT(inventory.film_id) AS'Film Count'
FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'HUNCHBACK IMPOSSIBLE' 
GROUP BY title;

# Viewing tables -- 6e
SELECT * FROM payment;
SELECT * FROM customer;

# Total payments by customer and sorted by last name -- 6e
SELECT customer.first_name,
customer.last_name,
SUM(payment.amount) AS'Total Payments'
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY first_name,last_name
ORDER BY customer.last_name ASC;

# Viewing tables -- 7a
SELECT * FROM film;

# Viewing movies that start with K or Q 
SELECT film.title
FROM film
WHERE film.title LIKE 'Q%' OR film.title LIKE 'K%' and
  language_id IN
( SELECT language_id
FROM language 
WHERE language.name = "English");

 
# Viewing tables -- 7b
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;

# Actors in Alone Trip (17) -- 7b
SELECT first_name, last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id 
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Alone Trip';
		
	
# Viewing tables -- 7c = 20
SELECT * FROM customer;
SELECT * FROM city;
SELECT * FROM country;

# Search for customers in Canada
SELECT first_name, last_name, email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada' 

# Viewing tables -- 7d 
SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM film;
SELECT * FROM film_text;
SELECT * FROM rental;

# Search for Family movies -- 7d
SELECT title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id 
WHERE category.name = 'Family'

# Viewing tables -- 7e 
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

# Search # of times movie was rented -- 7e
SELECT title, COUNT(title) AS 'Count by Movie'
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY title
ORDER BY COUNT(title) DESC;

# Viewing tables -- 7f
SELECT * FROM store;
SELECT * FROM inventory;
SELECT * FROM rental;
SELECT * FROM payment;

# Revenue by store -- 7f
SELECT store.store_id, SUM(payment.amount) 'Total Revenue By Store'
FROM store
JOIN inventory ON store.store_id = inventory.store_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id;

# Viewing tables -- 7g
SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM country;

# Finding address and country for different stores -- 7g
SELECT store.store_id, address.address, country.country
FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON country.country_id = city.country_id;

# Viewing tables -- 7h
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM rental;

# Top 5 grossing genres by revenue -- 7h
SELECT category.name, SUM(payment.amount) AS Revenue
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
LIMIT 5;

# Create view from 7h -- 8a 
CREATE VIEW Top_Five_Genres_By_GR
AS SELECT category.name, SUM(payment.amount) AS Revenue FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
LIMIT 5;

# View created view -- 8b
SELECT * FROM Top_Five_Genres_By_GR;

# Delete created view -- 8c
DROP VIEW IF EXISTS Top_Five_Genres_By_GR;
