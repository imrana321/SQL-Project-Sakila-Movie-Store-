-- ""SAKILA DVD"" Case Study

USE sakila;

-- *******Basic Queries******* :
-- Q1: Which actors have the first name as 'Scarlett'? 

SELECT * FROM actor
Where first_name = 'Scarlett';



-- Q2: Which actors have the last name as 'Johansson'? 

SELECT * FROM actor
Where last_name = 'Johansson';


-- Q3: How many distinct actors' last names are there?

Select count(distinct last_name) as count_of_actor From actor;




-- ---------------------------- ----
-- *******Advanced Queries******* :

SELECT * FROM country;
SELECT * FROM Address;
SELECT * FROM city;

desc city;
desc country;
desc address;


-- **LEFT JOIN**---
-- ---------------------------
SELECT 
	a.*, 
    b.city AS B_City
FROM 
	sakila.address a 
    LEFT JOIN sakila.city b
	ON a.city_id = b.city_id;


-- ** Create Table and use LEFT JOIN ** 

create table sakila.T_A2 as 
select 
	a.* ,
    b.city,
    b.city_id as B_City,
    b.country_id,
    c.country as C_Country
from
	sakila.address a 
		left join sakila.city b
		on a.city_id=b.city_id
		left join sakila.country c
		on b.country_id=c.country_id
		;

SELECT * FROM t_A2;

-- Q: Find the addresses from Canada:
SELECT * FROM t_A2 WHERE C_country = "United States";



-- ** SUB QUERY APPROACH **
Select * From address
Where city_id in 
		(Select Distinct city_id from city where country_id in 
				(Select Distinct country_id from country where country = 'United States'));






-- ** COMMON TABLE Expression Approach **

WITH table1 AS
	(SELECT city_id, city FROM city WHERE city_id < 100 ORDER BY city DESC)
    SELECT city_id, city FROM table1;


-- Q: For each actor find the count of the films:

SELECT a.first_name, b.last_name, b.Count_Films
	FROM actor a LEFT JOIN (
		SELECT actor_id, count(film_id) AS Count_Films FROM film_actor GROUP BY actor_id ORDER BY Count_Films DESC)
	ON a.actor_id = b.actor_id
	ORDER BY Count_Films DESC;     -- Day 13



-- Q: Is 'Academy Dinosaur' available for rent from store 1?

-- Approach 1:
SELECT * FROM rental
WHERE inventory_id IN 
	(SELECT inventory_id FROM inventory WHERE film_id in
    (SELECT film_id FROM film WHERE title = "Academy Dinosaur") AND store_id = 1);


-- Approach 2:
SELECT count(*) FROM rental; -- Table RENT
SELECT count(*) FROM inventory; -- Table INVENTORY
SELECT count(*) FROM film; -- Table FILMS


SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;


SELECT RENT.*, 
	INVENTORY.*, 
    FILMS.*
FROM
	rental RENT LEFT JOIN inventory INVENTORY
		ON RENT.inventory_id = INVENTORY.inventory_id
    LEFT JOIN film FILMS
		ON INVENTORY.film_id = FILMS.film_id
    
    WHERE FILMS.title = "Academy Dinosaur" AND INVENTORY.store_id = 1;   


USE sakila;

-- Q: What is the running time of all the films in the sakila Database?

SELECT * FROM film;


-- Q: What is the average running time of all the films in the sakila Database?

SELECT AVG(length) AS Lenght_Film FROM film;


-- Q: What is the average running time of films by category?


CREATE TABLE film_cate AS
SELECT 
	a.*,
	b.category_id AS B_CATEGORY_ID,
	b.film_id AS B_FILM_ID,
	c.name AS CATEGORY
 
	FROM film a 
    
    LEFT JOIN film_category b
		ON a.film_id = b.film_id
    LEFT JOIN category c
		ON b.category_id = c.category_id;


SELECT * FROM film_cate;


SELECT CATEGORY, AVG(length) AS Avg_Film_Length 
FROM FILM_CATE
GROUP BY CATEGORY
ORDER BY Avg_Film_Length DESC;




-- Drill 2 Q&As --
USE sakila;


-- Q.1a. Display the first and last names of all actors from the table actors:

SELECT first_name, last_name FROM actor;


-- Q.1b. Display the first and last names of each actor in the single column in upper case letters. Name the column as 'Actor Name.' :

SELECT upper(concat(first_name," ", last_name)) AS ACTOR_NAME FROM actor;



-- Q.2a. You need to find the ID number, first name and last name of an actor, of whom you know only the first name, "Joe." Write the query:

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";


-- Q.2b. Find all the actors whose last name contains the letters GEN:

SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";


-- Q.2c. Find all the actors whose last name contains the letters LI. This time, order the rows by the last name and first name, in that order. 

SELECT *
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;



-- Q.2d. Using 'IN' display the 'country_id' coulumn for the following countries: Afghanistan, Bangladesh and China

SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");


-- Q.3a. 
-- You want to keep a description of each actor. 
-- As you don't think that you will be performing queries on a description, so create a column on the table - actor named "Description." 
-- And use the data type as BLOB, but not VARCHAR.

ALTER TABLE actor
ADD column Description BLOB;

SELECT * FROM actor;

DESC actor;




-- Q.3b. Suddenly, you realized that entering descriptions for each actor is a matter of too much effort. So, delete the description column.

ALTER TABLE actor
DROP column Description;

SELECT * FROM actor;




-- Q.4a. List the names of actors, and how many actors have that last name? :

SELECT 
	last_name, 
    count(*) AS Actor_Count 

FROM actor
	GROUP BY last_name
	ORDER BY Actor_Count DESC;


-- Q.4b. List the last_name of actors and the number of actors who have the same last name, 
-- specifically for last names that are shared by at least two actors.

SELECT 
	last_name, 
    count(*) AS Actor_Count 

FROM actor
	GROUP BY last_name
    HAVING Actor_Count>1
	ORDER BY Actor_Count DESC;



-- Q.4c. By mistake, the actor HARPO WILLIAMS was recorded in the actor table as GROUCHO WILLIAMS. Write a query to fix it.

SELECT * 
FROM actor 
WHERE last_name = "WILLIAMS" 
	and first_name = "GROUCHO";

UPDATE actor SET first_name = "HARPO"
WHERE last_name = "WILLIAMS"
	and first_name = "GROUCHO";

SELECT * 
FROM actor 
WHERE actor_id = 172;



-- Q.4d. 
-- Perhaps we were too hasty to change from GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first_name of the actor is curent;y HARPO, change it to GROUCHO.

UPDATE actor SET first_name = "GROUCHO"
WHERE last_name = "WILLIAMS"
	and first_name = "HARPO";

SELECT * 
FROM actor 
WHERE actor_id = 172;



-- Q.5a. You are not being able to locate the schema of the address table. Which query would you use to re-create it?

SHOW DATABASES;


-- Q.6a. Use JOIN to display the first and last names, as well as the address of each staff member. Use the tables staff and address.

SELECT * FROM staff; -- a
SELECT * FROM address; -- b


SELECT 
	a.first_name, 
    a.last_name, 
    b.address

FROM staff a 

LEFT JOIN address b
	ON a.address_id = b.address_id;



-- Q.6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use staff and payment tables. 

SELECT * FROM staff;
SELECT * FROM payment; 

SELECT
    year(a.payment_date) AS YEAR,
    month(a.payment_date) AS MONTH,
    a.staff_id,
    sum(a.amount) AS AMOUNT,
    b.first_name,
    b.last_name
    
FROM payment a
	LEFT JOIN staff b
		ON a.staff_id = b.staff_id
    
	WHERE year(a.payment_date) = 2005 and month(a.payment_date) = 8
    GROUP BY a.staff_id, YEAR(payment_date), MONTH(payment_date), b.first_name, b.last_name
	ORDER BY a.staff_id;




-- Q.6c. List each film and the number of actors who are listed for that film. Use tables "film_actor" and "film" while using INNER JOIN. 

SELECT * FROM film_actor; -- b
SELECT * FROM film limit 100; -- a


CREATE TABLE Film_Wise_Actor AS
SELECT 
	film_id,
    count(actor_id) AS Count_Actor
FROM film_actor
	GROUP BY film_id
    ORDER BY Count_Actor DESC;

SELECT * FROM Film_Wise_Actor;

-- Now, let's join the two tables:

-- Film_Wise_Actor -> a
-- film -> b


SELECT 
	b.title AS Movie_Title,
    a.Count_actor,
    a.Film_id
    
FROM Film_Wise_Actor a
	INNER JOIN Film b
    ON a.film_id = b.film_id;




-- Q:6d. How many copies of the film "Hunchback Impossible" exists in the inventory system?

SELECT * FROM inventory;
SELECT * FROM film;


-- Approach 1: Sub-Query:
SELECT count(distinct inventory_id) AS Number_of_Copies 
	FROM inventory 
		WHERE film_id in (
							SELECT film_id FROM film WHERE title = "Hunchback Impossible"
                            )
                            ;


-- Approach 2: JOIN:
SELECT 
	title, 
	count(inventory_id) AS Count_Inventory
FROM film f
	INNER JOIN inventory i
		ON f.film_id = i.film_id
	WHERE title = "Hunchback Impossible";



-- Approach 3: JOIN (Sub-qyery):
SELECT
	a.inventory_id,
    a.film_id,
    b.title
    
FROM inventory a 
	INNER JOIN film b
    ON a.film_id = b.film_id;



-- Q.6e. Using the tables "payment" and "customer" and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by the last name. 

SELECT * FROM payment; -- b
SELECT * FROM customer; -- a


SELECT 
	a.first_name,
    a.last_name,
	sum(b.amount) AS Customer_Amount
    
FROM customer a 
	INNER JOIN payment b
		ON a.customer_id = b.customer_id
	GROUP BY a.first_name, a.last_name
    ORDER BY a.last_name;




-- Q.7a. The music of "Queen" and "Kris Kristofferson" have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soard in popularity.
-- Use subqueriesd to display the titles of movies starting with the letters K and Q whose language is ENGLISH.

SELECT * 
	FROM film
	WHERE language_id in (SELECT language_id
							FROM language
							WHERE name = "English"
                            )
	AND title LIKE 'K%' OR title LIKE 'Q%';




-- Q.7b. Use subqueries to display all actors who appeared in the film "Alone Trip."

SELECT first_name, 
		last_name 
FROM actor 
WHERE actor_id IN (SELECT actor_id 
					FROM film_actor 
                    WHERE film_id IN (SELECT film_id 
										FROM film 
										WHERE title = 'Alone Trip'
                                        )
					);



-- Q.7c. You want run an e-mail marketing campaign in Canada, few that you will need the names 
-- and e-mail addresses of all the Canadian customers. Use JOINs to retrieve.

-- Approach 1 - Sub-Query::
SELECT first_name, 
	last_name, 
    email 
FROM customer
WHERE address_id IN (
					SELECT address_id, 
							phone 
					FROM address 
					WHERE city_id IN (
									SELECT city_id 
									FROM city 
									WHERE country_id IN (
														SELECT country_id 
														FROM country 
														WHERE country = "Canada")
									)
					);



-- Approach 2 - JOINS::

-- Customr - a
-- Address - b
-- City - c
-- Country - d


SELECT a.first_name,
		a.last_name,
		a.email,
		b.phone,
        c.city_id,
        c.city
    FROM customer a
		LEFT JOIN address b ON a.address_id = b.address_id
		LEFT JOIN city c ON b.city_id = c.city_id
		LEFT JOIN country d ON c.country_id = d.country_id
	WHERE country = 'United States';



-- Q.7d. Sales have been lagging among young families, and you want ot target all family movies for a promotion. 
-- Identify all movies categorize as family films.

-- Catergory - a
-- film_category - 
-- film - c

SELECT c.title
FROM sakila.film c
	INNER JOIN sakila.film_category b
		ON c.film_id = b.film_id
	INNER JOIN sakila.category a
		ON b.category_id = a.category_id
	WHERE name = 'Family';




-- Q.7e. Display the most frequently rented movies in descending order.

USE sakila;
-- Rental - a
-- inventory - b
-- film- c

SELECT 
	c.title AS Movies,
    e.name AS Genre,
    count(distinct a.rental_id) AS Rental_Times

FROM rental a
	INNER JOIN inventory b ON a.inventory_id = b.inventory_id
	INNER JOIN film c ON b.film_id = c.film_id
    INNER JOIN film_category d ON b.film_id = d.film_id    
    INNER JOIN category e ON d.category_id = e.category_id     
        
        
GROUP BY c.title, e.name
ORDER BY Rental_Times DESC;
    



-- Q.7f. List the to 5 genres in gross revenue in decending order.
-- (Hint: You may use the following tables: category, film_category, inventory, payment)

SELECT 
	c.title AS Movies,
    e.name AS Genre,
    count(distinct a.rental_id) AS Rental_Times,
	sum(f.amount) AS Revenue

FROM rental a
	INNER JOIN inventory b ON a.inventory_id = b.inventory_id
	INNER JOIN film c ON b.film_id = c.film_id
    INNER JOIN film_category d ON b.film_id = d.film_id    
    INNER JOIN category e ON d.category_id = e.category_id     
    INNER JOIN payment f ON a.rental_id = f.rental_id     
        
GROUP BY c.title, e.name
ORDER BY Revenue DESC;



select * 
from film
	Inner join film_actor on film.film_id=film_actor.film_id
    inner join actor on film_actor.actor_id=actor.actor_id;


-- Top 5 Genres by Gross Revenue:
SELECT
    e.name AS Genre,
    SUM(f.amount) AS Revenue
 
FROM rental a
INNER JOIN inventory b ON a.inventory_id = b.inventory_id
INNER JOIN film c ON b.film_id = c.film_id
INNER JOIN film_category d ON b.film_id = d.film_id    
INNER JOIN category e ON d.category_id = e.category_id     
INNER JOIN payment f ON a.rental_id = f.rental_id     
 
GROUP BY e.name
 
ORDER BY Revenue DESC
 
LIMIT 5;


-- Most Frequently Rented Movies
SELECT
    c.title AS Movies,
    e.name AS Genre,
    COUNT(DISTINCT a.rental_id) AS Rental_Times
 
FROM rental a
INNER JOIN inventory b ON a.inventory_id = b.inventory_id
INNER JOIN film c ON b.film_id = c.film_id
INNER JOIN film_category d ON b.film_id = d.film_id    
INNER JOIN category e ON d.category_id = e.category_id     
 
GROUP BY c.title, e.name
 
ORDER BY Rental_Times DESC;




-- Average Running Time of Films by Category:

SELECT CATEGORY, AVG(length) AS Avg_Film_Length 
FROM FILM_CATE
GROUP BY CATEGORY
ORDER BY Avg_Film_Length DESC;




SELECT 
    f.title AS Movie_Title,
    c.name AS Genre,
    COUNT(r.rental_id) AS Rental_Count
FROM 
    rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id

GROUP BY f.title, c.name
ORDER BY Rental_Count DESC
LIMIT 5;

SELECT c.title
FROM sakila.film c
   INNER JOIN sakila.film_category b ON c.film_id = b.film_id
   INNER JOIN sakila.category a ON b.category_id = a.category_id
WHERE a.name = 'Music';