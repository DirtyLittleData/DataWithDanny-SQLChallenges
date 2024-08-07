**D. Pricing and Ratings**

***1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?***
---

This question is pretty straightforward; we'll use a CASE / WHEN statement to create a population of the column and a column name. We then used the created table as a Common Table Expression (CTE). We then SUM the total and CONCAT a $ sign for the result.

```sql
    WITH price_CTE AS
    (SELECT
        p.pizza_name,
        SUM(CASE   
            WHEN c.pizza_id = 1 THEN 12
            WHEN c.pizza_id = 2 THEN 10
            ELSE 0
        END) AS price
    FROM customer_orders c
    JOIN pizza_names p ON p.pizza_id = c.pizza_id
    GROUP BY p.pizza_name
    ORDER BY MIN(c.order_id))
    
    SELECT 
    	CONCAT('$', SUM(price)) AS total_pizza_money
    FROM price_CTE;
```

| total_pizza_money |
| ----------------- |
| $160              |

---

***2. What if there was an additional $1 charge for any pizza extras?***

-Add cheese is $1 extra

***3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.***

***4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?***

-customer_id

-order_id

-runner_id

-rating

-order_time

-pickup_time

-Time between order and pickup

-Delivery duration

-Average speed

-Total number of pizzas

***5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?***
