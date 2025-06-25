# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/ab21bisht/Netflix_sql_project/blob/main/Netflix%20logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows
```sql
select 
type, 
count(*) as total_content
from netflix
group by type;
```

### 2. Find the Most Common Rating for Movies and TV Shows
```sql
select 
type,
rating
from
(select 
type,
rating,
count(*),
rank()over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2) as t1
where ranking = 1;
```

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
select * 
from netflix
where type = 'Movie' 
and 
release_year = 2020;
```

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
select 
unnest(String_To_Array(country,',')) as new_country, 
count(show_id) as total_content
from netflix
where country is not null
group by 1
order by count(show_id) desc
limit 5;
```

### 5. Identify the Longest Movie
```sql
select 
title,
duration
from netflix
where type = 'Movie' and duration is not null
order by 2 desc;
```

### 6. Find Content Added in the Last 5 Years
```sql
select *
from netflix
where 
TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'
;
```

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select *
from netflix
where director like '%Rajiv Chilaka%';
```

### 8. List All TV Shows with More Than 5 Seasons
```sql
select * 
from netflix
where 
type = 'TV Show' 
and 
duration > '5 Seasons';
```

### 9. Count the Number of Content Items in Each Genre
```sql
select
unnest(String_To_Array(listed_in,',')) as Genre,
count(listed_in)
from netflix
group by 1
order by 2 desc;
```

### 10.Find each year and the average numbers of content release in India on netflix, return top 5 year with highest avg content release!
```sql
select 
EXTRACT (YEAR from TO_DATE(date_added, 'Month DD,yyyy')) as year,
count(*) as total_content,
round(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric*100,0) as average_content_count
from netflix
where country ='India'
group by 1
order by 2 desc;
```

### 11. List All Movies that are Documentaries
```sql
select * from netflix
where type ='Movie'
and listed_in like '%Documentaries%';
```

### 12. Find All Content Without a Director
```sql
select * from netflix
where director is null
;
```

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
and casts ilike '%salman khan%'
and release_year >= Extract(YEAR from CURRENT_DATE) - 10
;
```

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
select 
unnest(String_To_Array(Casts,',')) as Actor,
count(Casts) as number_movies
from netflix
where country ='India'
group by 1
order by 2 desc
limit 10;
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category
```sql
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
```
## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
