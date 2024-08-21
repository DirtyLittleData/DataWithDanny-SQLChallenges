D. Outside The Box Questions
The following are open ended questions which might be asked during a technical interview for this case study - there are no right or wrong answers, but answers that make sense from both a technical and a business perspective make an amazing impression!

1. How would you calculate the rate of growth for Foodie-Fi?

---
**Breaking Plaid Thoughts**

Using our previous payments table (found in the Schema file), first I wanted to check on monthly totals to find whether certain months cause a spike in sales. 

From the data, seems like October is a strong month and May is a weak month.

```sql
    SELECT
    	INITCAP(TO_CHAR(payment_date::DATE, 'month')) AS payment_month,
        TO_CHAR(SUM(amount), 'FM$999,999,999.00') AS formatted_amount
    FROM payments
    GROUP BY 1
    ORDER BY MIN(payment_date::DATE);
```

| payment_month | formatted_amount |
| ------------- | ---------------- |
| January       | $7,358.30        |
| February      | $6,333.50        |
| March         | $5,010.20        |
| April         | $6,631.90        |
| May           | $4,512.20        |
| June          | $5,556.20        |
| July          | $6,441.80        |
| August        | $7,406.50        |
| September     | $7,655.80        |
| October       | $8,771.00        |
| November      | $6,481.80        |
| December      | $6,114.00        |

---

You can also ORDER BY the formatted_amount for a clearer picture.

| payment_month | formatted_amount |
|---------------|------------------|
| October       | $8,771.00        |
| September     | $7,655.80        |
| August        | $7,406.50        |
| January       | $7,358.30        |
| April         | $6,631.90        |
| November      | $6,481.80        |
| July          | $6,441.80        |
| February      | $6,333.50        |
| December      | $6,114.00        |
| June          | $5,556.20        |
| March         | $5,010.20        |
| May           | $4,512.20        |


```sql
WITH monthly_revenue_CTE AS 
(
    SELECT
        EXTRACT(MONTH FROM payment_date::DATE) AS month_number,
        INITCAP(TO_CHAR(payment_date::DATE, 'month')) AS payment_month,
        SUM(amount) AS monthly_revenue
    FROM payments
    WHERE EXTRACT(YEAR FROM payment_date::DATE) = 2020
    GROUP BY 1, 2
    ORDER BY 1
)
,

month_CTE AS 
(
  SELECT
	month_number,
    monthly_revenue AS current_revenue,
	LAG(monthly_revenue) OVER() AS prev_month_rev
FROM monthly_revenue_CTE
ORDER BY month_number
             )

SELECT
	*,
	ROUND(((current_revenue - prev_month_rev) / prev_month_rev * 100), 1) AS growth_rate
FROM month_CTE
```

| month_number | current_revenue | prev_month_rev | growth_rate |
|--------------|-----------------|----------------|-------------|
| 1            | 864.70          | null           | null        |
| 2            | 1958.00         | 864.70         | 126.4       |
| 3            | 2782.50         | 1958.00        | 42.1        |
| 4            | 3945.70         | 2782.50        | 41.8        |
| 5            | 4512.20         | 3945.70        | 14.4        |
| 6            | 5556.20         | 4512.20        | 23.1        |
| 7            | 6441.80         | 5556.20        | 15.9        |
| 8            | 7406.50         | 6441.80        | 15.0        |
| 9            | 7655.80         | 7406.50        | 3.4         |
| 10           | 8771.00         | 7655.80        | 14.6        |
| 11           | 6481.80         | 8771.00        | -26.1       |
| 12           | 6114.00         | 6481.80        | -5.7        |


2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?

How many people convert to pro-annuals? What's their history. Did they go straight from trial? What can we identify as something that gets people to pro-annual. How long were they there, a short time or a long time?

3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?

Churn rates, downgrades, and people who just use the trial and churn.

4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?

The only thing missing from data would be for us to create a list of reasons that a user would quit, while including an "other" section to allow the customers to write something it. That way you can see if there are any reasons missed in the options provided.

5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?

It's possible the trial date isn't long enough, and analyzing the data could provide those answers.
