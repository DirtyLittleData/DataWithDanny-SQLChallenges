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