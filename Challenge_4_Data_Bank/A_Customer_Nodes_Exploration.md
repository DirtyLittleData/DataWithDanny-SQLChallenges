
### A. Customer Nodes Exploration
---
1. How many unique nodes are there on the Data Bank system?
---
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
---
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
---
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
---
4. How many days on average are customers reallocated to a different node?
---

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

**BP All-In-One-Solution™**

```sql
SELECT
    ROUND(AVG(end_date - start_date), 2) AS average_reallocation
FROM customer_nodes
WHERE end_date != '9999-12-31'
```

|avg                |
|-------------------|
|14.6340000000000000|
---

There are a lot of solutions swimming around the internet that read 24 or 23, which is another way to interpret the question, but if you are looking to find the average days spent per customer on node transfer, in the text it reads that the average is generally quick. We saw this as a flag to re-check the numbers and verify that it would be closer to an average turnaround of two weeks rather than a whole month. In most cases, you get the total of 43,902 entries, but you have to make sure not to lose row entries because that affects your average solution (no GROUP BY, no further SUM).

---
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
---

```sql
WITH diff_CTE AS
(
SELECT
	*,
    end_date - start_date AS difference
FROM customer_nodes
WHERE end_date != '9999-12-31'
ORDER BY 1, 2
)

SELECT 
    d.region_id,
    r.region_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY d.difference) AS median,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY d.difference) AS percent_80,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY d.difference) AS percent_95
FROM diff_CTE d
JOIN regions r ON d.region_id = r.region_id
GROUP BY d.region_id, r.region_name

-- Code to save for later
-- SELECT
-- 	d.region_id,
--     n.region_name,
--     d.node_id,
-- 	SUM(difference) AS duration
-- FROM diff_CTE d
-- JOIN regions n ON n.region_id = d.region_id
-- GROUP BY 1,2,3
-- ORDER BY 1, 3
```
