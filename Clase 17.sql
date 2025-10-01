USE sakila;

-- ------------------------------------------------------------
-- ------------------------------------------------------------

-- Consulta con IN en postal_code
SELECT a.address_id, a.address, a.postal_code
FROM address a
WHERE a.postal_code IN ('12345', '54321', '67890');

-- Consulta con NOT IN en postal_code
SELECT a.address_id, a.address, a.postal_code
FROM address a
WHERE a.postal_code NOT IN ('12345', '54321', '67890');

-- Consulta uniendo con city y country
SELECT a.address_id, a.address, a.postal_code, ci.city, co.country
FROM address a
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE a.postal_code IN ('12345', '54321', '67890');

--  NOTA:
-- Como postal_code no tiene índice al inicio, MySQL hace un Full Table Scan.
-- Esto significa que revisa toda la tabla, lo cual es lento si la tabla crece.

-- ------------------------------------------------------------
-- 2) CREAR ÍNDICE EN postal_code
-- ------------------------------------------------------------
CREATE INDEX idx_postal_code ON address (postal_code);

--  NOTA:
-- Después de crear el índice, MySQL puede usar un Index Range Scan.
-- Esto hace que las consultas anteriores sean mucho más rápidas,
-- ya que no necesita leer toda la tabla.

-- ------------------------------------------------------------
-- 3) FULL-TEXT SEARCH EN actor
-- ------------------------------------------------------------

-- Buscar actores con nombre que contenga "Nick" (LIKE)
SELECT * 
FROM actor
WHERE first_name LIKE '%Nick%';

-- Buscar actores con apellido que contenga "Nick" (LIKE)
SELECT * 
FROM actor
WHERE last_name LIKE '%Nick%';

--  NOTA:
-- LIKE '%Nick%' es lento porque no puede usar índice si el comodín % está al inicio.
-- La diferencia entre first_name y last_name depende de la cantidad de coincidencias.

-- ------------------------------------------------------------
-- 4) COMPARACIÓN LIKE vs MATCH ... AGAINST EN film
-- ------------------------------------------------------------

-- Buscar en description usando LIKE
SELECT film_id, title, description
FROM film
WHERE description LIKE '%action%';

--  NOTA:
-- LIKE '%action%' obliga a MySQL a revisar toda la columna.
-- Es ineficiente en textos largos.

-- Buscar en film_text usando Full-Text Search
SELECT film_id, title, description
FROM film_text
WHERE MATCH(description) AGAINST('action');

--  NOTA:
-- MATCH ... AGAINST usa un FULLTEXT INDEX ya creado en (title, description).
-- Esto es mucho más rápido, permite ranking de relevancia y búsquedas complejas.
-- Es ideal para búsquedas en textos largos como descripciones de películas.

-- ------------------------------------------------------------
-- 5) CONCLUSIONES 
-- ------------------------------------------------------------

-- 1. Sin índice en postal_code, MySQL hace Full Table Scan → más lento.
-- 2. Con índice, las consultas son mucho más rápidas (usa Index Range Scan).
-- 3. LIKE funciona pero no usa índices con % al inicio → lento en tablas grandes.
-- 4. MATCH ... AGAINST aprovecha FULLTEXT INDEX → búsquedas rápidas y más inteligentes.
