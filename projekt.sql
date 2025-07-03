CREATE VIEW sales_over_years AS
SELECT ROUND(SUM(global_sales), 2) AS global_sales
,ROUND(SUM(na_sales), 2) AS na_sales
,ROUND(SUM(eu_sales), 2) AS eu_sales
,ROUND(SUM(jp_sales), 2) AS jp_sales
,ROUND(SUM(other_sales), 2) AS other_sales
,year 
FROM vgsales
GROUP BY year
ORDER BY year;

CREATE VIEW all_games_platform AS
SELECT platform, COUNT(name) AS games_number
FROM vgsales
GROUP BY platform
ORDER BY games_number DESC;

CREATE VIEW games_count_year AS
SELECT year, COUNT(name) AS n_games
FROM vgsales
GROUP BY year
ORDER BY year;

CREATE VIEW top100games_anomaly AS 
SELECT vgsales.rank, name, platform, year, genre, publisher FROM vgsales
WHERE (year = 2006 OR year = 2013) AND vgsales.rank <= 100;

CREATE VIEW participation_of_100 AS
WITH filtered AS (
SELECT vgsales.rank, name, platform, year, genre, publisher, global_sales FROM vgsales
WHERE vgsales.rank <= 100
)
SELECT filtered.year, 
ROUND(SUM(100 * filtered.global_sales  / sales_over_years.global_sales), 2) as shares_in_global_sales,
COUNT(filtered.rank) AS number_of_games
FROM filtered JOIN sales_over_years ON sales_over_years.year = filtered.year
GROUP BY filtered.year
ORDER BY shares_in_global_sales DESC;


CREATE VIEW genre_sales_over_years AS
SELECT ROUND(SUM(global_sales), 2) AS global_sales
,ROUND(SUM(na_sales), 2) AS na_sales
,ROUND(SUM(eu_sales), 2) AS eu_sales
,ROUND(SUM(jp_sales), 2) AS jp_sales
,ROUND(SUM(other_sales), 2) AS other_sales
,genre
,year
FROM vgsales
GROUP BY genre, year
ORDER BY year;

CREATE VIEW part_genre_sales_over_years AS
WITH CTE AS (
SELECT ROUND(SUM(global_sales), 2) AS g_global_sales
,ROUND(SUM(na_sales), 2) AS g_na_sales
,ROUND(SUM(eu_sales), 2) AS g_eu_sales
,ROUND(SUM(jp_sales), 2) AS g_jp_sales
,ROUND(SUM(other_sales), 2) AS g_other_sales
,year
FROM vgsales
GROUP BY year
)
SELECT ROUND(SUM(global_sales), 2) AS global_sales
,ROUND(SUM(na_sales) / g_na_sales * 100, 2) AS na_sales
,ROUND(SUM(eu_sales) / g_eu_sales * 100, 2) AS eu_sales
,ROUND(SUM(jp_sales) / g_jp_sales * 100, 2) AS jp_sales
,ROUND(SUM(other_sales) / g_other_sales * 100, 2) AS other_sales
,genre
,vgsales.year
FROM vgsales JOIN CTE on vgsales.year = CTE.year
GROUP BY genre, year
ORDER BY year;

SELECT * FROM vgsales
limit 30;

CREATE  OR REPLACE VIEW publisher_sales AS
SELECT ROUND(SUM(global_sales), 2) AS global_sales
,ROUND(SUM(na_sales), 2) AS na_sales
,ROUND(SUM(eu_sales), 2) AS eu_sales
,ROUND(SUM(jp_sales), 2) AS jp_sales
,ROUND(SUM(other_sales), 2) AS other_sales
,publisher
,platform
,year
FROM vgsales
GROUP BY publisher, platform, year
ORDER BY year;

CREATE OR REPLACE VIEW publisher_games AS
SELECT COUNT(Name)
,publisher
,platform
,year
FROM vgsales
GROUP BY publisher, platform, year
ORDER BY year;

SELECT * FROM vgsales
limit 20;

CREATE VIEW top5platforms AS 
SELECT ROUND(SUM(na_sales), 2) AS g_na_sales
,ROUND(SUM(eu_sales), 2) AS g_eu_sales
,ROUND(SUM(jp_sales), 2) AS g_jp_sales
,ROUND(SUM(other_sales), 2) AS g_other_sales
,platform
FROM vgsales
GROUP BY platform;

CREATE VIEW jp_platforms AS
SELECT platform, genre, name
FROM vgsales
WHERE platform = 'NES' OR platform = 'SNES' OR platform = 'DS';

CREATE VIEW participation_of_100_platform AS
SELECT platform, ROUND(SUM(global_sales), 2) as g_sales FROM vgsales
WHERE vgsales.rank <= 100
GROUP BY platform;

CREATE OR REPLACE VIEW publishers_genres AS
SELECT COUNT(name) 
, genre
,publisher
FROM vgsales
GROUP BY publisher, genre;

CREATE VIEW platforms_genres AS
SELECT 
COUNT(NAME)
, genre
, platform
FROM vgsales
GROUP BY platform, genre;

CREATE VIEW platforms_exclusives AS
SELECT vgsales.name, vgsales.rank, genre, platform
FROM vgsales
WHERE name IN (
SELECT name
FROM vgsales
GROUP BY name
HAVING COUNT(name) = 1);