#STEP 1

In the data cleaning process, you need to start by looking at your data (or knowing it at a business). 

We used SELECT * FROM customer_id to look at the data.

![image](https://github.com/user-attachments/assets/ebacaaf7-b879-45a6-ae2d-2cfcce96d2cc)

We notice from the output that the "Exclusions" and "Extras" columns contain empty fields.

We then decided to use UPDATE rather than ALTER.

```
{
UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');
}

{
ALTER TABLE pizza_runner.customer_orders
ADD COLUMN delivery_time TIMESTAMP;
}
```

## Benefits of UPDATE TABLE:
*Good for* exists only for the duration of one session. One-time use, intermediate results
*Bad for* data integrity, security

## Benefits of ALTER TABLE:
*Good for* editing a schema permanently when necessary to reuse data
*Bad for* audit trails

Given the initial research, "figure out if it works with a temporary table, and then make a new table for the work." It would be best to work with newly created tables. 

# Customer_Orders
From the schema, it looks like missing values are issue with this table. Let's do a search to identify colums with NULLs or empty fields with UPDATE and then proceed to create a newly cleaned table.

- Jonny's Note: I also enjoyed learning about the BEGIN to COMMIT capability to run commands sequentially. It seems like a safe way to write SQL.

When a column field contains multiple values separated by commas it's called a denormalized structure.

```
BEGIN;

UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

SELECT *
FROM pizza_runner.customer_orders
WHERE exclusions IS NULL OR extras IS NULL;


COMMIT;
```

```
CREATE TABLE pizza_runner.cleaned_customer_orders AS
SELECT * FROM pizza_runner.customer_orders WHERE 1=0;

BEGIN;

UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

INSERT INTO pizza_runner.cleaned_customer_orders
SELECT * FROM pizza_runner.customer_orders;

COMMIT;

SELECT *
FROM pizza_runner.cleaned_customer_orders
WHERE exclusions IS NULL OR extras IS NULL;
```


# Runner_Orders
