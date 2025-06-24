drop table if exists netflix;
create table netflix
(
	show_id varchar(6),
	type	varchar(100),
	title	varchar(150),
	director	varchar(250),
	casts	varchar(1500),
	country	varchar(150),
	date_added	varchar(50),
	release_year	INT,
	rating	varchar(10),
	duration	varchar(15),
	listed_in	varchar(150),
	description varchar(300)

)
select * from netflix;

#1.Count the number of Movies vs TV Shows
select 
	type, 
	count(*) as total_content
from netflix
group by type;

#2.Find the most common rating for movies and TV shows
select 
	type,
	rating
from
(
select 
	type,
	rating,
	count(*),
	rank()over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
) as t1
where ranking = 1;

#3.List all movies released in a specific year (e.g., 2020)
select * 
from netflix
where type = 'Movie' 
and 
release_year = 2020;

#4.Find the top 5 countries with the most content on Netflix
select 
	unnest(String_To_Array(country,',')) as new_country, 
	count(show_id) as total_content
from netflix
where country is not null
group by 1
order by count(show_id) desc
limit 5;

#5.Identify the longest movie
select 
	title,
	duration
from netflix
where type = 'Movie' and duration is not null
order by 2 desc;

#6.Find content added in the last 5 years
select *
from netflix
where 
TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'
;

#7.Find all the movies/TV shows by director 'Rajiv Chilaka'!
select *
from netflix
where director like '%Rajiv Chilaka%';

#8.List all TV shows with more than 5 seasons
select * 
from netflix
where 
type = 'TV Show' 
and 
duration > '5 Seasons';

#9.Count the number of content items in each genre
select
	unnest(String_To_Array(listed_in,',')) as Genre,
	count(listed_in)
from netflix
group by 1
order by 2 desc;

#10.Find each year and the average numbers of content release in India on netflix and return top 5 year with highest avg content release!
select 
	EXTRACT (YEAR from TO_DATE(date_added, 'Month DD,yyyy')) as year,
	count(*) as total_content,
	round(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric*100,0) as average_content_count
from netflix
where country ='India'
group by 1
order by 2 desc;

#11.List all movies that are documentaries
select * from netflix
where type ='Movie'
and listed_in like '%Documentaries%';

#12.Find all content without a director
select * from netflix
where director is null
;

#13.Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix
WHERE type = 'Movie'
and casts ilike '%salman khan%'
and release_year >= Extract(YEAR from CURRENT_DATE) - 10
;

  
#14.Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	unnest(String_To_Array(Casts,',')) as Actor,
	count(Casts) as number_movies
from netflix
where country ='India'
group by 1
order by 2 desc
limit 10;

#15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

select 
case 
	when description ilike '%kill%'
	or
	description ilike '%violence%' then 'bad'
	else 'good'
end as category,
count(show_id) as count
from netflix
group by 1;


