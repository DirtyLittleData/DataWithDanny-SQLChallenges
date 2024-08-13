## A. Customer Journey
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

## BreakingPlaid Solution: 

Well, instead of 8 sample customers, we decided to explore the entire dataset. It wasnt fun at first. But eventually, we learned worked it out. We learned about the window function lead to re-arrange our data around the plan changes by customer, so that we can calculate the patterns of plan changes by total numbers and avg time in days between plan changes.



```sql
SET search_path = foodie_fi;

---
    WITH customer_plans AS (
      SELECT 
        s.customer_id,
        s.plan_id,
        p.plan_name,
        s.start_date,
        LEAD(s.plan_id) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_plan_id,
        LEAD(p.plan_name) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_plan_name,
        LEAD(s.start_date) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_start_date
      FROM 
        subscriptions s
      JOIN 
        plans p ON s.plan_id = p.plan_id
    ),
    
    upgrades AS (
      SELECT 
        customer_ID,
      	plan_name AS from_plan,
        next_plan_name AS to_plan,
        next_start_date - start_date AS days_to_upgrade
      FROM 
        customer_plans
      WHERE 
        next_plan_id > plan_id
    )
    
    
    SELECT 
      from_plan,
      to_plan,
      COUNT(*) AS upgrade_count,
      AVG(days_to_upgrade) AS avg_days_to_upgrade
    FROM 
      upgrades
    GROUP BY 
      from_plan, to_plan
    ORDER BY 
      from_plan, to_plan;
```

---
| from_plan     | to_plan       | upgrade_count | avg_days_to_upgrade  |
| ------------- | ------------- | ------------- | -------------------- |
| basic monthly | churn         | 97            | 83.6907216494845361  |
| basic monthly | pro annual    | 110           | 92.0090909090909091  |
| basic monthly | pro monthly   | 214           | 90.7429906542056075  |
| pro annual    | churn         | 6             | 365.0000000000000000 |
| pro monthly   | churn         | 112           | 86.4107142857142857  |
| pro monthly   | pro annual    | 111           | 104.6396396396396396 |
| trial         | basic monthly | 546           | 7.0000000000000000   |
| trial         | churn         | 92            | 7.0000000000000000   |
| trial         | pro annual    | 37            | 7.0000000000000000   |
| trial         | pro monthly   | 325           | 7.0000000000000000   |

---
