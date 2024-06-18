CREATE DATABASE dannys_diner
USE dannys_diner

CREATE TABLE sales (
  `customer_id` VARCHAR(1),
  `order_date` DATE,
  `product_id` INTEGER
)

INSERT INTO sales
  (`customer_id`, `order_date`, `product_id`)
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
  `product_id` INTEGER,
  `product_name` VARCHAR(5),
  `price` INTEGER
);

INSERT INTO menu
  (`product_id`, `product_name`, `price`)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  CREATE TABLE members (
  `customer_id` VARCHAR(1),
  `join_date` DATE
);

INSERT INTO members
  (`customer_id`, `join_date`)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  --Exploratory Data Analysis
  
--  Q1. What is the total amount each customer spent at the restaurant?

SELECT a.customer_id,SUM(b.price) as total_spent
FROM sales a
JOIN menu b
ON a.product_id=b.product_id
GROUP BY a.customer_id

--Q2. How many days has each customer visited the restaurant?

SELECT customer_id,COUNT(customer_id) as no_days_visited FROM SALES
GROUP BY customer_id

--Q3. What was the first item from the menu purchased by each customer?

SELECT * FROM (
SELECT a.customer_id,b.product_name,RANK() OVER(PARTITION BY a.customer_id ORDER BY a.order_date)as rn
FROM sales a
JOIN menu b
ON a.product_id=b.product_id)cd
WHERE rn=1

--Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT b.product_name,COUNT(*) as total_purchased
FROM sales a
JOIN menu b
ON a.product_id=b.product_id
GROUP BY b.product_name
ORDER BY total_purchased DESC LIMIT 1

--Q5. Which Item was most popular for each customer?

WITH customer_popularity as
(SELECT a.customer_id,b.product_name,COUNT(*) as purchase_count,DENSE_RANK() OVER (PARTITION BY a.customer_id ORDER BY COUNT(*)DESC) as rnk
FROM sales a
JOIN menu b
ON a.product_id=b.product_id
GROUP BY a.customer_id,b.product_name)
SELECT cp.customer_id,cp.product_name,cp.purchase_count
FROM customer_popularity cp
WHERE rnk=1

--Q6. Which item was purchased first by the customer after they became a member?

WITH first_purchase_date as 
(
SELECT a.customer_id,MIN(a.order_date) as first_purchase
FROM sales a
JOIN members b on a.customer_id=b.customer_id
WHERE a.order_date>= b.join_date
GROUP BY a.customer_id
)
SELECT fpd.customer_id,c.product_name
FROM first_purchase_date fpd
JOIN sales a on a.customer_id=fpd.customer_id
AND fpd.first_purchase=a.order_date
JOIN menu c ON a.product_id=c.product_id

--Q7. Which item was purchased just before the customer became a member?

WITH last_purchase_before_membership as
(SELECT a.customer_id,MAX(a.order_date) as last_purchase_date
FROM sales a 
JOIN members b ON a.customer_id=b.customer_id
WHERE a.order_date<b.join_date
GROUP BY a.customer_id
)
SELECT lpb.customer_id,c.product_name
FROM last_purchase_before_membership as lpb
JOIN sales a  ON lpb.customer_id=a.customer_id
AND lpb.last_purchase_date=a.order_date
JOIN menu c ON a.product_id=c.product_id

--Q8 What is the total items and amount spent for each member before they became member?

SELECT a.customer_id,COUNT(*) as total_items,SUM(b.price) as total_spent
FROM sales a
JOIN menu b ON a.product_id=b.product_id
JOIN members c ON a.customer_id=c.customer_id
WHERE a.order_date< c.join_date
GROUP BY a.customer_id

--Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT a.customer_id,SUM(
       CASE WHEN b.product_name='sushi' THEN b.price*20
       ELSE b.price*10 END)as total_points
FROM sales a
JOIN menu b ON a.product_id=b.product_id
GROUP BY a.customer_id









