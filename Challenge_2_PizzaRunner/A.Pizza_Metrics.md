**Schema (PostgreSQL v13)**

---
#### Question #1
How many pizzas were ordered?

'''sql
    SELECT 
        COUNT(order_id)
    FROM Customer_orders;
'''

#### Solution:
| count |
| ----- |
| 14    |
---

#### Question #2

How many unique customer orders were made?

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
