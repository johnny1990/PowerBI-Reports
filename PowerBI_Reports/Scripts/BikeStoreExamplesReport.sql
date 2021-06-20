use BikeStoresSampleDB

select so.order_id,so.order_status,sc.first_name+' '+sc.last_name as customer_name,
so.order_date,so.shipped_date,soi.item_id
as order_item_id,pp.product_name,soi.quantity,soi.list_price,soi.discount 
,(quantity*soi.list_price -discount*(quantity*soi.list_price)/100) as total_price
from sales.orders so
inner join sales.order_items soi on soi.order_id = so.order_id
inner join sales.customers sc on sc.customer_id =so.customer_id
inner join sales.staffs ss on ss.staff_id = so.staff_id
inner join production.products pp on pp.product_id = soi.product_id
where order_date >= '2016-01-01'
order by so.order_id asc
