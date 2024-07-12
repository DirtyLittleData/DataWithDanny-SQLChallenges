WITH first_order_from_date AS 
(
    SELECT customer_id, MIN(order_date) as first_order_date
    FROM sales
    GROUP BY customer_id
)
SELECT 
    s.customer_id,
    s.order_date,
    s.product_id,
    m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id

JOIN first_order_from_date fod ON s.customer_id = fod.customer_id 
                           AND s.order_date = fod.first_order_date
ORDER BY s.customer_id, s.product_id

-- #Dense rank solution
-- WITH ranked_orders AS (
--     SELECT 
--         s.customer_id,
--         s.order_date,
--         s.product_id,
--         m.product_name,
--         DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) as order_rank
--     FROM sales s
--     JOIN menu m ON s.product_id = m.product_id
-- )
-- SELECT 
--     customer_id,
--     order_date,
--     product_id,
--     product_name
-- FROM ranked_orders
-- WHERE order_rank = 1
-- ORDER BY 1, 3