-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

-- Question 9 Part 1
SELECT
  	s.customer_id,
 	m.product_name,
  	m.price
FROM sales s
JOIN menu m on s.product_id = m.product_id

-- Question 9 Part 2
SELECT
  	s.customer_id,
 	m.product_name,
  	m.price,
    CASE WHEN m.product_name = 'sushi' THEN m.price * 20 ELSE m.price * 10 END AS points
FROM sales s
JOIN menu m on s.product_id = m.product_id
ORDER BY 1, 2


-- Question 9 Part 3
WITH point_CTE AS (
SELECT
  	s.customer_id,
 	m.product_name,
  	m.price,
    CASE WHEN m.product_name = 'sushi' THEN m.price * 20 ELSE m.price * 10 END AS points
FROM sales s
JOIN menu m on s.product_id = m.product_id
ORDER BY 1, 2
)

SELECT
	customer_id,
    SUM(points)
FROM point_CTE
GROUP BY customer_id

-- Question 9 Part 4, Solution
WITH point_CTE AS (
SELECT
  	s.customer_id,
 	m.product_name,
  	m.price,
    CASE WHEN m.product_name = 'sushi' THEN m.price * 20 ELSE m.price * 10 END AS points
FROM sales s
JOIN menu m on s.product_id = m.product_id
ORDER BY 1, 2
)

SELECT
	point_CTE.customer_id,
    SUM(points)
FROM point_CTE
	JOIN members mem ON point_CTE.customer_id = mem.customer_id
GROUP BY point_CTE.customer_id

