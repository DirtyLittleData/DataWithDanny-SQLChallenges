**Schema (PostgreSQL v13)**
```sql
    CREATE SCHEMA dannys_diner;
    SET search_path = dannys_diner;
    
    CREATE TABLE sales (
      "customer_id" VARCHAR(1),
      "order_date" DATE,
      "product_id" INTEGER
    );
    
    INSERT INTO sales
      ("customer_id", "order_date", "product_id")
    VALUES
      ('A', '2021-01-01', '1'),
      ('A', '2021-01-01', '2'),
      ('A', '2021-01-07', '2'),
      ('A', '2021-01-10', '3'),
      ('A', '2021-01-11', '3'),
      ('A', '2021-01-11', '3'),
      ('B', '2021-01-01', '2'),
      ('B', '2021-01-02', '2'),
      ('B', '2021-01-04', '1'),
      ('B', '2021-01-11', '1'),
      ('B', '2021-01-16', '3'),
      ('B', '2021-02-01', '3'),
      ('C', '2021-01-01', '3'),
      ('C', '2021-01-01', '3'),
      ('C', '2021-01-07', '3');
     
    
    CREATE TABLE menu (
      "product_id" INTEGER,
      "product_name" VARCHAR(5),
      "price" INTEGER
    );
    
    INSERT INTO menu
      ("product_id", "product_name", "price")
    VALUES
      ('1', 'sushi', '10'),
      ('2', 'curry', '15'),
      ('3', 'ramen', '12');
      
    
    CREATE TABLE members (
      "customer_id" VARCHAR(1),
      "join_date" DATE
    );
    
    INSERT INTO members
      ("customer_id", "join_date")
    VALUES
      ('A', '2021-01-07'),
      ('B', '2021-01-09');
``` 
---

**Query #2**
```sql
    WITH point_CTE AS(
      SELECT
    	s.customer_id,
        s.order_date,
    	CASE 
    		WHEN s.order_date BETWEEN mem.join_date AND (mem.join_date + 6) THEN price * 20
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10 END AS points
    FROM sales s
    	JOIN menu m ON s.product_id = m.product_id
    	JOIN members mem ON mem.customer_id = s.customer_id
    WHERE EXTRACT (MONTH FROM order_date) = 1
    )
    
    SELECT 
    	point_CTE.customer_id,
        SUM(points)
    FROM point_CTE 
    GROUP BY customer_id
    ORDER BY customer_id;
```
#### Result set:
| customer_id | sum  |
| ----------- | ---- |
| A           | 1370 |
| B           | 820  |

---
**Return**
🍣[Danny's Diner SQL](https://github.com/BreakingPlaid/DannysDinerSQL)
