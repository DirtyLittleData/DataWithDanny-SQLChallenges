## C. Challenge Payment Question
The Foodie-Fi team wants you to create a new **payments** table for the year 2020 that includes amounts paid by each customer in the **subscriptions** table with the following requirements:

* monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
* upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
* once a customer churns they will no longer make payments\

* Example outputs for this table might look like the following:

| customer_id | plan_id | plan_name      | payment_date | amount | payment_order |
|-------------|---------|----------------|--------------|--------|---------------|
| 1           | 1       | basic monthly  | 2020-08-08   | 9.90   | 1             |
| 1           | 1       | basic monthly  | 2020-09-08   | 9.90   | 2             |
| 1           | 1       | basic monthly  | 2020-10-08   | 9.90   | 3             |
| 1           | 1       | basic monthly  | 2020-11-08   | 9.90   | 4             |
| 1           | 1       | basic monthly  | 2020-12-08   | 9.90   | 5             |
| 2           | 3       | pro annual     | 2020-09-27   | 199.00 | 1             |
| 13          | 1       | basic monthly  | 2020-12-22   | 9.90   | 1             |
| 15          | 2       | pro monthly    | 2020-03-24   | 19.90  | 1             |
| 15          | 2       | pro monthly    | 2020-04-24   | 19.90  | 2             |
| 16          | 1       | basic monthly  | 2020-06-07   | 9.90   | 1             |
| 16          | 1       | basic monthly  | 2020-07-07   | 9.90   | 2             |
| 16          | 1       | basic monthly  | 2020-08-07   | 9.90   | 3             |
| 16          | 1       | basic monthly  | 2020-09-07   | 9.90   | 4             |
| 16          | 1       | basic monthly  | 2020-10-07   | 9.90   | 5             |
| 16          | 3       | pro annual     | 2020-10-21   | 189.10 | 6             |
| 18          | 2       | pro monthly    | 2020-07-13   | 19.90  | 1             |
| 18          | 2       | pro monthly    | 2020-08-13   | 19.90  | 2             |
| 18          | 2       | pro monthly    | 2020-09-13   | 19.90  | 3             |
| 18          | 2       | pro monthly    | 2020-10-13   | 19.90  | 4             |
| 18          | 2       | pro monthly    | 2020-11-13   | 19.90  | 5             |
| 18          | 2       | pro monthly    | 2020-12-13   | 19.90  | 6             |
| 19          | 2       | pro monthly    | 2020-06-29   | 19.90  | 1             |
| 19          | 2       | pro monthly    | 2020-07-29   | 19.90  | 2             |
| 19          | 3       | pro annual     | 2020-08-29   | 199.00 | 

## Breaking Plaid Solution - well we sourced a solution and will circle back 

```sql
SELECT
  customer_id,
  plan_id,
  plan_name,
  payment_date ::date :: varchar,
  CASE
    WHEN LAG(plan_id) OVER (
      PARTITION BY customer_id
      ORDER BY
        plan_id
    ) != plan_id
    AND DATE_PART(
      'day',
      payment_date - LAG(payment_date) OVER (
        PARTITION BY customer_id
        ORDER BY
          plan_id
      )
    ) < 30 THEN amount - LAG(amount) OVER (
      PARTITION BY customer_id
      ORDER BY
        plan_id
    )
    ELSE amount
  END AS amount,
  RANK() OVER(
    PARTITION BY customer_id
    ORDER BY
      payment_date
  ) AS payment_order 
  
INTO TEMP TABLE payments
FROM
  (
    SELECT
      customer_id,
      s.plan_id,
      plan_name,
      generate_series(
        start_date,
        CASE
          WHEN s.plan_id = 3 THEN start_date
          WHEN s.plan_id = 4 THEN NULL
          WHEN LEAD(start_date) OVER (
            PARTITION BY customer_id
            ORDER BY
              start_date
          ) IS NOT NULL THEN LEAD(start_date) OVER (
            PARTITION BY customer_id
            ORDER BY
              start_date
          )
          ELSE '2020-12-31' :: date
        END,
        '1 month' + '1 second' :: interval
      ) AS payment_date,
      price AS amount
    FROM
      subscriptions AS s
      JOIN plans AS p ON s.plan_id = p.plan_id
    WHERE
      s.plan_id != 0
      AND start_date < '2021-01-01' :: date
    GROUP BY
      customer_id,
      s.plan_id,
      plan_name,
      start_date,
      price
  ) AS t
ORDER BY
  customer_id
  limit 50;
  
    
  select * 
  from Payments  ```


| customer_id | plan_id | plan_name     | payment_date | amount | payment_order |
|-------------|---------|---------------|--------------|--------|---------------|
| 1           | 1       | basic monthly | 2020-08-08   | 9.90   | 1             |
| 1           | 1       | basic monthly | 2020-09-08   | 9.90   | 2             |
| 1           | 1       | basic monthly | 2020-10-08   | 9.90   | 3             |
| 1           | 1       | basic monthly | 2020-11-08   | 9.90   | 4             |
| 1           | 1       | basic monthly | 2020-12-08   | 9.90   | 5             |
| 2           | 3       | pro annual    | 2020-09-27   | 199.00 | 1             |
| 3           | 1       | basic monthly | 2020-01-20   | 9.90   | 1             |
| 3           | 1       | basic monthly | 2020-02-20   | 9.90   | 2             |
| 3           | 1       | basic monthly | 2020-03-20   | 9.90   | 3             |
| 3           | 1       | basic monthly | 2020-04-20   | 9.90   | 4             |
| 3           | 1       | basic monthly | 2020-05-20   | 9.90   | 5             |
| 3           | 1       | basic monthly | 2020-06-20   | 9.90   | 6             |
| 3           | 1       | basic monthly | 2020-07-20   | 9.90   | 7             |
| 3           | 1       | basic monthly | 2020-08-20   | 9.90   | 8             |
| 3           | 1       | basic monthly | 2020-09-20   | 9.90   | 9             |
| 3           | 1       | basic monthly | 2020-10-20   | 9.90   | 10            |
| 3           | 1       | basic monthly | 2020-11-20   | 9.90   | 11            |
| 3           | 1       | basic monthly | 2020-12-20   | 9.90   | 12            |
| 4           | 1       | basic monthly | 2020-01-24   | 9.90   | 1             |
| 4           | 1       | basic monthly | 2020-02-24   | 9.90   | 2             |
| 4           | 1       | basic monthly | 2020-03-24   | 9.90   | 3             |
| 5           | 1       | basic monthly | 2020-08-10   | 9.90   | 1             |
| 5           | 1       | basic monthly | 2020-09-10   | 9.90   | 2             |
| 5           | 1       | basic monthly | 2020-10-10   | 9.90   | 3             |
| 5           | 1       | basic monthly | 2020-11-10   | 9.90   | 4             |
| 5           | 1       | basic monthly | 2020-12-10   | 9.90   | 5             |
| 6           | 1       | basic monthly | 2020-12-30   | 9.90   | 1             |
| 7           | 1       | basic monthly | 2020-02-12   | 9.90   | 1             |
| 7           | 1       | basic monthly | 2020-03-12   | 9.90   | 2             |
| 7           | 1       | basic monthly | 2020-04-12   | 9.90   | 3             |
| 7           | 1       | basic monthly | 2020-05-12   | 9.90   | 4             |
| 7           | 2       | pro monthly   | 2020-05-22   | 10.00  | 5             |
| 7           | 2       | pro monthly   | 2020-06-22   | 19.90  | 6             |
| 7           | 2       | pro monthly   | 2020-07-22   | 19.90  | 7             |
| 7           | 2       | pro monthly   | 2020-08-22   | 19.90  | 8             |
| 7           | 2       | pro monthly   | 2020-09-22   | 19.90  | 9             |
| 7           | 2       | pro monthly   | 2020-10-22   | 19.90  | 10            |
| 7           | 2       | pro monthly   | 2020-11-22   | 19.90  | 11            |
| 7           | 2       | pro monthly   | 2020-12-22   | 19.90  | 12            |
| 8           | 1       | basic monthly | 2020-06-18   | 9.90   | 1             |
| 8           | 1       | basic monthly | 2020-07-18   | 9.90   | 2             |
| 8           | 2       | pro monthly   | 2020-08-03   | 10.00  | 3             |
| 8           | 2       | pro monthly   | 2020-09-03   | 19.90  | 4             |
| 8           | 2       | pro monthly   | 2020-10-03   | 19.90  | 5             |
| 8           | 2       | pro monthly   | 2020-11-03   | 19.90  | 6             |
| 8           | 2       | pro monthly   | 2020-12-03   | 19.90  | 7             |
| 9           | 3       | pro annual    | 2020-12-14   | 199.00 | 1             |
| 10          | 2       | pro monthly   | 2020-09-26   | 19.90  | 1             |
| 10          | 2       | pro monthly   | 2020-10-26   | 19.90  | 2             |
| 10          | 2       | pro monthly   | 2020-11-26   | 19.90  | 3             |


