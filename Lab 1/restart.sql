drop database kids_shop; 

/*
-- CLEAN UP
-- run the following lines to clean up the database
drop table category;
drop table product;
drop table vote;
*/

/*
If you already have the database, do not run the next two lines
*/
create database kids_shop;
use kids_shop;


-- ======================================CHANGE LOG
create table change_log(
    id int not null auto_increment primary key,
    applied_at timestamp not null,
    created_by varchar(100) not null,
    script_name varchar(50) not null,
    script_details varchar(200) not null
);

DROP PROCEDURE IF EXISTS insert_into_change_log;
DELIMITER //
CREATE PROCEDURE insert_into_change_log(
IN p_created_by varchar(100), IN p_script_name varchar(50), in p_script_details varchar(200)
)
BEGIN
    insert into change_log(applied_at, created_by, script_name, script_details)
    values(NOW(), p_created_by, p_script_name, p_script_details);
END;
//
DELIMITER ;

call insert_into_change_log("Nafisa Maliyat", "000_init_schema.sql", "created change_log_table");


-- ====================================DB INIT 
create table category (
    id int not null auto_increment primary key,
    name varchar(100)
);

create table product (
    id int not null auto_increment primary key,
    name varchar(100),
    category_id int not null,
    votes int not null default 0
);


create table vote (
    id int not null auto_increment primary key,
    product_id int not null,
    is_up_vote bit
);

delimiter //
create procedure recalculate_product_votes()
begin
    update product p
        set votes =
            (select count(*) from vote where product_id = p.id and is_up_vote = true)
            - (select count(*) from vote where product_id = p.id and is_up_vote = false)
    where 1 = 1;
end;//
delimiter ;

call insert_into_change_log("Nafisa Maliyat", "001_db_init.sql", 
"Created category, product and vote table. Created procedure recalculate_product_votes to update vote in 
product table");

-- ====================================DB SEED
use kids_shop;

insert into category (name) values
    ('toys'),
    ('cloths'),
    ('diaper');

insert into product (name, category_id) values
    ('light ball', 1),
    ('blocks', 1),
    ('cool red shirt', 2),
    ('long blue skirt', 2),
    ('nice green pants', 2),
    ('kids comfi', 3);

insert into vote(product_id, is_up_vote) values
    (1, true),
    (1, true),
    (1, false),
    (2, false),
    (2, false),
    (3, true),
    (3, true),
    (5, false),
    (5, true),
    (5, true),
    (5, true);

call recalculate_product_votes(); 

call insert_into_change_log("Nafisa Maliyat", "002_db_init_seed.sql", 
"Populated category, vote and product table. Called recalculate_product_votes procedure to update vote in product table");


-- =======================================33
use kids_shop;
alter table vote rename rating;
alter table rating add rating int;

update rating set rating = case 
when is_up_vote = 1 then 5
when is_up_vote = 0 then 1 end;
alter table product change votes average_rating float not null default 0;


DROP PROCEDURE IF EXISTS recalculate_product_average_rating;
delimiter //
create procedure recalculate_product_average_rating()
begin
    update product p
        set average_rating =
            round(ifnull((select avg(rating) from rating where product_id = p.id),0),1)
    where 1 = 1;
end;//
delimiter ;

call recalculate_product_average_rating();
call insert_into_change_log("Nafisa Maliyat", "003_33.sql", 
"Changed vote to average_rating in product table and added rating in rating table. Created procedure recalculate_product_average_rating
to update the average_rating in product according to vote");

-- ====================================TASK A1
use kids_shop;

create table customer(
    id int not null auto_increment primary key,
    name varchar(50)
);

alter table rating add rating_timestamp timestamp;
alter table rating add RaterId int;

call insert_into_change_log("Nafisa Maliyat", "003_task_a1.sql", 
"Added customer table. Added redundant columns rating timestamp and rater id to rating table");

-- ================================TASK A2
use kids_shop;

create table employee (
    id int not null auto_increment primary key,
    name varchar(50)
);

create table invoice (
    id int not null auto_increment primary key,
	CustomerId int not null,
    SellerId int not null,
    invoice_timestamp timestamp,
    foreign key (CustomerId) references customer(id),
    foreign key (SellerId) references employee(id)
);

create table sale (
    id int not null auto_increment primary key,
	ProductId int not null,
    InvoiceId int not null,
    UnitPrice float,
    Count int,
    foreign key (ProductId) references customer(id),
    foreign key (InvoiceId) references invoice(id)
);


call insert_into_change_log("Nafisa Maliyat", "004_task_a2.sql", 
"Created employee, invoice and sale table");

-- ================================TASK B1 
USE kids_shop;

-- category
alter table category add AverageRating float;
alter table rating drop is_up_vote;

-- invoice
alter table invoice add TotalPrice float;

-- sale
alter table sale add sale_timestamp timestamp;

DROP PROCEDURE IF EXISTS add_rating;
DELIMITER //
CREATE PROCEDURE add_rating(IN p_productId INT, IN p_ratingValue INT, IN p_customerId INT)
BEGIN
	declare v_categoryId INT;
    INSERT INTO rating(product_id, rating, rating_timestamp, RaterId) 
    VALUES(p_productId, p_ratingValue, NOW(), p_customerId);
    UPDATE product p
    SET average_rating = 
        ROUND((SELECT IFNULL(AVG(rating), 0) FROM rating WHERE product_id = p.id), 1)
    WHERE p.id = p_productId;
    
    select category_id into v_categoryId from product where id = p_productId;
	update category c
    set c.AverageRating = ROUND((SELECT IFNULL(AVG(rating), 0) FROM rating WHERE product_id = p_productId), 1)
    where c.id = v_categoryId;
END;
//
DELIMITER ;

DROP PROCEDURE IF EXISTS get_average_rating;
DELIMITER //
CREATE PROCEDURE get_average_rating(IN p_productId INT, OUT p_averageRating FLOAT)
BEGIN
    SELECT ROUND(IFNULL(AVG(rating), 0), 1) INTO p_averageRating
    FROM rating
    WHERE product_id = p_productId;
END;
//
DELIMITER ;

call insert_into_change_log("Nafisa Maliyat", "005_task_b1.sql", 
"Added redundant columns category, invoice and sale table to find top n products by average rating. Added 
procedures add_rating and get_average_rating for data inconsistency");

-- ============================TASK B2 
USE kids_shop;

alter table category add TotalSale float;
-- product
alter table product add SaleCount int;

ALTER TABLE sale 
ADD COLUMN SellerId int, 
ADD CONSTRAINT employee_sale_fk 
FOREIGN KEY (SellerId) 
REFERENCES employee(id); 

ALTER TABLE sale 
ADD COLUMN CategoryId int, 
ADD CONSTRAINT category_sale_fk 
FOREIGN KEY (CategoryId) 
REFERENCES category(id); 

DROP PROCEDURE IF EXISTS add_sale;
DELIMITER //

CREATE PROCEDURE add_sale(
    IN p_sellerId INT,
    IN p_productId INT,
    IN p_customerId INT,
    IN p_unitPrice FLOAT,
    IN p_count INT
)
BEGIN 
    DECLARE v_invoiceId INT;
    DECLARE v_timestamp_now TIMESTAMP;
    DECLARE v_categoryId INT;
    DECLARE v_totalSale FLOAT;
    
    
    SET v_timestamp_now = NOW();
    
    INSERT INTO invoice(CustomerId, SellerId, invoice_timestamp, TotalPrice) 
    VALUES (p_customerId, p_sellerId, v_timestamp_now, p_count * p_unitPrice);
    
    SELECT id INTO v_invoiceId 
    FROM invoice 
    WHERE invoice_timestamp = v_timestamp_now 
    ORDER BY id DESC 
    LIMIT 1;
    
    SELECT category_id INTO v_categoryId FROM product WHERE id = p_productId;
    
    INSERT INTO sale(ProductId, InvoiceId, UnitPrice, Count, SellerId, CategoryId, sale_timestamp) 
    VALUES (p_productId, v_invoiceId, p_unitPrice, p_count, p_sellerId, v_categoryId, NOW());
    
    select IFNULL(TotalSale, 0) into v_totalSale from category where id = v_categoryId;
    
    UPDATE category 
    SET TotalSale = v_totalSale + (p_unitPrice * p_count) 
    WHERE id = v_categoryId;
    
    UPDATE product 
    SET SaleCount = IFNULL(SaleCount, 0) + 1
    WHERE id = p_productId;
END;
//
DELIMITER ;

DROP PROCEDURE IF EXISTS get_sale_per_category;
DELIMITER //
CREATE PROCEDURE get_sale_per_category(IN p_employeeId INT)
BEGIN
    SELECT c.id AS category_id, SUM(s.UnitPrice * s.Count) AS total_sale
    FROM sale s 
    INNER JOIN category c ON s.CategoryId = c.id
    WHERE s.SellerId = p_employeeId
    GROUP BY c.id;
END;
//
DELIMITER ;

DROP PROCEDURE IF EXISTS set_product_category;
DELIMITER //
CREATE PROCEDURE set_product_category(IN p_productId INT, IN p_categoryId INT)
BEGIN
    UPDATE product p 
    SET category_id = p_categoryId
    WHERE p.id = p_productId;
    
    UPDATE sale s
    SET s.CategoryId = p_categoryId
    WHERE s.ProductId = p_productId;
    
	UPDATE product p
	SET average_rating = (
    SELECT ROUND(IFNULL(AVG(rating), 0), 1)
    FROM rating
    WHERE product_id = p.id);
    
    update product p 
    set SaleCount = (
    select count(*) from sale
    where ProductId = p.id);
  
	update category c
    set AverageRating = (
    select round(ifnull(avg(average_rating),0),1)
    from product
    where product.category_id = c.id);
    
    update category c
    set TotalSale = (
    select sum(UnitPrice*Count) from sale 
    where CategoryId = c.id);
    
    update sale s
    set CategoryId = (select category_id from product where id = s.ProductId);
END;
//
DELIMITER ;

call insert_into_change_log("Nafisa Maliyat", "005_task_b2.sql", 
"Added redundant columns to sale, product and category table to find total sale per category for a 
given employee. Added procedures add_sale, get_sale_per_category and set_product_category");

-- =====================================TEST SEED 
use kids_shop;
INSERT INTO customer (name) VALUES ('Emma'), ('David'), ('Sophia');

INSERT INTO employee (name) VALUES ('Seller3'), ('Seller4');

-- 	   IN p_sellerId INT,
--     IN p_productId INT,
--     IN p_customerId INT,
--     IN p_unitPrice FLOAT,
--     IN p_count INT
CALL add_sale(2, 1, 1, 10.99, 3);
CALL add_sale(1, 2, 3, 15.50, 2);
CALL add_sale(1, 3, 3, 8.75, 1);
CALL add_sale(2, 1, 2, 12.25, 4);
CALL add_sale(2, 1, 1, 10.99, 3);

-- product id, rating, customer id
call add_rating(1, 3, 1);
call add_rating(2, 5, 2);
call add_rating(3, 1, 2);
call add_rating(1, 2, 3);
CALL recalculate_product_average_rating();

-- set	@avg_rating=0;
-- call get_average_rating(3,@avg_rating);
-- select @avg_rating as res_avg;

-- call get_sale_per_category(2);
call set_product_category(4,3);
call set_product_category(2,2);
call set_product_category(6,1);

call insert_into_change_log("Nafisa Maliyat", "006_test_seed.sql", 
"Seeded the db with test data for debugging");


