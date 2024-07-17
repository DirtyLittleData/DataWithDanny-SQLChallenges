# Data Cleaning Process

Look at the schema.

```sql
CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
```


In the data cleaning process, you need to start by looking at your data (or knowing it at a business). 

We used SELECT * FROM customer_id to look at the data.

![image](https://github.com/user-attachments/assets/ebacaaf7-b879-45a6-ae2d-2cfcce96d2cc)

We notice from the output that the "Exclusions" and "Extras" columns contain empty fields, null values, and comma-separated values which indicate a denormalized structure.

We then decided to use UPDATE rather than ALTER.

```sql

UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

ALTER TABLE pizza_runner.customer_orders
ADD COLUMN delivery_time TIMESTAMP;
```

## Benefits of UPDATE TABLE:
*Good for* exists only for the duration of one session. One-time use, intermediate results

*Bad for* data integrity, security

## Benefits of ALTER TABLE:
*Good for* editing a schema permanently when necessary to reuse data

*Bad for* audit trails

Given the initial research, "figure out if it works with a temporary table, and then make a new table for the work." It would be best to work with newly created tables. 

We decided to use different methods to experiment, and cleaned the data as you will find in the [0_Data_Clean.sql](https://github.com/BreakingPlaid/DataWithDanny-SQLChallenges/blob/main/Challenge_2_PizzaRunner/0_Data_Clean.sql).


# Cleaned Tables

**Table #1**

    SELECT * FROM runners;

| runner_id | registration_date        |
| --------- | ------------------------ |
| 1         | 2021-01-01T00:00:00.000Z |
| 2         | 2021-01-03T00:00:00.000Z |
| 3         | 2021-01-08T00:00:00.000Z |
| 4         | 2021-01-15T00:00:00.000Z |


**Table #2**

    UPDATE pizza_runner.customer_orders
    SET exclusions = NULLIF(exclusions, ''),
        extras = NULLIF(extras, '');

    SELECT *
    FROM pizza_runner.customer_orders
    WHERE exclusions IS NULL OR extras IS NULL;

| order_id | customer_id | pizza_id | exclusions | extras | order_time               |
| -------- | ----------- | -------- | ---------- | ------ | ------------------------ |
| 1        | 101         | 1        |            |        | 2020-01-01T18:05:02.000Z |
| 2        | 101         | 1        |            |        | 2020-01-01T19:00:52.000Z |
| 3        | 102         | 1        |            |        | 2020-01-02T23:51:23.000Z |
| 3        | 102         | 2        |            |        | 2020-01-02T23:51:23.000Z |
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 2        | 4          |        | 2020-01-04T13:23:46.000Z |


**Table #3**

    CREATE TEMPORARY TABLE temp_runner_orders AS
    SELECT * FROM runner_orders;

    UPDATE temp_runner_orders
    SET 
        pickup_time = NULLIF(NULLIF(pickup_time, ''), 'null'),
        distance = CASE 
            WHEN distance = 'null' THEN NULL
            ELSE (REGEXP_REPLACE(COALESCE(distance, '0'), '[^0-9.]', '', 'g'))::FLOAT
        END,
        duration = CASE 
            WHEN duration = 'null' THEN NULL
            ELSE (REGEXP_REPLACE(COALESCE(duration, '0'), '[^0-9]', '', 'g'))::INTEGER
        END,
        cancellation = NULLIF(NULLIF(cancellation, ''), 'null');

    SELECT * FROM temp_runner_orders;

| order_id | runner_id | pickup_time         | distance | duration | cancellation            |
| -------- | --------- | ------------------- | -------- | -------- | ----------------------- |
| 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                         |
| 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                         |
| 3        | 1         | 2020-01-03 00:12:37 | 13.4     | 20       |                         |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                         |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                         |
| 6        | 3         |                     |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                         |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                         |
| 9        | 2         |                     |          |          | Customer Cancellation   |
| 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                         |


**Table #4**

    SELECT * FROM pizza_names;

| pizza_id | pizza_name |
| -------- | ---------- |
| 1        | Meatlovers |
| 2        | Vegetarian |


**Table #5**

    CREATE TEMP TABLE split_toppings AS
    SELECT 
        pizza_id,
        unnest(string_to_array(toppings, ', '))::integer AS topping_id
    FROM pizza_recipes;

    SELECT * FROM split_toppings;

---

| pizza_id | topping_id |
| -------- | ---------- |
| 1        | 1          |
| 1        | 2          |
| 1        | 3          |
| 1        | 4          |
| 1        | 5          |
| 1        | 6          |
| 1        | 8          |
| 1        | 10         |
| 2        | 4          |
| 2        | 6          |
| 2        | 7          |
| 2        | 9          |
| 2        | 11         |
| 2        | 12         |


**Table #6**

    SELECT * FROM pizza_toppings;

---

| topping_id | topping_name |
| ---------- | ------------ |
| 1          | Bacon        |
| 2          | BBQ Sauce    |
| 3          | Beef         |
| 4          | Cheese       |
| 5          | Chicken      |
| 6          | Mushrooms    |
| 7          | Onions       |
| 8          | Pepperoni    |
| 9          | Peppers      |
| 10         | Salami       |
| 11         | Tomatoes     |
| 12         | Tomato Sauce |


**Table #7**

    CREATE TEMP TABLE temp_order_ex AS
    SELECT
        order_id,
        customer_id,
        pizza_id,
        UNNEST(STRING_TO_ARRAY(NULLIF(exclusions, ''), ',')) AS exclusion,
        UNNEST(STRING_TO_ARRAY(NULLIF(extras, ''), ',')) AS extra,
        order_time
    FROM customer_orders;

---

    SELECT
        *
    FROM temp_order_ex;

| order_id | customer_id | pizza_id | exclusion | extra | order_time               |
| -------- | ----------- | -------- | --------- | ----- | ------------------------ |
| 4        | 103         | 1        | 4         |       | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 1        | 4         |       | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 2        | 4         |       | 2020-01-04T13:23:46.000Z |
| 5        | 104         | 1        | null      | 1     | 2020-01-08T21:00:29.000Z |
| 6        | 101         | 2        | null      | null  | 2020-01-08T21:03:13.000Z |
| 7        | 105         | 2        | null      | 1     | 2020-01-08T21:20:29.000Z |
| 8        | 102         | 1        | null      | null  | 2020-01-09T23:54:33.000Z |
| 9        | 103         | 1        | 4         | 1     | 2020-01-10T11:22:59.000Z |
| 9        | 103         | 1        |           |  5    | 2020-01-10T11:22:59.000Z |
| 10       | 104         | 1        | null      | null  | 2020-01-11T18:34:49.000Z |
| 10       | 104         | 1        | 2         | 1     | 2020-01-11T18:34:49.000Z |
| 10       | 104         | 1        |  6        |  4    | 2020-01-11T18:34:49.000Z |

[View on DB Fiddle](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65)
