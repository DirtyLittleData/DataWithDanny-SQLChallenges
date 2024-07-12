-- 5. Which item was the most popular for each customer?
WITH count_rank_table AS ( 
	SELECT
		s.customer_id,
    	m.product_name,
    	COUNT(s.product_id) total,
  		DENSE_RANK() OVER (
      	PARTITION BY customer_id 
      	ORDER BY COUNT(s.product_id) DESC
    ) ranked_by_cust
	FROM sales s
	JOIN menu m ON s.product_id = m.product_id
	GROUP BY s.customer_id, m.product_name
)

SELECT 
	*
FROM count_rank_table
WHERE ranked_by_cust = 1
ORDER BY customer_id, total DESC

-- WITH count_table AS ( 
-- 	SELECT
-- 		s.customer_id,
--     	m.product_name,
--     	COUNT(s.product_id) totals
-- 	FROM sales s
-- 	JOIN menu m ON s.product_id = m.product_id
-- 	GROUP BY 1, 2
-- ),
-- ranked_table AS (
--   	SELECT 
-- 		*,
-- 	DENSE_RANK() OVER (
--       PARTITION BY customer_id 
--       ORDER BY totals DESC
--     ) ranked_by_cust
-- FROM count_table
-- )

-- SELECT 
-- 	*
-- FROM ranked_table
-- WHERE ranked_by_cust = 1
-- ORDER BY customer_id, totals DESC