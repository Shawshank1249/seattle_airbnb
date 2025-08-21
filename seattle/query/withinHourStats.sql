CREATE TABLE withinHourStats AS
WITH withinAnHour AS (
    SELECT 
        c.listing_id as listing_id, 
        l.neighbourhood as neighbourhood, 
        SUM(CASE WHEN c.available = 't' THEN 1 ELSE 0 END) AS days_available,
        CAST(REPLACE(REPLACE(l.price, '$', ''), ',', '') AS DECIMAL) 
          * SUM(CASE WHEN c.available = 't' THEN 1 ELSE 0 END) AS money_lost,
        l.host_response_time
    FROM calendar AS c
    JOIN listings AS l ON c.listing_id = l.id
    WHERE l.host_response_time = 'within an hour'
      AND c.date BETWEEN '2016-01-01' AND '2016-01-31'
      AND l.neighbourhood IS NOT NULL
    GROUP BY c.listing_id, l.neighbourhood, l.host_response_time, l.price
)
SELECT 
    neighbourhood,
    COUNT(listing_id) AS num_listings,
    SUM(days_available) AS total_days_available,
    SUM(money_lost) AS total_money_lost,
    AVG(money_lost) AS avg_money_lost_per_listing
FROM withinAnHour
GROUP BY neighbourhood
ORDER BY total_money_lost DESC;

