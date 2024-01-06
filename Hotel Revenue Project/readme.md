-- Simple SQL code
```sql
WITH hotels AS (
  SELECT * FROM `hotel-revenue-408106.hotel_revenue.2018hotel`
  UNION ALL
  SELECT * FROM `hotel-revenue-408106.hotel_revenue.2019hotel`
  UNION ALL
  SELECT * FROM `hotel-revenue-408106.hotel_revenue.2020hotel`
)
SELECT 
arrival_date_year,
hotel,
round(sum((stays_in_week_nights + stays_in_weekend_nights) * adr),2) as revenue
FROM hotels
GROUP BY arrival_date_year, hotel; --- this query gives the revenues for each year and hotel type

SELECT * FROM `hotel-revenue-408106.hotel_revenue.combined_years` h
LEFT JOIN `hotel-revenue-408106.hotel_revenue.market_segment` m
ON h.market_segment = m.market_segment
LEFT JOIN `hotel-revenue-408106.hotel_revenue.meal_cost` c
ON c.meal = h.meal
```
