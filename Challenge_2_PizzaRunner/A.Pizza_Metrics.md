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



#### Question #3

How many successful orders were delivered by each runner?

#### Question #4

How many of each type of pizza was delivered?

#### Question #5

How many Vegetarian and Meatlovers were ordered by each customer?

#### Question #6

What was the maximum number of pizzas delivered in a single order?

#### Question #7

For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

#### Question #8

How many pizzas were delivered that had both exclusions and extras?

#### Question #9

What was the total volume of pizzas ordered for each hour of the day?

#### Question #10

What was the volume of orders for each day of the week?
