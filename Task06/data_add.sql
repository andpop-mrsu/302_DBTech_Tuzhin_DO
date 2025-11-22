-- Лабораторная работа 6. Добавление новых данных

-- 1. Добавление 5 пользователей
INSERT INTO users (username, email, gender) VALUES
('tuzhin_do', 'tuzhin.do@student.mrsu.ru', 'M'),
('ivanov_ai', 'ivanov.ai@student.mrsu.ru', 'M'),
('petrova_es', 'petrova.es@student.mrsu.ru', 'F'), 
('sidorov_mv', 'sidorov.mv@student.mrsu.ru', 'M'),
('kozlov_ap', 'kozlov.ap@student.mrsu.ru', 'M');

-- 2. Добавление 3 новых фильмов
INSERT INTO movies (movieId, title, release_year) VALUES
(100000, 'The Matrix Resurrections', 2021),
(100001, 'Dune: Part Two', 2024),
(100002, 'Oppenheimer', 2023);

-- 3. Связываем фильмы с жанрами
INSERT INTO movie_genres (movieId, genreId) 
SELECT 100000, genreId FROM genres WHERE genre_name = 'Sci-Fi'
UNION ALL
SELECT 100000, genreId FROM genres WHERE genre_name = 'Action'
UNION ALL
SELECT 100001, genreId FROM genres WHERE genre_name = 'Sci-Fi' 
UNION ALL
SELECT 100001, genreId FROM genres WHERE genre_name = 'Adventure'
UNION ALL
SELECT 100002, genreId FROM genres WHERE genre_name = 'Drama'
UNION ALL
SELECT 100002, genreId FROM genres WHERE genre_name = 'Thriller';

-- 4. Добавление 3 отзывов
INSERT INTO ratings (userId, movieId, rating, timestamp) 
SELECT 
    (SELECT userId FROM users WHERE username = 'tuzhin_do'),
    100000,
    4.5,
    strftime('%s', 'now');

INSERT INTO ratings (userId, movieId, rating, timestamp)
SELECT 
    (SELECT userId FROM users WHERE username = 'tuzhin_do'),
    100001,
    5.0,
    strftime('%s', 'now');

INSERT INTO ratings (userId, movieId, rating, timestamp)
SELECT 
    (SELECT userId FROM users WHERE username = 'tuzhin_do'),
    100002,
    4.8,
    strftime('%s', 'now');

-- 5. Проверка данных
SELECT '=== ДОБАВЛЕННЫЕ ПОЛЬЗОВАТЕЛИ ===' as info;
SELECT userId, username, email, gender, registration_date 
FROM users 
WHERE username IN ('tuzhin_do', 'ivanov_ai', 'petrova_es', 'sidorov_mv', 'kozlov_ap');

SELECT '=== ДОБАВЛЕННЫЕ ФИЛЬМЫ ===' as info;
SELECT m.movieId, m.title, m.release_year, group_concat(g.genre_name, ', ') as genres
FROM movies m
JOIN movie_genres mg ON m.movieId = mg.movieId
JOIN genres g ON mg.genreId = g.genreId
WHERE m.movieId IN (100000, 100001, 100002)
GROUP BY m.movieId;

SELECT '=== ДОБАВЛЕННЫЕ ОЦЕНКИ ===' as info;
SELECT u.username, m.title, r.rating, datetime(r.timestamp, 'unixepoch') as rated_at
FROM ratings r
JOIN users u ON r.userId = u.userId
JOIN movies m ON r.movieId = m.movieId
WHERE u.username = 'tuzhin_do' AND m.movieId IN (100000, 100001, 100002);