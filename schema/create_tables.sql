--  Tables Creation 

CREATE TABLE customer (
 customer_id INTEGER PRIMARY KEY ,
 customer_name VARCHAR(100),
 email TEXT UNIQUE ,
 phone TEXT,
 created_at DATE 
);

CREATE TABLE address (
 address_id INTEGER PRIMARY KEY ,
 street TEXT,
 city TEXT,
 country TEXT,
 zip_code VARCHAR(20),
 customer_id INTEGER NOT NULL REFERENCES customer(customer_id)
);


CREATE TABLE orders (
 order_id INTEGER PRIMARY KEY ,
 order_date DATE,
 status VARCHAR(50) ,
 total_amount DECIMAL(10,2),
 customer_id INTEGER NOT NULL REFERENCES customer(customer_id) 
) ;

ALTER TABLE orders
ADD CONSTRAINT check_status CHECK (status IN ('Pending','Processing','Delivered','Cancelled'));

CREATE TABLE category (
 category_id INTEGER PRIMARY KEY ,
 category_name VARCHAR(100) 
) ;

CREATE TABLE product (
 product_id INTEGER PRIMARY KEY ,
 product_name VARCHAR(100),
 description TEXT,
 price DECIMAL(10,2),
 stock_quantity INTEGER ,
 category_id INTEGER NOT NULL REFERENCES category(category_id) 
) ;

CREATE TABLE order_details (
 product_id INTEGER NOT NULL REFERENCES product(product_id),
 order_id INTEGER NOT NULL REFERENCES orders(order_id),
 unit_price DECIMAL(10,2),
 quantity INTEGER ,
 PRIMARY KEY(product_id,order_id)
) ;

CREATE TABLE shipping (
 shipping_id INTEGER PRIMARY KEY ,
 shipping_date DATE,
 delivery_date DATE,
 status VARCHAR(50),
 order_id INTEGER NOT NULL REFERENCES orders(order_id) ,
 address_id INTEGER NOT NULL REFERENCES address(address_id) 
) ;


CREATE TABLE payment (
 payment_id INTEGER PRIMARY KEY ,
 payment_date DATE,
 amount_paid DECIMAL(10,2),
 "method" VARCHAR(50),
 status VARCHAR(50),
 order_id INTEGER NOT NULL REFERENCES orders(order_id) 
);

ALTER TABLE payment
ADD CONSTRAINT check_payment_status CHECK (status IN ('Pending','Completed','Failed'));


