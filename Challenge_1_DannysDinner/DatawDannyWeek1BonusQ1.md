**BONUS QUESTION 1:**
* Join All The Things: Recreate the attached table output using the available data.

<p align="center">
<img src="https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/Images/Bonus1.png" alt="Image" width=50% height=50% </p>

```sql
SELECT
    	s.customer_id,
      	TO_CHAR(s.order_date, 'yyyy-mm-dd') AS order_date,
      	m.product_name,
      	m.price,
      	CASE WHEN s.order_date >= mem.join_date THEN 'Y'
        	WHEN mem.join_date IS null THEN 'N'
      		ELSE 'N' END AS member
FROM sales s
    	JOIN menu m ON m.product_id = s.product_id
    	FULL OUTER JOIN members mem ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date , m.price DESC
```
#### Result set:
| customer_id | order_date | product_name | price | member |
| ----------- | ---------- | ------------ | ----- | ------ |
| A           | 2021-01-01 | curry        | 15    | N      |
| A           | 2021-01-01 | sushi        | 10    | N      |
| A           | 2021-01-07 | curry        | 15    | Y      |
| A           | 2021-01-10 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| B           | 2021-01-01 | curry        | 15    | N      |
| B           | 2021-01-02 | curry        | 15    | N      |
| B           | 2021-01-04 | sushi        | 10    | N      |
| B           | 2021-01-11 | sushi        | 10    | Y      |
| B           | 2021-01-16 | ramen        | 12    | Y      |
| B           | 2021-02-01 | ramen        | 12    | Y      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-07 | ramen        | 12    | N      |

---

**Return**
🍣[Danny's Diner SQL](https://github.com/BreakingPlaid/DannysDinerSQL)