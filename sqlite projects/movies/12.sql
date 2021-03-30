SELECT movies.title
FROM people
JOIN stars
ON stars.person_id = people.id
JOIN movies
ON movies.id = stars.movie_id
where name = "Johnny Depp"
INTERSECT
SELECT movies.title
FROM people
JOIN stars
ON stars.person_id = people.id
JOIN movies
ON movies.id = stars.movie_id
where name ="Helena Bonham Carter";