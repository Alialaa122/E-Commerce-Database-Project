------------------------------------------------------------
						-- Triggers
------------------------------------------------------------
-- Update stock after ordering 

CREATE OR REPLACE FUNCTION update_stock_after_order()
RETURNS TRIGGER 
AS 
$$
BEGIN
    UPDATE product
	SET stock_quantity=stock_quantity-NEW.quantity
	WHERE product_id=NEW.product_id;

	RETURN NEW;
END ; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_update_stock
AFTER INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_order();

-- TRY Trigger 

INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (3002, 5, CURRENT_DATE, 'Pending', 250);

INSERT INTO order_details (order_id, product_id, quantity, unit_price)
VALUES (3002, 1, 3, 500);

SELECT * FROM product WHERE product_id = 1 ; 
------------------------------------------------------------
-- Log deleted products

CREATE TABLE deleted_products(

product_id INT ,
product_name VARCHAR(100),
deleted_at TIMESTAMP 

) ;

CREATE OR REPLACE FUNCTION log_deleted_products()
RETURNS TRIGGER
AS
$$
BEGIN

    INSERT INTO deleted_products(product_id,product_name,deleted_at)
    VALUES(OLD.product_id,OLD.product_name,NOW()) ; 
	RETURN OLD ; 
	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_deleted_products
AFTER DELETE ON product
FOR EACH ROW 
EXECUTE FUNCTION log_deleted_products() ;


ALTER TABLE order_details
DROP CONSTRAINT order_details_product_id_fkey;

ALTER TABLE order_details
ADD CONSTRAINT order_details_product_id_fkey FOREIGN KEY (product_id)
REFERENCES product(product_id) ON DELETE CASCADE ; 

DELETE FROM product WHERE product_id = 5 ; 

SELECT * 
FROM deleted_products ; 
------------------------------------------------------------
-- Prevent deleting customer if they have orders

CREATE OR REPLACE FUNCTION prevent_deleteing_customer()
RETURNS TRIGGER
AS
$$
DECLARE total_orders INT;
BEGIN
    SELECT COUNT(*)
	INTO total_orders
	FROM orders 
	WHERE customer_id=OLD.customer_id ; 

	IF total_orders > 0 THEN 
	RAISE EXCEPTION 'This customer has orders and cannot be deleted';
	END IF ; 

	RETURN OLD;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_prevent_deleting_customer
BEFORE DELETE ON customer
FOR EACH ROW 
EXECUTE FUNCTION prevent_deleteing_customer();

DELETE FROM customer WHERE customer_id = 5; 

------------------------------------------------------------
-- Log updates on orders (status changes)

CREATE TABLE order_log(
order_id INT,
old_status VARCHAR(20),
new_status VARCHAR(20),
updated_at TIMESTAMP
) ; 

CREATE OR REPLACE FUNCTION load_new_status_to_log()
RETURNS TRIGGER 
AS
$$
BEGIN

    IF OLD.status IS DISTINCT FROM NEW.status THEN 
		INSERT INTO order_log (order_id,old_status,new_status,updated_at)
		VALUES(OLD.order_id,OLD.status,NEW.status,NOW()) ; 
	END IF ; 

	RETURN NEW ; 
	
END ; 
$$ LANGUAGE plpgsql ; 

CREATE OR REPLACE TRIGGER trg_change_status
AFTER UPDATE  ON orders
FOR EACH ROW 
EXECUTE FUNCTION load_new_status_to_log();

UPDATE orders
SET status = 'Delivered'
WHERE order_id = 5  ; 

SELECT * 
FROM order_log ; 

------------------------------------------------------------
-- prevent inserting a new order into the orders table if the order’s total_amount is less than 100.

CREATE OR REPLACE FUNCTION no_orders_less_than_100 ()
RETURNS TRIGGER
AS
$$
BEGIN

    IF NEW.total_amount <= 100 THEN 
	   RAISE EXCEPTION 'Order should be more than 100 ' ; 
	END IF ;

	RETURN NEW ; 

END ; 
$$ LANGUAGE plpgsql ; 



CREATE OR REPLACE TRIGGER trg_no_orders_less_than_100
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION no_orders_less_than_100 () ;

INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (3004, 10, CURRENT_DATE, 'Pending', 180);

SELECT *
FROM orders
WHERE customer_id=10 ;

------------------------------------------------------------

-- Auto-update total_amount when new order_detail is inserted

CREATE OR REPLACE FUNCTION change_total_amount_auto()
RETURNS TRIGGER
AS
$$

BEGIN

     UPDATE orders
	 SET total_amount=total_amount+(NEW.quantity*NEW.unit_price)
	 WHERE order_id=NEW.order_id ; 
	 
	 RETURN NEW ; 
		
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_change_total_amount
AFTER INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION change_total_amount_auto() ; 



INSERT INTO order_details (product_id,order_id,unit_price,quantity)
VALUES(921,31,1918.53,2) ;

SELECT *
FROM orders
WHERE order_id=31 ; 
---------------------------------------------------------------------
-- prevents updating an order’s status from "Delivered" to any other status.

CREATE OR REPLACE FUNCTION prevent_change_delivered_status()
RETURNS TRIGGER 
AS
$$
BEGIN
    IF OLD.status='Delivered' AND OLD.status <> NEW.status THEN 
	   RAISE EXCEPTION 'order_status cannot change from Delivered';
	END IF ; 

	RETURN NEW ; 
END ; 
$$ LANGUAGE plpgsql ; 

CREATE OR REPLACE TRIGGER trg_prevent_change_delivered_status
BEFORE UPDATE ON orders
FOR EACH ROW 
EXECUTE FUNCTION prevent_change_delivered_status() ; 

UPDATE orders
SET status = 'Delivered'
WHERE order_id = 5 ;

SELECT *
FROM orders
WHERE order_id = 5 ;