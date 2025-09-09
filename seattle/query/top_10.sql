CREATE TABLE top_10_neighborhoods AS

WITH listing_income AS (
    SELECT l.id AS listing_id, l.neighbourhood, SUM(CAST(REPLACE(REPLACE(l.price, '$', ''), ',', '') AS DECIMAL(10,2))) AS total_income
    FROM listings AS l
    JOIN calendar AS c ON l.id = c.listing_id
    WHERE l.neighbourhood IS NOT NULL AND c.available = 'f'
    GROUP BY l.id, l.neighbourhood
)

-- Step 2: average income per listing by neighborhood
SELECT neighbourhood, AVG(total_income) AS avg_income_per_listing, COUNT(listing_id) AS num_listings
FROM listing_income
GROUP BY neighbourhood
HAVING COUNT(listing_id) > 50
ORDER BY avg_income_per_listing DESC
LIMIT 10
;
