-- db_init.sql - создание базы данных movies_rating.db

DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS movies;

-- Создаем таблицу movies (фильмы)
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);

-- Создаем таблицу users (пользователи)
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);

-- Создаем таблицу ratings (оценки)
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    movie_id INTEGER,
    rating REAL,
    timestamp INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Создаем таблицу tags (теги)
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    movie_id INTEGER,
    tag TEXT,
    timestamp INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Вставляем тестовые данные в таблицу movies (20 фильмов)
INSERT INTO movies (id, title, year, genres) VALUES
(1, 'Toy Story', 1995, 'Animation|Children|Comedy'),
(2, 'Jumanji', 1995, 'Adventure|Children|Fantasy'),
(3, 'Grumpier Old Men', 1995, 'Comedy|Romance'),
(4, 'Waiting to Exhale', 1995, 'Comedy|Drama|Romance'),
(5, 'Father of the Bride Part II', 1995, 'Comedy'),
(6, 'Heat', 1995, 'Action|Crime|Thriller'),
(7, 'Sabrina', 1995, 'Comedy|Romance'),
(8, 'Tom and Huck', 1995, 'Adventure|Children'),
(9, 'Sudden Death', 1995, 'Action'),
(10, 'GoldenEye', 1995, 'Action|Adventure|Thriller'),
(11, 'The American President', 1995, 'Comedy|Drama|Romance'),
(12, 'Dracula: Dead and Loving It', 1995, 'Comedy|Horror'),
(13, 'Balto', 1995, 'Animation|Children'),
(14, 'Nixon', 1995, 'Drama'),
(15, 'Cutthroat Island', 1995, 'Action|Adventure|Romance'),
(16, 'Casino', 1995, 'Crime|Drama'),
(17, 'Sense and Sensibility', 1995, 'Drama|Romance'),
(18, 'Four Rooms', 1995, 'Comedy'),
(19, 'Ace Ventura: When Nature Calls', 1995, 'Comedy'),
(20, 'Money Train', 1995, 'Action|Comedy|Crime|Drama');

-- Вставляем тестовые данные в таблицу users (15 пользователей)
INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES
(1, 'John Doe', 'john@email.com', 'M', '2000-01-15', 'engineer'),
(2, 'Jane Smith', 'jane@email.com', 'F', '2000-02-20', 'teacher'),
(3, 'Bob Johnson', 'bob@email.com', 'M', '2000-03-10', 'doctor'),
(4, 'Alice Brown', 'alice@email.com', 'F', '2000-04-05', 'engineer'),
(5, 'Charlie Wilson', 'charlie@email.com', 'M', '2000-05-12', 'student'),
(6, 'Diana Jarvis', 'diana@email.com', 'F', '2000-06-18', 'artist'),
(7, 'Edward Mentos', 'edward@email.com', 'M', '2000-07-22', 'engineer'),
(8, 'Fiona Swamp', 'fiona@email.com', 'F', '2000-08-30', 'scientist'),
(9, 'George Chezh', 'george@email.com', 'M', '2000-09-14', 'student'),
(10, 'Helen Anderson', 'helen@email.com', 'F', '2000-10-25', 'engineer'),
(11, 'Ivan Oleg', 'ivan@email.com', 'M', '2001-01-10', 'teacher'),
(12, 'Julia Jackson', 'julia@email.com', 'F', '2001-02-15', 'doctor'),
(13, 'Walter White', 'kevin@email.com', 'M', '2001-03-20', 'artist'),
(14, 'Laura Harris', 'laura@email.com', 'F', '2001-04-25', 'engineer'),
(15, 'Mike Clark', 'mike@email.com', 'M', '2001-05-30', 'student');

-- Вставляем тестовые данные в таблицу ratings (28 оценок)
INSERT INTO ratings (id, user_id, movie_id, rating, timestamp) VALUES
(1, 1, 1, 4.5, 978300000),
(2, 1, 2, 5.0, 978300001),
(3, 2, 1, 4.0, 978300002),
(4, 3, 3, 4.8, 978300003),
(5, 4, 2, 4.2, 978300004),
(6, 5, 4, 4.7, 978300005),
(7, 6, 5, 4.9, 978300006),
(8, 7, 6, 4.1, 978300007),
(9, 8, 7, 5.0, 978300008),
(10, 9, 8, 4.3, 978300009),
(11, 10, 9, 4.6, 978300010),
(12, 2, 10, 4.4, 978300011),
(13, 3, 11, 4.7, 978300012),
(14, 4, 12, 4.9, 978300013),
(15, 5, 13, 4.2, 978300014),
(16, 6, 14, 4.8, 978300015),
(17, 7, 15, 4.5, 978300016),
(18, 8, 16, 4.7, 978300017),
(19, 9, 17, 4.9, 978300018),
(20, 10, 18, 4.6, 978300019),
(21, 11, 19, 4.8, 1294876800),
(22, 12, 20, 4.3, 1294876801),
(23, 13, 1, 4.1, 1326412800),
(24, 14, 2, 4.9, 1326412801),
(25, 15, 3, 4.7, 1326412802),
(26, 1, 16, 4.5, 1302739200),
(27, 2, 17, 4.3, 1302739201),
(28, 3, 18, 4.8, 1302739202);

-- Вставляем тестовые данные в таблицу tags (16 тегов)
INSERT INTO tags (id, user_id, movie_id, tag, timestamp) VALUES
(1, 1, 1, 'animation', 978300000),
(2, 1, 1, 'pixar', 978300001),
(3, 2, 2, 'adventure', 978300002),
(4, 2, 2, 'fantasy', 978300003),
(5, 3, 3, 'comedy', 978300004),
(6, 3, 3, 'romance', 978300005),
(7, 4, 4, 'drama', 978300006),
(8, 4, 4, 'romantic', 978300007),
(9, 5, 5, 'funny', 978300008),
(10, 5, 5, 'comedy', 978300009),
(11, 6, 6, 'action', 978300010),
(12, 6, 6, 'crime', 978300011),
(13, 7, 7, 'classic', 978300012),
(14, 7, 7, 'romance', 978300013),
(15, 8, 8, 'children', 978300014),
(16, 8, 8, 'adventure', 978300015);