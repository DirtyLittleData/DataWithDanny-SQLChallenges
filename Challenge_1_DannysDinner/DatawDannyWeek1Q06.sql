WITH ranked_order_date AS ( 
SELECT 
	s.customer_id,
    s.order_date,
    m.product_name,
    mem.join_date,
    DENSE_RANK() OVER (
      	PARTITION BY s.customer_id
      	ORDER BY s.order_date) first_member_order 
FROM sales s
	JOIN menu m ON s.product_id = m.product_id
    JOIN members mem ON s.customer_id = mem.customer_id
WHERE order_date >= join_date
)
SELECT *
FROM ranked_order_date
WHERE first_member_order = 1

-- -- Solution provided for traditional SQL query
-- SELECT 
--     s.customer_id,
--     s.order_date,
--     m.product_name
-- FROM sales s
-- JOIN menu m ON s.product_id = m.product_id
-- JOIN members mem ON s.customer_id = mem.customer_id
-- WHERE s.order_date >= mem.join_date
-- AND s.order_date = (
--     SELECT MIN(s2.order_date)
--     FROM sales s2
--     WHERE s2.customer_id = s.customer_id
--     AND s2.order_date >= mem.join_date
-- )
-- ORDER BY s.customer_id, s.order_date