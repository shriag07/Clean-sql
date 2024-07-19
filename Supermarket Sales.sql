CREATE DATABASE sales
USE sales
SELECT * FROM supermarket_sales
DESCRIBE supermarket_sales
# CHanging datatype of date column to date
ALTER TABLE supermarket_sales MODIFY `Date` Date ##

UPDATE supermarket_sales
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y')
ALTER TABLE supermarket_sales MODIFY `Date` Date

SELECT TRIM(Total) FROM supermarket_sales

#Calculate Total Sales- 86775.82
SELECT SUM(Total) as total_sales
FROM supermarket_sales

#Average sales per transaction-369.25
SELECT AVG(Total) as average_sales
FROM supermarket_sales

#Total Sales by Category-Sports & Travel>Home>Health>F7B>fashion>Electronics
SELECT `Product line`,SUM(Total) as total_sales
FROM supermarket_sales
GROUP BY `Product line`
ORDER BY `Product line` DESC

#Sales by Period-Month wise- 1:28444.52,2:- 25335.94, 3:- 32995.35

SELECT MONTH(`Date`) as sales_month,SUM(Total) as total_sales
FROM supermarket_sales 
GROUP BY sales_month
ORDER BY sales_month

#Sales by Period-Week wise

SELECT WEEK(`Date`) as sales_week,SUM(Total) as total_sales
FROM supermarket_sales 
GROUP BY sales_week
ORDER BY sales_week

#Customer count Type- 109-Member  126-Normal
SELECT `Customer type`,COUNT(*) as customer_type
FROM supermarket_sales
GROUP BY `Customer type`

#Prefered Mode of Payment:- Ewallet-86,Cash-78,Credit card-71
SELECT `Payment`,COUNT(*) as customer_type
FROM supermarket_sales
GROUP BY `Payment`

#Average Ratings Across Product line- Food-7.54,Electronic-7.37,Sports-6.9,Home-6.8,Health-6.75
SELECT `Product line`,AVG(Rating) as avg_rating
FROM supermarket_sales
GROUP BY `Product line`
ORDER BY avg_rating DESC

#Total Sales across Branches- A-26327 B-32235 C-28212
SELECT Branch,SUM(Total) as total_sales
FROM supermarket_sales
GROUP BY Branch

#Trends of monthly sales by product line across Branches- Helps in optimising inventory

SELECT Branch,`Product line`,MONTH(`Date`) as monthly_sales,SUM(Total) as total_sales
FROM supermarket_sales
GROUP BY Branch,`Product line`,monthly_sales
ORDER BY Branch,`Product line`,monthly_sales

#Gross Income across categories- Health>SPorts>Food>Home>Electronics>Fashion
SELECT `Product line`,SUM(`gross income`) as total_profit
FROM supermarket_sales
GROUP BY `Product line`
ORDER BY total_profit DESC

#Gender Prefernces across Product categories
SELECT Gender,`Product line`,SUM(Total) as total_sales
FROM supermarket_sales
GROUP BY Gender,`Product line`
ORDER BY Gender,`Product line`



