#Report of Individual product sales (aggregated on a monthly basis at the product code level) for
#Croma India customer for FY-2021 so that I can track individual product sales.
-- The  report should contain the following fields
-- 1.Month
-- 2.Product Name
-- 3.Variant
-- 4.Sold Quantity
-- 5.Gross Price Per Item
-- 6.Gross Price Total
use gdb041;
select s.date,s.product_code,
       p.product,p.variant,s.sold_quantity,g.gross_price as gross_price_per_item,
       ROUND(g.gross_price * s.sold_quantity,2) as Total_gross_price
from fact_sales_monthly s
join dim_product p
	on s.product_code = p.product_code
join fact_gross_price g
    on g.product_code = p.product_code and 
       g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002 and
	  get_fiscal_year(date) = 2021
order by date asc
limit 10000;

#Aggregate monthly gross sales report for Croma India customer 
#Fields it should contain 1.Month 2.Total Gross sales amount to Croma in this month

select s.date ,sum(gross_price*sold_quantity) as monthly_gross_sales
	from fact_sales_monthly s
	join fact_gross_price g
	on s.product_code = g.product_code and 
       get_fiscal_year(s.date) = g.fiscal_year
	where customer_code =90002002 	      
	group by date
	order by date;

#Generate a yearly report for Croma India where there are two columns
#1. Fiscal Year
#2. Total Gross Sales amount In that year from Croma

select get_fiscal_year(s.date) as fiscal_year,round(sum(g.gross_price*s.sold_quantity),2) as Total_gross_sales_amount
	from fact_sales_monthly s
	join fact_gross_price g
		 on s.product_code = g.product_code
	where s.customer_code = 90002002 and 
		  g.fiscal_year = get_fiscal_year(s.date)
	group by fiscal_year
	order by fiscal_year;

#Using CTEs
with cte1 as 
(select s.date,s.product_code,
       p.product,p.variant,s.sold_quantity,
       g.gross_price as gross_price_per_item,
       ROUND(g.gross_price * s.sold_quantity,2) as Total_gross_price,
       pre.pre_invoice_discount_pct ,
       s.fiscal_year
from fact_sales_monthly s
join dim_product p
	on s.product_code = p.product_code
join fact_gross_price g
    on g.product_code = p.product_code and 
       g.fiscal_year =  s.fiscal_year
join fact_pre_invoice_deductions pre
    on pre.customer_code = s.customer_code and
       pre.fiscal_year = s.fiscal_year
where dt.fiscal_year = 2021)

select *,
   (Total_gross_price - Total_gross_price*pre_invoice_discount_pct) as net_invoice_sales
from cte1;

#Using Views
select *,
   (1 - pre_invoice_discount_pct)*Total_gross_price as net_invoice_sales,
   (po.discounts_pct + po.other_deductions_pct) as post_invoice_deductions_pct
from sales_preinv_discount s
join fact_post_invoice_deductions po
on s.date=po.date and 
   s.product_code = po.product_code and 
   s.customer_code = po.customer_code
;
#Creating Net sales View
CREATE VIEW net_sales as (
SELECT * ,
     (1-post_invoice_deductions_pct)*net_invoice_sales as net_sales
FROM gdb041.sales_postinv_discount)
#Create a view for gross sales. It should have the following columns,
#date, fiscal_year, customer_code, customer, market, product_code, product, variant,
#sold_quanity, gross_price_per_item, gross_price_total
CREATE VIEW gross_sales as 
(select s.date,s.fiscal_year,
       s.customer_code,c.customer,
       c.market,s.product_code,
       p.product,p.variant,
       s.sold_quantity,
       g.gross_price,
       round(s.sold_quantity * g.gross_price,2) as gross_price_total
from fact_sales_monthly s
join fact_gross_price g
on s.product_code = g.product_code and
   s.fiscal_year = g.fiscal_year
join dim_customer c 
on s.customer_code = c.customer_code
join dim_product p
on p.product_code = s.product_code)

# Top markets,products,customers for a given financial year
#Top markets
select 
     market, 
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln desc
limit 5;

#Top customers
select 
     c.customer, 
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales ns
join dim_customer c
on ns.customer_code = c.customer_code
where fiscal_year = 2021
group by c.customer
order by net_sales_mln desc
limit 5;

#Top products
select 
	 product,
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales ns
where fiscal_year = 2021
group by product
order by net_sales_mln desc
limit 5;

#Bar chart report for Net-sales % for the financial year 2021 for top 10 markets
with cte1 as 
(select 
	 c.customer,
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales ns
join dim_customer c
on ns.customer_code = c.customer_code
where fiscal_year = 2021 
group by c.customer
order by net_sales_mln desc)

select * ,
      (net_sales_mln*100)/sum(net_sales_mln) over() as pct_share_overall
from cte1;

#Report- pct market share based on regions
with cte1 as 
(select 
	 c.customer,c.region,
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales ns
join dim_customer c
on ns.customer_code = c.customer_code
where fiscal_year = 2021
group by c.customer,c.region
order by net_sales_mln desc)

select * ,
      (net_sales_mln*100)/sum(net_sales_mln) over(partition by region) as pct_share_overall
from cte1
order by region,net_sales_mln desc;

# Top-n products in each division by their quantity sold in a given financial year 
with cte1 as
(SELECT p.product,p.division,sum(s.sold_quantity) as qty,
       dense_rank() over(partition by division order by sum(s.sold_quantity) desc) as rnk
FROM gdb041.gross_sales s
join dim_product p
on s.product_code = p.product_code
where s.fiscal_year = 2021
group by p.product,p.division
order by p.division,qty desc)

select * 
from cte1
where rnk <= 3;


# the top 2 markets in every region by their gross sales amount in FY=2021. 

with 
cte1 as (
	select c.market,c.region,s.fiscal_year,
		   (s.sold_quantity*g.gross_price)as gross_sales_amount
	from fact_sales_monthly s
	join fact_gross_price g
	on s.product_code = g.product_code 
	   and s.fiscal_year = g.fiscal_year
	join dim_customer c
	on s.customer_code = c.customer_code
	where s.fiscal_year = 2021),
cte2 as 
	(select market,region,sum(gross_sales_amount)/1000000 as Total_gross_sales_amount
	from cte1
	group by market,region),
cte3 as 
	(select *,
		   dense_rank() over(partition by region order by Total_gross_sales_amount desc) as drnk
	from cte2)
select market,region,round(Total_gross_sales_amount,2) as gross_sales_mln
from cte3
where drnk <= 2;


# Forecast accuracy for all customers for a given fiscal year
with forecast_error_table as 
	(SELECT s.customer_code,
			sum(s.sold_quantity) as Total_sold_quantity,
            sum(s.forecast_quantity) as Total_forecast_quantity,
			sum(forecast_quantity - sold_quantity) as net_error,
			sum(forecast_quantity - sold_quantity)*100/sum(forecast_quantity) as net_error_pct,
			sum(abs(forecast_quantity - sold_quantity)) as abs_error,
			sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as abs_error_pct

	FROM gdb041.fact_act_est s
	where s.fiscal_year = 2021
	group by customer_code)
    
select 
	   e.*,
       c.customer, 
       c.market, 
	if(abs_error_pct > 100,0,100- abs_error_pct) as  forecast_accuracy
from forecast_error_table e
join dim_customer  c
using (customer_code)
order by forecast_accuracy desc ;

#report where customers’ forecast accuracy has dropped from 2020 to 2021.
#--Create a temporary table to store forecast accuracy for 2020
drop table if exists temp_2021;
create temporary table temp_2021
with forecast_error_table as 
	(SELECT s.*,
			sum(s.sold_quantity) as Total_sold_quantity,
			sum(forecast_quantity - sold_quantity) as net_error,
			sum(forecast_quantity - sold_quantity)*100/sum(forecast_quantity) as net_error_pct,
			sum(abs(forecast_quantity - sold_quantity)) as abs_error,
			sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as abs_error_pct

	FROM gdb041.fact_act_est s
	where s.fiscal_year = 2021
	group by customer_code)
    
select e.*, c.market,c.customer,
	if(abs_error_pct > 100,0,100- abs_error_pct) as  forecast_accuracy
from forecast_error_table e
join dim_customer  c
using (customer_code)
order by forecast_accuracy desc ;

#--Create 2nd temporary table to store forecast accuracy for 2021
drop table if exists temp_2020;
create temporary table temp_2020
with forecast_error_table as 
	(SELECT s.*,
			sum(s.sold_quantity) as Total_sold_quantity,
			sum(forecast_quantity - sold_quantity) as net_error,
			sum(forecast_quantity - sold_quantity)*100/sum(forecast_quantity) as net_error_pct,
			sum(abs(forecast_quantity - sold_quantity)) as abs_error,
			sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as abs_error_pct

	FROM gdb041.fact_act_est s
	where s.fiscal_year = 2020
	group by customer_code)
    
select e.*, c.market,c.customer,

	if(abs_error_pct > 100,0,100- abs_error_pct) as  forecast_accuracy
from forecast_error_table e
join dim_customer  c
using (customer_code)
order by forecast_accuracy desc ;

# Creating ctes with the temporary tables
with cte_2020 as(
	select customer_code,customer,market,forecast_accuracy as forecast_accuracy_2020
	from temp_2020
	order by customer,market),

cte_2021 as(
select customer_code,customer,market,forecast_accuracy as forecast_accuracy_2021
from temp_2021
order by customer,market)

select cte_2020.*,cte_2021.forecast_accuracy_2021
from cte_2020 
join cte_2021
using (customer_code,customer,market)
where cte_2021.forecast_accuracy_2021 < cte_2020.forecast_accuracy_2020

