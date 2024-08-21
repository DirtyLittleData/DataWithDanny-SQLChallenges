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


2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?


3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?


4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?


5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?

