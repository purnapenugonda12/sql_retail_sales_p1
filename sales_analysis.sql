-- CREATE DATABASE

CREATE DATABASE sales_analysis;

__ Deleting a table if exists
DROP TABLE sales ;

-- Creating table
CREATE TABLE sales(
	transactions_id	INT,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(20),	
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,	
	total_sale FLOAT		
	);
-- Data exploring & cleaning

-- Searching for NULL values
SELECT * FROM sales
WHERE 
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Deleting NULL values
DELETE  FROM sales
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Counting number of sales
SELECT COUNT(*) AS total_sales FROM sales;

-- How many unique customers we have
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM sales;

-- How many catagories and types
SELECT  
COUNT(DISTINCT category) AS category
FROM sales;

SELECT  
DISTINCT category
FROM sales;

-- Data analysis & Business key problems

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM sales 
WHERE sale_date = '2022-11-05'

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM sales
WHERE 
category = 'Clothing'
AND TO_CHAR (sale_date,'YYYY-MM') = '2022-11'
AND quantity >= 4 ;

-- Alternative method
SELECT * FROM sales 
WHERE 
category = 'Clothing'
AND EXTRACT (YEAR FROM sale_date) = 2022
AND EXTRACT (MONTH FROM sale_date) = 11
AND quantity >= 4 ;

-- Write a SQL query to calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale) AS Net_sale
FROM sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category, AVG(age) AS average_age 
FROM sales
WHERE 
category = 'Beauty'
GROUP BY 1;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT * FROM sales 
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender, count(transactions_id) AS transactions
FROM sales
GROUP BY 1,2;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale
FROM(
SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale)AS avg_sale,
RANK() OVER(
	PARTITION BY EXTRACT(YEAR FROM sale_date)
	ORDER BY AVG(total_sale) DESC	
	)AS RANK
FROM sales
GROUP BY 1,2)
WHERE RANK=1

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id AS customer, SUM(total_sale) AS TOTAL_SALE
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) AS "number of customers"
FROM sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT Shift, COUNT(*) AS "total sales"
	FROM(
		SELECT *,
		  CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		  END AS Shift
		FROM sales)
	GROUP BY Shift;