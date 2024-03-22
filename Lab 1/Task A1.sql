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
