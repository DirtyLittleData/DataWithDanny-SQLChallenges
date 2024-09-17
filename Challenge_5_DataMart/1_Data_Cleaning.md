1. Data Cleansing Steps
In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

* Convert the week_date to a DATE format

```sql
 select *, 
to_date(week_date, 'dd-mm-yy' )as converted_week_date
from weekly_sales
limit 10
```

*** output ***

| week_date | region  | platform | segment | customer_type | transactions | sales   | converted_week_date      |
|-----------|---------|----------|---------|---------------|--------------|---------|---------------------------|
| 31/8/20   | ASIA    | Retail   | C3      | New           | 120631       | 3656163 | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | ASIA    | Retail   | F1      | New           | 31574        | 996575  | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | USA     | Retail   | null    | Guest         | 529151       | 16509610| 2020-08-31T00:00:00.000Z  |
| 31/8/20   | EUROPE  | Retail   | C1      | New           | 4517         | 141942  | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | AFRICA  | Retail   | C2      | New           | 58046        | 1758388 | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | CANADA  | Shopify  | F2      | Existing      | 1336         | 243878  | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | AFRICA  | Shopify  | F3      | Existing      | 2514         | 519502  | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | ASIA    | Shopify  | F1      | Existing      | 2158         | 371417  | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | AFRICA  | Shopify  | F2      | New           | 318          | 49557   | 2020-08-31T00:00:00.000Z  |
| 31/8/20   | AFRICA  | Retail   | C3      | New           | 111032       | 3888162 | 2020-08-31T00:00:00.000Z  |

upon mooving forward with the next question, we realized it would be best to alter the table and add the new column convered week_date which can can then query

```sql
-- Add a new column with DATE type
ALTER TABLE weekly_sales
ADD COLUMN week_date_converted DATE;

-- Update the new column with the converted date values
UPDATE weekly_sales
SET week_date_converted = TO_DATE(week_date, 'DD-MM-YY');
```

* Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc

```sql
-- Step 1: Add a new column for week number
ALTER TABLE weekly_sales
ADD COLUMN week_number INT;

-- Step 2: Update the new column with week numbers
UPDATE weekly_sales
SET week_number = EXTRACT(week FROM week_date_converted);

-- Step 3: Verify the update
SELECT *
FROM weekly_sales
LIMIT 10;
```

***output***

| week_date | region  | platform | segment | customer_type | transactions | sales   | week_date_converted     | week_number |
|-----------|---------|----------|---------|---------------|--------------|---------|-------------------------|-------------|
| 31/8/20   | ASIA    | Retail   | C3      | New           | 120631       | 3656163 | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | ASIA    | Retail   | F1      | New           | 31574        | 996575  | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | USA     | Retail   | null    | Guest         | 529151       | 16509610| 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | EUROPE  | Retail   | C1      | New           | 4517         | 141942  | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | AFRICA  | Retail   | C2      | New           | 58046        | 1758388 | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | CANADA  | Shopify  | F2      | Existing      | 1336         | 243878  | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | AFRICA  | Shopify  | F3      | Existing      | 2514         | 519502  | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | ASIA    | Shopify  | F1      | Existing      | 2158         | 371417  | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | AFRICA  | Shopify  | F2      | New           | 318          | 49557   | 2020-08-31T00:00:00.000Z | 36          |
| 31/8/20   | AFRICA  | Retail   | C3      | New           | 111032       | 3888162 | 2020-08-31T00:00:00.000Z | 36          |


* Add a month_number with the calendar month for each week_date value as the 3rd column
once action we will alter the table to add the new column

```sql
ALTER TABLE weekly_sales
ADD COLUMN month_number INT;

-- Step 2: Update the new column with week numbers
UPDATE weekly_sales
SET month_number = EXTRACT(month FROM week_date_converted);

-- Step 3: Verify the update
SELECT *
FROM weekly_sales
LIMIT 10;
```

*** output  ***
| week_date | region  | platform | segment | customer_type | transactions | sales   | week_date_converted     | week_number | month_number |
|-----------|---------|----------|---------|---------------|--------------|---------|-------------------------|-------------|--------------|
| 31/8/20   | ASIA    | Retail   | C3      | New           | 120631       | 3656163 | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | ASIA    | Retail   | F1      | New           | 31574        | 996575  | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | USA     | Retail   | null    | Guest         | 529151       | 16509610| 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | EUROPE  | Retail   | C1      | New           | 4517         | 141942  | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | AFRICA  | Retail   | C2      | New           | 58046        | 1758388 | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | CANADA  | Shopify  | F2      | Existing      | 1336         | 243878  | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | AFRICA  | Shopify  | F3      | Existing      | 2514         | 519502  | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | ASIA    | Shopify  | F1      | Existing      | 2158         | 371417  | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | AFRICA  | Shopify  | F2      | New           | 318          | 49557   | 2020-08-31T00:00:00.000Z | 36          | 8            |
| 31/8/20   | AFRICA  | Retail   | C3      | New           | 111032       | 3888162 | 2020-08-31T00:00:00.000Z | 36          | 8            |


* Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values

combining all the above cleaning steps:
```sql
-- Step 1: Add new columns
ALTER TABLE weekly_sales
ADD COLUMN week_date_converted DATE,
ADD COLUMN week_number INT,
ADD COLUMN month_number INT,
ADD COLUMN year_number INT;

-- Step 2: Update week_date_converted with converted date values
UPDATE weekly_sales
SET week_date_converted = TO_DATE(week_date, 'DD-MM-YY');

-- Step 3: Update week_number and month_number based on the converted date
UPDATE weekly_sales
SET week_number = EXTRACT(week FROM week_date_converted),
    month_number = EXTRACT(month FROM week_date_converted),
	year_number = EXTRACT(year FROM week_date_converted);
```

*** output ***
| week_date | region  | platform | segment | customer_type | transactions | sales   | week_date_converted     | week_number | month_number | year_number |
|-----------|---------|----------|---------|---------------|--------------|---------|-------------------------|-------------|--------------|-------------|
| 31/8/20   | ASIA    | Retail   | C3      | New           | 120631       | 3656163 | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | ASIA    | Retail   | F1      | New           | 31574        | 996575  | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | USA     | Retail   | null    | Guest         | 529151       | 16509610| 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | EUROPE  | Retail   | C1      | New           | 4517         | 141942  | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | AFRICA  | Retail   | C2      | New           | 58046        | 1758388 | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | CANADA  | Shopify  | F2      | Existing      | 1336         | 243878  | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | AFRICA  | Shopify  | F3      | Existing      | 2514         | 519502  | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | ASIA    | Shopify  | F1      | Existing      | 2158         | 371417  | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | AFRICA  | Shopify  | F2      | New           | 318          | 49557   | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |
| 31/8/20   | AFRICA  | Retail   | C3      | New           | 111032       | 3888162 | 2020-08-31T00:00:00.000Z | 36          | 8            | 2020        |


* Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

Here is the data formatted into a two-column markdown table:

| Segment   | Age Band      |
|-----------|---------------|
| 1         | Young Adults  |
| 2         | Middle Aged   |
| 3 or 4    | Retirees      |

And the mapping for the demographic column:

| Segment (First Letter) | Demographic |
|------------------------|-------------|
| C                      | Couples     |
| F                      | Families    |

* Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns

once again we've determined to alter the table to add this column (at some later date we me return to create a stored procedure)

```sql
--age band + demographic
ALTER TABLE weekly_sales
ADD COLUMN age_band VARCHAR(50),
ADD COLUMN demographic VARCHAR(50);

--add values to age band + demographic 

UPDATE weekly_sales
SET age_band = CASE
    WHEN SUBSTRING(segment FROM '[0-9]')::int = 1 THEN 'Young Adults'
    WHEN SUBSTRING(segment FROM '[0-9]')::int = 2 THEN 'Middle Aged'
    WHEN SUBSTRING(segment FROM '[0-9]')::int IN (3, 4) THEN 'Retirees'
    ELSE 'Unknown' -- Optional, in case `segment` does not match any of the cases
END,
demographic = CASE
    WHEN SUBSTRING(segment FROM '[a-zA-Z]') = 'C' THEN 'Couples'
    WHEN SUBSTRING(segment FROM '[a-zA-Z]') = 'F' THEN 'Families'
    ELSE 'Unknown' -- Optional, in case `segment` does not match any of the cases
END;
```

***output***

| week_date | region | platform | segment | customer_type | transactions | sales    | week_date_converted         | week_number | month_number | year_number | age_band     | demographic |
|-----------|--------|----------|---------|---------------|--------------|----------|-----------------------------|-------------|--------------|-------------|-------------|-------------|
| 31/8/20   | ASIA   | Retail   | C3      | New           | 120631       | 3656163  | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Retirees    | Couples     |
| 31/8/20   | ASIA   | Retail   | F1      | New           | 31574        | 996575   | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Young Adults| Families    |
| 31/8/20   | USA    | Retail   | null    | Guest         | 529151       | 16509610 | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Unknown     | Unknown     |
| 31/8/20   | EUROPE | Retail   | C1      | New           | 4517         | 141942   | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Young Adults| Couples     |
| 31/8/20   | AFRICA | Retail   | C2      | New           | 58046        | 1758388  | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Middle Aged | Couples     |



* Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record

```sql 
select * ,
	round((sales/transactions),2) as avg_transaction
from weekly_sales
limit 5
```

***output***

 | week_date | region | platform | segment | customer_type | transactions | sales    | week_date_converted         | week_number | month_number | year_number | age_band     | demographic | avg_transaction |
|-----------|--------|----------|---------|---------------|--------------|----------|-----------------------------|-------------|--------------|-------------|--------------|-------------|-----------------|
| 31/8/20   | ASIA   | Retail   | C3      | New           | 120631       | 3656163  | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Retirees     | Couples     | 30.00           |
| 31/8/20   | ASIA   | Retail   | F1      | New           | 31574        | 996575   | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Young Adults | Families    | 31.00           |
| 31/8/20   | USA    | Retail   | null    | Guest         | 529151       | 16509610 | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Unknown      | Unknown     | 31.00           |
| 31/8/20   | EUROPE | Retail   | C1      | New           | 4517         | 141942   | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Young Adults | Couples     | 31.00           |
| 31/8/20   | AFRICA | Retail   | C2      | New           | 58046        | 1758388  | 2020-08-31T00:00:00.000Z    | 36          | 8            | 2020        | Middle Aged  | Couples     | 30.00           |
