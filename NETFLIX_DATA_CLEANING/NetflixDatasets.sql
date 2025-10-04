select *
from Netflix_Dataset

--------------------
--Check null values

select show_id,count(show_id)
from Netflix_Dataset
group by show_id
order by show_id desc

-----------------------------
---Check null values in each column

SELECT sum(case when show_id is null then 1 else 0 end) AS showid_nulls,
       sum(case when type is null then 1 else 0 end) AS type_nulls,
       sum(case when title is null then 1 else 0 end) AS title_nulls,
       sum(case when director is null then 1 else 0 end) AS director_nulls,
       sum(case when cast is null then 1 else 0 end) AS movie_cast_nulls,
       sum(case when country is null then 1 else 0 end) AS country_nulls,
       sum(case when date_added is null then 1 else 0 end) AS date_added_nulls,
       sum(case when release_year is null then 1 else 0 end) AS release_year_nulls,
       sum(case when rating is null then 1 else 0 end) AS rating_nulls,
       sum(case when duration is null then 1 else 0 end) AS duration_nulls,
       sum(case when listed_in is null then 1 else 0 end) AS listed_in_nulls,
       sum(case when description is null then 1 else 0 end) AS description_nulls
FROM Netflix_Dataset;

-------------------------------------

--- Below, we find out if some directors are likely to work with particular cast

Select n1.director,n1.cast,n2.director,n2.cast,isnull(n1.director,n2.director)
from Netflix_Dataset n1
join (SELECT director,cast, COUNT(*) AS count
	FROM Netflix_Dataset
	GROUP BY director,cast
	HAVING COUNT(*) > 1
	--ORDER BY COUNT(*) DESC
	) 
	n2
on n1.cast = n2.cast
where n1.director is null


update n1
set director  = isnull(n1.director,n2.director)
from Netflix_Dataset n1
join (SELECT director,cast, COUNT(*) AS count
	FROM Netflix_Dataset
	GROUP BY director,cast
	HAVING COUNT(*) > 1
	--ORDER BY COUNT(*) DESC
	) 
	n2
on n1.cast = n2.cast
where n1.director is null

UPDATE Netflix_Dataset			---For null put value Not given
SET director = 'Not Given'
WHERE director IS NULL;

-----------------------------------------------------------------

SELECT COALESCE(nt.country,nt2.country) 
FROM Netflix_Dataset  AS nt
JOIN Netflix_Dataset AS nt2 
ON nt.director = nt2.director 
AND nt.show_id <> nt2.show_id
WHERE nt.country IS NULL;


UPDATE nt
SET country = COALESCE(nt.country,nt2.country) 
FROM Netflix_Dataset  AS nt
JOIN Netflix_Dataset AS nt2 
ON nt.director = nt2.director 
AND nt.show_id <> nt2.show_id
WHERE nt.country IS NULL;


--To confirm if there are still directors linked to country that refuse to update

SELECT director, country, date_added
FROM Netflix_Dataset
WHERE country IS NULL;

--Populate the rest of the NULL in director as "Not Given"

UPDATE Netflix_Dataset 
SET country = 'Not Given'
WHERE country IS NULL;


-------------------------------------------------------------------------
--The date_added rows nulls is just 10 out of over 8000 rows, deleting them cannot affect our analysis or visualization

--Show date_added nulls

SELECT show_id, date_added
FROM Netflix_Dataset
WHERE date_added IS NULL;


DELETE FROM Netflix_Dataset
WHERE show_id 
IN (SELECT show_id
FROM Netflix_Dataset
WHERE date_added IS NULL);

------------------------------------------------------------------------------

---rating nulls is 4. Delete them

--Show rating NULLS

SELECT show_id, rating
FROM Netflix_Dataset
WHERE rating IS NULL;

--Delete the nulls, and show deleted fields

DELETE FROM Netflix_Dataset 
WHERE show_id 
IN (SELECT show_id
FROM Netflix_Dataset
WHERE rating IS NULL)
-------------------------------------------------------------------------------------

---duration nulls is 3. Delete them

--Show rating NULLS

SELECT show_id, duration
FROM Netflix_Dataset
WHERE duration IS NULL;

--Delete the nulls, and show deleted fields

DELETE FROM Netflix_Dataset 
WHERE show_id 
IN (SELECT show_id
FROM Netflix_Dataset
WHERE duration IS NULL)


---------------------------------------------------------------------------------


----movie_cast nulls are 825 but there is no such column we can retrieve the data

update Netflix_Dataset
set cast = 'Not Given'
where cast is null


----------------------------------------------------------------------------------

--Check to confirm the number of rows are the same(NO NULL)

SELECT sum(case when show_id is null then 1 else 0 end) AS showid_nulls,
       sum(case when type is null then 1 else 0 end) AS type_nulls,
       sum(case when title is null then 1 else 0 end) AS title_nulls,
       sum(case when director is null then 1 else 0 end) AS director_nulls,
       sum(case when cast is null then 1 else 0 end) AS movie_cast_nulls,
       sum(case when country is null then 1 else 0 end) AS country_nulls,
       sum(case when date_added is null then 1 else 0 end) AS date_added_nulls,
       sum(case when release_year is null then 1 else 0 end) AS release_year_nulls,
       sum(case when rating is null then 1 else 0 end) AS rating_nulls,
       sum(case when duration is null then 1 else 0 end) AS duration_nulls,
       sum(case when listed_in is null then 1 else 0 end) AS listed_in_nulls,
       sum(case when description is null then 1 else 0 end) AS description_nulls
FROM Netflix_Dataset;



----------------------------------------------------------------------------------

--We can drop the description column because they are not needed for our analysis or visualization task.

ALTER TABLE Netflix_Dataset
DROP COLUMN description;


-------------------------------------------------------------------------
---In some of country column there were multiple countries

SELECT country,
       Parsename(REPLACE(country,',','.'),1),
	   Parsename(REPLACE(country,',','.'),2),
	   Parsename(REPLACE(country,',','.'),3),
	   Parsename(REPLACE(country,',','.'),4),
	   Parsename(REPLACE(country,',','.'),5),
	   Parsename(REPLACE(country,',','.'),6),
	   Parsename(REPLACE(country,',','.'),7),
	   Parsename(REPLACE(country,',','.'),8),
	   Parsename(REPLACE(country,',','.'),9),
	   Parsename(REPLACE(country,',','.'),10)
FROM Netflix_Dataset;


-- NOW lets update the table

ALTER TABLE Netflix_Dataset 
ADD country1 varchar(500);

UPDATE Netflix_Dataset 
SET country1 = Parsename(REPLACE(country,',','.'),1);

--Delete column
ALTER TABLE Netflix_Dataset 
DROP COLUMN country;


---Rename the country1 column to country

exec sp_rename 'Netflix_Dataset.country1', 'country'

----------------------------------------------

select * 
from Netflix_Dataset


------------------------------------

update Netflix_Dataset
set country = 'Not Given'
where country is null

SELECT sum(case when show_id is null then 1 else 0 end) AS showid_nulls,
       sum(case when type is null then 1 else 0 end) AS type_nulls,
       sum(case when title is null then 1 else 0 end) AS title_nulls,
       sum(case when director is null then 1 else 0 end) AS director_nulls,
       sum(case when cast is null then 1 else 0 end) AS movie_cast_nulls,
       sum(case when country is null then 1 else 0 end) AS country_nulls,
       sum(case when date_added is null then 1 else 0 end) AS date_added_nulls,
       sum(case when release_year is null then 1 else 0 end) AS release_year_nulls,
       sum(case when rating is null then 1 else 0 end) AS rating_nulls,
       sum(case when duration is null then 1 else 0 end) AS duration_nulls,
       sum(case when listed_in is null then 1 else 0 end) AS listed_in_nulls
FROM Netflix_Dataset;


-----------Now the datset is clean now it is able to use in a visualization-------

select * from Netflix_Dataset;