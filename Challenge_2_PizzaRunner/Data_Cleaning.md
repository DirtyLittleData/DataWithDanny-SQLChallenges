In the data cleaning process, we used UPDATE rather than ALTER. 
```
{
UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

ALTER TABLE pizza_runner.customer_orders
ADD COLUMN delivery_time TIMESTAMP;
}
```

Characteristics of Temporary Tables:
- Lifetime: They exist only for the duration of a session or transaction. Once the session ends, the temporary table is automatically dropped.
- Scope: They are only visible to the session or transaction that created them.
- Use Cases: Useful for storing intermediate results, performing complex joins or aggregations, and simplifying complex queries.

## Customer_Orders
First let's do a search to identify colums with NULLs or empty fields.

- Shifra's Note-: 

- Jonny's Note-: I also enjoyed learning about the BEGIN to COMMIT capability to run commands sequentially. It seems like a safe way to write SQL.

BEGIN;

UPDATE pizza_runner.customer_orders
SET exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

SELECT *
FROM pizza_runner.customer_orders
WHERE exclusions IS NULL OR extras IS NULL;

COMMIT;

Run each TABLE