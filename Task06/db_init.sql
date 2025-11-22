-- Лабораторная работа 6. Нормализация базы данных
PRAGMA foreign_keys = ON;

-- Удаляем существующие таблицы
DROP TABLE IF EXISTS movie_genres;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;

-- 1. Таблица пользователей
CREATE TABLE users (
    userId INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE NOT NULL,
    gender TEXT CHECK(gender IN ('M', 'F')) DEFAULT 'M',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Таблица фильмов
CREATE TABLE movies (
    movieId INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    release_year INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Таблица жанров
CREATE TABLE genres (
    genreId INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name TEXT UNIQUE NOT NULL
);

-- 4. Таблица связи фильмов и жанров
CREATE TABLE movie_genres (
    movieId INTEGER,
    genreId INTEGER,
    PRIMARY KEY (movieId, genreId),
    FOREIGN KEY (movieId) REFERENCES movies(movieId) ON DELETE CASCADE,
    FOREIGN KEY (genreId) REFERENCES genres(genreId) ON DELETE CASCADE
);

-- 5. Таблица рейтингов
CREATE TABLE ratings (
    userId INTEGER,
    movieId INTEGER,
    rating REAL CHECK(rating BETWEEN 0 AND 5),
    timestamp INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userId, movieId),
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
    FOREIGN KEY (movieId) REFERENCES movies(movieId) ON DELETE RESTRICT
);

-- 6. Таблица тегов
CREATE TABLE tags (
    tagId INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER,
    movieId INTEGER,
    tag TEXT NOT NULL,
    timestamp INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
    FOREIGN KEY (movieId) REFERENCES movies(movieId) ON DELETE CASCADE
);

-- Заполняем таблицу жанров
INSERT INTO genres (genre_name) VALUES 
('Action'), ('Adventure'), ('Animation'), ('Children'), ('Comedy'),
('Crime'), ('Documentary'), ('Drama'), ('Fantasy'), ('Film-Noir'),
('Horror'), ('Musical'), ('Mystery'), ('Romance'), ('Sci-Fi'),
('Thriller'), ('War'), ('Western'), ('IMAX'), ('(no genres listed)');

-- Импортируем данные из CSV файлов
.mode csv

-- Импортируем фильмы
.import movies.csv temp_movies

-- Вставляем фильмы в нормализованную таблицу
INSERT INTO movies (movieId, title, release_year)
SELECT 
    movieId,
    trim(title),
    CASE 
        WHEN title LIKE '%(%' THEN CAST(substr(trim(title), -5, 4) AS INTEGER)
        ELSE NULL 
    END
FROM temp_movies;

-- Обрабатываем жанры
INSERT INTO movie_genres (movieId, genreId)
SELECT DISTINCT m.movieId, g.genreId
FROM temp_movies m
JOIN genres g ON m.genres LIKE '%' || g.genre_name || '%';

-- Импортируем рейтинги
.import ratings.csv temp_ratings

-- Создаем пользователей для рейтингов
INSERT INTO users (userId, username, email, gender)
SELECT DISTINCT userId, 
       'user_' || userId, 
       'user' || userId || '@example.com',
       CASE WHEN userId % 2 = 0 THEN 'M' ELSE 'F' END
FROM temp_ratings;

-- Вставляем рейтинги
INSERT INTO ratings (userId, movieId, rating, timestamp)
SELECT userId, movieId, rating, timestamp
FROM temp_ratings;

-- Импортируем теги
.import tags.csv temp_tags

-- Создаем пользователей для тегов (если их еще нет)
INSERT OR IGNORE INTO users (userId, username, email, gender)
SELECT DISTINCT userId, 
       'user_' || userId, 
       'user' || userId || '@example.com',
       CASE WHEN userId % 2 = 0 THEN 'M' ELSE 'F' END
FROM temp_tags
WHERE userId NOT IN (SELECT userId FROM users);

-- Вставляем теги
INSERT INTO tags (userId, movieId, tag, timestamp)
SELECT userId, movieId, tag, timestamp
FROM temp_tags;

-- Создаем индексы
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_movies_year ON movies(release_year);
CREATE INDEX idx_ratings_user ON ratings(userId);
CREATE INDEX idx_ratings_movie ON ratings(movieId);
CREATE INDEX idx_tags_user ON tags(userId);
CREATE INDEX idx_tags_movie ON tags(movieId);
CREATE INDEX idx_movie_genres_movie ON movie_genres(movieId);
CREATE INDEX idx_movie_genres_genre ON movie_genres(genreId);

-- Удаляем временные таблицы
DROP TABLE IF EXISTS temp_movies;
DROP TABLE IF EXISTS temp_ratings;
DROP TABLE IF EXISTS temp_tags;

ANALYZE;