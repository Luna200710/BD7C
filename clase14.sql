USE sakila;

-- 1) Clientes que viven en Argentina (nombre completo, dirección y ciudad)
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    a.address,
    ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

-- 2) Películas con título, idioma y rating con texto completo
SELECT 
    f.title,
    l.name AS language,
    CASE f.rating
        WHEN 'G' THEN 'General Audiences – All Ages Admitted'
        WHEN 'PG' THEN 'Parental Guidance Suggested'
        WHEN 'PG-13' THEN 'Parents Strongly Cautioned – Some Material May Be Inappropriate for Children Under 13'
        WHEN 'R' THEN 'Restricted – Under 17 Requires Accompanying Parent or Adult Guardian'
        WHEN 'NC-17' THEN 'Adults Only – No One 17 and Under Admitted'
    END AS rating_description
FROM film f
JOIN language l ON f.language_id = l.language_id;

-- 3) Búsqueda de películas por actor (entrada ajustada desde texto libre)
-- Ejemplo: si el usuario escribe "pitt"
SET @actor_name = 'pitt';
SELECT 
    f.title,
    f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE CONCAT('%', UPPER(@actor_name), '%');

-- 4) Rentas en Mayo y Junio con indicador de devolución
SELECT 
    f.title,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5,6);

-- 5) CAST y CONVERT en Sakila
-- CAST: convierte un valor a otro tipo de dato
SELECT 
    CAST(rental_date AS DATE) AS rental_day
FROM rental
LIMIT 5;

-- CONVERT: hace lo mismo, sintaxis alternativa
SELECT 
    CONVERT(rental_date, DATE) AS rental_day
FROM rental
LIMIT 5;

-- En MySQL CAST y CONVERT son equivalentes (a diferencia de SQL Server).
-- CAST(expr AS type)  vs  CONVERT(expr, type)

-- 6) NVL, ISNULL, IFNULL, COALESCE
-- NVL: solo existe en Oracle, NO en MySQL.
-- ISNULL(expr): devuelve 1 si expr es NULL, sino 0.
SELECT first_name, ISNULL(null) AS test_null FROM customer LIMIT 1;

-- IFNULL(expr1, expr2): devuelve expr2 si expr1 es NULL, sino expr1.
SELECT first_name, IFNULL(null, 'No Value') AS safe_value FROM customer LIMIT 1;

-- COALESCE(expr1, expr2, ...): devuelve el primer valor no nulo.
SELECT first_name, COALESCE(null, null, 'Fallback') AS safe_value FROM customer LIMIT 1;
