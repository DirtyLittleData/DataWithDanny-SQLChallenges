-- Copy and paste this into schema to update when working on Fiddle

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

-- Updates CUSTOMER ORDER table. Inserts NULL values into empty fields
UPDATE customer_orders
SET 
    exclusions = CASE 
        WHEN exclusions = '' THEN NULL 
        WHEN LOWER(exclusions) = 'null' THEN NULL 
        ELSE exclusions 
    END,
    extras = CASE 
        WHEN extras = '' THEN NULL 
        WHEN LOWER(extras) = 'null' THEN NULL 
        ELSE extras 
    END;

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

  -- Removes text from columns that need to be numeric, adds NULL to empty fields
CREATE TABLE temp_runner_orders AS
SELECT * FROM runner_orders;

-- Update the temporary table
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

  -- Unnests fields with numeric values which are separated by commas
CREATE TABLE split_toppings AS
SELECT 
    pizza_id,
    unnest(string_to_array(toppings, ', '))::integer AS topping_id
FROM pizza_recipes;

SELECT * FROM split_toppings;


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

  -- Lovely code solution for separating fields with multiple numeric values separated by commas into rows and NULLIF
CREATE TABLE temp_order_ex AS
SELECT
    order_id,
    customer_id,
    pizza_id,
    UNNEST(STRING_TO_ARRAY(NULLIF(exclusions, ''), ',')) AS exclusion,
    UNNEST(STRING_TO_ARRAY(NULLIF(extras, ''), ',')) AS extra,
    order_time
FROM customer_orders;

SELECT
    *
FROM temp_order_ex;





CREATE TEMPORARY TABLE temp_cleaned_orders AS
SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE 
        WHEN exclusions = '' OR LOWER(exclusions) = 'null' THEN NULL 
        ELSE exclusions 
    END AS exclusions,
    CASE 
        WHEN extras = '' OR LOWER(extras) = 'null' OR extras IS NULL THEN NULL 
        ELSE extras 
    END AS extras,
    order_time
FROM customer_orders;

-- Unnest the exclusions and extras
CREATE TABLE temp_unnested_orders AS
SELECT
    order_id,
    customer_id,
    pizza_id,
    NULLIF(trim(e.exclusion), '')::INTEGER AS exclusion,
    NULLIF(trim(x.extra), '')::INTEGER AS extra,
    order_time
FROM temp_cleaned_orders
LEFT JOIN LATERAL unnest(string_to_array(exclusions, ',')) AS e(exclusion) ON true
LEFT JOIN LATERAL unnest(string_to_array(extras, ',')) AS x(extra) ON true;

-- View the result
-- SELECT * FROM temp_unnested_orders ORDER BY order_id, customer_id, pizza_id;

-- SELECT * FROM temp_cleaned_orders


--new cleaning and joining of cusotmer order table
drop table if exists order_names_cleaned;

create temp TABLE order_names_cleaned 
as

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
