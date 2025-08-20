USE imdb;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
SELECT 
	* 
FROM 
	movie;

SELECT 
	COUNT(*) AS null_values 
FROM 
	movie
WHERE 
	worlwide_gross_income IS NULL;

SELECT 
	* 
FROM 
	genre;

SELECT 
	DISTINCT(genre) AS unique_genre 
FROM 
	genre;
-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
	COUNT(*) AS rows_movie 
FROM 
	movie;
-- Total no. of rows in table movie are 7997
SELECT 
	COUNT(*) AS rows_genre 
FROM 
	genre;
-- Total no. of rows in table genre are 14662
SELECT 
	COUNT(*) AS rows_dir 
FROM 
	director_mapping;
-- Total no. of rows in table director_mapping are 3867
SELECT 
	COUNT(*) AS rows_name 
FROM 
	names;
-- Total no. of rows in table names are 25735
SELECT 
	COUNT(*) AS rows_rating 
FROM 
	ratings;
-- Total no. of rows in table ratings are 7997
SELECT 
	COUNT(*) AS rows_role 
FROM 
	role_mapping;
-- Total no. of rows in table role_mapping are 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
	* 
FROM
	movie
WHERE 
	id IS NULL
	OR title IS NULL
	OR year IS NULL
	OR date_published IS NULL
	OR duration IS NULL
	OR country IS NULL
	OR worlwide_gross_income IS NULL
	OR languages IS NULL
	OR production_company IS NULL;
    
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
SELECT 
	YEAR(date_published) AS year, 
	COUNT(id) AS num_of_movies 
FROM 
	movie
GROUP BY 
	YEAR(date_published);
-- OR --
SELECT 
	year, 
	COUNT(id) AS num_of_movies 
FROM 
	movie
GROUP BY 
	year;
-- This will help us retrieve total number of movies released per year.

SELECT 
	MONTH(date_published) AS month_num, 
    YEAR(date_published) AS year_num, 
    COUNT(id) AS num_of_movies 
FROM 
	movie
GROUP BY 
	MONTH(date_published), 
    YEAR(date_published)
ORDER BY 
	year_num, 
    month_num;
-- This will give month wise number of movies for each year.

SELECT 
	MONTH(date_published) AS month_num, 
    COUNT(id) AS num_of_movies 
FROM 
	movie
GROUP BY 
	MONTH(date_published)
ORDER BY 
	month_num;
-- We can clearly observe by combining together this data for last 3 years that least number of movies are released in the month of December and most being released in the month of March.
/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
	COUNT(country) AS total_num_movies, 
    country
FROM 
	movie
WHERE 
	country IN ('USA', 'India')
	AND year = 2019
GROUP BY 
	country;

/* USA and India produced 887 movies in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/
-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
	COUNT(DISTINCT(genre)) AS unique_genre 
FROM 
	genre;
-- We have 13 distinct genres in the genre table.

SELECT 
	DISTINCT(genre) as unique_genre 
FROM 
	genre;
-- This will enlist all 13 of them.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */
-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
	COUNT(movie.id) AS num_of_movies, 
    genre.genre 
FROM 
	movie
JOIN 
	genre
ON
	(id=movie_id)
GROUP BY 
	genre.genre
ORDER BY 
	num_of_movies DESC;
    
-- We can see that over the spawn of last 3 years, the most number of movies made are of genre 'DRAMA' followed by 'COMEDY' and the 3rd most popular genre is 'THRILLER'.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/
-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT 
	COUNT(*) AS num_of_movies_with_one_genre
FROM 
	(SELECT 
		movie_id
	FROM 
		genre
	GROUP BY 
		movie_id
	HAVING 
		COUNT(genre) = 1) 
AS single_genre_movies;

/* There are 3289 movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project. */
-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	ROUND(AVG(movie.duration),2) AS avg_duration, 
	genre.genre
FROM 
	movie
JOIN 
	genre
ON
	(movie.id=genre.movie_id)
GROUP BY 
	genre.genre
ORDER BY 
	avg_duration;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/
-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	COUNT(movie.id) AS movie_count, 
	genre.genre,
	DENSE_RANK() OVER (ORDER BY COUNT(movie.id) DESC) AS genre_rank
FROM 
	movie
JOIN 
	genre
ON
	(movie.id=genre.movie_id)
GROUP BY 
	genre.genre;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/
-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
	MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_votes,
	MAX(total_votes) AS max_votes,
	MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
FROM 
	ratings; 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/
-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
WITH Ranked_Movies AS 
(SELECT 
	title, 
	ROUND(AVG(avg_rating),2) AS avg_rating,
	DENSE_RANK() OVER (ORDER BY AVG(avg_rating) DESC) AS movie_rank
FROM 
	movie
JOIN 
	ratings
ON
	(movie.id=ratings.movie_id)
GROUP BY 
	title)
SELECT 
	title, 
	avg_rating,
    movie_rank
FROM 
	Ranked_Movies
WHERE
	movie_rank<=10
ORDER BY 
	movie_rank;
    
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/
-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    ratings.median_rating,
    COUNT(movie.id) AS movie_count
FROM 
	ratings
JOIN
	movie
ON
	(ratings.movie_id=movie.id)
GROUP BY 
	ratings.median_rating
ORDER BY
	movie_count DESC;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/
-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH most_hit_movies AS 
	(SELECT 
		AVG(ratings.avg_rating) AS avg_rating,
		movie.production_company, 
		COUNT(movie.id) AS movie_count,
		DENSE_RANK() OVER (ORDER BY COUNT(movie.id)DESC) AS prod_company_rank
	FROM
		movie
	JOIN
		ratings
	ON
		movie.id=ratings.movie_id
	GROUP BY
		movie.production_company
	HAVING
		AVG(ratings.avg_rating)>8)
SELECT 
	production_company,
    movie_count,
    prod_company_rank
FROM
	most_hit_movies
WHERE 
	prod_company_rank =1
ORDER BY
	movie_count DESC,
    production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both
-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH movies_released AS
	(SELECT 
		COUNT(movie.id) AS movie_count,
        genre.genre AS genre,
        SUM(ratings.total_votes) AS votes
	FROM
		movie
	JOIN
		genre ON movie.id=genre.movie_id
	JOIN
		ratings	ON movie.id=ratings.movie_id
	WHERE
		movie.country= 'USA' AND movie.year= 2017 AND MONTH(movie.date_published)= 3 AND ratings.total_votes> 1000
	GROUP BY
		genre.genre)
SELECT 
	genre,
	movie_count
FROM 
	movies_released
WHERE
	genre= 'Thriller';

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH avg_rating_the AS
	(SELECT 
		movie.id AS id,
		movie.title AS title,
		ratings.avg_rating AS avg_rating
	FROM 
		movie
	JOIN
		ratings ON movie.id=ratings.movie_id
	WHERE
		movie.title LIKE ('The%') AND ratings.avg_rating > 8)
SELECT
    title,
    avg_rating,
    genre
FROM
	avg_rating_the
JOIN
	genre ON avg_rating_the.id=genre.movie_id
ORDER BY
	avg_rating;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
	movie.title AS title,
	ratings.median_rating AS movie_rating,
    movie.date_published AS date
FROM 
	movie
JOIN
	ratings ON movie.id=ratings.movie_id
WHERE 
	movie.date_published Between '2018-04-01' AND '2019-04-01' AND ratings.median_rating = 8
ORDER BY
	date

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH german_italian AS
	(SELECT 
		COUNT(movie.title) AS movies,
		movie.languages AS languages,
        SUM(ratings.total_votes) AS votes
	FROM 
		movie
	JOIN
		ratings ON movie.id=ratings.movie_id
	WHERE 
		languages IN ('Italian', 'GERMAN')
	GROUP BY
		languages)
SELECT 
	languages,
    votes
FROM 
	german_italian
    
-- The answer to this is NO, clear we can see with 110 German movies there are 79k around votes but when it comes to Italian movie with just 2 more in number the votes are pretty high at around 100k.
/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/
-- Segment 3:
-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
	names

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/
-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH director_name AS
	(SELECT 
		names.name AS name,
        director_mapping.movie_id AS movie_id
	FROM 
		director_mapping
	JOIN
		names ON director_mapping.name_id=names.id
        ),
genre_ratings AS
	(SELECT
		genre.movie_id AS movie_id,
		genre.genre AS genre,
        ratings.avg_rating AS avg_rating
	FROM 
		genre
	JOIN
		ratings ON genre.movie_id=ratings.movie_id
	WHERE
		avg_rating > 8
        ),
top_three_genres AS
	(SELECT 
		genre AS genre,
        COUNT(movie_id) AS movie_count
	FROM
		genre
	GROUP BY
		genre
	ORDER BY
		movie_count DESC
	LIMIT 3
    )
SELECT 
    director_name.name AS name,
    genre_ratings.genre AS genre,
    COUNT(genre_ratings.movie_id) AS movie_count
FROM
    director_name
JOIN
    genre_ratings ON director_name.movie_id = genre_ratings.movie_id
JOIN
    top_three_genres ON genre_ratings.genre = top_three_genres.genre
GROUP BY
    director_name.name, genre_ratings.genre
ORDER BY
    movie_count DESC
LIMIT 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/
-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
	WITH actor_name AS
		(SELECT 
			COUNT(rm.movie_id) AS movie_count,
			names.name AS name
			
		FROM
			role_mapping AS rm
		JOIN
			names ON names.id=rm.name_id
		JOIN
			ratings ON ratings.movie_id=rm.movie_id
		WHERE
			category= 'actor'
			AND median_rating >= 8
		GROUP BY
			names.name
		ORDER BY
			movie_count DESC)
	SELECT
		name,
		movie_count
	FROM
		actor_name
	LIMIT 2;
	
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/
-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	production_company,
    SUM(total_votes) AS vote_count,
	DENSE_RANK() OVER (ORDER BY 
						SUM(total_votes) DESC) 
	AS prod_comp_rank 
FROM 
	movie
JOIN 
	ratings ON ratings.movie_id=movie.id
WHERE
	production_company IS NOT NULL
GROUP BY 
	production_company
ORDER BY
	vote_count DESC
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.
Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/
-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
	names.name AS actor_name,
	SUM(ratings.total_votes) AS total_votes,
	COUNT(movie.id) AS movie_count,
	ROUND(AVG(ratings.avg_rating),2) AS actor_avg_rating,
	RANK() OVER (ORDER BY 
					SUM(ratings.avg_rating * ratings.total_votes) / SUM(ratings.total_votes) DESC, 
                    SUM(ratings.total_votes) DESC) 
	AS actor_rank
FROM
	movie
JOIN
	role_mapping AS rm ON rm.movie_id=movie.id
JOIN 
	names ON names.id=rm.name_id
JOIN
	ratings ON movie.id=ratings.movie_id
WHERE
	rm.category= 'actor'
	AND
	movie.country= 'India'
GROUP BY
	names.name
HAVING
	COUNT(movie.id) >= 5
LIMIT 5;

-- Top actor is Vijay Sethupathi
-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
	names.name AS actor_name,
	SUM(ratings.total_votes) AS total_votes,
	COUNT(movie.id) AS movie_count,
    ROUND(SUM(ratings.avg_rating * ratings.total_votes) / SUM(ratings.total_votes),2) AS avg_actress_rating,
    RANK() OVER (ORDER BY
					SUM(ratings.total_votes * ratings.avg_rating)/ SUM(ratings.total_votes) DESC,
					SUM(ratings.total_votes) DESC
				) 
	AS actress_rank
	
FROM
	movie
JOIN
	role_mapping AS rm ON rm.movie_id=movie.id
JOIN 
	names ON names.id=rm.name_id
JOIN
	ratings ON movie.id=ratings.movie_id
WHERE
	rm.category= 'actress'
	AND
	movie.country= 'India'
GROUP BY
	names.name
HAVING
	COUNT(movie.id) >= 3
ORDER BY
    actress_rank
LIMIT 5;

-- Shraddha Srinath tops the list with the Average rating 8.48.
/* Now let us divide all the thriller movies in the following categories and find out their numbers.
Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  
			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/
-- Type your code below:
SELECT
	movie.title AS movie_name,
    CASE
	WHEN ratings.avg_rating > 8 THEN 'Super-Hit'
    WHEN ratings.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
    WHEN ratings.avg_rating BETWEEN 5 AND 7 THEN 'One-Tume-Watch'
    ELSE 'Flop' 
    END AS movie_category
FROM
	movie
JOIN
	ratings ON movie.id=ratings.movie_id
ORDER BY
	ratings.avg_rating DESC

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/
-- Segment 4:
-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH total_genre_duration AS
	(
    SELECT 
		genre.genre AS genre,
		SUM(movie.duration) as total_duration
	FROM
		movie
	JOIN
		genre ON movie.id=genre.movie_id
	GROUP BY 
		genre.genre
    ),
avg_genre_duration AS
	(
    SELECT 
		genre.genre AS genre,
		AVG(movie.duration) as avg_duration
	FROM
		movie
	JOIN
		genre ON movie.id=genre.movie_id
	GROUP BY 
		genre.genre
	),
genre_running_total AS 
	(
    SELECT
        genre,
        total_duration,
        SUM(total_duration) OVER (ORDER BY 
									genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
		AS running_total_duration
    FROM
        total_genre_duration
	),
genre_moving_avg AS 
	(
    SELECT
        genre,
        avg_duration,
        AVG(avg_duration) OVER (ORDER BY 
									genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
		AS moving_avg_duration
    FROM
        avg_genre_duration
	)
SELECT
    g.genre,
    ROUND(avg_duration,2) AS avg_duration,
    ROUND((g.running_total_duration),2) AS running_total_duration,
    ROUND(a.moving_avg_duration,2) AS moving_average_duration
FROM
    genre_running_total AS g
JOIN
    genre_moving_avg AS a ON g.genre=a.genre
ORDER BY
    g.genre

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.
-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_3_genre AS
	(
	SELECT
		COUNT(movie.id) AS movie_count,
		genre.genre AS genre
	FROM
		movie
	JOIN
		genre ON movie.id=genre.movie_id
	GROUP BY
		genre.genre
	ORDER BY
		movie_count DESC
	LIMIT 3
    ),
movie_by_year AS
	(
	SELECT
		top_3_genre.genre AS genre,
		movie.year AS year,
		movie.title AS movie_name,
		movie.worlwide_gross_income AS total_earnings,
		DENSE_RANK() OVER (PARTITION BY 
							movie.year, 
							top_3_genre.genre 
						   ORDER BY 
							movie.worlwide_gross_income DESC) 
		AS movie_rank
    FROM
		movie
	JOIN
        genre ON movie.id = genre.movie_id
    JOIN
        top_3_genre ON top_3_genre.genre = genre.genre
    WHERE
        movie.worlwide_gross_income IS NOT NULL
	)
SELECT 
	movie_by_year.genre,
    movie_by_year.year,
    movie_by_year.movie_name,
    movie_by_year.total_earnings,
    movie_by_year.movie_rank
FROM
	movie_by_year
WHERE
	movie_rank BETWEEN 1 AND 5
    
-- Top 3 Genres based on most number of movies
-- DRAMA
-- COMEDY
-- THRILLER
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_movie AS
	(
	SELECT 
		*
	FROM
		movie
	WHERE
		languages LIKE ('%,%')
        AND 
        production_company IS NOT NULL
	)
SELECT 
	multilingual_movie.production_company,
	COUNT(multilingual_movie.id) AS movie_count,
    DENSE_RANK() OVER (ORDER BY 
						COUNT(multilingual_movie.id) DESC,
						AVG(ratings.median_rating) DESC) 
	AS prod_comp_rank
FROM 
	multilingual_movie
JOIN
	ratings ON ratings.movie_id=multilingual_movie.id
WHERE
	ratings.median_rating >= 8
GROUP BY
	 multilingual_movie.production_company
ORDER BY
	prod_comp_rank
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language
-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?
-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH super_hit_movies AS
	(
	SELECT
		names.name AS name,
        ratings.total_votes AS total_votes,
        movie.title AS title,
        ratings.avg_rating AS avg_rating
	FROM
		movie
	JOIN
		ratings ON ratings.movie_id = movie.id
	JOIN
		role_mapping AS rm ON rm.movie_id = movie.id
	JOIN
		names ON rm.name_id=names.id
	JOIN
		genre ON movie.id=genre.movie_id
	WHERE
		rm.category= 'actress'
        AND
        ratings.avg_rating > 8
        AND
        genre.genre = 'Drama'
	)
SELECT
	super_hit_movies.name AS actress_name,
    SUM(super_hit_movies.total_votes) AS total_votes,
    COUNT(super_hit_movies.title) AS movie_count,
   	ROUND(AVG(super_hit_movies.avg_rating),2) AS actress_avg_rating,
    DENSE_RANK() OVER (ORDER BY 
						COUNT(super_hit_movies.title) DESC, 
						SUM(super_hit_movies.avg_rating * super_hit_movies.total_votes)/ SUM(super_hit_movies.total_votes) DESC, 
						SUM(super_hit_movies.total_votes) DESC, 
						super_hit_movies.name) 
	AS actress_rank
FROM
	super_hit_movies
GROUP BY
	super_hit_movies.name
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations
Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_names AS
	(
    SELECT
		dm.name_id AS director_id,
		names.name AS director_name,
		movie.title AS movie_title,
		ratings.avg_rating AS avg_rating,
		ratings.total_votes AS total_votes,
		movie.duration AS duration,
		movie.date_published AS release_date,
		LEAD(movie.date_published) OVER (
									PARTITION BY 
										dm.name_id 
									ORDER BY
										movie.date_published DESC
                                        )
		AS next_release_date
	FROM
		director_mapping AS dm
	JOIN
		movie ON dm.movie_id=movie.id
	JOIN
		ratings ON ratings.movie_id=dm.movie_id
	JOIN
		names ON names.id=dm.name_id
	)
SELECT 
	director_id,
    director_name,
    COUNT(movie_title) AS movie_count,
    ROUND(AVG(DATEDIFF(next_release_date, release_date))) AS average_inter_movie_days,
    AVG(avg_rating) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM
	director_names
GROUP BY
	director_id
ORDER BY
	COUNT(movie_title) DESC
LIMIT 9;
-- This code helps us find the top 9 directors with most movie counts and all the details except the average inter movie duration.
-- Lets work on getting the average movie duration and then we can have it combined within our output.

