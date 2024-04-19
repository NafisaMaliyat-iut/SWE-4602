USE reporting_db_kids_shop;
call get_top_3_products;
call get_top_2_categories();
call get_top_product_by_duration('2024-01-01', '2024-02-16');
call get_top_product_by_category(1);
call get_top_employee_by_duration('2024-02-15', '2024-02-16');
