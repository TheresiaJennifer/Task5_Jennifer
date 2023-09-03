create table shipping_summary (
	summary_id serial primary key, 
	shipping_date date, 
	seller_name varchar(255),
	buyer_name varchar(255),
	buyer_address varchar(255),
	buyer_city varchar(255),
	zipcode bigint,
	kode_resi varchar(50)
);

insert into shipping_summary (shipping_date, seller_name, buyer_name,
							  buyer_address, buyer_city, zipcode, kode_resi)
select shipping_date, seller_name, buyer_name, buyer_table.address, buyer_table.city, zipcode, 
		cast(concat(TO_CHAR(shipping_table.shipping_id,'fm00000'), 
			  TO_CHAR(purchase_date, 'yyyymmdd'),
			  TO_CHAR(shipping_date, 'yyyymmdd'), 
			  TO_CHAR(buyer_table.buyer_id,'fm000'), 
			  TO_CHAR(seller_table.seller_id,'fm000'))
			as varchar)
from shipping_table inner join buyer_table 
on shipping_table.buyer_id = buyer_table.buyer_id inner join seller_table
on shipping_table.seller_id = seller_table.seller_id
where shipping_date >= '20221201' and shipping_date <= '20221231';

select * from shipping_summary;

copy public."shipping_summary" to 'D:\shipping_summary.csv' delimiter ',' csv header;