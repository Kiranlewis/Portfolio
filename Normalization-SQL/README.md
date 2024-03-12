![image](https://github.com/Kiranlewis/Portfolio/assets/35210598/9dee19ef-88dc-4e0f-b889-1f673e79a95d)# Data Normalization #
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

## Overview: ##

  * This README provides an overview and guidance on data normalization in the context of a relational database management system (RDBMS) like MySQL. Data normalization is the process of organizing data in a database to reduce redundancy and dependency, thereby improving data integrity and efficiency.
  
  
## Purpose ##
**Schema used**
  * The purpose of data normalization is to design a database schema that minimizes duplication of data and ensures that data dependencies are logical and consistent. This leads to a more efficient database structure, easier maintenance, and better scalability.

## Levels of Normalization ##
  * Data normalization is typically divided into several levels, known as normal forms. The most common normal forms are First Normal Form (1NF), Second Normal Form (2NF), and Third Normal Form (3NF). Higher normal forms like Boyce-Codd Normal Form (BCNF) and Fourth Normal Form (4NF) may also be considered depending on specific requirements.
## Process ##
  * The process of data normalization involves identifying and resolving anomalies in the database schema. This includes:
    * Ensuring each table represents a single logical entity or relationship.
    * Eliminating repeating groups and ensuring each column contains atomic values in 1NF.
    * Removing partial and transitive dependencies in 2NF and 3NF, respectively. 
## Example ##
  * Consider a sample dataset of sales transactions with columns like InvoiceNo, CustomerID, ProductID, Quantity, and UnitPrice. By normalizing this data, we can break it down into separate tables for Invoices, Customers, Products, and InvoiceItems, thereby reducing redundancy and improving maintainability.

#### Sample table
Index|InvoiceNo|StockCode|Description|Quantity|InvoiceDate|UnitPrice|CustomerID|Country
---|---|---|---|---|---|---|---|
0|536365|85123A|WHITE HANGING HEART T-LIGHT HOLDER|6|12-01-2010 08:26|2.55|17850|United Kingdom
1|536365|71053|WHITE METAL LANTERN|6|12-01-2010 08:26|3.39|17850|United Kingdom
2|536365|84406B|CREAM CUPID HEARTS COAT HANGER|8|12-01-2010 08:26|2.75|17850|United Kingdom
3|536365|84029G|KNITTED UNION FLAG HOT WATER BOTTLE|6|12-01-2010 08:26|3.39|17850|United Kingdom
4|536370|22728|ALARM CLOCK BAKELIKE PINK|24|12-01-2010 08:45|3.75|12583|France
5|536370|22727|ALARM CLOCK BAKELIKE RED |24|12-01-2010 08:45|3.75|12583|France
6|536370|22726|ALARM CLOCK BAKELIKE GREEN|12|12-01-2010 08:45|3.75|12583|France
7|536389|22195|LARGE HEART MEASURING SPOONS|24|12-01-2010 10:03|1.65|12431|Australia
8|536389|22196|SMALL HEART MEASURING SPOONS|24|12-01-2010 10:03|0.85|12431|Australia
9|536390|22941|CHRISTMAS LIGHTS 10 REINDEER|2|12-01-2010 10:19|8.5|17511|United Kingdom
10|581574|22077|6 RIBBONS RUSTIC CHARM|12|12-09-2011 12:09|1.95|12526|Germany
11|581574|22074|6 RIBBONS SHIMMERING PINKS |12|12-09-2011 12:09|0.39|12526|Germany
12|581574|22621|TRADITIONAL KNITTING NANCY|12|12-09-2011 12:09|1.65|12526|Germany







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
