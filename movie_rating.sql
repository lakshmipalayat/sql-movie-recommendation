-- SQL PROJECT
-- Analysis of two data sets.
-- 1.movies_new with columns movieid,title and genres.
-- movieid(int)-unique identifier(primary key) for each movie
-- title(text)-movie name
-- genres(text)-genre of each movie which belong to

-- 2.ratings_new with columns userid,movieid,rating and timestamp
-- userid(int)-unique id of the user
-- movieid(int)-identifier for each movie
-- rating(double)-rating given by user(0-5)
-- timestamp(int)-updated timestamp

-- movieid set as the primary key.
-- clauses used:where,and,not,between,in,like,order by,group by,
-- having,aggregate functions,join,nested queries,view and cte

use jan_batch;
select * from movies_new;
select * from ratings_new;
desc movies_new;
desc ratings_new;

-- 1. WHERE: List all movie titles of comedy genres
select * from movies_new
where genres="comedy";

-- 2. AND: Find all ratings where the userId is 1 and
--  the rating is 5.0.
select * from ratings_new
where userid=1 and rating=5;

-- 3. OR: List movies that belong to either drama or crime 
select * from movies_new
where genres="drama" or genres="thriller";

-- 4. NOT: Retrieve all movies that are not in the 'Comedy' genre.
select * from movies_new
where not genres="comedy";
select * from movies_new
where genres not like "%comedy%";


-- 5. BETWEEN: Find movie id  with ratings between 3 and 5;
select movieid from ratings_new
where rating between 3 and 5;

-- 6. IN: List all movies that belong to either drama ,comedy or crime
select * from movies_new
where genres in ("drama","comedy","crime");

-- 7. LIKE: Find all movies staring with letter "s".
select * from movies_new
where title like "sa%";

-- 8.count the number of distinct users
select  count(distinct userid) from ratings_new;

-- 9. GROUP BY : Find the total number 
-- of ratings for each movie.
select m.title,count(r.rating) as total_rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title;


-- 10. Calculate the average rating for every 
-- movie in the database.
select m.title,round(avg(r.rating)) as avg_rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title;

-- 11. GROUP BY (MIN/MAX): Find the highest and lowest rating per movie.
select m.title,max(r.rating) as max_rating,min(r.rating) as min_rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title;

-- --12.  (group by+having)List movies that have an average rating of 4.0 
-- or higher.
select m.title,round(avg(r.rating)) as average
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title
having average>=4;


-- 13. GROUP BY + HAVING: Identify usersid who have given more than
-- 5 ratings in total.
select userid,count(rating) as rating_count
from ratings_new
group by userid
having rating_count>5
order by rating_count desc;

-- 14. INNER JOIN: show movie title with rating
select m.title,m.movieid,r.userid,r.rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid;

-- 15. LEFT JOIN: show all movie with no rating
select m.title
from movies_new as m
left join ratings_new as r
on m.movieid=r.movieid
where r.movieid is null;

-- 16.combine movieids from both table
select m.movieid,m.title,r.userid,r.rating
from movies_new as m
left join ratings_new as r
on m.movieid=r.movieid
union 
select m.movieid,m.title,r.userid,r.rating
from movies_new as m
right join ratings_new as r
on m.movieid=r.movieid;

-- 17. JOIN + WHERE: List the titles of all movies rated 5.0 by userId 5.
select m.title,r.rating,r.userid from
movies_new as m
join ratings_new as r
on m.movieid=r.movieid
where r.userid=5 and r.rating=5;

-- 18. Top 10 highest-rated movies
select m.title ,avg(round(r.rating)) as average_rating from 
movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title
order by average_rating desc
limit 10;

-- 19. Most active 10  users
select userid,count(rating) from ratings_new
group by userid
order by  count(rating) desc
limit 10;
 
-- 20.Genre popularity (group by genre)
select m.genres,count(r.rating) as total_rating
from movies_new as m
join ratings_new as r
on m.movieId = r.movieId
group by genres
order by total_rating desc;

-- 21.find all movies where all ratings are 4 or above
select m.title ,min(r.rating) as min_rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title
having min_rating>=4;

-- 22. SUBQUERY (WHERE): List titles of movies that have a 
-- rating higher than the average of all ratings.
select m.title,r.rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
where r.rating>(select round(avg(rating))from ratings_new);

-- 23. SUBQUERY :find the movies that have the rating greater
-- than the minimum rating.
select m.title,r.rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
where r.rating>(select min(rating) from ratings_new);



-- 24. VIEW CREATE: Create a view called HighRatedMovies that
--  only contains movies with an average rating above 4.5.
create view high_rated_movies as
select m.movieid,m.title,avg(round(r.rating)) as average_rating
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title,m.movieid
having average_rating>4.5;
select * from high_rated_movies;
-- find total number of highest rated movies using view
select count(*)
from high_rated_movies;


-- 25. CASE: Create a query that labels  movie based on ratings 
-- given by different users as 'Bad' (below 2), 'Average' (2–4),
--  or 'Excellent' (above 4).
select m.title,r.userid,r.rating,
case
when r.rating <2 then "Bad"
when r.rating between 2 and 4 then "Average"
else "Excellent"
end as review
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid;


-- 26. RANK:  rank movies  based on their average rating.
select m.title,avg(round(r.rating)) as average,
dense_rank() over(order by avg(r.rating) desc) as rating_rank
from movies_new as m
join ratings_new as r
on m.movieid=r.movieid
group by m.title;


-- 27. nested queries:Find the userid of the user
--  who has given the most "above-average" ratings.
select userid
from ratings_new
where rating>(select avg(rating) from ratings_new)
group by userid
order by count(*) desc
limit 1;

-- 28.create a cte with unique users and number of ratings they 
-- have given and arrange in descending order
with user_ratings as(
select userid,count(rating) as count_rating
from ratings_new as rating
group by userid)
select * from user_ratings
order by count_rating desc;







