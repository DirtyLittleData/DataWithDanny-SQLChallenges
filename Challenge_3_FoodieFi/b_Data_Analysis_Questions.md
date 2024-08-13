## B. Data Analysis Questions

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
    	COUNT(plan_id),
        EXTRACT(YEAR FROM start_date) as year   
    FROM subscriptions
    WHERE EXTRACT(YEAR FROM start_date) > 2020
    GROUP BY EXTRACT(YEAR FROM start_date)
    ORDER BY EXTRACT(YEAR FROM start_date);
```

| count | year |
| ----- | ---- |
| 202   | 2021 |

---

4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

6. What is the number and percentage of customer plans after their initial free trial?

7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

8. How many customers have upgraded to an annual plan in 2020?

9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
