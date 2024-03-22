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