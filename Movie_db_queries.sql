-- Q1: Show all users
SELECT * FROM Users;

-- Q2: Movies released after 2020
SELECT title, release_year
FROM Movies
WHERE release_year > 2020;

-- Q3: Affordable subscriptions
SELECT plan_name, price
FROM Subscriptions
WHERE price < 10;

-- Q4: Actors from USA
SELECT name, country
FROM Actors
WHERE country = 'USA';

-- Q5: Genres sorted alphabetically
SELECT genre_name
FROM Genres
ORDER BY genre_name ASC;

-- Q6: Total users
SELECT COUNT(*) AS total_users
FROM Users;

-- Q7: Most expensive subscription
SELECT plan_name, price
FROM Subscriptions
ORDER BY price DESC
LIMIT 1;

-- Q8: English movies
SELECT title, language
FROM Movies
WHERE language = 'English';

-- Q9: Users with their subscription plan (if exists)
SELECT u.name AS user_name,
       s.plan_name AS subscription_plan
FROM Users u
LEFT JOIN UserSubscriptions us ON u.user_id = us.user_id
LEFT JOIN Subscriptions s ON us.subscription_id = s.subscription_id;

-- Q10: Movies sorted by release year (latest first)
SELECT title, release_year
FROM Movies
ORDER BY release_year DESC;

-- Q11: Movies with 'Star' in title
SELECT title
FROM Movies
WHERE title LIKE '%Star%';

-- Q12: Subscription plan and screens allowed
SELECT plan_name, screens_allowed
FROM Subscriptions;

-- Q13: Young actors born after 1990
SELECT name, birth_year
FROM Actors
WHERE birth_year > 1990
ORDER BY birth_year ASC;

-- Q14: Users with their current subscription plan
SELECT u.name AS user_name,
       s.plan_name AS subscription_plan,
       us.start_date,
       us.end_date
FROM Users u
JOIN UserSubscriptions us ON u.user_id = us.user_id
JOIN Subscriptions s ON us.subscription_id = s.subscription_id;

-- Q15: Movies and their genres
SELECT m.title AS movie_title,
       g.genre_name AS genre
FROM Movies m
JOIN MovieGenres mg ON m.movie_id = mg.movie_id
JOIN Genres g ON mg.genre_id = g.genre_id
ORDER BY m.title;


-- Q16: Actors and their movies
SELECT a.name AS actor_name,
       m.title AS movie_title
FROM Actors a
JOIN MovieActors ma ON a.actor_id = ma.actor_id
JOIN Movies m ON ma.movie_id = m.movie_id
ORDER BY a.name;


-- Q17: User ratings with movie names
SELECT u.name AS user_name,
       m.title AS movie_title,
       r.rating,
       r.review
FROM Ratings r
JOIN Users u ON r.user_id = u.user_id
JOIN Movies m ON r.movie_id = m.movie_id
ORDER BY u.name;

-- Q18: Recent movies with actors
SELECT m.title AS movie_title,
       a.name AS actor_name,
       m.release_year
FROM Movies m
JOIN MovieActors ma ON m.movie_id = ma.movie_id
JOIN Actors a ON ma.actor_id = a.actor_id
WHERE m.release_year > 2015
ORDER BY m.release_year DESC;

-- Q19: Average rating per movie
SELECT m.title AS movie_title,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;

-- Q20: Movie count per actor
SELECT a.name AS actor_name,
       COUNT(ma.movie_id) AS movie_count
FROM Actors a
JOIN MovieActors ma ON a.actor_id = ma.actor_id
GROUP BY a.name
ORDER BY movie_count DESC;

-- Q21: User count per subscription plan
SELECT s.plan_name AS subscription_plan,
       COUNT(us.user_id) AS user_count
FROM Subscriptions s
LEFT JOIN UserSubscriptions us ON s.subscription_id = us.subscription_id
GROUP BY s.plan_name
ORDER BY user_count DESC;

-- Q22: Movie count per genre
SELECT g.genre_name,
       COUNT(mg.movie_id) AS movie_count
FROM Genres g
JOIN MovieGenres mg ON g.genre_id = mg.genre_id
GROUP BY g.genre_name
ORDER BY movie_count DESC;

-- Q23: Active users based on ratings
SELECT u.name AS user_name,
       COUNT(r.rating_id) AS total_ratings
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
GROUP BY u.name
HAVING COUNT(r.rating_id) > 3
ORDER BY total_ratings DESC;

-- Q24: Movies with avg rating > 4.5
SELECT title
FROM Movies
WHERE movie_id IN (
    SELECT movie_id
    FROM Ratings
    GROUP BY movie_id
    HAVING AVG(rating) > 4.5
);

-- Q25: Users rating Inception above its average
SELECT u.name AS user_name,
       r.rating
FROM Ratings r
JOIN Users u ON r.user_id = u.user_id
WHERE r.movie_id = (
    SELECT movie_id FROM Movies WHERE title = 'Inception'
) AND r.rating > (
    SELECT AVG(rating) 
    FROM Ratings 
    WHERE movie_id = (SELECT movie_id FROM Movies WHERE title = 'Inception')
);


-- Q26: Users with no ratings
SELECT name AS user_name
FROM Users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id FROM Ratings
);


-- Q27: Movies having more than 3 actors
SELECT m.title AS movie_title,
       COUNT(ma.actor_id) AS total_actors
FROM Movies m
JOIN MovieActors ma ON m.movie_id = ma.movie_id
GROUP BY m.title
HAVING COUNT(ma.actor_id) > 3;


-- Q28: Movies ranked by average rating
SELECT m.title AS movie_title,
       AVG(r.rating) AS avg_rating,
       RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rank
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY rank;

-- Q29: Cumulative average rating per movie
SELECT m.title AS movie_title,
       r.created_at,
       r.rating,
       AVG(r.rating) OVER (PARTITION BY m.movie_id ORDER BY r.created_at ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_avg
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
ORDER BY m.title, r.created_at;

-- Q30: Users ranked by number of ratings
SELECT u.name AS user_name,
       COUNT(r.rating_id) AS total_ratings,
       RANK() OVER (ORDER BY COUNT(r.rating_id) DESC) AS user_rank
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
GROUP BY u.name
ORDER BY user_rank;


-- Q31: Top 5 movies by number of ratings
SELECT m.title AS movie_title,
       COUNT(r.rating_id) AS total_ratings
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY total_ratings DESC
LIMIT 5;

-- Q32: View: Movie rating summary
CREATE VIEW MovieRatingSummary AS
SELECT m.title AS movie_title,
       COUNT(r.rating_id) AS total_ratings,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM Movies m
LEFT JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title;

-- Q33: Users rating the same movie multiple times
SELECT u.name AS user_name,
       m.title AS movie_title,
       COUNT(r.rating_id) AS rating_count
FROM Ratings r
JOIN Users u ON r.user_id = u.user_id
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY u.name, m.title
HAVING COUNT(r.rating_id) > 1;






























