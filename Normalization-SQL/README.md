# Texture Tales #
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

## Task: ##

  * Texture Tales Clothing Company prides themselves on providing an optimized range of clothing and lifestyle wear for the modern adventurer!
  * To assist the team’s merchandising teams analyze their sales performance and generate a basic financial report to share with the wider business.
  
  
## Case study questions & answers ##
**Schema used**
Insert schema here





**sales(Sample)**
prod_id|qty|price|discount|member|txn_id|start_txn_time
-----|-----|-----|-----|-----|-----|-----|
c4a632|4|13|17|true|54f307|2021-02-13T01:59:43.296Z
5d267b|4|40|17|true|54f307|2021-02-13T01:59:43.296Z
b9a74d|4|17|17|true|54f307|2021-02-13T01:59:43.296Z
2feb6b|2|29|17|true|54f307|2021-02-13T01:59:43.296Z
c4a632|5|13|21|true|26cc98|2021-01-19T01:39:00.346Z
e31d39|2|10|21|true|26cc98|2021-01-19T01:39:00.346Z

**product_details(Sample)**
product_id|price|product_name|category_id|segment_id|style_id|category_name|segment_name|style_name
-----|-----|-----|-----|-----|-----|-----|-----|-----|
2a2353|57|Blue Polo Shirt - Mens|2|5|15|Mens|Shirt|Blue Polo
2feb6b|29|Pink Fluro Polkadot Socks - Mens|2|6|18|Mens|Socks|Pink Fluro Polkadot
5d267b|40|White Tee Shirt - Mens|2|5|13|Mens|Shirt|White Tee
72f5d4|19|Indigo Rain Jacket - Womens|1|4|11|Womens|Jacket|Indigo Rain
9ec847|54|Grey Fashion Jacket - Womens|1|4|12|Womens|Jacket|Grey Fashion
b9a74d|17|White Striped Socks - Mens|2|6|17|Mens|Socks|White Striped

**product_prices(Sample)**
id|product_id|price
-----|-----|-----|
7|c4a632|13
8|e83aa3|32
9|e31d39|10
10|d5e9a6|23
11|72f5d4|19

**product_hierarchy(Sample)**
id|parent_id|level_text|level_name
-----|-----|-----|-----|
1| |Womens|Category
2| |Mens|Category
3|1|Jeans|Segment
4|1|Jacket|Segment
5|2|Shirt|Segment
6|2|Socks|Segment
7|3|Navy Oversized|Style
8|3|Black Straight|Style
9|3|Cream Relaxed|Style


#### Total quantity sold for all products
````sql
select sum(qty) as Total_qty_sold
from sales;
````
Total_qty_sold|
---|
45216|

#### Total quantity sold for each product
````sql
select product_name,
       prod_id,
       sum(qty) as Total_qty_sold
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by prod_id
order by Total_qty_sold desc;
````
product_name|prod_id|Total_qty_sold
---|---|---|
Grey Fashion Jacket - Womens|9ec847|3876
Navy Oversized Jeans - Womens|c4a632|3856
Blue Polo Shirt - Mens|2a2353|3819
White Tee Shirt - Mens|5d267b|3800
Navy Solid Socks - Mens|f084eb|3792
Black Straight Jeans - Womens|e83aa3|3786
Pink Fluro Polkadot Socks - Mens|2feb6b|3770
Indigo Rain Jacket - Womens|72f5d4|3757
Khaki Suit Jacket - Womens|d5e9a6|3752
Cream Relaxed Jeans - Womens|e31d39|3707
White Striped Socks - Mens|b9a74d|3655
Teal Button Up Shirt - Mens|c8d436|3646

#### Total generated revenue for all products before discounts
````sql
select product_name,
       prod_id,
       sum(sales.qty*sales.price) as revenue
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by prod_id
order by revenue desc;
````
product_name|prod_id|revenue
---|---|---|
Blue Polo Shirt - Mens|2a2353|217683
Grey Fashion Jacket - Womens|9ec847|209304
White Tee Shirt - Mens|5d267b|152000
Navy Solid Socks - Mens|f084eb|136512
Black Straight Jeans - Womens|e83aa3|121152
Pink Fluro Polkadot Socks - Mens|2feb6b|109330
Khaki Suit Jacket - Womens|d5e9a6|86296
Indigo Rain Jacket - Womens|72f5d4|71383
White Striped Socks - Mens|b9a74d|62135
Navy Oversized Jeans - Womens|c4a632|50128
Cream Relaxed Jeans - Womens|e31d39|37070
Teal Button Up Shirt - Mens|c8d436|36460

#### Total discount amount for all products
````sql
select sum(qty*price*discount)/100 as Total_discount_amount
from sales;
````
Total_discount_amount|
-|
156229.1400|

#### Total discount amount for each products
````sql
select prod_id,
       sum(qty*price*discount)/100 as Discount_amount
from sales
group by prod_id;
````
prod_id|Discount_amount
-|-
c4a632|6135.6100
5d267b|18377.6000
b9a74d|7410.8100
2feb6b|12952.2700
e31d39|4463.4000
72f5d4|8642.5300
2a2353|26819.0700
f084eb|16650.3600
e83aa3|14744.9600
d5e9a6|10243.0500
9ec847|25391.8800
c8d436|4397.6000

#### Number of unique transactions made
````sql
select count(distinct txn_id) as unique_transcation
from sales;
````
unique_transaction|
-|
2500|

#### Average number of unique transactions made
````sql
with cte_transaction_products as(
 select txn_id,
        count(distinct prod_id) as product_count 
        from sales 
group by txn_id)

select round(avg(product_count)) as avg_unique_products
from cte_transaction_products;
````
avg_unique_products
-|
6|


#### Average Discount value per transaction
````sql
with cte_discount_transaction as(
 select txn_id,
        sum(qty*price*discount)/100 as discount_value 
from sales
group by txn_id)

select round(avg(discount_value)) as avg_discount_value
from cte_discount_transaction;
````
avg_discount_value
-|
62

#### Average revenue for member transactions and non member transactions

````sql
with cte_member_revenue as(
select member,txn_id,sum(qty*price) as Total_revenue 
from sales
group by member,txn_id)

select member,round(avg(Total_revenue)) as revenue
from cte_member_revenue
group by member;
````
member|revenue
-|-
true|516
false|515



#### Top 3 products by Total revenue before discount
````sql
select product_details.product_name,prod_id,sum(sales.qty*sales.price) as Total_revenue
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by prod_id
order by Total_revenue desc
limit 3 ;
````
product_name|prod_id|Total_revenue
-|-|-
Blue Polo Shirt - Mens|2a2353|217683
Grey Fashion Jacket - Womens|9ec847|209304
White Tee Shirt - Mens|5d267b|152000

#### Total quantity, Total revenue and Total discount for each segment
````sql
select product_details.segment_id,product_details.segment_name as Segment ,
sum(sales.qty) as Total_quantity,
sum(sales.qty*sales.price) as Total_revenue,
sum(sales.qty*sales.price*sales.discount)/100 as Total_discount
from sales inner join product_details 
on sales.prod_id = product_details.product_id
group by product_details.segment_name,product_details.segment_id;
````
segment_id|Segment|Total_quantity|Total_revenue|Total_discount
-|-|-|-|-
3|Jeans|11349|208350|25343.9700
5|Shirt|11265|406143|49594.2700
6|Socks|11217|307977|37013.4400
4|Jacket|11385|366983|44277.4600

#### Top selling product for each segment
````sql

with cte1 as (
select product_details.segment_id as Segment_id ,
product_details.segment_name as Segment, product_details.product_name as Product_name ,
product_details.product_id as Product_id,
sum(sales.qty) as Total_sales_quantity
from sales inner join product_details 
on sales.prod_id = product_details.product_id
group by product_details.segment_name,product_details.segment_id,
		 product_details.product_id,product_details.product_name
order by Total_sales_quantity desc
)

select Segment_id,
       Segment,
       Product_name,
       Product_id,
       Total_sales_quantity
 from(
select *,rank() over(partition by Segment order by Total_sales_quantity desc) as rk
from cte1) sub
where rk = 1
order by Segment_id
;
````
Segment_id|Segment|Product_name|Product_id|Total_sales_quantity
-|-|-|-|-
4|Jacket|Grey Fashion Jacket - Womens|9ec847|3876
3|Jeans|Navy Oversized Jeans - Womens|c4a632|3856
5|Shirt|Blue Polo Shirt - Mens|2a2353|3819
5|Shirt|White Tee Shirt - Mens|5d267b|3800
6|Socks|Navy Solid Socks - Mens|f084eb|3792


#### The total quantity, revenue and discount for each category
````sql
select category_name,
category_id,sum(qty) as Total_quantity,
sum(sales.qty*sales.price) as Total_revenue, 
sum(sales.qty*sales.price*sales.discount)/100 as Total_discount 
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by category_id,category_name;
````
#### Top selling product for each category
````sql
with cte1 as(
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
order by category_id,sales_qty desc
)

select category_id,category_name,product_id,product_name,sales_qty
from
(
select *,rank() over (partition by category_id order by sales_qty) as rk 
from cte1) tab
where rk =1;
````
category_id|category_name|product_id|product_name|sales_qty
-|-|-|-|-
1|Womens|e31d39|Cream Relaxed Jeans - Womens|3707
2|Mens|c8d436|Teal Button Up Shirt - Mens|3646
