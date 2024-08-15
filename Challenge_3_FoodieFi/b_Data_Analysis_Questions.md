## B. Data Analysis Questions

🥑 Case Study #3: Foodie-Fi - Data Analysis Questions
### Case Study Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

1. How many customers has Foodie-Fi ever had?

---
**BP Solution**

```sql
    SELECT 
    	COUNT(DISTINCT customer_id) 
    FROM subscriptions;
```

| count |
| ----- |
| 1000  |
---

2. What is the monthly distribution of trial plan start_date values for our dataset — use the start of the month as the group by value.

---
**BP Solution**

```sql
    WITH months_CTE AS(
      SELECT 
      	EXTRACT(MONTH FROM start_date),
        TO_CHAR(start_date, 'Month') AS month_name
    FROM subscriptions
    WHERE plan_id = 0
      ORDER BY 1, 2
    )
    
    SELECT 
    	month_name,
    	COUNT(month_name) 
    FROM months_CTE
    GROUP BY month_name;
```

| month_name | count |
| ---------- | ----- |
| April      | 81    |
| August     | 88    |
| December   | 84    |
| February   | 68    |
| January    | 88    |
| July       | 89    |
| June       | 79    |
| March      | 94    |
| May        | 88    |
| November   | 75    |
| October    | 79    |
| September  | 87    |

---

```sql
    SELECT 
        TO_CHAR(start_date, 'Month') AS month_name,
        COUNT(*) AS count_entries
    FROM subscriptions
    WHERE plan_id = 0
    GROUP BY TO_CHAR(start_date, 'Month'), EXTRACT(MONTH FROM start_date)
    ORDER BY EXTRACT(MONTH FROM start_date);
```

| month_name | count_entries |
| ---------- | ------------- |
| January    | 88            |
| February   | 68            |
| March      | 94            |
| April      | 81            |
| May        | 88            |
| June       | 79            |
| July       | 89            |
| August     | 88            |
| September  | 87            |
| October    | 79            |
| November   | 75            |
| December   | 84            |

---

3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
   
---
**BP Solution**

```sql
    SELECT 
    	plan_id,
    	COUNT(plan_id) AS count_2021 
    FROM subscriptions
    WHERE EXTRACT(YEAR FROM start_date) > 2020
    GROUP BY 1
    ORDER BY 1;
```

| plan_id | count_2021 |
| ------- | ---------- |
| 1       | 8          |
| 2       | 60         |
| 3       | 63         |
| 4       | 71         |

---


4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

---
**Breaking Plaid Solution**

We've come up with two solutions. The first is a straightforward set of two CTEs, where total_customers gives us the customer total which we know to be 1,000 and churned_customers calculates the count of customers who have churned whcih we know to be 307. The final query calculates the percent using the above CTEs.

```sql
WITH total_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS total
    FROM subscriptions
),
churned_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS churned
    FROM subscriptions
    WHERE plan_id = 4
)
SELECT 
    churned AS churn_count,
    ROUND(100.0 * churned / total, 1) AS churn_percentage
FROM churned_customers, total_customers;
```
##### total_customers CTE:
| Description | Amount |
|-------------|--------|
| Total       | 1000   |

##### churned_cutomers CTE: 
| Churned |
|---------|
| 307     |


##### Final solution: 
| churn_count | churn_percentage |
|-------------|------------------|
| 307         | 30.7%            |

---
**Breaking Plaid Solution**

The All-in-One™ solution creates the count of 307 by counting all customers WHERE the plan_id = 4 (churn). It then creates the total customer count of 1,000 within a subquery, which is used as the denominator of the created column three. In one step we convert the data type to FLOAT, multiply by 100, and add a percentage sign. JOIN is added as a courtesy to read the name "churn" rather than hard-coding the column name in.

```sql
    SELECT
    	p.plan_name,
        COUNT(DISTINCT customer_id) as churn_count,
        
        CONCAT(COUNT(DISTINCT customer_id)/
        (SELECT 
         	COUNT(DISTINCT customer_id)
         FROM subscriptions)
         ::FLOAT * 100, '%')
         AS churn_percent 
         
    FROM subscriptions s
    JOIN plans p ON s.plan_id = p.plan_id
    WHERE s.plan_id = 4
    GROUP BY 1;
```

| plan_name | churn_count | churn_percent |
| --------- | ----------- | ------------- |
| churn     | 307         | 30.7%         |
---


5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

---
**Breaking Plaid Solution**

Using the LEAD clause that we'd used a couple questions earlier, we decided to create a CTE that provides a side by side view of the original plan name with the next plan name for each customer. In the following SELECT statement, we queried the CTE and filtered the first column to only count the customers who had plan_name of "trial" and a next_plan as "churn" to find the numerator. Then we used a subquery to get the total customers, used that as the denominator and calculated that to get the trial to churn totals and total percent.

```sql
    WITH next_plan_CTE AS (
      SELECT
    	customer_id,
        start_date,
        plan_name,
        LEAD(p.plan_name) OVER(PARTITION BY s.customer_id ORDER BY s.plan_id) as next_plan
    FROM subscriptions s
    JOIN plans p ON p.plan_id = s.plan_id
    ORDER BY customer_id, start_date
    )
    
    SELECT 
    	COUNT(*),
        CONCAT(COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions)::FLOAT * 100, '%') AS percentage_churn
    FROM next_plan_CTE
    WHERE plan_name = 'trial' AND next_plan = 'churn';
 ```
#####
next_plan_CTE sample outplut to help visualize the result of lead() window function that moves the following plan name up one row partitioned by customer
| customer_id | start_date              | plan_name      | next_plan      |
|-------------|-------------------------|----------------|----------------|
| 1           | 2020-08-01T00:00:00.000Z | trial          | basic monthly  |
| 1           | 2020-08-08T00:00:00.000Z | basic monthly  | null           |
| 2           | 2020-09-20T00:00:00.000Z | trial          | pro annual     |
| 2           | 2020-09-27T00:00:00.000Z | pro annual     | null           |
| 3           | 2020-01-13T00:00:00.000Z | trial          | basic monthly  |
| 3           | 2020-01-20T00:00:00.000Z | basic monthly  | null           |
| 4           | 2020-01-17T00:00:00.000Z | trial          | basic monthly  |
| 4           | 2020-01-24T00:00:00.000Z | basic monthly  | churn          |
| 4           | 2020-04-21T00:00:00.000Z | churn          | null           |



| count | percentage_churn |
| ----- | ---------------- |
| 92    | 9.2%             |
---


6. What is the number and percentage of customer plans after their initial free trial?
---

**Breaking Plaid Solution**
```sql
WITH first_plan_after_trial AS (
  SELECT
    customer_id,
    MAX(plan_id) AS last_plan_id
  FROM
    subscriptions
  WHERE
    plan_id != '0'
  GROUP BY
    customer_id
  ORDER BY customer_id
)

SELECT
  last_plan_id,
  COUNT(*) AS number_plans,
  ROUND(SUM(COUNT(*) OVER(PARTITION BY last_plan_id)) / COUNT(*), 2) AS percentage
FROM
  first_plan_after_trial
GROUP BY
  last_plan_id
ORDER BY
  1;
```

| last_plan_id | number_plans | percentage |
|--------------|--------------|------------|
|      1       |     125      |   12.50    |
|      2       |     316      |   31.60    |
|      3       |     252      |   25.20    |
|      4       |     307      |   30.70    |
---

**Breaking Plaid Solution**
```sql
WITH count_CTE AS (
    SELECT 
        *,
        COUNT(*) OVER() AS total_nontrial_plans
    FROM subscriptions
    WHERE plan_id != 0
)
SELECT
    plan_id,
    CONCAT(ROUND(COUNT(plan_id) * 100.0 / total_nontrial_plans, 2), '%') AS plan_percentage
FROM count_CTE
GROUP BY plan_id, total_nontrial_plans
ORDER BY plan_id
```

| plan_id | plan_percentage |
|---------|-----------------|
|    1    |      33.09%     |
|    2    |      32.67%     |
|    3    |      15.64%     |
|    4    |      18.61%     |
---

7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
---

```sql
WITH start_date_CTE AS (
    SELECT 
        *, 
        LEAD(start_date, 1) OVER (PARTITION BY customer_id ORDER BY plan_id) AS next_date
    FROM subscriptions
    WHERE start_date <= '2020-12-31'::DATE
)

SELECT 
    c.plan_id,
    p.plan_name, 
    COUNT(DISTINCT c.customer_id) AS customer_count,  
    (CAST(COUNT(DISTINCT c.customer_id) AS FLOAT) * 100.0 / 
        (SELECT COUNT(DISTINCT customer_id) FROM subscriptions)) AS percentage_customer
FROM start_date_CTE c
LEFT JOIN plans p ON c.plan_id = p.plan_id
WHERE c.next_date IS NULL OR c.next_date > '2020-12-31' 
GROUP BY c.plan_id, p.plan_name
ORDER BY c.plan_id
```

| plan_id | plan_name     | customer_count | percentage_customer |
|---------|---------------|----------------|---------------------|
| 0       | trial         | 19             | 1.9%                |
| 1       | basic monthly | 224            | 22.4%               |
| 2       | pro monthly   | 326            | 32.6%               |
| 3       | pro annual    | 195            | 19.5%               |
| 4       | churn         | 236            | 23.6%               |
---

8. How many customers have upgraded to an annual plan in 2020?
---
We learned that BETWEEN includes both the start and end values (as if using >= and <=).

```sql
SELECT 
	COUNT(*) AS total_annual
FROM subscriptions
WHERE plan_id = 3 and start_date BETWEEN '01-01-2020'::DATE AND '12-31-2020'::DATE
```

|total_annual|
|------------|
|195         |
---

9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql
	SELECT
		customer_id,
		plan_id,
		start_date AS trial_date
	FROM subscriptions
	WHERE plan_id = 0
```

| customer_id | plan_id | trial_date                |
|-------------|---------|---------------------------|
| 1           | 0       | 2020-08-01T00:00:00.000Z  |
| 2           | 0       | 2020-09-20T00:00:00.000Z  |
| 3           | 0       | 2020-01-13T00:00:00.000Z  |
| 4           | 0       | 2020-01-17T00:00:00.000Z  |
---

```sql
	SELECT
		customer_id,
		plan_id,
		start_date AS annual_start_date
	FROM subscriptions
	WHERE plan_id = 3
 ```

| customer_id | plan_id | annual_start_date         |
|-------------|---------|---------------------------|
| 2           | 3       | 2020-09-27T00:00:00.000Z  |
| 9           | 3       | 2020-12-14T00:00:00.000Z  |
| 16          | 3       | 2020-10-21T00:00:00.000Z  |
| 17          | 3       | 2020-12-11T00:00:00.000Z  |
---

```sql
	SELECT
    		ROUND(AVG(annual_start_date - trial_date), 2) AS date_diff
	FROM annual_plan_CTE a
	JOIN trial_date_CTE t ON a.customer_id = t.customer_id
	JOIN plans p ON p.plan_id = a.plan_id
```

|date_diff|
|---------|
|104.62   |
---

10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
---

```sql
WITH trial_date_CTE AS
(
SELECT
		customer_id,
		plan_id,
		start_date AS trial_date
FROM subscriptions
WHERE plan_id = 0
),

annual_plan_CTE AS 
(
SELECT
	customer_id,
	plan_id,
	start_date AS annual_start_date
FROM subscriptions
WHERE plan_id = 3
),

difference_CTE AS (SELECT
	t.customer_id,
    annual_start_date - trial_date AS difference
FROM annual_plan_CTE a
JOIN trial_date_CTE t ON a.customer_id = t.customer_id
JOIN plans p ON p.plan_id = a.plan_id),

bucket_CTE AS (SELECT
    customer_id,
    CASE
        WHEN difference BETWEEN 0 AND 30 THEN '1-30'
        WHEN difference BETWEEN 31 AND 60 THEN '31-60'
        WHEN difference BETWEEN 61 AND 90 THEN '61-90'
        ELSE '90+'
    END AS _30_day_buckets
FROM difference_CTE)

SELECT
	COUNT(customer_id),
    _30_day_buckets
FROM bucket_CTE
GROUP BY _30_day_buckets
```
| Count | _30_day_buckets |
|-------|-----------------|
|   49  | 1-30            |
|   24  | 31-60           |
|   34  | 61-90           |
|  151  | 90+             |
---

```sql
WITH trial_date_CTE AS
(
SELECT
		customer_id,
		plan_id,
		start_date AS trial_date
FROM subscriptions
WHERE plan_id = 0
),

annual_plan_CTE AS 
(
SELECT
	customer_id,
	plan_id,
	start_date AS annual_start_date
FROM subscriptions
WHERE plan_id = 3
),

difference_CTE AS (SELECT
	t.customer_id,
    annual_start_date - trial_date AS difference
FROM annual_plan_CTE a
JOIN trial_date_CTE t ON a.customer_id = t.customer_id
JOIN plans p ON p.plan_id = a.plan_id),

bucket_CTE AS (SELECT 
	customer_id,
    difference,
    WIDTH_BUCKET(difference, 0, 30 * 12, 12) AS day_group
FROM 
    difference_CTE)

SELECT
	day_group,
    COUNT(customer_id)
FROM bucket_CTE
GROUP BY 1
```

| day_group | count |
|-----------|-------|
| 1         | 48    |
| 2         | 25    |
| 3         | 33    |
| 4         | 35    |
| 5         | 43    |
| 6         | 35    |
| 7         | 27    |
| 8         | 4     |
| 9         | 5     |
| 10        | 1     |
| 11        | 1     |
| 12        | 1     |
---

12. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
