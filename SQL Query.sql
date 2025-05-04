
----------------------------------------------------------------Business Problems------------------------------------------------------------------------------------

-- Add New Column week_number

ALTER TABLE walmart_data ADD COLUMN week_number INT;

UPDATE walmart_data
SET week_number = EXTRACT(WEEK FROM "date"::DATE);


-- Add New Shift Mode Column.

ALTER TABLE walmart_data ADD COLUMN shift_mode VARCHAR(100)

UPDATE walmart_data AS w
SET shift_mode = CASE
    WHEN w."time"::TIME < TIME '12:00' THEN 'Morning'
    WHEN w."time"::TIME >= TIME '12:00' AND w."time"::TIME < TIME '15:00' THEN 'Noon'
    WHEN w."time"::TIME >= TIME '15:00' AND w."time"::TIME < TIME '18:00' THEN 'Evening'
    ELSE 'Night'
END;



-- Calculate The Total Transaction
SELECT COUNT(*) FROM walmart_data;

-- How many Branch
SELECT COUNT(DISTINCT "Branch") FROM walmart_data;

-- Q1. What are the different payment methods, and how many transactions and
-- items were sold with each method?

SELECT 
		"payment_method" AS payment_method,
 		COUNT(*) AS transactions,
		SUM("quantity") AS item_sold
FROM walmart_data
GROUP BY
	payment_method
ORDER BY
	item_sold DESC;


-- Q2. Which category received the highest average rating in each branch?

WITH avg_ratings AS (
    SELECT 
        "category" AS category,
        "Branch" AS branch,
        ROUND(AVG("rating")::numeric, 2) AS avg_rating,
        ROW_NUMBER() OVER (PARTITION BY "Branch" ORDER BY AVG("rating") DESC) AS rank
    FROM walmart_data
    GROUP BY category, branch
)
SELECT category, branch, avg_rating
FROM avg_ratings
WHERE rank = 1;

-- Q3. What is the busiest day of the week for each branch based on transaction volume?

WITH busiest_day AS(
SELECT 
	"Branch" AS branch,
	"Day" AS days,
	"week_number" AS week_num,
	-- "Branch" AS branch,
	COUNT(*) AS transaction_vol,
	ROW_NUMBER() OVER(PARTITION BY "week_number","Branch" ORDER BY COUNT(*) DESC) AS rank
FROM walmart_data
GROUP BY branch,days,week_num
)
SELECT
	branch,
	days,
	week_num,
	transaction_vol
FROM busiest_day
WHERE
	rank = 1;

-- Q4. How many items were sold through each payment method?

SELECT
	"payment_method" AS payment_method,
	SUM("quantity") AS item_sold
FROM
	walmart_data
GROUP BY
	payment_method;


-- Q5. What are the average, minimum, and maximum ratings for each category in
--     each city?

SELECT 
	"category" AS category,
	"City" AS city,
	ROUND(AVG("rating")::numeric,2) AS avg_rating,
	MIN("rating") AS minimum_rating,
	MAX("rating") AS maximum_rating
FROM walmart_data
GROUP BY
	category,city
ORDER BY city

-- Q6. What is the total profit for each category, ranked from highest to lowest?

SELECT
	"category" AS category,
	SUM("Total_price") AS total_profit
FROM
	walmart_data
GROUP BY
	category
ORDER BY
	total_profit DESC;

-- Q7. What is the most frequently used payment method in each branch?

WITH frequently_used_payment AS (
	SELECT
		"Branch" AS branch,
		"payment_method" AS payment_method,
		COUNT(*) AS number_of_trans,
		ROW_NUMBER() OVER(PARTITION BY "Branch" ORDER BY COUNT(*) DESC) AS rank
	FROM walmart_data
	GROUP BY
		branch,payment_method
	)
SELECT
	branch,
	payment_method,
	number_of_trans
FROM
	frequently_used_payment
WHERE rank = 1;


-- Q8. How many transactions occur in each shift (Morning, Afternoon, Evening)
-- across branches?

SELECT
	"Branch" AS branch,
	"shift_mode" AS shit_mode,
	COUNT(*) AS num_trans
FROM
	walmart_data
GROUP BY
	branch,shift_mode
ORDER BY
	branch;


-- Q9. Which branches experienced the largest decrease in revenue compared to
-- the previous year?


SELECT 
    curr."Branch" AS branch,
    prev."Year" AS previous_year,
    curr."Year" AS current_year,
    prev.total_revenue AS revenue_previous_year,
    curr.total_revenue AS revenue_current_year,
    (curr.total_revenue - prev.total_revenue) AS revenue_change
FROM (
    SELECT "Branch", "Year", SUM("Total_price") AS total_revenue
    FROM walmart_data
    GROUP BY "Branch", "Year"
) curr
JOIN (
    SELECT "Branch", "Year", SUM("Total_price") AS total_revenue
    FROM walmart_data
    GROUP BY "Branch", "Year"
) prev
ON curr."Branch" = prev."Branch" AND curr."Year" = prev."Year" + 1
ORDER BY revenue_change,branch ASC;
































































































































