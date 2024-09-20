## 3. Before & After Analysis
This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

Using this analysis approach - answer the following questions:

What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
What about the entire 12 weeks before and after?
How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?


* What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
 note - we didnt quite calcualate the growth rate with SQL but we can calcualte with the percentages. We will circle back to trouble shoot this script

```sql
WWITH BEFORE_AFTER_CTE AS (
    SELECT
        CASE
            WHEN week_date_converted::DATE BETWEEN (DATE '2020-06-15' - INTERVAL '4 weeks') AND (DATE '2020-06-14')
                THEN 'Before'
            WHEN week_date_converted::DATE BETWEEN DATE '2020-06-15' AND (DATE '2020-06-15' + INTERVAL '4 weeks')
                THEN 'After'
        END AS period,
        SUM(sales) AS total_sales
    FROM weekly_sales
    WHERE week_date_converted::DATE BETWEEN (DATE '2020-06-15' - INTERVAL '4 weeks') 
                                        AND (DATE '2020-06-15' + INTERVAL '4 weeks')
    GROUP BY period
)

SELECT 
    period, 
    total_sales,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS percent,
    CASE 
        WHEN period = 'After' THEN 
            ROUND((total_sales - (SELECT total_sales FROM BEFORE_AFTER_CTE WHERE period = 'Before')) / NULLIF((SELECT total_sales FROM BEFORE_AFTER_CTE WHERE period = 'Before'), 0) * 100.0, 2)
        END AS growth_rate
FROM BEFORE_AFTER_CTE;


```

**output**

| Period  | Total Sales   | Percent | Growth Rate |
|---------|---------------|---------|-------------|
| After   | 2,904,930,571 | 55.32   | 0.00        |
| Before  | 2,345,878,357 | 44.68   | NULL        |


* What about the entire 12 weeks before and after?
change the interval of previous code to 12
* How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
change the years