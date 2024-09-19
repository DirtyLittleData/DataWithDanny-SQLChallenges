## 2.  DATAMART: DATA EXPLORATION

1. What day of the week is used for each week_date value?
2. What range of week numbers are missing from the dataset?
3. How many total transactions were there for each year in the dataset?
4. What is the total sales for each region for each month?
5. What is the total count of transactions for each platform
6. What is the percentage of sales for Retail vs Shopify for each month?
7. What is the percentage of sales by demographic for each year in the dataset?
8. Which age_band and demographic values contribute the most to Retail sales?
9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

-----------------------------------------------------------
1. What day of the week is used for each week_date value?


```sql
select week_date, week_date_converted,
to_char(week_date_converted, 'Day') as day_of_week
from weekly_sales
limit 10
```

***output*** 
| week_date | week_date_converted         | day_of_week |
|-----------|-----------------------------|-------------|
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |
| 31/8/20   | 2020-08-31T00:00:00.000Z    | Monday      |


2. What range of week numbers are missing from the dataset?
```sql
select week_number, count(week_number)
from weekly_sales
group by week_number
order by 1 asc
```

***output***

| week_number | count |
|-------------|-------|
| 13          | 713   |
| 14          | 712   |
| 15          | 713   |
| 16          | 713   |
| 17          | 713   |
| 18          | 714   |
| 19          | 713   |
| 20          | 714   |
| 21          | 713   |
| 22          | 713   |
| 23          | 713   |
| 24          | 714   |
| 25          | 714   |
| 26          | 714   |
| 27          | 713   |
| 28          | 714   |
| 29          | 713   |
| 30          | 714   |
| 31          | 714   |
| 32          | 713   |
| 33          | 714   |
| 34          | 712   |
| 35          | 712   |
| 36          | 712   |

weeks 1-12 are 37-52 are not represented 

3. How many total transactions were there for each year in the dataset?

```sql 
select year_number, sum(transactions) as sum_yearly_transactions
from weekly_sales
group by 1
order by 1
limit 5
```

***output***
| year_number | sum_yearly_transactions |
|-------------|------------------------|
| 2018        | 346,406,460            |
| 2019        | 365,639,285            |
| 2020        | 375,813,651            |


4. What is the total sales for each region for each month?

```sql
select region, month_number, sum(sales) as total_monthly_sales
from weekly_sales
group by 1,2
order by 1,2
```

***output***

| region        | month_number | total_monthly_sales |
|---------------|--------------|---------------------|
| AFRICA        | 3            | 567,767,480         |
| AFRICA        | 4            | 1,911,783,504       |
| AFRICA        | 5            | 1,647,244,738       |
| AFRICA        | 6            | 1,767,559,760       |
| AFRICA        | 7            | 1,960,219,710       |
| AFRICA        | 8            | 1,809,596,890       |
| AFRICA        | 9            | 276,320,987         |
| ASIA          | 3            | 529,770,793         |
| ASIA          | 4            | 1,804,628,707       |
| ASIA          | 5            | 1,526,285,399       |
| ASIA          | 6            | 1,619,482,889       |
| ASIA          | 7            | 1,768,844,756       |
| ASIA          | 8            | 1,663,320,609       |
| ASIA          | 9            | 252,836,807         |
| CANADA        | 3            | 144,634,329         |
| CANADA        | 4            | 484,552,594         |
| CANADA        | 5            | 412,378,365         |
| CANADA        | 6            | 443,846,698         |
| CANADA        | 7            | 477,134,947         |
| CANADA        | 8            | 447,073,019         |
| CANADA        | 9            | 69,067,959          |
| EUROPE        | 3            | 35,337,093          |
| EUROPE        | 4            | 127,334,255         |
| EUROPE        | 5            | 109,338,389         |
| EUROPE        | 6            | 122,813,826         |
| EUROPE        | 7            | 136,757,466         |
| EUROPE        | 8            | 122,102,995         |
| EUROPE        | 9            | 18,877,433          |
| OCEANIA       | 3            | 783,282,888         |
| OCEANIA       | 4            | 2,599,767,620       |
| OCEANIA       | 5            | 2,215,657,304       |
| OCEANIA       | 6            | 2,371,884,744       |
| OCEANIA       | 7            | 2,563,459,400       |
| OCEANIA       | 8            | 2,432,313,652       |
| OCEANIA       | 9            | 372,465,518         |
| SOUTH AMERICA | 3            | 71,023,109          |
| SOUTH AMERICA | 4            | 238,451,531         |
| SOUTH AMERICA | 5            | 201,391,809         |
| SOUTH AMERICA | 6            | 218,247,455         |
| SOUTH AMERICA | 7            | 235,582,776         |
| SOUTH AMERICA | 8            | 221,166,052         |
| SOUTH AMERICA | 9            | 34,175,583          |
| USA           | 3            | 225,353,043         |
| USA           | 4            | 759,786,323         |
| USA           | 5            | 655,967,121         |
| USA           | 6            | 703,878,990         |
| USA           | 7            | 760,331,754         |
| USA           | 8            | 712,002,790         |
| USA           | 9            | 110,532,368         |

5. What is the total count of transactions for each platform

```sql
select 
	platform, sum(transactions) as total_txn_by_platform
from weekly_sales
group by 1
```

***output***
| platform | total_txn_by_platform |
|----------|-----------------------|
| Shopify  | 5,925,169             |
| Retail   | 1,081,934,227         |

6. What is the percentage of sales for Retail vs Shopify for each month?

```sql
with sum_sales_cte AS
(
select 
	platform, sum(sales) as total_sales_by_platform
from weekly_sales
group by 1
),

total_cte AS 
(
SELECT
*, 
sum(total_sales_by_platform) over()
from sum_sales_cte
)

select *, 
total_sales_by_platform/sum as percent_sales_by_platform
from total_cte
```
***output***
| platform | total_sales_by_platform | percent_sales_by_platform |
|----------|-------------------------|---------------------------|
| Shopify  | 1,089,017,790           | 0.0267                    |
| Retail   | 39,654,616,437          | 0.9733                    |


7. What is the percentage of sales by demographic for each year in the dataset?

```sql
with demographic_sales_CTE AS
(
select year_number, demographic,sum(sales) as total_by_demo, sum(sum(sales)) over (partition by year_number) as yearly_sales_total 
from weekly_sales 
group by 1,2
order by 1,2
limit 5
)

select *, 
round(total_by_demo/yearly_sales_total *100,2) as percent_of_sales_by_demographic
from demographic_sales_CTE
```

*** output ***
| year_number | demographic | total_by_demo | yearly_sales_total | percent_of_sales_by_demographic |
|-------------|-------------|---------------|--------------------|--------------------------------|
| 2018        | Couples     | 3,402,388,688 | 12,897,380,827     | 26.38%                         |
| 2018        | Families    | 4,125,558,033 | 12,897,380,827     | 31.99%                         |
| 2018        | Unknown     | 5,369,434,106 | 12,897,380,827     | 41.63%                         |
| 2019        | Couples     | 3,749,251,935 | 13,746,032,500     | 27.28%                         |
| 2019        | Families    | 4,463,918,344 | 13,746,032,500     | 32.47%                         |

8. Which age_band and demographic values contribute the most to Retail sales?

```sql
SELECT platform, age_band, demographic, sum(sales) as total_sales
from weekly_sales
where platform = 'Retail'
group by 1,2,3
order by total_sales DESC
limit 5
```

***output***

| platform | age_band     | demographic | total_sales    |
|----------|--------------|-------------|----------------|
| Retail   | Unknown      | Unknown     | 16,067,285,533 |
| Retail   | Retirees     | Families    | 6,634,686,916  |
| Retail   | Retirees     | Couples     | 6,370,580,014  |
| Retail   | Middle Aged  | Families    | 4,354,091,554  |
| Retail   | Young Adults | Couples     | 2,602,922,797  |

9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?