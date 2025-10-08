USE sakila;

-- ========================================================
-- 1) FUNCIÓN: Cantidad de copias de una película en una tienda
-- ========================================================

DELIMITER $$
CREATE FUNCTION get_film_copies(film_identifier VARCHAR(100), store_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE film_id_val INT;

    -- Verifica si el parámetro es numérico (id) o texto (nombre)
    IF film_identifier REGEXP '^[0-9]+$' THEN
        SET film_id_val = film_identifier;
    ELSE
        SELECT film_id INTO film_id_val
        FROM film
        WHERE title = film_identifier
        LIMIT 1;
    END IF;

    RETURN (
        SELECT COUNT(*)
        FROM inventory
        WHERE film_id = film_id_val
          AND store_id = store_id
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE list_customers_by_country(
    IN country_name VARCHAR(50),
    OUT customer_list TEXT
)
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE f_name VARCHAR(45);
    DECLARE l_name VARCHAR(45);

    DECLARE cur CURSOR FOR
        SELECT c.first_name, c.last_name
        FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = country_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    SET customer_list = '';

    OPEN cur;
    get_names: LOOP
        FETCH cur INTO f_name, l_name;
        IF finished = 1 THEN 
            LEAVE get_names;
        END IF;

        IF customer_list = '' THEN
            SET customer_list = CONCAT(f_name, ' ', l_name);
        ELSE
            SET customer_list = CONCAT(customer_list, ';', f_name, ' ', l_name);
        END IF;
    END LOOP get_names;
    CLOSE cur;
END$$

DELIMITER ;

-- 3) EXPLICACIÓN: inventory_in_stock y film_in_stock
-- ========================================================

--  FUNCION: inventory_in_stock(inventory_id)
-- Verifica si una copia específica (inventory_id) está disponible.
-- Internamente consulta la tabla rental para saber si esa copia
-- tiene algún alquiler sin fecha de devolución (return_date IS NULL).
-- Si no está alquilada → devuelve 1 (disponible), si está alquilada → 0.

-- Ejemplo:
SELECT inventory_in_stock(1) AS disponible; 
-- Devuelve 1 si la copia 1 está disponible para alquilar

-- PROCEDIMIENTO: film_in_stock(film_id, store_id, out cantidad)
-- Lista todas las copias disponibles de una película en una tienda.
-- Internamente busca en la tabla inventory todas las copias que correspondan
-- a ese film_id y store_id, y llama a inventory_in_stock por cada una.
-- Si inventory_in_stock devuelve 1, la incluye en el resultado.
-- Además, guarda en el parámetro OUT la cantidad total de copias disponibles.




