USE sakila;
-- 1.
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'analyst123';

-- ==============================
-- 2. 
-- ==============================
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

-- ==============================
-- 3.

CREATE TABLE prueba_creacion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(100)
);


-- 4. 
USE sakila;

UPDATE film 
SET title = 'NEW MOVIE TITLE' 
WHERE film_id = 1;

SELECT film_id, title FROM film WHERE film_id = 1;

-- 5. 
-- mysql -u root -p
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

-- Verificar permisos actuales
SHOW GRANTS FOR 'data_analyst'@'localhost';

-- 6. 
USE sakila;

UPDATE film 
SET title = 'TITLE AFTER REVOKE' 
WHERE film_id = 1;
