USE sakila;

SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

SELECT f.title, i.inventory_id
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    c.store_id,
    f.title,
    r.rental_date,
    r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.store_id, c.last_name;

SELECT 
    CONCAT(ci.city, ', ', co.country) AS ubicacion_tienda,
    CONCAT(m.first_name, ' ', m.last_name) AS gerente,
    s.store_id,
    SUM(p.amount) AS total_ventas
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN staff m ON s.manager_staff_id = m.staff_id
JOIN payment p ON s.store_id = p.staff_id 
GROUP BY s.store_id;

SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY cantidad_peliculas DESC
LIMIT 1;
