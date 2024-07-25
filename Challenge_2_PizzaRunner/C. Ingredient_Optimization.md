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
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
    Meat Lovers
    Meat Lovers - Exclude Beef
    Meat Lovers - Extra Bacon
    Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
    For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
