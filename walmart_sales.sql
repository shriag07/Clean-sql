CREATE DATABASE saleswalmart
USE saleswalmart
Create table  sales (
 invoice_id  varchar(30) Not null primary Key,
 branch  varchar (5) not null,
    city varchar (30) not null,
    customer_type varchar (30) not null,
    gender  varchar(10) not null,
    product_line varchar (100) not null,
    unit_price  decimal(10,2) not null,
    quantity int not null,
    VAT  float not null,
    total decimal (12,4) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar (15)  not null, 
    cogs  decimal (10, 2) not null,
    gross_margin_pct float ,
    gross_income decimal(12, 4) not null,
    rating float 
);

SELECT * FROM sales
LIMIT 10

#Feature engg
#1.Add column time of day

alter table sales add column time_of_day  varchar(30);
update sales set time_of_day= (
 case 
  when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else  "Evening" 
    end
);

#2 add column day name
alter table sales add column day_name varchar(10);
update  sales
set day_name= dayname(date);

#3 add column month name
ALTER TABLE sales add column month_name varchar(15);
UPDATE sales set month_name=monthname(date);

#Performing EDA

#1. Product analysis
#a. How many unique product lines does the data have?

SELECT COUNT(DISTINCT(product_line)) FROM sales;

#b. What is the most common payment method?
SELECT payment_method,count(payment_method) as cnt FROM sales
group by payment_method
ORDER BY cnt DESC;

#c. What is the most selling product line?
SELECT product_line,count(product_line) as cnt FROM sales
group by product_line
ORDER BY cnt DESC;

#d. What is the total revenue by month?
Select month_name,sum(total) as total_revenue 
from sales
group by month_name;

#e. What month had the largest COGS?
Select month_name,sum(cogs) as total_cogs 
from sales
group by month_name
order by total_cogs DESC;

#f. What product line had the largest revenue?
Select product_line,sum(total) as total_revenue 
from sales
group by product_line
order by total_revenue DESC;

#g. Which branch sold more products than average product sold?
select branch ,sum(quantity) as qty
from sales
group by branch having sum(quantity) > (select  avg(quantity) from sales);

#h. What is the most common product line by gender?
SELECT gender,product_line,count(gender) as cnt
FROM sales
GROUP BY gender,product_line
ORDER BY cnt DESC;

#i. What is the average rating of each product line?
SELECT product_line,round(avg(rating),2) as avg_rating FROM sales
group by product_line;

#2.Sales analysis
#a. Number of sales made in each time of the day per Monday?
SELECT time_of_day,sum(total) as total_sales
FROM sales
WHERE day_name='Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

#b.Which of the customer types brings the most revenue?
SELECT customer_type,sum(total) as total_sales
FROM sales
GROUP BY customer_type
ORDER BY total_sales DESC;

#c.Which city has the largest tax percent/ VAT ?
SELECT city,round(avg(VAT),2) as avg_vat
FROM sales
GROUP BY city
ORDER BY avg_vat DESC;

#3.Customer analysis
#a.How many unique customer types does the data have?
SELECT distinct(customer_type) FROM sales;

#b.What is the most common customer type?
SELECT customer_type,count(*) as cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

#c. What is the gender of most of the customers?
SELECT gender,count(*) as cnt
FROM sales
GROUP BY gender
ORDER BY cnt DESC;

#d.What is the gender distribution per branch?
SELECT branch,gender,count(gender) as gender_count
FROM sales
GROUP BY branch,gender;

#e.Which time of the day do customers give most ratings per branch?
Select time_of_day,branch,avg(rating) as avg_rating
from sales
group by time_of_day, branch
order by avg_rating ;

#f.Which day fo the week has the best avg ratings?
Select day_name,avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;
