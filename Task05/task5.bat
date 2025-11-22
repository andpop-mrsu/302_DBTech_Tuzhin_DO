@echo off
chcp 65001 > nul

echo ==================================================
echo 1. Creating movies_rating.db database
echo ==================================================
sqlite3.exe movies_rating.db < db_init.sql
if errorlevel 1 echo NOTE: Some import warnings are normal

echo.
echo ==================================================
echo 2. Top 10 movies with ranking by average rating
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT m.title, ROUND(AVG(r.rating),2) as avg_rating, DENSE_RANK() OVER (ORDER BY AVG(r.rating) DESC) as rank FROM movies m JOIN ratings r ON m.movieId = r.movieId GROUP BY m.movieId ORDER BY avg_rating DESC LIMIT 10;"

echo.
echo ==================================================
echo 3. Simple genre analysis
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT 'Drama' as genre, ROUND(AVG(r.rating),2) as avg_rating FROM movies m JOIN ratings r ON m.movieId = r.movieId WHERE m.genres LIKE '%Drama%' UNION SELECT 'Comedy', ROUND(AVG(r.rating),2) FROM movies m JOIN ratings r ON m.movieId = r.movieId WHERE m.genres LIKE '%Comedy%' UNION SELECT 'Action', ROUND(AVG(r.rating),2) FROM movies m JOIN ratings r ON m.movieId = r.movieId WHERE m.genres LIKE '%Action%';"

echo.
echo ==================================================
echo 4. Movie count by main genres
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT 'Drama' as genre, COUNT(*) as count FROM movies WHERE genres LIKE '%Drama%' UNION SELECT 'Comedy', COUNT(*) FROM movies WHERE genres LIKE '%Comedy%' UNION SELECT 'Action', COUNT(*) FROM movies WHERE genres LIKE '%Action%' UNION SELECT 'Romance', COUNT(*) FROM movies WHERE genres LIKE '%Romance%' UNION SELECT 'Thriller', COUNT(*) FROM movies WHERE genres LIKE '%Thriller%';"

echo.
echo ==================================================
echo 5. Tags count by main genres
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT 'Drama' as genre, COUNT(t.tag) as tags FROM movies m JOIN tags t ON m.movieId = t.movieId WHERE m.genres LIKE '%Drama%' UNION SELECT 'Comedy', COUNT(t.tag) FROM movies m JOIN tags t ON m.movieId = t.movieId WHERE m.genres LIKE '%Comedy%' UNION SELECT 'Action', COUNT(t.tag) FROM movies m JOIN tags t ON m.movieId = t.movieId WHERE m.genres LIKE '%Action%';"

echo.
echo ==================================================
echo 6. User ratings statistics
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT userId, COUNT(*) as ratings, ROUND(AVG(rating),2) as avg_rating FROM ratings GROUP BY userId ORDER BY ratings DESC LIMIT 10;"

echo.
echo ==================================================
echo 7. User behavior simple
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT r.userId, COUNT(DISTINCT r.rating) as ratings, COUNT(DISTINCT t.tag) as tags, CASE WHEN COUNT(DISTINCT t.tag) > COUNT(DISTINCT r.rating) THEN 'Commenter' WHEN COUNT(DISTINCT r.rating) > COUNT(DISTINCT t.tag) THEN 'Rater' ELSE 'Mixed' END as type FROM ratings r LEFT JOIN tags t ON r.userId = t.userId GROUP BY r.userId LIMIT 15;"

echo.
echo ==================================================
echo 8. Last ratings
echo ==================================================
sqlite3.exe movies_rating.db -box "SELECT r.userId, m.title, datetime(MAX(r.timestamp),'unixepoch') as last_time FROM ratings r JOIN movies m ON r.movieId = m.movieId GROUP BY r.userId LIMIT 10;"

echo.
echo ==================================================
echo ALL TASKS COMPLETED!
echo ==================================================
pause