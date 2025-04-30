USE sakila;

SELECT title, rating
FROM film
WHERE length <= ALL (
    SELECT length FROM film
);

SELECT title 
FROM film
WHERE length = (SELECT MIN(length) FROM film)
HAVING COUNT(*) = 1;

SELECT title 
FROM film f
WHERE NOT EXISTS (
    SELECT * FROM film f2 
    WHERE f2.length < f.length
)
AND NOT EXISTS (
    SELECT * FROM film f3 
    WHERE f3.length = f.length AND f3.film_id <> f.film_id
);

SELECT c.customer_id, c.first_name, c.last_name, a.address, p.amount AS min_amount
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount <= ALL (
    SELECT amount 
    FROM payment 
    WHERE customer_id = c.customer_id
)
ORDER BY c.customer_id;

SELECT c.customer_id, c.first_name, c.last_name, a.address, MIN(p.amount) AS min_amount
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY c.customer_id;

SELECT c.customer_id, c.first_name, c.last_name, a.address,
    (SELECT MAX(amount) FROM payment p1 WHERE p1.customer_id = c.customer_id) AS max_payment,
    (SELECT MIN(amount) FROM payment p2 WHERE p2.customer_id = c.customer_id) AS min_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
ORDER BY c.customer_id;
