# Lab | Stored procedures

USE sakila;

### Instructions

#Write queries, stored procedures to answer the following questions:

#- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented `Action` movies. 
# Convert the query into a simple stored procedure. Use the following query:
DELIMITER //
CREATE PROCEDURE get_action_film_customers()
BEGIN
  SELECT concat(first_name," ", last_name) as name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = "Action"
  GROUP BY first_name, last_name, email;
END;
// DELIMITER ;

CALL get_action_film_customers();


#- Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the category name and return the results 
# for all customers that rented movie of that category/genre. For eg., it could be `action`, `animation`, `children`, `classics`, etc.
DELIMITER //
CREATE PROCEDURE get_customers_by_category(IN category_name VARCHAR(100))
BEGIN
  SELECT concat(first_name," ", last_name) as name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = category_name
  GROUP BY first_name, last_name, email;
END;
// DELIMITER ;

CALL get_customers_by_category("Action");

#- Write a query to check the number of movies released in each movie category. 
# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
# Pass that number as an argument in the stored procedure.

SELECT category.name, COUNT(*) AS num_films
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name;

DELIMITER //
CREATE PROCEDURE get_categories_with_min_films(IN param INT)
BEGIN
  SELECT category.name, COUNT(*) AS num_films
  FROM category
  JOIN film_category ON category.category_id = film_category.category_id
  JOIN film ON film_category.film_id = film.film_id
  GROUP BY category.name
  HAVING num_films >= param;
END;
// DELIMITER ;

CALL get_categories_with_min_films(50);