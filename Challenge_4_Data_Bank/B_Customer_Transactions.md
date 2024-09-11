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
SELECT
	COUNT(txn_type) AS total_deposit_count,
    SUM(txn_amount) AS total_deposit_amount
FROM customer_transactions
```

| total_deposit_count | total_deposit_amount |
|---------------------|----------------------|
| 5868                | 2958708              |
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

4. What is the closing balance for each customer at the end of the month?


5. What is the percentage of customers who increase their closing balance by more than 5%?

