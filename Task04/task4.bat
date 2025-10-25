#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили. В списке оставить первые 100 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT 
    u1.name as user1,
    u2.name as user2,
    m.title as movie_title
FROM ratings r1
JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id
JOIN users u1 ON r1.user_id = u1.id
JOIN users u2 ON r2.user_id = u2.id
JOIN movies m ON r1.movie_id = m.id
ORDER BY user1, user2, movie_title
LIMIT 100;"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT
    m.title as movie_title,
    u.name as user_name,
    r.rating,
    date(r.timestamp, 'unixepoch') as rating_date
FROM ratings r
JOIN movies m ON r.movie_id = m.id
JOIN users u ON r.user_id = u.id
ORDER BY r.timestamp DESC
LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке 'Рекомендуем' для фильмов должно быть написано 'Да' или 'Нет'."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH movie_avg_ratings AS (
    SELECT 
        m.id,
        m.title,
        m.year,
        AVG(r.rating) as avg_rating
    FROM movies m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY m.id, m.title, m.year
),
min_max_ratings AS (
    SELECT 
        MIN(avg_rating) as min_rating,
        MAX(avg_rating) as max_rating
    FROM movie_avg_ratings
)
SELECT 
    mar.title as 'Название фильма',
    mar.year as 'Год выпуска',
    ROUND(mar.avg_rating, 2) as 'Средний рейтинг',
    CASE 
        WHEN mar.avg_rating = (SELECT max_rating FROM min_max_ratings) THEN 'Да'
        ELSE 'Нет'
    END as 'Рекомендуем'
FROM movie_avg_ratings mar
WHERE mar.avg_rating = (SELECT min_rating FROM min_max_ratings)
   OR mar.avg_rating = (SELECT max_rating FROM min_max_ratings)
ORDER BY mar.year, mar.title;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT 
    COUNT(*) as 'Количество оценок',
    ROUND(AVG(r.rating), 2) as 'Средняя оценка'
FROM ratings r
JOIN users u ON r.user_id = u.id
WHERE u.gender = 'F'
AND date(r.timestamp, 'unixepoch') BETWEEN '2010-01-01' AND '2012-12-31';"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH movie_ratings AS (
    SELECT 
        m.id,
        m.title,
        m.year,
        AVG(r.rating) as avg_rating,
        RANK() OVER (ORDER BY AVG(r.rating) DESC) as rating_rank
    FROM movies m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY m.id, m.title, m.year
)
SELECT 
    title as 'Название фильма',
    year as 'Год выпуска',
    ROUND(avg_rating, 2) as 'Средняя оценка',
    rating_rank as 'Место в рейтинге'
FROM movie_ratings
ORDER BY year, title
LIMIT 20;"
echo " "

echo "6. Вывести список из 10 последних зарегистрированных пользователей в формате 'Фамилия Имя|Дата регистрации' (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT 
    SUBSTR(name, INSTR(name, ' ') + 1) || ' ' || SUBSTR(name, 1, INSTR(name, ' ') - 1) || '|' || register_date as 'Пользователь|Дата регистрации'
FROM users
ORDER BY register_date DESC
LIMIT 10;"
echo " "

echo "7. С помощью рекурсивного CTE составить таблицу умножения для чисел от 1 до 10."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE multiplication_table(a, b) AS (
    SELECT 1, 1
    UNION ALL
    SELECT 
        CASE 
            WHEN b = 10 THEN a + 1
            ELSE a
        END,
        CASE 
            WHEN b = 10 THEN 1
            ELSE b + 1
        END
    FROM multiplication_table
    WHERE a <= 10 AND b <= 10
)
SELECT a || 'x' || b || '=' || (a * b) as 'Таблица умножения'
FROM multiplication_table
WHERE a <= 10 AND b <= 10
ORDER BY a, b;"
echo " "

echo "8. С помощью рекурсивного CTE выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split_genres(genre, remaining, movie_id) AS (
    SELECT 
        CASE 
            WHEN INSTR(genres, '|') > 0 THEN SUBSTR(genres, 1, INSTR(genres, '|') - 1)
            ELSE genres
        END,
        CASE 
            WHEN INSTR(genres, '|') > 0 THEN SUBSTR(genres, INSTR(genres, '|') + 1)
            ELSE ''
        END,
        id
    FROM movies
    
    UNION ALL
    
    SELECT 
        CASE 
            WHEN INSTR(remaining, '|') > 0 THEN SUBSTR(remaining, 1, INSTR(remaining, '|') - 1)
            ELSE remaining
        END,
        CASE 
            WHEN INSTR(remaining, '|') > 0 THEN SUBSTR(remaining, INSTR(remaining, '|') + 1)
            ELSE ''
        END,
        movie_id
    FROM split_genres
    WHERE remaining != ''
)
SELECT DISTINCT genre as 'Уникальные жанры'
FROM split_genres
WHERE genre != ''
ORDER BY genre;"