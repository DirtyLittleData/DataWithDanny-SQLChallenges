-- 7. Which item was purchased just before the customer became a member?

WITH ranked_order_date AS ( 
SELECT 
	s.customer_id,
    s.order_date,
    m.product_name,
    mem.join_date,
    DENSE_RANK() OVER (
      	PARTITION BY s.customer_id
      	ORDER BY s.order_date DESC) first_pre_member_order 
FROM sales s
	JOIN menu m ON s.product_id = m.product_id
    JOIN members mem ON s.customer_id = mem.customer_id
WHERE order_date < join_date
)
SELECT TO_CHAR
-- NOTE THIS LATER FOR DATE SOLUTION OUTPUT
FROM ranked_order_date
WHERE first_pre_member_order = 1