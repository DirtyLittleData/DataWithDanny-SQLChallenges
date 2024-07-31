C. Ingredient Optimisation
1. What are the standard ingredients for each pizza?

**Temp Table**
```sql
    CREATE TEMP TABLE IF NOT EXISTS temp_pizza_recipe AS (
        SELECT 
      		pizza_id,
            UNNEST(STRING_TO_ARRAY(r.toppings, ','))::INT AS topping_id
        FROM pizza_recipes r
    );
```

**Query**
```sql
    SELECT 
    	r.pizza_id,
        n.pizza_name,
        t.topping_name
    FROM temp_pizza_recipe r
    JOIN pizza_toppings t ON r.topping_id = t.topping_id
    JOIN pizza_names n ON n.pizza_id = r.pizza_id;
```

| pizza_id | pizza_name | topping_name |
| -------- | ---------- | ------------ |
| 1        | Meatlovers | BBQ Sauce    |
| 1        | Meatlovers | Pepperoni    |
| 1        | Meatlovers | Cheese       |
| 1        | Meatlovers | Salami       |
| 1        | Meatlovers | Chicken      |
| 1        | Meatlovers | Bacon        |
| 1        | Meatlovers | Mushrooms    |
| 1        | Meatlovers | Beef         |
| 2        | Vegetarian | Tomato Sauce |
| 2        | Vegetarian | Cheese       |
| 2        | Vegetarian | Mushrooms    |
| 2        | Vegetarian | Onions       |
| 2        | Vegetarian | Peppers      |
| 2        | Vegetarian | Tomatoes     |

---

2. What was the most commonly added extra?

---
**Solution**
```sql
    SELECT 
    	t.extra, 
        COUNT(*) as count,
        p.topping_name
    FROM temp_unnested_orders t
    JOIN pizza_toppings p ON p.topping_id = t.extra 
    WHERE extra IS NOT NULL
    GROUP BY 1, 3
    ORDER BY count DESC
    LIMIT 1;
```

| extra | count | topping_name |
| ----- | ----- | ------------ |
| 1     | 5     | Bacon        |

---

3. What was the most common exclusion?

---

**Solution 1**

```sql
    SELECT
        p.topping_name,
        COUNT(extra) AS extras_count
      FROM temp_unnested_orders t
      JOIN pizza_toppings p ON p.topping_id = t.extra
      GROUP BY t.extra, p.topping_name
      LIMIT 1;
```

| topping_name | extras_count |
| ------------ | ------------ |
| Bacon        | 5            |
---

**Solution 2**

```sql
    WITH ranked_extras AS (
      SELECT
        t.extra,
        COUNT(*) AS extras_count,
        p.topping_name,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
      FROM temp_unnested_orders t
      JOIN pizza_toppings p ON p.topping_id = t.extra
      WHERE t.extra IS NOT NULL
      GROUP BY t.extra, p.topping_name
    )
    SELECT
    	topping_name,
        extras_count
    FROM ranked_extras
    WHERE rank = 1
    ORDER BY extras_count DESC, topping_name;
```

| topping_name | extras_count |
| ------------ | ------------ |
| Bacon        | 5            |
---

4. Generate an order item for each record in the customers_orders table in the format of one of the following:
    Meat Lovers
    Meat Lovers - Exclude Beef
    Meat Lovers - Extra Bacon
    Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

******
**Query**

    WITH order_details AS (
        SELECT 
            o.order_id,
            o.pizza_id,
            n.pizza_name,
            STRING_AGG(DISTINCT t_ex.topping_name, ', ') AS exclusions,
            STRING_AGG(DISTINCT t_ex2.topping_name, ', ') AS extras
        FROM temp_unnested_orders o
        JOIN pizza_names n ON n.pizza_id = o.pizza_id
        LEFT JOIN pizza_toppings t_ex ON t_ex.topping_id = o.exclusion
        LEFT JOIN pizza_toppings t_ex2 ON t_ex2.topping_id = o.extra
        GROUP BY o.order_id, o.pizza_id, n.pizza_name
    )
    SELECT 
        order_id,
        CASE 
            WHEN exclusions IS NULL AND extras IS NULL THEN pizza_name
            WHEN exclusions IS NOT NULL AND extras IS NULL THEN pizza_name || ' - Exclude ' || exclusions
            WHEN exclusions IS NULL AND extras IS NOT NULL THEN pizza_name || ' - Extra ' || extras
            ELSE pizza_name || ' - Exclude ' || exclusions || ' - Extra ' || extras
        END AS order_item
    FROM order_details
    ORDER BY order_id;

| order_id | order_item                                                      |
| -------- | --------------------------------------------------------------- |
| 1        | Meatlovers                                                      |
| 2        | Meatlovers                                                      |
| 3        | Meatlovers                                                      |
| 3        | Vegetarian                                                      |
| 4        | Meatlovers - Exclude Cheese                                     |
| 4        | Vegetarian - Exclude Cheese                                     |
| 5        | Meatlovers - Extra Bacon                                        |
| 6        | Vegetarian                                                      |
| 7        | Vegetarian - Extra Bacon                                        |
| 8        | Meatlovers                                                      |
| 9        | Meatlovers - Exclude Cheese - Extra Bacon, Chicken              |
| 10       | Meatlovers - Exclude BBQ Sauce, Mushrooms - Extra Bacon, Cheese |

---

--this code will be update by jonny and shifra 

*******


   
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
    For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
