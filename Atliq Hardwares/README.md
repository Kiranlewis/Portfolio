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

#### Making a view for sales_preinv_discount
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

#### Creating net_sales view
````
CREATE VIEW net_sales as (
SELECT * ,
     (1-post_invoice_deductions_pct)*net_invoice_sales as net_sales
FROM gdb041.sales_postinv_discount)

