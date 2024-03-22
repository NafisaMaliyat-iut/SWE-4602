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

-- ===========================stored query
delimiter //

create procedure get_top_3_products()
begin
    select p.id, p.name, sum(s.UnitPrice * s.Count) as total_sales
    from dimension_product p
    inner join fact_sale s on p.id = s.productid
    group by p.id, p.name
    order by total_sales desc
    limit 3;
end//
call get_top_3_products;


create procedure get_top_2_categories()
begin
    select c.id, c.name, sum(s.UnitPrice * s.Count) as total_sales
    from dimension_category c
    inner join fact_sale s on c.id = s.categoryid
    group by c.id, c.name
    order by total_sales desc
    limit 2;
end//
call get_top_2_categories();

create procedure get_top_product_by_duration(
    in start_date date,
    in end_date date
)
begin
    select p.id, p.name, p.average_rating
    from dimension_product p
    inner join fact_sale s on p.id = s.productid
    where s.sale_timestamp between start_date and end_date
    order by p.average_rating desc
    limit 1;
end//
call get_top_product_by_duration('2024-01-01', '2024-02-16');


create procedure get_top_product_by_category(
    in category_id int
)
begin
    select p.id, p.name, p.average_rating
    from dimension_product p
    inner join fact_sale s on p.id = s.productid
    where s.categoryid = category_id
    order by p.average_rating desc
    limit 1;
end//
call get_top_product_by_category(1);

create procedure get_top_employee_by_duration(
    in start_date date,
    in end_date date
)
begin
    select sellerid, sum(UnitPrice * Count) as total_sales
    from fact_sale
    where sale_timestamp between start_date and end_date
    group by sellerid
    order by total_sales desc
    limit 1;
end//
delimiter ;
call get_top_employee_by_duration('2024-01-01', '2024-02-16');





	