USE sakila;

INSERT INTO customer (
    store_id, first_name, last_name, email, address_id, active, create_date
)
VALUES (
    1,
    'joaquin',
    'luna',
    'joaquin@gmail.com',
    (
        SELECT MAX(a.address_id)
        FROM address a
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = 'United States'
    ),
    1,
    NOW()
);

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    (
        SELECT MAX(i.inventory_id)
        FROM inventory i
        JOIN film f ON i.film_id = f.film_id
        WHERE f.title = 'ACE GOLDFINGER'
    ),
    1,
    (
        SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1
    )
);

UPDATE film SET release_year = 2001 WHERE rating = 'G';
UPDATE film SET release_year = 2002 WHERE rating = 'PG';
UPDATE film SET release_year = 2003 WHERE rating = 'PG-13';
UPDATE film SET release_year = 2004 WHERE rating = 'R';
UPDATE film SET release_year = 2005 WHERE rating = 'NC-17';

UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
    SELECT rental_id
    FROM rental
    WHERE return_date IS NULL
    ORDER BY rental_date DESC
    LIMIT 1
);

DELETE FROM payment WHERE rental_id IN (
    SELECT r.rental_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE i.film_id = (
        SELECT film_id FROM film WHERE title = 'ACE GOLDFINGER'
    )
);

DELETE FROM rental WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'ACE GOLDFINGER'
    )
);

DELETE FROM inventory WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'ACE GOLDFINGER'
);

DELETE FROM film_actor WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'ACE GOLDFINGER'
);

DELETE FROM film_category WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'ACE GOLDFINGER'
);

DELETE FROM film WHERE title = 'ACE GOLDFINGER';

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    1000,
    (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1),
    (SELECT staff_id FROM staff ORDER BY RAND() LIMIT 1)
);

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1),
    (SELECT staff_id FROM staff ORDER BY RAND() LIMIT 1),
    (SELECT MAX(rental_id) FROM rental),
    4.99,
    NOW()
);
