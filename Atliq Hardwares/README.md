# Atliq Hardwares #
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

## Case study questions & answers ##
####  Report of Individual product sales (aggregated on a monthly basis at the product code level) for Croma India customer for FY-2021 to track individual product sales.
  
The  report should contain the following fields
* 1.Month
* 2.Product Name
* 3.Variant
* 4.Sold Quantity 
* 5.Gross Price Per Item
* 6.Gross Price Total
````sql
select month(s.date) as Month,
       p.product as Product_Name ,p.variant,s.sold_quantity,g.gross_price as gross_price_per_item,
       ROUND(g.gross_price * s.sold_quantity,2) as Total_gross_price
from fact_sales_monthly s
join dim_product p
	on s.product_code = p.product_code
join fact_gross_price g
    on g.product_code = p.product_code and 
       g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002 and
	  get_fiscal_year(date) = 2021
order by Month asc
limit 50;
````

Month|Product_Name|variant|sold_quantity|gross_price_per_item|Total_gross_price
---|---|---|---|---|---|
1|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|182|19.0573|3468.43
1|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Plus|121|21.4565|2596.24
1|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Premium|142|21.7795|3092.69
1|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Premium Plus|35|22.9729|804.05
1|AQ WereWolf NAS Internal Hard Drive HDD – 8.89 cm|Standard|161|23.6987|3815.49
1|AQ WereWolf NAS Internal Hard Drive HDD – 8.89 cm|Plus|241|24.7312|5960.22
1|AQ WereWolf NAS Internal Hard Drive HDD – 8.89 cm|Premium|41|23.6154|968.23
1|AQ Zion Saga|Standard|121|23.7223|2870.40
1|AQ Zion Saga|Plus|164|27.1027|4444.84
1|AQ Zion Saga|Premium|172|28.0059|4817.01

####  Monthly gross sales report for Croma India customer,containing 1.Month 2.Total Gross sales amount to Croma in this month 

````sql
select MONTH(s.date) as month ,sum(gross_price*sold_quantity) as monthly_gross_sales
	from fact_sales_monthly s
	join fact_gross_price g
	on s.product_code = g.product_code and 
       get_fiscal_year(s.date) = g.fiscal_year
	where customer_code =90002002 	      
	group by month
	order by month;
````
month|monthly_gross_sales
---|---|
1|3602615.8754
2|3719339.9102
4|2894289.4160
5|2805954.1692
6|3120660.0053
8|3612325.2139
9|14763737.8717
10|18713418.0124
12|26003729.0467

#### Generate a yearly report for Croma India where there are two columns 1. Fiscal Year 2. Total Gross Sales amount In that year from Croma
````sql
select get_fiscal_year(s.date) as fiscal_year,round(sum(g.gross_price*s.sold_quantity),2) as Total_gross_sales_amount
	from fact_sales_monthly s
	join fact_gross_price g
		 on s.product_code = g.product_code
	where s.customer_code = 90002002 and 
		  g.fiscal_year = get_fiscal_year(s.date)
	group by fiscal_year
	order by fiscal_year;
````


#### Getting net invoice sales
````sql
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
where s.fiscal_year = 2021)

select *,
   (Total_gross_price - Total_gross_price*pre_invoice_discount_pct) as net_invoice_sales
from cte1;
````
date|product_code|product|variant|sold_quantity|gross_price_per_item|Total_gross_price|pre_invoice_discount_pct|fiscal_year|net_invoice_sales
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
2020-09-01|A0118150101|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|248|19.0573|4726.21|0.0703|2021|4393.957437
2020-09-01|A0118150101|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|240|19.0573|4573.75|0.2061|2021|3631.100125
2020-09-01|A0118150101|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|31|19.0573|590.78|0.0974|2021|533.238028
2020-09-01|A0118150101|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|37|19.0573|705.12|0.2065|2021|559.512720
2020-09-01|A0118150101|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|7|19.0573|133.40|0.1068|2021|119.152880
2020-09-01|A0118150101|AQ Dracula HDD – 3.5 Inch SATA 6 Gb/s 5400 RPM 256 MB Cache|Standard|12|19.0573|228.69|0.2612|2021|168.956172

#### Creating a view for sales_preinv_discount
````sql
CREATE VIEW sales_preinv_discount AS
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
       pre.fiscal_year = s.fiscal_year)
````
#### Creating view for post_invoice_deductions_pct
````sql
CREATE VIEW AS sales_postinv_discount AS(
select 
      s.date AS date,
      s.fiscal_year AS fiscal_year,
      s.customer AS customer,
      s.customer_code AS customer_code,
      s.market AS market,
      s.product_code AS product_code,
      s.product AS product,
      s.variant AS variant,
      s.sold_quantity AS sold_quantity,
      s.Total_gross_price AS Total_gross_price,
      s.pre_invoice_discount_pct AS pre_invoice_discount_pct,
      ((1 - s.pre_invoice_discount_pct) * s.Total_gross_price) AS net_invoice_sales,
      (po.discounts_pct + po.other_deductions_pct) AS post_invoice_deductions_pct,
      (1 - pre_invoice_discount_pct)*Total_gross_price as net_invoice_sales,
      (po.discounts_pct + po.other_deductions_pct) as post_invoice_deductions_pct
from sales_preinv_discount s
join fact_post_invoice_deductions po
on s.date=po.date and 
   s.product_code = po.product_code and 
   s.customer_code = po.customer_code)
````

#### Creating net_sales view
````sql
CREATE VIEW net_sales as (
SELECT * ,
     (1-post_invoice_deductions_pct)*net_invoice_sales as net_sales
FROM gdb041.sales_postinv_discount)
````
#### Creating gross_sales view
````sql
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
````

#### Top markets,products,customers for a given financial year
#### Top 5 markets
````sql
select 
     market, 
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln desc
limit 5;
````
#### Top 5 customers
````sql
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
````
#### Top 5 products
````sql
select 
	 product,
     round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb041.net_sales ns
where fiscal_year = 2021
group by product
order by net_sales_mln desc
limit 5;
````

#### Percent share overall
````sql
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
````

#### Percent market share based on regions
````sql
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
````

#### Top-3 products in each division by their quantity sold in a given financial year 
````sql
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
````
product|division|qty|rnk
---|---|---|---
AQ Pen Drive DRC |	N & S |	2034569 |	1
AQ Digit SSD |	N & S |	1240149 |	2
AQ Clx1	N & S |	1238683	3
AQ Gamers Ms |	 P & A |	2477098	 |1
AQ Maxima Ms |	P & A |	2461991 |	2
AQ Master wireless x1 Ms |	P & A |	2448784 |	3
AQ Digit |	PC |	135092 |	1
AQ Gen Y |	PC |	135031 |	2
AQ Elite	PC	134431	3

#### Top 2 markets in every region by their gross sales amount in FY=2021. 
````sql
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
````
market|region|gross_sales_mln
---|---|---
India|APAC|455.05
South Korea|APAC|131.86
United Kingdom|EU|78.11
France|EU|67.62
Mexico|LATAM|2.30
Brazil|LATAM|2.14
USA|NA|264.46
Canada|NA|89.78

#### Forecast accuracy for all customers for a given fiscal year
````sql
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
````
#### Creating a report where customers forecast accuracy has dropped from 2020 to 2021
#1-Create a temporary table to store forecast accuracy for 2020
````sql
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
````
#2-Create a temporary table to store forecast accuracy for 2021
````sql
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
````

#3- Create ctes with the temporary tables so we can compare both years
````sql
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
````
