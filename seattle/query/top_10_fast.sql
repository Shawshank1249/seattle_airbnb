CREATE TABLE top_10_fast AS
WITH listing_income AS (
    SELECT 
        l.id AS listing_id,
        l.neighbourhood,
        SUM(CAST(REPLACE(REPLACE(l.price, '$', ''), ',', '') AS DECIMAL(10,2))) AS total_income
    FROM listings AS l
    JOIN calendar AS c 
        ON l.id = c.listing_id
    WHERE l.neighbourhood IS NOT NULL
      AND c.available = 'f'
	  AND l.host_response_time IN  ('within a day', 'within a few hours')
      AND l.neighbourhood IN (
          'Belltown',
		  'Lower Queen Anne',
		  'Queen Anne',
		  'Stevens',
		  'Wallingford',
		  'Capitol Hill',
		  'Central Business District',
		  'First Hill',
		  'Fremont',
		  'Minor'
      )
    GROUP BY l.id, l.neighbourhood
)

SELECT 
    neighbourhood,
    AVG(total_income) AS avg_income_per_listing,
    COUNT(listing_id) AS num_listings
FROM listing_income
GROUP BY neighbourhood
ORDER BY avg_income_per_listing DESC;
