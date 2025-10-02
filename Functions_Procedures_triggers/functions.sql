------------------------------------------------------------------
						-- Functions 
------------------------------------------------------------------
-- A function that takes customer_id and returns the total amount the customer has paid.

CREATE OR REPLACE FUNCTION total_sales_per_customer(id INTEGER)
RETURNS NUMERIC
AS
$$
DECLARE total NUMERIC ; 
BEGIN
     SELECT SUM(p.amount_paid)
	 INTO total
	 FROM payment p 
	 JOIN orders o ON p.order_id=o.order_id
	 WHERE o.customer_id=id ; 

	 RETURN COALESCE(total, 0);
END;
$$ language plpgsql;

SELECT total_sales_per_customer(15) ; 

-----------------------------------------------------------
-- A function that takes product_id and returns the total quantity sold and the total revenue.

CREATE OR REPLACE FUNCTION price_and_total_quantity_sold(id INTEGER)
RETURNS TABLE(product_id INT , total_quantity BIGINT, total_value NUMERIC)AS $$
BEGIN

    RETURN QUERY
	SELECT od.product_id , 
       	   SUM(od.quantity) as total_quantity ,
	   	   SUM(od.unit_price*od.quantity) AS total_value
	FROM order_details od
	WHERE od.product_id=id
	GROUP BY od.product_id ; 
	
END;
$$ LANGUAGE plpgsql;

SELECT * FROM  price_and_total_quantity_sold(5) ; 

------------------------------------------------------------
-- A function that takes customer_id and returns the average amount the customer spends per order.

CREATE OR REPLACE FUNCTION avg_per_order(id integer)
RETURNS numeric
AS
$$
DECLARE total_amount NUMERIC ; 
BEGIN

    SELECT ROUND(AVG(o.total_amount),2)
	into total_amount
    FROM orders o
    WHERE o.customer_id = id;

	RETURN total_amount;
END;
$$LANGUAGE plpgsql ; 

SELECT avg_per_order(60) ; 
------------------------------------------------------------
-- A function without parameters that returns customer_id and customer_name of the customer with the highest number of orders.

CREATE OR REPLACE FUNCTION customer_with_most_orders()
RETURNS TABLE(customer_id integer, customer_name VARCHAR(100))
AS 
$$
BEGIN
    RETURN QUERY
    SELECT c.customer_id,
           c.customer_name
    FROM orders o
    JOIN customer c ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY COUNT(*) DESC
    LIMIT 1;
	
END
$$LANGUAGE plpgsql ; 

SELECT * FROM customer_with_most_orders() ; 

------------------------------------------------------------
-- A function that takes month and year and returns the number of orders placed in that month.

CREATE OR REPLACE FUNCTION total_order_by_month_year(month integer, year integer)
RETURNS integer
AS 
$$
DECLARE total_orders INT ;
BEGIN
    SELECT COUNT(*) 
	INTO total_orders
    FROM orders
    WHERE EXTRACT(month FROM order_date) = month
      AND EXTRACT(year FROM order_date) = year;

	RETURN total_orders ; 
END
$$LANGUAGE plpgsql;

SELECT total_order_by_month_year(9,2025) ;

------------------------------------------------------------
-- A function that takes order_id and returns the number of distinct products in the order.

CREATE OR REPLACE FUNCTION total_products_per_order(id integer)
RETURNS integer
AS 
$$
DECLARE total_products INT ;  
BEGIN

    SELECT COUNT(*) 
	INTO total_products
    FROM order_details od
    WHERE od.order_id = id;

	RETURN total_products;
	
END
$$LANGUAGE plpgsql;

SELECT total_products_per_order(6) ; 

------------------------------------------------------------
-- A function that takes category_id and returns the total sales (quantity × price) for that category.

CREATE OR REPLACE FUNCTION total_sales_by_category(id integer)
RETURNS numeric
AS 
$$
DECLARE total_sales NUMERIC ; 
BEGIN

    SELECT SUM(od.unit_price*od.quantity)
	INTO total_sales
    FROM order_details od
    JOIN product p ON od.product_id = p.product_id
    WHERE p.category_id = id;

	RETURN total_sales;
	
END
$$LANGUAGE plpgsql;

SELECT total_sales_by_category(6) ; 
------------------------------------------------------------
-- A function that takes year and returns the total sales in that year.

CREATE OR REPLACE FUNCTION total_sales_per_year(year integer)
RETURNS numeric
AS 
$$
DECLARE total_sales NUMERIC ;

BEGIN

	SELECT SUM(amount_paid)
	INTO total_sales
	FROM payment
	WHERE status = 'Completed'
	  AND EXTRACT(year FROM payment_date)=year ; 
    

	RETURN total_sales ; 

END
$$LANGUAGE 'plpgsql';

SELECT total_sales_per_year(2025) ; 

------------------------------------------------------------

-- A function that takes product_id and returns a Boolean (TRUE/FALSE) depending on whether stock > 0.

CREATE OR REPLACE FUNCTION is_in_stock (id INT)
RETURNS BOOLEAN 
AS 
$$
DECLARE in_stock BOOLEAN;
BEGIN

    SELECT CASE WHEN p.stock_quantity > 0 THEN TRUE
           ELSE FALSE END
    INTO in_stock
    FROM product p
    WHERE p.product_id = id;

    IF in_stock IS NULL THEN
        RETURN FALSE;
    END IF;

    RETURN in_stock;
	
END;
$$ LANGUAGE plpgsql;

SELECT is_in_stock(96) ; 