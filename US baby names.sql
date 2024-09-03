CREATE DATABASE baby;
USE baby;
SELECT * FROM names;

SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

#Cleaning the data
ALTER TABLE names ADD COLUMN year_born1 DATE;
UPDATE names
SET year_born1 = STR_TO_DATE(CONCAT(year_born, '-01-01'), '%Y-%m-%d');
ALTER TABLE names DROP COLUMN year_born;
ALTER TABLE names RENAME COLUMN year_born1 to year_born; 

#finding max and min years
SELECT MAX(YEAR(year_born)),MIN(YEAR(year_born)) FROM names

#Finding same names across years-self join
SELECT e1.baby_name,e1.gender,e1.year_born FROM names e1, names e2 WHERE e1.baby_name=e2.baby_name AND e1.year_born!= e2.year_born

#Finding timeless names-names occuring for atleast 5 years
SELECT baby_name,SUM(num) as name_count
FROM names
WHERE YEAR(year_born) between 1990 AND 2011 
GROUP BY baby_name
HAVING COUNT(DISTINCT YEAR(year_born))>=5

#Type of popularity-classic vs Trendy
SELECT baby_name, 'classic' AS type
FROM 
    (
        SELECT baby_name, COUNT(DISTINCT YEAR(year_born)) AS years_appeared
        FROM names
        WHERE YEAR(year_born) BETWEEN 1990 AND 2005 AND YEAR(year_born) NOT BETWEEN 2006 AND 2011
        GROUP BY baby_name
    ) AS timeless_names

UNION ALL

SELECT 
    baby_name, 'trendy' AS type
FROM 
    (
        SELECT baby_name, SUM(num) AS total_count,COUNT(DISTINCT YEAR(year_born)) AS years_appeared
        FROM names
        WHERE YEAR(year_born) BETWEEN 2006 AND 2011
        GROUP BY baby_name
        HAVING years_appeared <= 3 AND SUM(num)>1000
    ) AS trendy_names;
    
#Find top 10 Female names
SELECT baby_name, SUM(num) AS total_count
FROM names
WHERE gender = 'F'
GROUP BY baby_name
ORDER BY total_count DESC
LIMIT 10;

#The most popular female name ending in "a" since 2005
SELECT baby_name, SUM(num) AS total_count
FROM names
WHERE gender = 'F' AND baby_name LIKE '%a' AND YEAR(year_born)>2005
GROUP BY baby_name
ORDER BY total_count DESC;

#Most popular male names by year
SELECT year_born, baby_name, total_count
FROM (
SELECT year_born, baby_name, SUM(num) AS total_count,RANK() OVER (PARTITION BY year_born ORDER BY SUM(num) DESC) AS rnk
FROM names WHERE gender = 'M'
GROUP BY year_born, baby_name
) AS ranked_names
WHERE rnk = 1
ORDER BY year_born;

#The most popular male name for largest number of years
WITH cte as (
SELECT year_born, baby_name, SUM(num) AS total_count,RANK() OVER (PARTITION BY year_born ORDER BY SUM(num) DESC) AS rnk
FROM names WHERE gender = 'M'
GROUP BY year_born, baby_name
) 
SELECT baby_name, COUNT(*) AS years_most_popular
FROM cte
WHERE rnk = 1
GROUP BY baby_name
ORDER BY years_most_popular DESC;






