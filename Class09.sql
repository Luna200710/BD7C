USE sakila;

SELECT 
    co.country_id,
    co.country,
    COUNT(ci.city_id) AS cantidad_ciudades
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id
ORDER BY co.country, co.country_id;

SELECT 
    co.country,
    COUNT(ci.city_id) AS cantidad_ciudades
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country
HAVING COUNT(ci.city_id) > 10
ORDER BY cantidad_ciudades DESC;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    a.address,
    COUNT(r.rental_id) AS total_alquileres,
    SUM(p.amount) AS total_gastado
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY total_gastado DESC;

SELECT 
    cat.name AS categoria,
    AVG(f.length) AS duracion_promedio
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.category_id
ORDER BY duracion_promedio DESC;

SELECT 
    f.rating,
    SUM(p.amount) AS total_ventas
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_ventas DESC;
