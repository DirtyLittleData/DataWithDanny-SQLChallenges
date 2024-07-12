-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

WITH purchase_count_table AS(
	SELECT 
    	s.product_id,
    	m.product_name,
    	COUNT(*) as purchase_count
	FROM sales s
	JOIN menu m ON m.product_id = s.product_id
	GROUP BY s.product_id, m.product_name
)
SELECT
	product_name,
    purchase_count
    FROM (
    SELECT 
        *,
        DENSE_RANK() OVER (ORDER BY purchase_count DESC) AS dr
    FROM purchase_count_table
) ranked_table
WHERE dr = 1
ORDER BY purchase_count DESC

-- In rank, if there's a tie, it will create a gap in the ranking
-- In dense rank, each rank, no matter how many items are in each place will be sequential