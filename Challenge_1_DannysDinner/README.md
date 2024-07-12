# 8 WeekSQL Challenge Week 1
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="Image" width="450" height="450">

This repository contains the solutions for the case studies in **[8WeekSQLChallenge](https://8weeksqlchallenge.com)** by Danny Ma.

Each repository contains the following:
- A README file providing easy navigation and the scenarios provided
- SQL file to work with the schema, tables, and SQL
- MD files c/o Fiddle which contain SQL solutions

**Note:** 
Solutions are coded in **Fiddle** and **MySQL**

Please star any projects you like!

**Danny's Diner Questions:** 

1. What is the total amount each customer spent at the restaurant?

[Q1 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q01.sql)

2. How many days has each customer visited the restaurant?

[Q2 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q02.sql)

3. What was the first item from the menu purchased by each customer?

[Q3 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q03.sql)

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

[Q4 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q04.sql)

5. Which item was the most popular for each customer?

[Q5 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q05.sql)

6. Which item was purchased first by the customer after they became a member?

[Q6 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q06.sql)

7. Which item was purchased just before the customer became a member?

[Q7 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q07.sql)

8. What is the total items and amount spent for each member before they became a member?

[Q8 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q08.sql)

9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

[Q9 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q09.sql)

10. What is the total items and amount spent for each member before they became a member?

[Q10 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q10.md)

11. BONUS QUESTION, Join All The Things:
We recreate the attached table output using the available data.

[Q11 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q11.sql)

12. BONUS QUESTION, Rank All The Things:
Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program. We recreate the attached table output using the available data.

[Q12 Solution](https://github.com/BreakingPlaid/DannysDinerSQL/blob/main/DatawDannyWeek1Q12.sql)
***

**Schema (PostgreSQL v13)**

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

## Challenge Case Studies
* 🍣[Danny's Diner SQL](https://github.com/BreakingPlaid/DannysDinerSQL)
* 🍕[Pizza Runner](https://github.com/BreakingPlaid/PizzaRunnerSQL)
* 🥑[Foodie-Fi](https://github.com/BreakingPlaid/Foodie-FiSQL)
* 🏦[Data Bank](https://github.com/BreakingPlaid/DataBankSQL)
* 🛒[Data Mart](https://github.com/BreakingPlaid/DataMartSQL)
* 🎣[Clique Bait](https://github.com/BreakingPlaid/CliqueBaitSQL)
* 🌳[Balanced Tree Clothing Co.](https://github.com/BreakingPlaid/BalancedTreeClothingCoSQL)
* 🍊[Fresh Segments](https://github.com/BreakingPlaid/FreshSegmentsSQL)