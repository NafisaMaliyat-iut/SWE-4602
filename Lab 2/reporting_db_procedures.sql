-- ===========================stored query
USE reporting_db_kids_shop;

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


create or replace procedure get_top_2_categories()
begin
    select c.id, c.name, sum(s.UnitPrice * s.Count) as total_sales
    from dimension_category c
    inner join fact_sale s on c.id = s.categoryid
    group by c.id, c.name
    order by total_sales desc
    limit 2;
end//
call get_top_2_categories();

create or replace procedure get_top_product_by_duration(
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


create or replace procedure get_top_product_by_category(
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

create or replace procedure get_top_employee_by_duration(
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