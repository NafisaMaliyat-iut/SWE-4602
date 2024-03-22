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
    
    INSERT INTO sale(ProductId, InvoiceId, UnitPrice, Count, SellerId, CategoryId) 
    VALUES (p_productId, v_invoiceId, p_unitPrice, p_count, p_sellerId, v_categoryId);
    
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
    
    
END;
//
DELIMITER ;

call insert_into_change_log("Nafisa Maliyat", "005_task_b2.sql", 
"Added redundant columns to sale, product and category table to find total sale per category for a 
given employee. Added procedures add_sale, get_sale_per_category and set_product_category");
