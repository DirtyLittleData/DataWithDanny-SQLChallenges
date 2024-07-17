-- Inserts NULL values into empty fields
SELECT * FROM runners;
BEGIN;

UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

SELECT *
FROM pizza_runner.customer_orders
WHERE exclusions IS NULL OR extras IS NULL;

COMMIT;


-- Removes text from columns that need to be numeric, adds NULL to empty fields
CREATE TEMPORARY TABLE temp_runner_orders AS
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

-- View the cleaned data
SELECT * FROM temp_runner_orders;


-- No data cleaning needed
SELECT * FROM pizza_names;


-- Unnests fields with numeric values which are separated by commas
CREATE TEMP TABLE split_toppings AS
SELECT 
    pizza_id,
    unnest(string_to_array(toppings, ', '))::integer AS topping_id
FROM pizza_recipes;

SELECT * FROM split_toppings;


-- No data cleaning needed
SELECT * FROM pizza_toppings;


-- Lovely code solution for separating fields with multiple numeric values separated by commas into rows and NULLIF
CREATE TEMP TABLE temp_order_ex AS
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