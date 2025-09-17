USE sakila;

INSERT INTO employees(employeeNumber,lastName,firstName,extension,email,officeCode,jobTitle) 
VALUES (2000,'Perez','Juan','x1111',NULL,'1','Developer');

UPDATE employees SET employeeNumber = employeeNumber - 20;
UPDATE employees SET employeeNumber = employeeNumber + 20;

ALTER TABLE employees
ADD COLUMN age INT,
ADD CONSTRAINT chk_age CHECK (age BETWEEN 16 AND 70);

ALTER TABLE film_actor
ADD CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES film(film_id),
ADD CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES actor(actor_id);

ALTER TABLE employees
ADD COLUMN lastUpdate DATETIME,
ADD COLUMN lastUpdateUser VARCHAR(50);

DELIMITER $$
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END$$
DELIMITER ;

SHOW TRIGGERS FROM sakila;

DELIMITER $$
CREATE TRIGGER ins_film
AFTER INSERT ON film
FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
    VALUES (NEW.film_id, NEW.title, NEW.description);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER upd_film
AFTER UPDATE ON film
FOR EACH ROW
BEGIN
    UPDATE film_text
    SET title = NEW.title,
        description = NEW.description
    WHERE film_id = NEW.film_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER del_film
AFTER DELETE ON film
FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = OLD.film_id;
END$$
DELIMITER ;
