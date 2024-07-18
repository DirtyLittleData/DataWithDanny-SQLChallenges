**Schema (PostgreSQL v13)**

---
#### Question #1
How many pizzas were ordered?

```sql
    SELECT 
        COUNT(order_id)
    FROM Customer_orders;
```

#### Solution:
| count |
| ----- |
| 14    |
---

#### Question #2

How many unique customer orders were made?

*If the question is "order IDs", the answer is 10 .

```sql
SELECT
    COUNT(DISTINCT(order_id)) AS count_order_id
FROM customer_orders;
```
| count_order_id |
| -------------- |
| 10             |
---

#### Question #3

*If the question is asking how many unique orders based on the content of the order (unique combinations of pizza_id, extra, and exclusions) then the answer is 8.

```sql
SELECT 
	COUNT(DISTINCT CONCAT(pizza_id, '-', exclusions, '-', extras)) AS count_order_id
FROM customer_orders;
```

| count_order_id |
| -------------- |
| 8              |
---

#### Question #4

How many successful orders were delivered by each runner?

```sql
SELECT 
    COUNT(CASE 
          WHEN cancellation IS NULL THEN 1
          END)
FROM temp_runner_orders;
```

| pizza_id | count_pizza_id |
| -------- | -------------- |
| 1        | 9              |
| 2        | 3              |
---

#### Question #5

How many Vegetarian and Meatlovers were ordered by each customer?

```sql
SELECT 
	customer_id,
    c.pizza_id,
    p.pizza_name,
	COUNT(c.pizza_id) AS count_pizza_id 
FROM customer_orders c
JOIN temp_runner_orders r ON r.order_id = c.order_id
JOIN pizza_names p ON p.pizza_id = c.pizza_id
WHERE cancellation IS NULL
GROUP BY c.pizza_id, p.pizza_name, customer_id
ORDER BY customer_id, c.pizza_id
```

| customer_id | pizza_id | pizza_name | count_pizza_id |
| ----------- | -------- | ---------- | -------------- |
| 101         | 1        | Meatlovers | 2              |
| 102         | 1        | Meatlovers | 2              |
| 102         | 2        | Vegetarian | 1              |
| 103         | 1        | Meatlovers | 2              |
| 103         | 2        | Vegetarian | 1              |
| 104         | 1        | Meatlovers | 3              |
| 105         | 2        | Vegetarian | 1              |
---

#### Question #6

What was the maximum number of pizzas delivered in a single order?

*One way to solve this is by joining the appropriate tables, filtering with a WHERE statement to avoid counting canceled orders, and using the GROUP BY, ORDER BY, and LIMIT commands to yield the right result.

```sql
SELECT 
	c.order_id,
    COUNT(pizza_id) AS pizzas_per_order
FROM customer_orders c
JOIN temp_runner_orders r ON r.order_id = c.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizzas_per_order DESC 
LIMIT 1
```

| order_id | pizzas_per_order |
| -------- | ---------------- |
| 4        | 3                |
---

*Note: As an alternative to using LIMIT, we can create a CTE that includes the COUNT of pizzas_per_order in DESC order and query that new CTE to get the MAX of the new column COUNT of pizzas_per_order. 

```sql
WITH test_CTE AS(
SELECT 
	c.order_id,
    COUNT(pizza_id) AS pizzas_per_order
FROM customer_orders c
JOIN temp_runner_orders r ON r.order_id = c.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizzas_per_order DESC 
)

SELECT 
	MAX(pizzas_per_order) AS most_pizzas_single_order
FROM test_CTE
```

| most_pizzas_single_order |
| ------------------------ |
| 3                        |
---

#### Question #7

For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

#### Question #8

How many pizzas were delivered that had both exclusions and extras?

#### Question #9

What was the total volume of pizzas ordered for each hour of the day?

#### Question #10

What was the volume of orders for each day of the week?
