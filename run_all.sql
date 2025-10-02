-- =====================================================
-- Master Script for E-Commerce Project
-- =====================================================

-- 1. Create tables

\i schema/create_tables.sql

-- =====================================================
-- 2. Load CSV data
-- =====================================================

-- Load customers
\copy customer(customer_id, customer_name, email, phone, created_at) FROM 'data/customers.csv' HEADER DELIMITER ',' CSV;

-- Load address
\copy address(address_id, street, city, country, zip_code, customer_id) FROM 'data/addresses.csv' HEADER DELIMITER ',' CSV;

-- Load orders
\copy orders(order_id, order_date, status, total_amount, customer_id) FROM 'data/orders.csv' HEADER DELIMITER ',' CSV ;

-- Load category
\copy category(category_id, category_name) FROM 'data/categories.csv' HEADER DELIMITER ',' CSV ;

-- Load product
\copy product(product_id, product_name, description, price, stock_quantity, category_id) FROM 'data/products.csv' HEADER DELIMITER ',' CSV ;

-- Load order_details
\copy order_details(product_id, order_id, unit_price, quantity)FROM 'data/order_details.csv' HEADER DELIMITER ',' CSV ;

-- Load shipping
\copy shipping(shipping_id, shipping_date, delivery_date, status, order_id, address_id) FROM 'data/shippings.csv' HEADER DELIMITER ',' CSV ;

-- Load payment
\copy payment(payment_id, payment_date, amount_paid, "method", status, order_id) FROM 'data/payments.csv' HEADER DELIMITER ',' CSV ;

-- 3. Run query scripts 

\i Queries/select_queries.sql
\i Queries/views.sql 

-- 4. Run Functions

\i Functions_Procedures_triggers/functions.sql

-- 5. Run Procedures 

\i Functions_Procedures_triggers/procedures.sql

-- 5. Run Triggers 

\i Functions_Procedures_triggers/triggers.sql

-- 6. Run Indexes

\i Optimization/indexes_and_optimization.sql 















