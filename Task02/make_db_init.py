#!/usr/bin/env python3
import csv
import os

def generate_sql_script():
    sql_script = """-- Удаляем существующие таблицы
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

-- Создаем таблицу movies
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);

-- Создаем таблицу ratings
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Создаем таблицу tags
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Создаем таблицу users
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);

"""
    return sql_script

def read_csv_and_generate_inserts():
    inserts = ""
    
    # Обрабатываем movies.csv
    try:
        with open('../dataset/movies.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                # Извлекаем год из названия "Toy Story (1995)"
                title = row['title'].replace("'", "''")
                year = None
                if '(' in title and ')' in title:
                    year_str = title.split('(')[-1].split(')')[0]
                    if year_str.isdigit():
                        year = int(year_str)
                
                genres = row['genres'].replace("'", "''")
                inserts += f"INSERT INTO movies (id, title, year, genres) VALUES ({row['movieId']}, '{title}', {year if year else 'NULL'}, '{genres}');\n"
    except Exception as e:
        print(f"Ошибка чтения movies.csv: {e}")
    
    # Обрабатываем ratings.csv
    try:
        with open('../dataset/ratings.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for i, row in enumerate(reader, 1):
                inserts += f"INSERT INTO ratings (id, user_id, movie_id, rating, timestamp) VALUES ({i}, {row['userId']}, {row['movieId']}, {row['rating']}, {row['timestamp']});\n"
    except Exception as e:
        print(f"Ошибка чтения ratings.csv: {e}")
    
    # Обрабатываем tags.csv
    try:
        with open('../dataset/tags.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for i, row in enumerate(reader, 1):
                tag = row['tag'].replace("'", "''")
                inserts += f"INSERT INTO tags (id, user_id, movie_id, tag, timestamp) VALUES ({i}, {row['userId']}, {row['movieId']}, '{tag}', {row['timestamp']});\n"
    except Exception as e:
        print(f"Ошибка чтения tags.csv: {e}")
    

    inserts += """
-- Создаем тестовых пользователей
INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES (1, 'Test User 1', 'user1@test.com', 'M', '2020-01-01', 'student');
INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES (2, 'Test User 2', 'user2@test.com', 'F', '2020-01-02', 'engineer');
INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES (3, 'Test User 3', 'user3@test.com', 'M', '2020-01-03', 'teacher');
"""
    
    return inserts

def main():
    # Генерируем SQL для создания таблиц
    sql_content = generate_sql_script()
    
    # Генерируем INSERT команды из CSV
    insert_content = read_csv_and_generate_inserts()
    
    # Сохраняем полный SQL скрипт
    with open('db_init.sql', 'w', encoding='utf-8') as f:
        f.write(sql_content)
        f.write("\n-- Заполняем таблицы данными\n")
        f.write(insert_content)
    
    print("SQL-скрипт db_init.sql создан успешно!")

if __name__ == "__main__":
    main()