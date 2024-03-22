DROP DATABASE IF EXISTS reporting_db_kids_shop;
CREATE DATABASE reporting_db_kids_shop;

USE reporting_db_kids_shop;

CREATE TABLE dimension_product 
AS 
SELECT id, name, category_id, average_rating, SaleCount
FROM kids_shop.product;
alter table dimension_product
add constraint primary key pk_product (id);

CREATE TABLE dimension_category
AS 
SELECT id, name, AverageRating, TotalSale
FROM kids_shop.category;
alter table dimension_category
add constraint primary key pk_category (id);

CREATE TABLE dimension_rating
AS 
SELECT id, product_id, rating, rating_timestamp
FROM kids_shop.rating;
alter table dimension_rating
add constraint primary key pk_rating(id);

CREATE TABLE dimension_employee
select id, name
FROM kids_shop.employee;
alter table dimension_employee
add constraint primary key pk_employee (id);

CREATE TABLE fact_sale 
AS 
SELECT id, ProductId, SellerId, CategoryId, UnitPrice, Count, sale_timestamp
FROM kids_shop.sale;
alter table fact_sale
add constraint primary key pk_sale (id);

ALTER TABLE fact_sale 
ADD CONSTRAINT fk_product_sale
FOREIGN KEY (ProductId) REFERENCES dimension_product(id);
ALTER TABLE fact_sale 
ADD CONSTRAINT fk_employee_sale
FOREIGN KEY (SellerId) REFERENCES dimension_employee(id);
ALTER TABLE fact_sale 
ADD CONSTRAINT fk_category_sale
FOREIGN KEY (CategoryId) REFERENCES dimension_category(id);