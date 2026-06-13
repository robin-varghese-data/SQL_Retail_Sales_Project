--Create Table

CREATE TABLE retail_sales(
 transactions_id INT PRIMARY KEY,
 sale_date DATE,
 sale_time TIME,
 customer_id INT,
 gender VARCHAR(15),
 age INT,
 category VARCHAR (15),
 quantiy INT,
 price_per_unit FLOAT,
 cogs FLOAT,
 total_sale FLOAT

)

-- To see first 10 rows
SELECT * FROM retail_sales
LIMIT 10;


-- To count the total number of rows in the table

SELECT
    COUNT(*) 
FROM retail_sales;


--DATA CLEANING
--To check if we have any null values

SELECT * FROM retail_sales
WHERE 
      transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR 
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL

;

-- To delete the null value rows

DELETE FROM retail_sales
WHERE 
      transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR 
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL

;

--DATA EXPLORATION

--How many sales we have?

SELECT 
COUNT(*) as Total_sale   --(Toatal_sales is an alias)
FROM retail_sales;


--How many unique customers we have?

SELECT 
COUNT(DISTINCT customer_id)
FROM retail_sales;

--How many unique categories we have?

SELECT COUNT(DISTINCT category) 
FROM retail_sales;
	  
SELECT DISTINCT category
FROM retail_sales;


--DATA ANALYSIS

--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05':

SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';

--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022?

SELECT * FROM retail_sales
WHERE category='Clothing' AND quantiy>=4 AND TO_CHAR(sale_date,'YYYY-MM')= '2022-11';

--Q3. Write a SQL query to calculate the total sales (total_sale) for each category?

SELECT 
  category,
  SUM(total_sale) AS Total_Sales, 
  COUNT (*) AS Total_Orders --If you want number of order for each category. It is not part of the question.
FROM retail_sales
GROUP BY category;

--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?

SELECT 
ROUND(AVG(Age),2) AS Avg_Age -- Round the result to 2 decimal places
FROM retail_sales 
WHERE category='Beauty';

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000?

SELECT * FROM retail_sales
WHERE total_sale>1000;

--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?

SELECT 
    category,
    gender, 
    COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


--Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?

SELECT * FROM 
(SELECT 
	EXTRACT (YEAR FROM sale_date) AS Year,
	EXTRACT (MONTH FROM sale_date) AS Month,
	ROUND(AVG(total_sale)::numeric,2) AS Avg_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
FROM retail_sales
GROUP BY Year,Month
) AS T1
WHERE rank=1
;

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales?

SELECT 
customer_id,
SUM(total_sale) AS Sales
FROM retail_sales
Group BY customer_id
ORDER BY Sales DESC
LIMIT 5;

--Q9  Write a SQL query to find the number of unique customers who purchased items from each category?

SELECT 
   COUNT(DISTINCT customer_id),
   category
FROM retail_sales
GROUP BY 2;

--Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?

WITH Hourly_sale
AS 
(
SELECT *,
   CASE
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening'
   END AS Shift
FROM retail_sales
)
SELECT 
 Shift,
 COUNT(Transactions_id) AS No_Of_Orders
FROM Hourly_sale
GROUP BY Shift;






