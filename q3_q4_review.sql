create table promo_code (
	promo_id serial primary key,
	promo_name varchar(255),
	price_deduction bigint,
	Description varchar(255),
	Duration int
);

create table q3_q4_review (
	review_id serial primary key,
	sales_id int,
	purchase_date date, 
	item_name varchar(255),
	promo_code int,
	promo_name varchar(255),
	total_price bigint,
	price_after_promo bigint,
	quantity int
)

insert into q3_q4_review (sales_id, purchase_date, total_price, item_name, quantity, promo_code)
select sales_id, purchase_date, quantity*price, item_name, quantity, sales_table.promo_id
from sales_table inner join marketplace_table
on sales_table.item_id = marketplace_table.item_id
where purchase_date >= '20220701' and purchase_date <= '20221231';

update q3_q4_review
set promo_name = promo_code.promo_name 
from promo_code
where q3_q4_review.promo_code = promo_code.promo_id;

update q3_q4_review
set price_after_promo = q3_q4_review.total_price - 
(select promo_code.price_deduction 
from promo_code where q3_q4_review.promo_code = promo_code.promo_id)
from promo_code
where purchase_date = purchase_date and item_name = item_name;

copy public."q3_q4_review" to 'D:\q3_q4_review.csv' delimiter ',' csv header;

select sum(price_after_promo) from q3_q4_review
where price_after_promo >= 0;

