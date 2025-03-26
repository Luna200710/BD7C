CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

CREATE TABLE IF NOT EXISTS film (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year YEAR NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE,
    FOREIGN KEY (film_id) REFERENCES film(film_id) ON DELETE CASCADE
);

INSERT INTO actor (first_name, last_name) VALUES 
('Leonardo', 'DiCaprio'),
('Robert', 'Downey Jr.'),
('Scarlett', 'Johansson');

INSERT INTO film (title, description, release_year) VALUES 
('Titanic', 'Historia de amor en el Titanic.', 1997),
('Iron Man', 'El origen del héroe.', 2008),
('Black Widow', 'La historia de Natasha Romanoff.', 2021);

INSERT INTO film_actor (actor_id, film_id) VALUES 
(1, 1), -- Leonardo DiCaprio en Titanic
(2, 2), -- Robert Downey Jr. en Iron Man
(3, 3); -- Scarlett Johansson en Black Widow

SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;
