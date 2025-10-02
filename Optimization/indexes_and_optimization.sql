----------------------------------------------------------
					-- Indexes
----------------------------------------------------------

CREATE INDEX idx_orders_customer_id ON orders(customer_id);

EXPLAIN ANALYZE 
SELECT *
FROM orders
WHERE customer_id = 11 ; 

-- BEFORE INDEX execution_time = 0.213 ms
-- AFTER INDEX execution_time = 0.048 ms

----------------------------------------------------------

CREATE INDEX idx_order_details_order_id ON order_details(order_id) ; 


EXPLAIN ANALYZE 
SELECT * 
FROM order_details
WHERE order_id = 99 ; 

-- BEFORE INDEX execution_time = 0.430 ms
-- AFTER INDEX execution_time = 0.045 ms

-----------------------------------------------------------