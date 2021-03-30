SELECT COUNT(movie_id)
FROM ratings 
WHERE rating = 10.0;

-- cat 4.sql | sqlite3 movies.db | wc