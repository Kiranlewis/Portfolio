# Atliq Hardwares #
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

## Case study questions & answers ##
  Report of Individual product sales (aggregated on a monthly basis at the product code level) for Croma India customer for FY-2021 so that I can track individual product sales.
  
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
