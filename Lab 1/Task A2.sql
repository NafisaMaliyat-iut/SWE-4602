-- ================================TASK A2
use kids_shop;

create table employee (
    id int not null auto_increment primary key,
    name varchar(50)
);

create table invoice (
    id int not null auto_increment primary key,
	CustomerId int not null,
    SellerId int not null,
    invoice_timestamp timestamp,
    foreign key (CustomerId) references customer(id),
    foreign key (SellerId) references employee(id)
);

create table sale (
    id int not null auto_increment primary key,
	ProductId int not null,
    InvoiceId int not null,
    UnitPrice float,
    Count int,
    foreign key (ProductId) references customer(id),
    foreign key (InvoiceId) references invoice(id)
);


call insert_into_change_log("Nafisa Maliyat", "004_task_a2.sql", 
"Created employee, invoice and sale table");
