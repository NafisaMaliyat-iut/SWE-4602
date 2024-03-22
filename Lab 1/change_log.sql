create table change_log(
    id int not null auto_increment primary key,
    applied_at timestamp not null,
    created_by varchar(100) not null,
    script_name varchar(50) not null,
    script_details varchar(100) not null
);

DROP PROCEDURE IF EXISTS insert_into_change_log;
DELIMITER //
CREATE PROCEDURE insert_into_change_log(
IN p_created_by varchar(100), IN p_script_name varchar(50), in p_script_details varchar(100)
)
BEGIN
    insert into change_log(applied_at, created_by, script_name, script_details)
    values(NOW(), p_created_by, p_script_name, p_script_details);
END;
//
DELIMITER ;

call insert_into_change_log("Nafisa Maliyat", "insert_into_change_log.sql", "created change_log_table");
