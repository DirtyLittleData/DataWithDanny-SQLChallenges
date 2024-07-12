-- 2. How many days has each customer visited the restaurant?
SET search_path to dannys_diner;
-- SELECT * from menu;
-- SELECT * from sales;
SELECT
	customer_id,
    count(distinct order_date) as number_of_visits
FROM sales
GROUP by customer_id
ORDER by 2 DESC;