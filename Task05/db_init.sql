-- db_init.sql
-- Создание базы данных movies_rating.db

DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;

CREATE TABLE movies (
    movieId INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genres TEXT
);

CREATE TABLE ratings (
    userId INTEGER,
    movieId INTEGER,
    rating REAL,
    timestamp INTEGER
);

CREATE TABLE tags (
    userId INTEGER,
    movieId INTEGER,
    tag TEXT,
    timestamp INTEGER
);

.mode csv
.import movies.csv movies
.import ratings.csv ratings
.import tags.csv tags

-- Удаляем строки с заголовками если они попали в данные
DELETE FROM movies WHERE movieId = 'movieId';
DELETE FROM ratings WHERE userId = 'userId'; 
DELETE FROM tags WHERE userId = 'userId';

-- Создаем индексы для скорости
CREATE INDEX idx_ratings_user ON ratings(userId);
CREATE INDEX idx_ratings_movie ON ratings(movieId);
CREATE INDEX idx_tags_user ON tags(userId);
CREATE INDEX idx_tags_movie ON tags(movieId);

ANALYZE;