-- db_init.sql
CREATE TABLE IF NOT EXISTS movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genre TEXT
);

CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    registration_date DATE,
    occupation TEXT
);

CREATE TABLE IF NOT EXISTS ratings (
    rating_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    movie_id INTEGER,
    rating REAL,
    rating_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

CREATE TABLE IF NOT EXISTS tags (
    tag_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    movie_id INTEGER,
    tag TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Вставка тестовых данных
INSERT INTO movies (movie_id, title, year, genre) VALUES
(1, 'The Matrix', 1999, 'Sci-Fi'),
(2, 'Inception', 2010, 'Action'),
(3, 'The Dark Knight', 2008, 'Action'),
(4, 'Pulp Fiction', 1994, 'Crime'),
(5, 'Forrest Gump', 1994, 'Drama'),
(6, 'The Shawshank Redemption', 1994, 'Drama'),
(7, 'The Godfather', 1972, 'Crime'),
(8, 'Fight Club', 1999, 'Drama'),
(9, 'Goodfellas', 1990, 'Crime'),
(10, 'The Silence of the Lambs', 1991, 'Thriller'),
(11, 'La La Land', 2016, 'Musical'),
(12, 'Parasite', 2019, 'Thriller'),
(13, 'Joker', 2019, 'Drama'),
(14, 'Avengers: Endgame', 2019, 'Action'),
(15, 'Toy Story 4', 2019, 'Animation');

INSERT INTO users (user_id, first_name, last_name, email, registration_date, occupation) VALUES
(1, 'John', 'Anderson', 'john@email.com', '2020-01-15', 'engineer'),
(2, 'Alice', 'Smith', 'alice@email.com', '2020-02-20', 'teacher'),
(3, 'Bob', 'Johnson', 'bob@email.com', '2020-03-10', 'doctor'),
(4, 'Carol', 'Adams', 'carol@email.com', '2020-04-05', 'engineer'),
(5, 'David', 'Wilson', 'david@email.com', '2020-05-12', 'student'),
(6, 'Eva', 'Brown', 'eva@email.com', '2020-06-18', 'artist'),
(7, 'Adam', 'Davis', 'adam@email.com', '2020-07-22', 'engineer'),
(8, 'Anna', 'Taylor', 'anna@email.com', '2020-08-30', 'scientist'),
(9, 'Alex', 'Miller', 'alex@email.com', '2020-09-14', 'student'),
(10, 'Andrew', 'Clark', 'andrew@email.com', '2020-10-25', 'engineer');

INSERT INTO ratings (rating_id, user_id, movie_id, rating, rating_date) VALUES
(1, 1, 1, 4.5, '2020-02-01'),
(2, 1, 2, 5.0, '2020-02-02'),
(3, 2, 1, 4.0, '2020-03-01'),
(4, 3, 3, 4.8, '2020-03-15'),
(5, 4, 2, 4.2, '2020-04-10'),
(6, 5, 4, 4.7, '2020-05-20'),
(7, 6, 5, 4.9, '2020-06-05'),
(8, 7, 6, 4.1, '2020-07-12'),
(9, 8, 7, 5.0, '2020-08-18'),
(10, 9, 8, 4.3, '2020-09-22'),
(11, 10, 9, 4.6, '2020-10-30'),
(12, 2, 10, 4.4, '2020-11-05'),
(13, 3, 11, 4.7, '2020-12-10'),
(14, 4, 12, 4.9, '2021-01-15'),
(15, 5, 13, 4.2, '2021-02-20');

INSERT INTO tags (tag_id, user_id, movie_id, tag) VALUES
(1, 1, 1, 'sci-fi'),
(2, 1, 1, 'mind-blowing'),
(3, 2, 2, 'inception'),
(4, 2, 2, 'dream'),
(5, 3, 3, 'batman'),
(6, 3, 3, 'joker'),
(7, 4, 4, 'crime'),
(8, 4, 4, 'tarantino'),
(9, 5, 5, 'drama'),
(10, 5, 5, 'inspirational'),
(11, 6, 6, 'prison'),
(12, 6, 6, 'hope'),
(13, 7, 7, 'mafia'),
(14, 7, 7, 'classic'),
(15, 8, 8, 'fight'),
(16, 8, 8, 'twist');