-- Seleccionar la base de datos sakila
USE sakila;

SELECT first_name, last_name 
FROM actor a1
WHERE EXISTS (
    SELECT * 
    FROM actor a2 
    WHERE a1.last_name = a2.last_name 
      AND a1.actor_id <> a2.actor_id
)
ORDER BY last_name, first_name;

SELECT first_name, last_name 
FROM actor 
WHERE actor_id NOT IN (
    SELECT actor_id 
    FROM film_actor
);

SELECT first_name, last_name 
FROM customer 
WHERE customer_id IN (
    SELECT customer_id 
    FROM rental 
    GROUP BY customer_id 
    HAVING COUNT(DISTINCT inventory_id) = 1
);

SELECT first_name, last_name 
FROM customer 
WHERE customer_id IN (
    SELECT customer_id 
    FROM rental 
    GROUP BY customer_id 
    HAVING COUNT(DISTINCT inventory_id) > 1
);

SELECT DISTINCT a.first_name, a.last_name 
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
ORDER BY a.last_name, a.first_name;

SELECT a.first_name, a.last_name 
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id 
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'BETRAYED REAR'
)
AND a.actor_id NOT IN (
    SELECT fa.actor_id 
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'CATCH AMISTAD'
)
ORDER BY a.last_name, a.first_name;

SELECT a.first_name, a.last_name 
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id 
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'BETRAYED REAR'
)
AND a.actor_id IN (
    SELECT fa.actor_id 
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'CATCH AMISTAD'
)
ORDER BY a.last_name, a.first_name;

SELECT a.first_name, a.last_name 
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id 
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
)
ORDER BY a.last_name, a.first_name;
