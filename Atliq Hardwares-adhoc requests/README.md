# Atliq Hardwares-adhoc requests #
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

Novypro : https://www.novypro.com/profile_projects/kiran

## Overview ##
    *  Atliq Hardwares (imaginary company) is one of the leading computer hardware producers in India and well expanded in other countries too.
    *  However, the management noticed that they do not get enough insights to make quick and smart data-informed decisions. They want to expand their data analytics team by adding several junior data analysts. Tony Sharma, their data analytics director wanted to hire someone who is good at both tech and soft skills. Hence, he decided to conduct a SQL challenge which will help him understand both the skills.
 
 ## Requests & queries ##
#### #1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
````sql
select distinct(market)
from dim_customer
where customer = "Atliq Exclusive" and region = "APAC"
order by market;
````
#### #2.What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields, unique_products_2020, unique_products_2021, percentage_chg
````sql
with up_2021 as(
select row_number() over() as rn,count(distinct(product_code)) as unique_products_2021
FROM gdb023.fact_sales_monthly
where fiscal_year = 2021
group by fiscal_year),
up_2020 as (
select row_number() over() as rn,count(distinct(product_code)) as unique_products_2020
from gdb023.fact_sales_monthly
where fiscal_year = 2020
group by fiscal_year)

select unique_products_2020,unique_products_2021,round(((unique_products_2021-unique_products_2020)/unique_products_2020)*100,2) as percentage_chg
from up_2020 
inner join up_2021
on up_2020.rn = up_2021.rn;
````

#### #3.Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The final output contains 2 fields,segment, product_count
````sql
select segment,
       count(distinct(product_code)) as product_count
from dim_product
group by segment
order by product_count desc;
````

#### #4.Follow-up: Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment
product_count_2020
product_count_2021
difference
````sql
with tab as(
select s.product_code,
       p.segment,
	   s.fiscal_year
from fact_sales_monthly s 
inner join dim_product p
on s.product_code = p.product_code
),
prod_2020 as (
select count(distinct(product_code)) as product_count_2020,segment
from tab
where fiscal_year = 2020
group by segment
order by segment),
prod_2021 as (
select count(distinct(product_code)) as product_count_2021,segment
from tab
where fiscal_year = 2021
group by segment
order by segment),

tab_2020_2021 as 
(select prod_2020.segment,
        product_count_2020,
		product_count_2021,
        (product_count_2021-product_count_2020) as difference
from prod_2020
join prod_2021
on prod_2020.segment = prod_2021.segment)

select * 
from tab_2020_2021
order by difference desc
;
````
#### #5.Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost
````sql
with manufacturing_cost_table as(
select m.product_code,
       p.product,
	   m.manufacturing_cost
from fact_manufacturing_cost m
inner join dim_product p 
on m.product_code = p.product_code
order by m.manufacturing_cost desc)

select *
from manufacturing_cost_table
where manufacturing_cost = (select min(manufacturing_cost) from manufacturing_cost_table) 
      or manufacturing_cost = (select max(manufacturing_cost) from manufacturing_cost_table)
;
````

#### #6.Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage
````sql
with cte1 as(
select s.customer_code,
       c.customer,
       round(avg(pre.pre_invoice_discount_pct),4) as average_discount_percentage,
       dense_rank() over (order by avg(pre.pre_invoice_discount_pct) desc) as rnk
from fact_sales_monthly s
join dim_customer c
on s.customer_code = c.customer_code
join fact_pre_invoice_deductions pre
on pre.customer_code = s.customer_code and pre.fiscal_year = s.fiscal_year
where c.market = 'India' and s.fiscal_year = 2021
group by s.customer_code
order by average_discount_percentage desc)

select customer_code,customer,average_discount_percentage
from cte1
where rnk <=5;
````

#### #7.Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns: Month Year Gross sales Amount

````sql
with cte1 as (
select month(date) as Month,s.fiscal_year as Year,round(((g.gross_price*s.sold_quantity)),2) as gross_sales_amount
from fact_sales_monthly s
join fact_gross_price g
	on s.product_code = g.product_code and
	   s.fiscal_year = g.fiscal_year
join dim_customer c 
	on s.customer_code = c.customer_code
where c.customer = "Atliq Exclusive"
),
cte2 as(
select Month,Year,round(sum(gross_sales_amount)/1000000,2) as gross_sales_amount
from cte1
group by Month,Year
order by Month)

select Month,Year,(gross_sales_amount) as gross_sales_amount_mln from cte2 
where Year = 2020
union(
select * from cte2 
where Year = 2021)
;
````
#### #8.In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity

````sql
select case when month(date) in (9,10,11) then 'Q1'
			when month(date) in (12,1,2) then 'Q2'
			when month(date) in (3,4,5) then 'Q3' 
            when month(date) in (6,7,8) then 'Q4' end as Quarter,
	  round(sum(sold_quantity)/1000000,2) as Total_sold_quantity_mln
from fact_sales_monthly
where fiscal_year = 2020
group by Quarter;
````
#### #9.Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,channel, gross_sales_mln,percentage
````sql
with cte1 as(
select c.channel,sum(g.gross_price*s.sold_quantity) as gross_sales_mln
from fact_sales_monthly s
join fact_gross_price g
on s.product_code = g.product_code and
   s.fiscal_year = g.fiscal_year
join dim_customer c
on s.customer_code = c.customer_code
where s.fiscal_year = 2021
group by channel),
cte2 as  (
select *,sum(gross_sales_mln) over() as Total_sum
from cte1)

select channel,
       round(gross_sales_mln/1000000,2) as gross_sales_mln,
       round((gross_sales_mln/Total_sum)*100,2) as percentage
from cte2
order by percentage desc;
````

#### #10.Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these fields,division,product_code,product,total_sold_quantity,rank_order,

````sql
with cte1 as (
select p.division,s.product_code,p.product,sum(s.sold_quantity)/1000000 as total_sold_quantity,
       dense_rank() over(partition by division order by sum(s.sold_quantity) desc) as rank_order
from fact_sales_monthly s
join dim_product p 
on s.product_code = p.product_code
where s.fiscal_year = 2021
group by p.division,s.product_code,p.product)

select *
from cte1
where rank_order in (1,2,3);
````

## Additional insights
#### #1.What is the average gross_sales_amount in 2020,in 2021 and percent change in Indian Market

````sql
with cust_2020 as (
select  f.customer_code,c.customer,avg(f.sold_quantity*g.gross_price) as gross_sales_amount_2020,c.channel,c.platform
from 
gdb023.fact_sales_monthly f 
join dim_customer c
on f.customer_code = c.customer_code
join fact_gross_price g
on f.product_code = g.product_code
where c.market = "India" and f.fiscal_year = 2020
group by f.customer_code,f.fiscal_year,c.market,c.channel
order by gross_sales_amount_2020 desc),
cust_2021 as 
(select avg(f.sold_quantity*g.gross_price) as gross_sales_amount_2021,c.market,f.customer_code,c.channel,c.platform
from 
gdb023.fact_sales_monthly f 
join dim_customer c
ON f.customer_code = c.customer_code
join fact_gross_price g
on f.product_code = g.product_code
where c.market = "India" AND f.fiscal_year = 2021
group by f.customer_code,f.fiscal_year,c.market
order by gross_sales_amount_2021 DESC),
join_2020_2021 as (
select  c_20.customer_code,c_20.customer,c_20.gross_sales_amount_2020,
       c_21.gross_sales_amount_2021,c_21.market,c_21.channel,c_21.platform
from 
cust_2020 c_20
join
cust_2021 c_21
on c_20.customer_code = c_21.customer_code)

select  customer,round(gross_sales_amount_2020,2) as gross_sales_amount_2020 ,
        round(gross_sales_amount_2021,2) as gross_sales_amount_2021,
        round(((gross_sales_amount_2021-gross_sales_amount_2020)/gross_sales_amount_2020)*100,2)as pct_chg,
        channel,platform 
from join_2020_2021
order by pct_chg desc
;
````

#### #2.Names of the products introduced in the fiscal year 2021 and their segment
````sql
with tab1 as(
select distinct(p.product),p.product_code,p.variant,f.fiscal_year
from dim_product p
join fact_sales_monthly f
on p.product_code = f.product_code
where f.fiscal_year = 2020),
tab2 as(
select distinct(p.product),p.product_code,p.variant,f.fiscal_year
from dim_product p
join fact_sales_monthly f
on p.product_code = f.product_code
where f.fiscal_year = 2021)
select * 
from tab2 
where tab2.product_code NOT IN (select distinct(product_code) from tab1);
````

#### #3.Top 10 products newly launched products by gross sales amount in the year 2021 in India
````sql
with all_2021_products as (
select distinct(p.product),p.product_code,p.segment,p.variant,f.fiscal_year
from dim_product p
join fact_sales_monthly f
on p.product_code = f.product_code
where f.fiscal_year = 2021)
,
category_labelled as (
select *,case when product_code in (select product_code from new_products_in_2021) then 'Launched in 2021' else 'Existing product' end as Category
from all_2021_products)
,
combined_table as(
select c.product,c.product_code,c.segment,cu.customer,cu.platform,cu.region,cu.market,c.variant,c.fiscal_year,c.Category,(f.sold_quantity*fg.gross_price) as gross_sales_amount
from fact_sales_monthly f
join category_labelled c
on f.product_code = c.product_code
join fact_gross_price fg
on f.product_code = fg.product_code
join dim_customer cu
on f.customer_code = cu.customer_code)

select product,product_code,variant,segment,customer,platform,region,market,fiscal_year,Category,round(sum(gross_sales_amount),2) as Total_gross_sales_amount
from combined_table
where Category = "Launched in 2021" and market = "India"
group by product,product_code,variant,segment,customer,platform,region,market,fiscal_year,Category
order by round(sum(gross_sales_amount),2)  desc
limit 10;
````

#### #4.Percentage of total gross amount contribution of Newly launched products and pre existing products
````sql
select category,round((Total_gross_sales_amount/sum(Total_gross_sales_amount) over())*100,2) as pct_gross_sales_amount
from(
SELECT category,sum(Total_grosssales_amount) as Total_gross_sales_amount FROM gdb023.product_gross_sales
where market = "India"
group by category) sub
````
