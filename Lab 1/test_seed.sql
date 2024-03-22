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

set	@avg_rating=0;
call get_average_rating(3,@avg_rating);
select @avg_rating as res_avg;

call get_sale_per_category(2);
call set_product_category(4,3);
call set_product_category(2,2);
call set_product_category(6,1);

call insert_into_change_log("Nafisa Maliyat", "006_test_seed.sql", 
"Seeded the db with test data for debugging");