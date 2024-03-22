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
