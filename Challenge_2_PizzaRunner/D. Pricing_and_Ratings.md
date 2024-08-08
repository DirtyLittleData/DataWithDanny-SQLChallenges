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

Assuming this means every entry of a number in the field of "extras" means a dollar extra.

***3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.***

In order to future-proof this query, we decided to use columns from the original dataset and create a new table for which we can generate random values of ratings.

The "random()" function will generate a random value between 0 and 1. The second number in the syntax indicates the range and the + 1 iterates the values for variation. The function "floor()" rounds down to the nearest integer, giving us values 1, 2, 3, 4, or 5.

---
**Query #1**

```sql
    CREATE TABLE runner_rating AS
    SELECT 
        order_id,
        runner_id,
        floor(random() * 5 + 1)::INTEGER AS rating
    FROM runner_orders;
```

---

**Query #2**

```sql
    ALTER TABLE runner_rating
    ADD CONSTRAINT rating_check CHECK (rating BETWEEN 1 AND 5);
```
---
**Query #3**

```sql
    SELECT *
    FROM runner_rating;
```

| order_id | runner_id | rating |
| -------- | --------- | ------ |
| 1        | 1         | 4      |
| 2        | 1         | 1      |
| 3        | 1         | 5      |
| 4        | 2         | 4      |
| 5        | 3         | 5      |
| 6        | 3         | 4      |
| 7        | 2         | 5      |
| 8        | 2         | 1      |
| 9        | 2         | 1      |
| 10       | 1         | 5      |

---

***4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?***

-customer_id
-order_id
-runner_id
-rating
-order_time
-pickup_time
-time between order and pickup
-delivery duration
-average speed
-total number of pizzas

We don't have time for reflection. We can't even ask Claudina what they would have given.

---
**Cleaned Customer Orders Creation**
```sql
    CREATE TEMP TABLE IF NOT EXISTS cleaned_customer_orders AS
    SELECT
    	order_id,
        customer_id,
        pizza_id,
        order_time,
        ROW_NUMBER()OVER() AS unique_id,
        CASE
        	WHEN exclusions IS NULL OR exclusions = 'null' OR exclusions = '' THEN NULL
        	ELSE exclusions
        END AS cleaned_exclusions,
        CASE
        	WHEN extras IS NULL OR extras = 'null' OR extras = '' THEN NULL
        	ELSE extras
        END AS cleaned_extras    
    FROM customer_orders;
```
---
**Cleaned Customer Orders**

| order_id | customer_id | pizza_id | order_time               | unique_id | cleaned_exclusions | cleaned_extras |
| -------- | ----------- | -------- | ------------------------ | --------- | ------------------ | -------------- |
| 1        | 101         | 1        | 2020-01-01T18:05:02.000Z | 1         |                    |                |
| 2        | 101         | 1        | 2020-01-01T19:00:52.000Z | 2         |                    |                |
| 3        | 102         | 1        | 2020-01-02T23:51:23.000Z | 3         |                    |                |
| 3        | 102         | 2        | 2020-01-02T23:51:23.000Z | 4         |                    |                |
| 4        | 103         | 1        | 2020-01-04T13:23:46.000Z | 5         | 4                  |                |
| 4        | 103         | 1        | 2020-01-04T13:23:46.000Z | 6         | 4                  |                |
| 4        | 103         | 2        | 2020-01-04T13:23:46.000Z | 7         | 4                  |                |
| 5        | 104         | 1        | 2020-01-08T21:00:29.000Z | 8         |                    | 1              |
| 6        | 101         | 2        | 2020-01-08T21:03:13.000Z | 9         |                    |                |
| 7        | 105         | 2        | 2020-01-08T21:20:29.000Z | 10        |                    | 1              |
| 8        | 102         | 1        | 2020-01-09T23:54:33.000Z | 11        |                    |                |
| 9        | 103         | 1        | 2020-01-10T11:22:59.000Z | 12        | 4                  | 1, 5           |
| 10       | 104         | 1        | 2020-01-11T18:34:49.000Z | 13        |                    |                |
| 10       | 104         | 1        | 2020-01-11T18:34:49.000Z | 14        | 2, 6               | 1, 4           |

---
**Runner Rating Creation**

    CREATE TABLE runner_rating AS
        SELECT 
            order_id,
            runner_id,
            floor(random() * 5 + 1)::INTEGER AS rating
        FROM runner_orders;

    ALTER TABLE runner_rating
        ADD CONSTRAINT rating_check CHECK (rating BETWEEN 1 AND 5);

---
**Runner Rating**

| order_id | runner_id | rating |
| -------- | --------- | ------ |
| 1        | 1         | 1      |
| 2        | 1         | 4      |
| 3        | 1         | 5      |
| 4        | 2         | 5      |
| 5        | 3         | 4      |
| 6        | 3         | 3      |
| 7        | 2         | 2      |
| 8        | 2         | 1      |
| 9        | 2         | 3      |
| 10       | 1         | 2      |

---
**Cleaned Runners Orders Creation**
```sql
    CREATE TEMP TABLE IF NOT EXISTS cleaned_runners_orders AS
        SELECT
            order_id,
            runner_id,
            CASE
    			WHEN pickup_time IS NOT NULL AND (pickup_time != 'null' AND pickup_time != '') THEN TO_TIMESTAMP(pickup_time, 'YYYY-MM-DD HH24:MI:SS') 
                ELSE NULL
            END AS cleaned_pickup_time,
            CASE
                WHEN distance = 'null' OR distance = '' THEN NULL
                ELSE CAST(REGEXP_REPLACE(distance, '[^0-9.]', '', 'g') AS NUMERIC)
            END AS distance_km,
            CASE
                WHEN duration = 'null' OR duration = '' THEN NULL
                ELSE CAST(REGEXP_REPLACE(duration, '[^0-9.]', '', 'g') AS NUMERIC)
            END AS duration_min,
            CASE
                WHEN cancellation IS NULL OR cancellation = 'null' OR cancellation = '' THEN 'No'
                ELSE 'Yes'
            END AS is_cancelled
        FROM runner_orders;
```

---
**Cleaned Runners Orders**

| order_id | runner_id | cleaned_pickup_time      | distance_km | duration_min | is_cancelled |
| -------- | --------- | ------------------------ | ----------- | ------------ | ------------ |
| 1        | 1         | 2020-01-01T18:15:34.000Z | 20          | 32           | No           |
| 2        | 1         | 2020-01-01T19:10:54.000Z | 20          | 27           | No           |
| 3        | 1         | 2020-01-03T00:12:37.000Z | 13.4        | 20           | No           |
| 4        | 2         | 2020-01-04T13:53:03.000Z | 23.4        | 40           | No           |
| 5        | 3         | 2020-01-08T21:10:57.000Z | 10          | 15           | No           |
| 6        | 3         |                          |             |              | Yes          |
| 7        | 2         | 2020-01-08T21:30:45.000Z | 25          | 25           | No           |
| 8        | 2         | 2020-01-10T00:15:02.000Z | 23.4        | 15           | No           |
| 9        | 2         |                          |             |              | Yes          |
| 10       | 1         | 2020-01-11T18:50:20.000Z | 10          | 10           | No           |

---
**Solution**

```sql
    SELECT
    	c.customer_id,
        c.order_id,
        r.runner_id,
        rr.rating,
        c.order_time,
        r.cleaned_pickup_time,
        r.cleaned_pickup_time - c.order_time AS time_between_order_and_pickup,
        r.duration_min,
        ROUND(AVG(duration_min) OVER(), 0) AS average_duration,
        COUNT(c.order_id) OVER() AS succesful_pizzas
    FROM cleaned_customer_orders c
    LEFT JOIN cleaned_runners_orders r ON c.order_id = r.order_id
    LEFT JOIN runner_rating rr ON c.order_id = rr.order_id
    WHERE r.cleaned_pickup_time IS NOT NULL;
```

| customer_id | order_id | runner_id | rating | order_time               | cleaned_pickup_time      | time_between_order_and_pickup | duration_min | average_duration | succesful_pizzas |
| ----------- | -------- | --------- | ------ | ------------------------ | ------------------------ | ----------------------------- | ------------ | ---------------- | ---------------- |
| 101         | 1        | 1         | 1      | 2020-01-01T18:05:02.000Z | 2020-01-01T18:15:34.000Z | [object Object]               | 32           | 25               | 12               |
| 101         | 2        | 1         | 4      | 2020-01-01T19:00:52.000Z | 2020-01-01T19:10:54.000Z | [object Object]               | 27           | 25               | 12               |
| 102         | 3        | 1         | 5      | 2020-01-02T23:51:23.000Z | 2020-01-03T00:12:37.000Z | [object Object]               | 20           | 25               | 12               |
| 102         | 3        | 1         | 5      | 2020-01-02T23:51:23.000Z | 2020-01-03T00:12:37.000Z | [object Object]               | 20           | 25               | 12               |
| 103         | 4        | 2         | 5      | 2020-01-04T13:23:46.000Z | 2020-01-04T13:53:03.000Z | [object Object]               | 40           | 25               | 12               |
| 103         | 4        | 2         | 5      | 2020-01-04T13:23:46.000Z | 2020-01-04T13:53:03.000Z | [object Object]               | 40           | 25               | 12               |
| 103         | 4        | 2         | 5      | 2020-01-04T13:23:46.000Z | 2020-01-04T13:53:03.000Z | [object Object]               | 40           | 25               | 12               |
| 104         | 5        | 3         | 4      | 2020-01-08T21:00:29.000Z | 2020-01-08T21:10:57.000Z | [object Object]               | 15           | 25               | 12               |
| 105         | 7        | 2         | 2      | 2020-01-08T21:20:29.000Z | 2020-01-08T21:30:45.000Z | [object Object]               | 25           | 25               | 12               |
| 102         | 8        | 2         | 1      | 2020-01-09T23:54:33.000Z | 2020-01-10T00:15:02.000Z | [object Object]               | 15           | 25               | 12               |
| 104         | 10       | 1         | 2      | 2020-01-11T18:34:49.000Z | 2020-01-11T18:50:20.000Z | [object Object]               | 10           | 25               | 12               |
| 104         | 10       | 1         | 2      | 2020-01-11T18:34:49.000Z | 2020-01-11T18:50:20.000Z | [object Object]               | 10           | 25               | 12               |

---


***5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?***
