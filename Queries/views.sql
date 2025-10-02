---------------------------------------------------------------------
						-- Views 
---------------------------------------------------------------------

CREATE OR REPLACE VIEW v_order_analytics AS 

SELECT o.order_id,
       o.order_date,
	   c.customer_name,
	   SUM(od.quantity*od.unit_price) AS total_amount,
	   p.status AS payment_method,
	   s.status AS shipping_method
FROM orders o 
JOIN customer c ON o.customer_id=c.customer_id
JOIN order_details od ON od.order_id=o.order_id
JOIN payment p ON p.order_id=o.order_id
JOIN shipping s ON s.order_id=o.order_id
GROUP BY o.order_id, o.order_date, c.customer_name, p.status, s.status
HAVING SUM(od.quantity*od.unit_price) > 500 ; 

SELECT *
FROM v_order_analytics ; 
---------------------------------------------------------
-- اعمل View يجيب المنتجات اللي لم تباع أبداً مع اسم الكاتيجوري

CREATE OR REPLACE VIEW products_never_sold AS

SELECT p.product_id , p.product_name,c.category_name
FROM product p 
JOIN category c ON c.category_id=p.category_id
WHERE product_id NOT IN (SELECT product_id FROM order_details) ; 


SELECT *FROM products_never_sold ; 

---------------------------------------------------------
--Delivered & Paid orders

CREATE OR REPLACE VIEW v_completed_paid_orders AS 

SELECT o.order_id,
       o.order_date,
	   c.customer_name,
	   SUM(od.quantity*od.unit_price) AS total_amount,
	   p.status AS payment_status,
	   s.status AS shipping_method
FROM orders o 
JOIN customer c ON o.customer_id=c.customer_id
JOIN order_details od ON od.order_id=o.order_id
JOIN payment p ON p.order_id=o.order_id
JOIN shipping s ON s.order_id=o.order_id
WHERE o.status = 'Delivered'
  AND s.status = 'Delivered'
  AND p.status = 'Completed'
GROUP BY o.order_id, o.order_date, c.customer_name, p.status, s.status ; 

SELECT *
FROM v_completed_paid_orders ; 

