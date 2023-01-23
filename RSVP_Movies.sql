USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) as Total_rows_DIRECTOR_MAPPING FROM DIRECTOR_MAPPING;
SELECT COUNT(*) As Total_rows_GENRE FROM GENRE;
SELECT COUNT(*) As Total_rows_MOVIE FROM  MOVIE;
SELECT COUNT(*) As Total_rows_NAMES FROM  NAMES;
SELECT COUNT(*) As Total_rows_RATINGS FROM  RATINGS;
SELECT COUNT(*) As Total_rows_ROLE_MAPPING FROM  ROLE_MAPPING;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 
	(case when sum(case when id is null then 1 else 0 end)>0 then 'yes' else 'no' end) as id,
    (case when sum(case when title is null then 1 else 0 end)>0 then 'yes' else 'no' end) as title,
    (case when sum(case when year is null then 1 else 0 end)>0 then 'yes' else 'no' end) as year,
    (case when sum(case when date_published is null then 1 else 0 end)>0 then 'yes' else 'no' end) as date_published,
    (case when sum(case when duration is null then 1 else 0 end)>0 then 'yes' else 'no' end) as duration,
    (case when sum(case when country is null then 1 else 0 end)>0 then 'yes' else 'no' end) as country,   
    (case when sum(case when worlwide_gross_income is null then 1 else 0 end)>0 then 'yes' else 'no' end) as worlwide_gross_income,
	(case when sum(case when languages is null then 1 else 0 end)>0 then 'yes' else 'no' end) as languages,
	(case when sum(case when production_company is null then 1 else 0 end)>0 then 'yes' else 'no' end) as production_company
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

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
-- Type your code below:
SELECT year, Count(title) AS number_of_movies FROM movie GROUP BY year;
SELECT MONTH(date_published) AS month_num, Count(*) AS number_of_movies FROM movie GROUP BY month_num ORDER BY month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select 
	sum(case when country like  '%USA%' or  country like '%India%' and year= 2019 then 1
			else 0 end)as Movies2019
from movie;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre AS unique_genre FROM genre; 

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
with p as (
SELECT count(genre) as c, genre as Genre
from genre
group by genre)
select genre, max(c) as Count
from p;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movies_belong_to_one_genre AS (SELECT movie_id FROM genre GROUP BY movie_id HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_belong_to_one_genre FROM movies_belong_to_one_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

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
select genre, round(avg(duration)) as avg_duration
from movie as m
inner join genre as g
on m.id=g.movie_id
group by genre;

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
SELECT * FROM (SELECT genre, Count(movie_id) AS movie_count ,
                Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank FROM genre GROUP BY genre) AS R
               where genre like '%Thriller%';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:
-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select round(min(avg_rating)) as min_avg_rating,
	round(max(avg_rating)) as max_avg_rating,
    min(total_votes) as min_total_votes,
    max(total_votes) as max_total_votes,
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
from ratings;

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
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating, Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank FROM ratings AS r INNER JOIN movie AS m ON m.id = r.movie_id limit 10;

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

select median_rating, count(movie_id) as movie_count
from ratings
group by median_rating
order by median_rating;

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
WITH production_house_has_hit_movies AS (SELECT production_company, Count(movie_id) AS movie_count,
                                         Rank() OVER(ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
                                         FROM ratings AS r INNER JOIN movie AS m ON m.id = r.movie_id
                                         WHERE production_company IS NOT NULL AND avg_rating > 8
                                         GROUP BY production_company)
SELECT * FROM production_house_has_hit_movies WHERE prod_company_rank = 1; 

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

select genre, count(title) as movie_count
from movie as m
inner join ratings as g on g.movie_id = m.id
inner join genre 
using (movie_id)
where year(date_published)=2017 and month(date_published)=3 and country like '%USA%' and total_votes>1000
group by genre;

#### dilmi obervation: some movies repeat due the fact that one movie has more that one genre represented ###

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
SELECT title, avg_rating, genre FROM movie as m
INNER JOIN genre AS g ON g.movie_id = m.id
INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE title LIKE 'THE%' and avg_rating > 8 GROUP BY title ORDER BY avg_rating DESC;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select count(title) as no_of_movies #year between 20018 and 2019
from movie as m
inner join ratings as r on m.id = r.movie_id
where date_published between '2018-04-01' and '2019-04-01';
select count(title) as no_of_movies_8 #and rating 8
from movie as m
inner join ratings as r on m.id = r.movie_id
where date_published between '2018-04-01' and '2019-04-01' and median_rating =8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

with german AS (
SELECT SUM(r.total_votes) AS German_votes 
FROM movie AS m
INNER JOIN ratings AS r ON m.id=r.movie_id 
WHERE m.languages LIKE '%German%'),
italian AS (
SELECT SUM(r.total_votes) AS Italian_votes 
FROM movie AS m
INNER JOIN ratings AS r ON m.id=r.movie_id 
WHERE m.languages LIKE '%Italian%')
SELECT *,
CASE WHEN german_votes > italian_votes THEN 'Yes' ELSE 'No' END ANSWER
FROM german,italian;	
 
-- Answer is Yes

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
select
	sum(case when name is null then 1 else 0 end)as name_nulls,
	sum(case when height is null then 1 else 0 end)as height_nulls,
	sum(case when date_of_birth is null then 1 else 0 end)as date_of_birth_nulls,
	sum(case when known_for_movies is null then 1 else 0 end)as known_for_movies_nulls
from names;

### dilmi observation total of 25736 entries###

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
WITH top_three_genres AS(SELECT genre, Count(m.id) AS movie_count ,
                     Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
                     FROM movie AS m INNER JOIN genre AS g ON g.movie_id = m.id
                     INNER JOIN ratings AS r ON r.movie_id = m.id
                     WHERE avg_rating > 8 GROUP BY genre limit 3)
SELECT n.name as director_name, COUNT(m.id) as movie_count FROM names AS n
INNER JOIN director_mapping AS d ON n.id=d.name_id
INNER JOIN movie AS m ON d.movie_id=m.id
INNER JOIN genre AS g ON m.id=g.movie_id
INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE r.avg_rating>8 AND g.genre IN (SELECT genre FROM top_three_genres)
GROUP BY director_name ORDER BY movie_count DESC LIMIT 3; 

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
select n.name as actor_name, count(id) as movie_count
from ratings as r
join director_mapping as d using(movie_id)
join names as n on n.id=d.name_id
where median_rating >= 8
group by n.name
order by movie_count desc
limit 2;


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
SELECT production_company, SUM(r.total_votes) AS vote_count,
DENSE_RANK() OVER(ORDER BY sum(r.total_votes)DESC) AS prod_comp_rank
FROM movie AS m INNER JOIN ratings AS r ON m.id= r.movie_id
GROUP BY production_company LIMIT 3;

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
with a as (
select n.name as actor_name, sum(r.total_votes) as total_votes , count(m.id) as movie_count , cast(avg(r.avg_rating)as DECIMAL(10,2)) as actor_avg_rating 
from role_mapping as rm
inner join names as n on n.id=rm.name_id
inner join movie as m on m.id=rm.movie_id
inner join ratings as r using(movie_id)
where country like '%India%' and category ='actor'
group by n.name)
select *,
	dense_rank() over(order by actor_avg_rating desc) as actor_rank
from a
where movie_count >=5;

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
SELECT name AS actress_name, r.total_votes,COUNT(m.id) AS movie_count,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
	RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actress_rank		
FROM movie AS m INNER JOIN ratings AS r  ON m.id = r.movie_id 
INNER JOIN role_mapping AS ro ON m.id=ro.movie_id 
INNER JOIN names AS n ON ro.name_id=n.id
WHERE ro.category='actress' AND m.country LIKE '%India%' AND m.languages LIKE '%Hindi%'
GROUP BY name HAVING COUNT(m.country='India')>=3 LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select title, 
	case when avg_rating>8 then 'Superhit movies'
		when avg_rating between 7 and 8 then 'Hit movies'
        when avg_rating between 5 and 7 then 'One-time-watch movies'
        else 'Flop movies' end as Classify
from movie as m
inner join genre as g on m.id=g.movie_id
inner join ratings as r using (movie_id)
where genre like '%thriller%'
order by Classify desc;


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
SELECT genre,
	ROUND(AVG(duration),0) AS avg_duration,
	SUM(ROUND(AVG(duration),1)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	ROUND(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie AS m INNER JOIN genre AS g ON m.id= g.movie_id GROUP BY genre ORDER BY genre;

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

with gg as ( # duumy table to identify top three genres
select *,
	dense_rank()over (order by count(movie_id) desc)as genre_rank
from genre
group by genre
limit 3),
mm as ( #table to rank all movies for each year
select g.genre,year,title as movie_name,worlwide_gross_income,
	row_number() OVER(PARTITION BY year ORDER BY cast(trim('INR' from trim('$' from worlwide_gross_income) )as float)DESC) AS movie_rank
from movie as m
inner join genre as g on m.id=g.movie_id),
rr as( #shows only top 5 movies
select *
from mm
where movie_rank < 6)
select rr.genre, rr.year, rr.movie_name, rr.worlwide_gross_income, rr.movie_rank
from rr
join gg
WHERE gg.genre=rr.genre;


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
SELECT production_company, count(m.id)AS movie_count, RANK() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND position(',' IN languages)>0
GROUP BY production_company LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actress_name, sum(total_votes)as total_votes,count(rm.movie_id) as movie_count , cast(avg(avg_rating) as decimal (10,1)) as actress_avg_rating,
	row_number() over(order by count(avg_rating>8) desc) as actress_rank
from role_mapping as rm
inner join names as n on n.id=rm.name_id
inner join ratings as r on rm.movie_id= r.movie_id
inner join genre as g on rm.movie_id=g.movie_id
where genre like '%drama%' and category = 'actress' and avg_rating >8
group by name
limit 3;

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
WITH date AS(
SELECT d.name_id, NAME, d.movie_id, duration, r.avg_rating, total_votes, m.date_published,
  Lead(date_published) OVER(partition BY d.name_id ORDER BY date_published, movie_id ) AS next_date
FROM director_mapping AS d INNER JOIN names AS n ON n.id = d.name_id 
INNER JOIN movie AS m ON m.id = d.movie_id 
INNER JOIN ratings AS r ON r.movie_id = m.id),
top_9 AS (
SELECT *, Datediff(next_date, date_published) AS date_diff 
FROM date)
SELECT name_id AS director_id,NAME AS director_name,Count(movie_id) AS number_of_moviesRound,
	(cast(Avg(date_diff) as decimal (10,2))) AS avg_inter_movie_days,
	(cast(Avg(avg_rating) as decimal(10,2))) AS avg_rating,
	Sum(total_votes) AS total_votes,
	Min(avg_rating) AS min_rating,
	Max(avg_rating) AS max_rating,
	Sum(duration) AS total_duration
FROM top_9 
GROUP BY name_id 
ORDER BY Count(movie_id) desc
limit 9;







