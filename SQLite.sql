create table appleStore_description_combined as 
Select * from appleStore_description1
union all 
Select * from appleStore_description2
union all 
Select * from appleStore_description3
union all 
Select * from appleStore_description4

#Exploratory Data Analysis

-- check number of unique apps in both tables

select count(DISTINCT id) as UniqueAppIDd
from AppleStore

select count(DISTINCT id) as UniqueAppIDd
from appleStore_description_combined

--check for any missing values in key fields

select count(*) as MissingValues
from appleStore_description_combined
where app_desc is NULL

--Find the number of games per genere

select prime_genre, count(*) as NumApps
from AppleStore
Group by prime_genre
order by NumApps DESC

-- Get overview of the apps ratings

select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
	   avg(user_rating) as AvgRating
From AppleStore       

# Data Analysis

-- Determine whether paid apps have higher rating than free apps 

Select Case 
			when price > 0 then 'Paid'
			else 'Free'
		end as App_Type,
		avg(user_rating) as Avg_rating 
from AppleStore
group by App_Type

-- Check if apps with more supported langauge have higher ratings

Select case 
			when lang_num < 10 then '<10 languages'
			when lang_num between 10 and 30 then '10-30 languages'
			else '>30 languages'
         end as language_bucket,
         avg(user_rating) as Avg_rating 
from AppleStore
group by language_bucket
order by Avg_rating DESC
            
-- Check genres with low ratings

select prime_genre,
		avg(user_rating) as Avg_rating 
from AppleStore
group by prime_genre
order by Avg_rating ASC
limit 10

-- Check if there is correclatioin between the length of the app description and the user rating

SELECT case 
			when length(B.app_desc) < 500 then 'Short'
			when length(B.app_desc) Between 500 and 1000 then 'Medium'
            else 'Long'
       end as description_length_bucket,
       avg(A.user_rating) as Avg_rating 
            
from AppleStore as A
join appleStore_description_combined as B
on A.id = B.id
group by description_length_bucket
order by Avg_rating DESC

-- Check the top rated apps for each genre

SELECT prime_genre, track_name, user_rating
FROM (
    SELECT 
        prime_genre,
        track_name,
        user_rating,
        RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM AppleStore
) AS a
WHERE a.rank = 1;


