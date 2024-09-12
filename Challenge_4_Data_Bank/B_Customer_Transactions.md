### B. Customer Transactions
1. What is the unique count and total amount for each transaction type?

```sql
SELECT
	txn_type,
    COUNT(txn_type),
    SUM(txn_amount)
FROM customer_transactions
GROUP BY 1
```
| txn_type    | count | sum      |
|-------------|-------|----------|
| purchase    | 1617  | 806,537  |
| deposit     | 2671  | 1,359,168|
| withdrawal  | 1580  | 793,003  |
---

2. What is the average total historical deposit counts and amounts for all customers?

```sql
WITH count_CTE AS
(
SELECT
    customer_id,
    txn_type,
    COUNT(txn_type) deposit_count,
    SUM(txn_amount) total_amount
FROM customer_transactions
WHERE txn_type = 'deposit'
GROUP BY 1, 2
)

SELECT
	ROUND(AVG(deposit_count), 2) AS avg_deposit_count,
	ROUND(AVG(total_amount), 2) AS avg_amount
FROM count_CTE
```

| avg_deposit_count | avg_amount |
|-------------------|------------|
| 5.34              | 2718.34    |
---

3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

### Solution

To solve this, we identified the count for each transaction type using a case/when statement, creating new columns to hold each transaction type count. We then queried our new CTE to filter for the stated criteria. We interpreted the question to mean MORE than 1 deposit and AT LEAST 1 withdrawal or 1 purchase.

```sql
WITH count_CTE AS
(
SELECT
    customer_id,
    TO_CHAR(txn_date, 'month') AS month_name,
      EXTRACT(MONTH FROM txn_date) AS month_number,
    SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_count,
    SUM(CASE WHEN txn_type IN ('purchase') THEN 1 ELSE 0 END) AS purchase_count,
    SUM(CASE WHEN txn_type IN ('withdrawal') THEN 1 ELSE 0 END) AS withdrawal_count
  FROM customer_transactions
  GROUP BY customer_id, 2, 3
  ORDER BY customer_id
)
```
![image](https://github.com/user-attachments/assets/8aa1f1b7-9e44-477b-8b7b-ed3816aeed23)
CTE yields this output.
```sql
SELECT 
	month_number,
    INITCAP(month_name) AS month_name,
    COUNT(*) active_customer_count
FROM count_CTE
WHERE deposit_count > 1 and (withdrawal_count >= 1 OR purchase_count >= 1)
GROUP BY 1, 2
ORDER BY month_number
```

| month_number | month_name | active_customer_count |
|--------------|------------|-----------------------|
| 1            | January    | 168                   |
| 2            | February   | 181                   |
| 3            | March      | 192                   |
| 4            | April      | 70                    |
---

4. What is the closing balance for each customer at the end of the month?

### Solution 1

In our initial assessment of this query, we calculated monthly balances by adding deposits and subtracting purchases and withdrawals from each customer. Upon further analysis we've realized we have not yet carried over balances which is needed to calculate a realistic running total.

```sql
SELECT 
    customer_id,
    EXTRACT(MONTH FROM txn_date) AS month_number,
    TO_CHAR(txn_date, 'Month'),
    SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount
        	WHEN txn_type = 'purchase' THEN -txn_amount
        	WHEN txn_type = 'withdrawal' THEN -txn_amount END) AS total_amount
FROM customer_transactions
GROUP BY customer_id, EXTRACT(MONTH FROM txn_date), 3
ORDER BY customer_id
```

| customer_id | month_number | to_char  | total_amount |
|-------------|--------------|----------|--------------|
| 1           | 1            | January  | 312          |
| 1           | 3            | March    | -952         |
| 2           | 1            | January  | 549          |
| 2           | 3            | March    | 61           |
| 3           | 2            | February | -965         |
| 3           | 4            | April    | 493          |
| 3           | 3            | March    | -401         |
| 3           | 1            | January  | 144          |
| 4           | 1            | January  | 848          |
| 4           | 3            | March    | -193         |
| 5           | 1            | January  | 954          |
| 5           | 4            | April    | -490         |
| 5           | 3            | March    | -2877        |
| 6           | 1            | January  | 733          |
| 6           | 2            | February | -785         |
| 6           | 3            | March    | 392          |
| 7           | 1            | January  | 964          |
| 7           | 3            | March    | -640         |
| 7           | 2            | February | 2209         |
| 7           | 4            | April    | 90           |
| 8           | 2            | February | -180         |
| 8           | 4            | April    | -972         |
| 8           | 3            | March    | -464         |
| 8           | 1            | January  | 587          |
| 9           | 3            | March    | 930          |
| 9           | 1            | January  | 849          |
| 9           | 2            | February | -195         |
| 9           | 4            | April    | -722         |
| 10          | 2            | February | 280          |
| 10          | 4            | April    | -2337        |
---

### Solution 2

In our second attempt we revisitied the issue of creating a running total and created the following solution:

```sql
WITH monthly_balances AS (
    SELECT 
        customer_id,
        EXTRACT(MONTH FROM txn_date) AS month_num,
        TO_CHAR(txn_date, 'Month') as month_name,
        SUM(
            CASE 
                WHEN txn_type = 'deposit' THEN txn_amount
                WHEN txn_type IN ('withdrawal', 'purchase') THEN -txn_amount
            END
        ) AS monthly_balance
    FROM 
        customer_transactions
    GROUP BY 
        customer_id, EXTRACT(MONTH FROM txn_date), 3
    ORDER BY 1, 2, 3
)


SELECT 
    customer_id,
    month_num,
    month_name,
    monthly_balance,
    SUM(monthly_balance) OVER (
        PARTITION BY customer_id
        ORDER BY month_num
    ) AS running_balance
FROM
    monthly_balances
ORDER BY 
    customer_id, month_num;
```


| customer_id | month_num | month_name | monthly_balance | running_balance |
|-------------|-----------|------------|-----------------|-----------------|
| 1           | 1         | January    | 312             | 312             |
| 1           | 3         | March      | -952            | -640            |
| 2           | 1         | January    | 549             | 549             |
| 2           | 3         | March      | 61              | 610             |
| 3           | 1         | January    | 144             | 144             |
| 3           | 2         | February   | -965            | -821            |
| 3           | 3         | March      | -401            | -1222           |
| 3           | 4         | April      | 493             | -729            |
| 4           | 1         | January    | 848             | 848             |
| 4           | 3         | March      | -193            | 655             |
| 5           | 1         | January    | 954             | 954             |
| 5           | 3         | March      | -2877           | -1923           |
| 5           | 4         | April      | -490            | -2413           |
| 6           | 1         | January    | 733             | 733             |
| 6           | 2         | February   | -785            | -52             |
| 6           | 3         | March      | 392             | 340             |
| 7           | 1         | January    | 964             | 964             |
| 7           | 2         | February   | 2209            | 3173            |
| 7           | 3         | March      | -640            | 2533            |
| 7           | 4         | April      | 90              | 2623            |
| 8           | 1         | January    | 587             | 587             |
| 8           | 2         | February   | -180            | 407             |
| 8           | 3         | March      | -464            | -57             |
| 8           | 4         | April      | -972            | -1029           |
| 9           | 1         | January    | 849             | 849             |
| 9           | 2         | February   | -195            | 654             |
| 9           | 3         | March      | 930             | 1584            |
| 9           | 4         | April      | -722            | 862             |
| 10          | 1         | January    | -1622           | -1622           |
| 10          | 2         | February   | 280             | -1342           |
| 10          | 3         | March      | -1411           | -2753           |
| 10          | 4         | April      | -2337           | -5090           |
---

5. What is the percentage of customers who increase their closing balance by more than 5%?

SET search_path = data_bank;
-- 5. What is the percentage of customers who increase their closing balance by more than 5%?

```sql
WITH monthly_balances AS (
    SELECT 
        customer_id,
        EXTRACT(MONTH FROM txn_date) AS month_num,
        TO_CHAR(txn_date, 'Month') as month_name,
        SUM(
            CASE 
                WHEN txn_type = 'deposit' THEN txn_amount
                WHEN txn_type IN ('withdrawal', 'purchase') THEN -txn_amount
            END
        ) AS monthly_balance
    FROM 
        customer_transactions
    GROUP BY 
        customer_id, EXTRACT(MONTH FROM txn_date), 3
    ORDER BY 1, 2, 3
)
,
closing_CTE AS (
  SELECT 
    customer_id,
    month_num,
    month_name,
    monthly_balance,
    SUM(monthly_balance) OVER (
        PARTITION BY customer_id
        ORDER BY month_num
    ) AS closing_balance
FROM
    monthly_balances
ORDER BY 
    customer_id, month_num
)
,
CTE AS (
SELECT
    customer_id,
    month_num,
    month_name,
    closing_balance AS new_value,
    CASE 
        WHEN closing_balance IS NOT NULL THEN 
        LAG(closing_balance, 1) OVER (PARTITION BY customer_id ORDER BY month_num)
        ELSE 0 
        END 
        AS old_value
FROM closing_CTE
ORDER BY 1, 2
)
SELECT
    customer_id,
    month_num,
    month_name,
    old_value AS previous_balance,
    new_value AS current_balance,
    CASE
        WHEN old_value = 0 THEN NULL
        ELSE ROUND((new_value - old_value) / NULLIF(old_value, 0) * 100)
    END AS percent_change
FROM CTE
ORDER BY customer_id, month_num;
```

#AI Solution (Thanks Claude!)

```sql
WITH monthly_balances AS (
  SELECT
    customer_id,
    DATE_TRUNC('month', txn_date) AS month,
    SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END) AS monthly_balance_change
  FROM customer_transactions
  GROUP BY customer_id, DATE_TRUNC('month', txn_date)
),
customer_balance_change AS (
  SELECT
    customer_id,
    SUM(monthly_balance_change) OVER (PARTITION BY customer_id ORDER BY month) AS running_balance,
    month,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY month) AS first_month,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY month DESC) AS last_month
  FROM monthly_balances
),
first_last_balance AS (
  SELECT
    customer_id,
    MAX(CASE WHEN first_month = 1 THEN running_balance END) AS first_balance,
    MAX(CASE WHEN last_month = 1 THEN running_balance END) AS last_balance
  FROM customer_balance_change
  GROUP BY customer_id
),
balance_increase AS (
  SELECT
    COUNT(*) AS total_customers,
    SUM(CASE 
      WHEN last_balance > first_balance * 1.05 AND first_balance != 0 THEN 1
      ELSE 0
    END) AS customers_with_increase
  FROM first_last_balance
)
SELECT
  ROUND((customers_with_increase * 100.0 / total_customers)) AS percentage_with_more_than_5_percent_increase
FROM balance_increase;
```