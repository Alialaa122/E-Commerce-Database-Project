----------------------------------------------------------------------------------------------------------------
												-- Queries-- 
----------------------------------------------------------------------------------------------------------------
-- Show all customers

SELECT * 
FROM customer 
LIMIT 10 ;
------------------------------------------------------
-- List all products with a price less than 200.

SELECT product_name
FROM product 
WHERE price < 200 
LIMIT 10 ;
-------------------------------------------------------
-- List customers with the orders they placed.

SELECT c.customer_id, 
       c.customer_name ,
	   o.order_id ,
	   o.order_date ,
	   o.total_amount
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id 
LIMIT 10 ;
-------------------------------------------------------

--Show all products included in each order (order + product).

SELECT od.order_id , 
       p.product_id,
	   p.product_name
FROM order_details od 
JOIN product p ON  od.product_id = p.product_id 
LIMIT 10 ;

---------------------------------------------------------

-- Show all shipments with the address they were sent to

SELECT s.shipping_id,
       s.shipping_date,
	   s.delivery_date,
	   s.status,
	   a.street,
	   a.city,
	   a.country
FROM shipping s 
JOIN address a ON s.address_id=a.address_id  
LIMIT 10 ;
---------------------------------------------------------
-- Count the number of orders for each customer.

SELECT customer_id , COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id 
ORDER BY total_orders DESC , customer_id ASC 
LIMIT 10 ;

----------------------------------------------------------
-- Calculate the total sales for each product, considering only delivered orders.

SELECT p.product_id,
       p.product_name,
	   SUM(od.unit_price*od.quantity) AS total_sales
FROM order_details od 
JOIN product p ON od.product_id=p.product_id
JOIN orders o ON od.order_id=o.order_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name 
LIMIT 10 ;


-----------------------------------------------------------
--Find the customer who spent the most money.

SELECT c.customer_id , 
       c.customer_name,
	   SUM(o.total_amount) AS total_spent
FROM orders o 
JOIN customer c ON o.customer_id=c.customer_id 
GROUP BY c.customer_id , c.customer_name
ORDER BY total_spent DESC
LIMIT 1 ;

------------------------------------------------------------
-- List all products priced above the average product price

SELECT product_name , 
       price 
FROM product 
WHERE price > (SELECT AVG(price) FROM product) 
LIMIT 10 ;

------------------------------------------------------------
--Show all orders that have not been delivered yet 

SELECT *
FROM orders 
WHERE status != 'Delivered' 
LIMIT 10 ;

-------------------------------------------------------------
-- Show customers who never made a payment.
WITH paid_customers AS (SELECT o.customer_id
					 	FROM payment p 
					 	JOIN orders o ON p.order_id=o.order_id )

SELECT customer_id 
FROM customer
WHERE customer_id NOT IN (SELECT customer_id FROM paid_customers) 
LIMIT 10 ;

---------------------------------------------------------------
-- Find the average number of products per order.
WITH cte1 AS (SELECT order_id, COUNT(*) AS total_products 
			  FROM order_details
		      GROUP BY order_id ) 

SELECT ROUND(AVG(total_products),2)
FROM cte1  
LIMIT 10 ;
----------------------------------------------------------------
-- Show the payment methods distribution (how many times each method was used).

SELECT "method" , COUNT(*)
FROM payment
GROUP BY "method" ;

-----------------------------------------------------------------
-- Find the top 3 best-selling products based on total quantity sold.

WITH cte1 AS (SELECT product_id, 
				     SUM(quantity) AS total_quantity_sold , 
				     DENSE_RANK()OVER(ORDER BY SUM(quantity) DESC)  AS rank 
			  FROM order_details
			  GROUP BY product_id )
			  
SELECT product_id , total_quantity_sold
FROM cte1 
WHERE rank <=3 ;

-----------------------------------------------------------------
-- Show the customer who made the largest single order (based on total amount).

SELECT o.customer_id ,
       c.customer_name,
       p.amount_paid
FROM payment p 
JOIN orders o ON o.order_id=p.order_id 
JOIN customer c ON o.customer_id=c.customer_id
WHERE o.status='Delivered' 
ORDER BY p.amount_paid DESC
LIMIT 1 ;
-----------------------------------------------------------------
-- List customers who placed at least 5 orders.

SELECT customer_id, 
       COUNT(*) total_orders 
FROM orders o
GROUP BY customer_id 
HAVING COUNT(*) >= 5
ORDER BY total_orders DESC , customer_id 
LIMIT 10 ;

-----------------------------------------------------------------
-- Find the category with the highest sales.

SELECT c.category_name ,
       SUM(od.unit_price*od.quantity) AS total_sales
FROM order_details od 
JOIN product p  ON od.product_id=p.product_id
JOIN category c ON p.category_id=c.category_id 
GROUP BY  c.category_name
ORDER BY total_sales DESC ;

------------------------------------------------------------------