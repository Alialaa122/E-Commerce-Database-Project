------------------------------------------------------------
					-- Procedures
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_stock( p_product_id integer, p_quantity integer)
AS 
$$
BEGIN

    UPDATE product
	SET stock_quantity= stock_quantity+p_quantity
	WHERE product_id=p_product_id ; 

	IF p_quantity < 0 THEN 
	RAISE EXCEPTION 'p_quantity should be greater than zero ' ; 
	END IF ; 

	RAISE NOTICE 'Stock Updated Successfully for product %',p_product_id ; 

END ; 
$$ LANGUAGE plpgsql;

CALL add_stock(3,20) ;
CALL add_stock(7,-5) ;

------------------------------------------------------------
CREATE OR REPLACE PROCEDURE delete_order(p_order_id INT) 
AS 
$$ 
BEGIN 

    DELETE FROM order_details WHERE order_id=p_order_id ;
    DELETE FROM orders WHERE order_id=p_order_id ;
    RAISE NOTICE ' order with id = % deleted successfully ',p_order_id ;
	
END; 
$$ LANGUAGE plpgsql; 

-- i forced to change fk constraint so when i remove order_id row it also removes rows from other connected tables
ALTER TABLE shipping

DROP CONSTRAINT shipping_order_id_fkey ; 

ALTER TABLE shipping 

ADD CONSTRAINT shipping_order_id_fkey FOREIGN KEY (order_id) 
REFERENCES orders(order_id) ON DELETE CASCADE ;

ALTER TABLE payment 
DROP CONSTRAINT payment_order_id_fkey ;  

ALTER TABLE payment 
ADD CONSTRAINT payment_order_id_fkey FOREIGN KEY (order_id) 
REFERENCES orders(order_id) ON DELETE CASCADE ;


CALL delete_order(59) ;

------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sold_quantity( p_product_id integer,p_sold_quantity integer)
AS 
$$
BEGIN 

    UPDATE product 
	SET stock_quantity = stock_quantity - p_sold_quantity
	WHERE product_id = p_product_id ; 

    RAISE NOTICE 'stock_quantity updated successfully' ; 
	
END ; 
$$ LANGUAGE plpgsql;

CALL sold_quantity(5,6) ; 


------------------------------------------------------------

CREATE OR REPLACE PROCEDURE update_status (p_order_id INTEGER,p_new_status VARCHAR(50))
AS
$$
BEGIN 

    UPDATE orders 
	SET status = p_new_status
	WHERE order_id = p_order_id ; 

	IF p_new_status NOT IN ('Delivered','Cancelled', 'Pending') THEN 
	   RAISE EXCEPTION 'Invalid status: % (must be Delivered, Cancelled, or Pending) ', p_new_status ; 
	END IF ; 

	RAISE NOTICE ' Order % updated to status= % ', p_order_id , p_new_status ; 
	    
END;
$$ LANGUAGE plpgsql;

CALL update_status(3,'Delivered') ; 

