use texture_tales;
--  the total quantity sold for all products
select sum(qty) as Total_qty_sold
from sales;

-- Total quantity sold for each products
select product_name,prod_id,sum(qty) as Total_qty_sold
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by prod_id
order by Total_qty_sold desc;

-- Total generated revenue for all products before discounts
select sum(qty*price) as Total_revenue
from sales;

-- Total generated revenue for each products before discounts
select product_name,prod_id,sum(sales.qty*sales.price) as revenue
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by prod_id
order by revenue desc;

-- Total discount amount for all products
select sum(qty*price*discount)/100 as Total_discount_amount
from sales;

-- Total discount amount for each products
select prod_id,sum(qty*price*discount)/100 as Discount_amount
from sales
group by prod_id;

-- Number of unique transactions made
select count(distinct txn_id) as unique_transation
from sales;

-- What are the average unique products purchased in each transaction
with cte_transaction_products as(
select txn_id,count(distinct prod_id) as product_count from sales 
group by txn_id)

select round(avg(product_count)) as avg_unique_products
from cte_transaction_products;

-- Average Discount value per transaction
with cte_discount_transaction as(
select txn_id,sum(qty*price*discount)/100 as discount_value 
from sales
group by txn_id)

select round(avg(discount_value)) as avg_discount_value
from cte_discount_transaction;

-- Average revenue for member transaction and non member transactions

with cte_member_revenue as(
select member,txn_id,sum(qty*price) as Total_revenue 
from sales
group by member,txn_id)

select member,round(avg(Total_revenue)) as Revenue
from cte_member_revenue
group by member;

-- Top 3 products by total revenue before discount
select product_details.product_name,prod_id,sum(sales.qty*sales.price) as Total_revenue
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by prod_id
order by Total_revenue desc
limit 3 ;

-- The total quantity, revenue and discount for each segment
select product_details.segment_id,product_details.segment_name as Segment ,
sum(sales.qty) as Total_quantity,
sum(sales.qty*sales.price) as Total_revenue,
sum(sales.qty*sales.price*sales.discount)/100 as Total_discount
from sales inner join product_details 
on sales.prod_id = product_details.product_id
group by product_details.segment_name,product_details.segment_id;

-- Top selling product for each segment
select product_details.segment_id as Segment_id ,
product_details.segment_name as Segment, product_details.product_name as Product_name ,
product_details.product_id as Product_id,
sum(sales.qty) as Total_sales_quantity
from sales inner join product_details 
on sales.prod_id = product_details.product_id
group by product_details.segment_name,product_details.segment_id,
		 product_details.product_id,product_details.product_name
order by Total_sales_quantity desc
limit 5;

-- The total quantity, revenue and discount for each category
select category_name,
category_id,sum(qty) as Total_quantity,
sum(sales.qty*sales.price) as Total_revenue, 
sum(sales.qty*sales.price*sales.discount)/100 as Total_discount 
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by category_id,category_name;

--  Top selling product for each category
select product_details.category_id as category_id,
	   product_details.category_name as category_name,
       product_details.product_id as product_id,
       product_details.product_name as product_name,
       sum(sales.qty) as sales_qty
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by product_details.category_id,
		 product_details.category_name,
         product_details.product_id,
	     product_details.product_name
order by sales_qty desc;







