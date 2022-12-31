# Data Mart #
## Case study questions & answers ##
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

  Table creation with the following Schema using CREATE TABLE and INSERT INTO commands
````sql
CREATE TABLE IF NOT EXISTS weekly_sales(
week_date date,
region VARCHAR( 100 ),
platform VARCHAR( 100 ),
segment VARCHAR( 100 ),
customer_type VARCHAR( 100 ),
transactions INT(11),
sales INT(11)
);
````
** Schema **
Column Name  | Data type
------------- | -------------
week_date  | date
region  | varchar(100)
platform | varchar(100)
segment | varchar(100)
customer | varchar(100)
transactions | int
sales | int

**Sample Table**

week_date|region|platform|segment|customer|transactions|sales|
--- | --- |--- | --- |--- | --- |--- |
2020-08-31 | ASIA | Retail | C3 | New | 120631 | 3656163
2020-08-31 | ASIA | Retail | F1 | New | 31574 | 996575
2020-08-31 | USA | Retail | null | Guest | 529151 | 16509610
2020-08-31 | EUROPE | Retail | C1 | New | 4517 | 141942
2020-08-31 | AFRICA | Retail | C2 | New | 58046 | 1758388
2020-08-31 | CANADA | Shopify | F2 | Existing | 1336 | 243878
2020-08-31 | AFRICA | Shopify | F3 | Existing | 2514 | 519502
2020-08-31 | ASIA | Shopify | F1 | Existing | 2158 | 371417
2020-08-31 | AFRICA | Shopify | F2 | New | 318 | 49557
2020-08-31 | AFRICA | Retail | C3 | New | 111032 | 3888162
2020-08-31 | USA | Shopify | F1 | Existing | 1398 | 260773

#### Creating a clean weekly table adding a week number,month_number,calender year, categorizing segments, calculating average transactions columns
````sql
create table clean_weekly_sales as
select week_date,
       week(week_date)as week_number,
       month(week_date) as month_number,
       year(week_date) as calender_year,
       region,platform,
case when segment = null then 'Unknown'
     else segment
     end as segment,
case when right(segment,1)='1' then 'Young Adults'
	   when right(segment,1)='2' then 'Middle Aged'
     when right(segment,1) in ('3','4') then 'Retirees'
     else 'Unknown' 
     end as age_band,
case when left(segment,1) = 'C' then 'Couples'
     when left(segment,1) = 'F' then 'Families'
     else 'Unknown'
     end as demographic,
     customer_type,transactions,sales,
round(sales/transactions,2) as avg_transaction
from weekly_sales ;
````
week_date | week_number | month_number | calender_year | region | platform | segment | age_band | demographic | customer_type | transactions | sales
------------ |------------ |------------ |------------ |------------ |------------ |------------ |------------ |------------ |------------ |------------ |------------ |
2020-08-31 | 35 | 8 | 2020 | ASIA | Retail | C3 | Retirees | Couples | New | 120631 | 3656163 | 30.31
2020-08-31 | 35 | 8 | 2020 | ASIA | Retail | F1 | Young Adults | Families | New | 31574 | 996575 | 31.56
2020-08-31 | 35 | 8 | 2020 | USA | Retail | null | Unknown | Unknown | Guest | 529151 | 16509610 | 31.20
2020-08-31 | 35 | 8 | 2020 | EUROPE | Retail | C1 | Young Adults | Couples | New | 4517 | 141942 | 31.42
2020-08-31 | 35 | 8 | 2020 | AFRICA | Retail | C2 | Middle Aged | Couples | New | 58046 | 1758388 | 30.29
2020-08-31 | 35 | 8 | 2020 | CANADA | Shopify | F2 | Middle Aged | Families | Existing | 1336 | 243878 | 182.54
2020-08-31 | 35 | 8 | 2020 | AFRICA | Shopify | F3 | Retirees | Families | Existing | 2514 | 519502 | 206.64
2020-08-31 | 35 | 8 | 2020 | ASIA | Shopify | F1 | Young Adults | Families | Existing | 2158 | 371417 | 172.11
2020-08-31 | 35 | 8 | 2020 | AFRICA | Shopify | F2 | Middle Aged | Families | New | 318 | 49557 | 155.84


#### Which week numbers are missing from the dataset?
````sql
create table seq100
(x int not null auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select x+50 from seq100;

select * from seq100;
create table seq52 as (select x from seq100 limit 52);
select * from seq52;

select x as week_day from seq52  where x not in (select week_number from clean_weekly_sales);
````
#### How many total transactions were there for each year in the dataset?
````sql
select calender_year, 
       sum(transactions) as total_transactions 
from clean_weekly_sales
group by calender_year
order by calender_year;
````
####  What are the total sales for each region for each month?
````sql
select region,month_number,sum(sales) as total_sales
from clean_weekly_sales
group by region,month_number
order by month_number asc;
````


