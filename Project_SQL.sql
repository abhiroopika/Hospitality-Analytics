Show databases;
use hospitality;
select * from dim_date;
select * from dim_hotels;
select * from dim_rooms;
select * from fact_aggregated_bookings;
select * from fact_bookings;


drop table fact_bookings;
------------------------------------------------
-- 1 Total Revenue
Select sum(revenue_realized) as Total_Revenue from fact_bookings;

-- 2 Total Bookings
select count(*) as Total_Bookings from fact_bookings;

-- 3 Total Capacity
select sum(capacity) as Total_Capacity from fact_aggregated_bookings;

-- 4 Total Sucessful Bookings
select sum(successful_bookings) as Total_Successful_Bookings from fact_aggregated_bookings;

-- 5 Occupancy %
select (sum(successful_bookings)/ sum(capacity))*100 as Occupancy_percentage from fact_aggregated_bookings;
select (sum(successful_bookings)*100 / sum(capacity)) as Occupancy_pct from fact_aggregated_bookings;

-- 6 Average Rating
select avg(ratings_given) as Average_ratings from fact_bookings;
 
 -- 7 No. of days
 select count(distinct check_in_date) as Number_of_days from fact_bookings;
 select count(date) from dim_date;
 
 -- 8 Totall cancelled bookings
 select count(booking_status) from fact_bookings where booking_status="Cancelled";
 
 -- 9 cancellation %
SELECT ROUND((COUNT(CASE WHEN booking_status = 'Cancelled' THEN 1 END) * 100.0) / COUNT(*), 2) AS cancellation_percentage
FROM fact_bookings; 

-- 10 Total Checked out
select count(booking_status) from fact_bookings where booking_status="Checked out";

-- 11 Total No show
select count(*) from fact_bookings where booking_status="No show";

-- 12 No show rate
SELECT ROUND((COUNT(CASE WHEN booking_status = 'No Show' THEN 1 END) * 100.0)/ COUNT(*),2) AS no_show_rate_percentage
FROM fact_bookings;

-- 13 booking % by platform
SELECT 
    booking_platform,
    COUNT(*) AS total_bookings,
    ROUND(
        (COUNT(*) * 100.0) / 
        (SELECT COUNT(*) FROM fact_bookings),
    2) AS booking_percentage
FROM fact_bookings
GROUP BY booking_platform
ORDER BY booking_percentage DESC;

-- 14 booking % by room class
select 
room_class,
count(*) as total_bookings,
round( (count(*) *100.0)/(select count(*) from dim_rooms),2) as booking_pct
FROM fact_bookings b
JOIN dim_rooms r
ON b.room_category = r.room_id

GROUP BY r.room_class

ORDER BY booking_pct DESC;

-- 15 ADR
select round(sum(revenue_realized)/count(case when booking_status="checked out" then 1 end),2) as ADR
from fact_bookings;

-- 16 realisation %
select round(sum(case when booking_status="checked out" then 1 end) *100/count(booking_id)) as Realization_pct from fact_bookings;
 
-- 17 RevPAR
SELECT 
  ROUND(
    SUM(fb.revenue_realized) / 
    SUM(fab.capacity), 2
  ) AS RevPAR
FROM fact_bookings fb
CROSS JOIN (SELECT SUM(capacity) AS capacity FROM fact_aggregated_bookings) fab;

SELECT room_category, COUNT(*)*100 / (SELECT COUNT(*) FROM fact_bookings) AS Booking_Rate 
FROM fact_bookings 
GROUP BY room_category 
ORDER BY booking_rate DESC;

SELECT r.room_class, COUNT(*)*100 / (SELECT COUNT(*) FROM fact_bookings) AS booking_rate
FROM fact_bookings f
JOIN dim_rooms r ON f.room_category = r.room_id
GROUP BY r.room_class
ORDER BY booking_rate DESC;
