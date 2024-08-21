
### A. Customer Nodes Exploration
1. How many unique nodes are there on the Data Bank system?

```sql
SELECT
	COUNT(DISTINCT node_id) AS node_count
FROM customer_nodes
```
| node_count|
|-----------|
| 5         |
---
2. What is the number of nodes per region?

```sql
SELECT
    r.region_id,
    r.region_name,
    COUNT(DISTINCT node_id) AS node_count
FROM customer_nodes c
JOIN regions r ON r.region_id = c.region_id
GROUP BY 1, 2
```

| region_id | region_name | node_count |
|-----------|-------------|------------|
| 1         | Australia   | 5          |
| 2         | America     | 5          |
| 3         | Africa      | 5          |
| 4         | Asia        | 5          |
| 5         | Europe      | 5          |
---

3. How many customers are allocated to each region?

```sql
SELECT
	r.region_id,
    r.region_name,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customer_nodes c
JOIN regions r ON r.region_id = c.region_id
GROUP BY 1, 2
```
| region_id | region_name | customer_count |
|-----------|-------------|----------------|
| 1         | Australia   | 110            |
| 2         | America     | 105            |
| 3         | Africa      | 102            |
| 4         | Asia        | 95             |
| 5         | Europe      | 88             |

4. How many days on average are customers reallocated to a different node?

```sql
WITH diff_CTE AS
(
SELECT
	*,
    end_date - start_date AS difference
FROM customer_nodes
WHERE end_date != '9999-12-31'
ORDER BY customer_id, start_date
)

SELECT
	AVG(difference)
FROM diff_CTE
```

|avg                |
|-------------------|
|14.6340000000000000|
---

5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
