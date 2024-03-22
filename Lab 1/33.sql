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
