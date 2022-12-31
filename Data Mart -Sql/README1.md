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

week_day|
---|
1
2
3
4
5
6
7
8
9
10
11
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52

#### How many total transactions were there for each year in the dataset?
````sql
select calender_year, 
       sum(transactions) as total_transactions 
from clean_weekly_sales
group by calender_year
order by calender_year;
````

calender_year|total_transactions
---|---|
2018 |	346406460
2019 |	365639285
2020 |	375813651

####  What are the total sales for each region for each month?
````sql
select region,month_number,sum(sales) as total_sales
from clean_weekly_sales
group by region,month_number
order by month_number asc;
````
region | month_number | total_sales
--- | --- | ---
ASIA | 3 | 529770793
AFRICA | 3 | 567767480
OCEANIA | 3 | 783282888
EUROPE | 3 | 35337093
SOUTH AMERICA | 3 | 71023109
USA | 3 | 225353043
CANADA | 3 | 144634329
EUROPE | 4 | 127334255
ASIA | 4 | 1804628707
SOUTH AMERICA | 4 | 238451531
CANADA | 4 | 484552594
OCEANIA | 4 | 2599767620
AFRICA | 4 | 1911783504
USA | 4 | 759786323
SOUTH AMERICA | 5 | 201391809
ASIA | 5 | 1526285399
EUROPE | 5 | 109338389
USA | 5 | 655967121
OCEANIA | 5 | 2215657304
CANADA | 5 | 412378365
AFRICA | 5 | 1647244738
OCEANIA | 6 | 2371884744
USA | 6 | 703878990
SOUTH AMERICA | 6 | 218247455
EUROPE | 6 | 122813826
ASIA | 6 | 1619482889
CANADA | 6 | 443846698
AFRICA | 6 | 1767559760
CANADA | 7 | 477134947
ASIA | 7 | 1768844756
AFRICA | 7 | 1960219710
OCEANIA | 7 | 2563459400
EUROPE | 7 | 136757466
USA | 7 | 760331754
SOUTH AMERICA | 7 | 235582776
CANADA | 8 | 447073019
OCEANIA | 8 | 2432313652
SOUTH AMERICA | 8 | 221166052
ASIA | 8 | 1663320609
USA | 8 | 712002790
EUROPE | 8 | 122102995
AFRICA | 8 | 1809596890
OCEANIA | 9 | 372465518
EUROPE | 9 | 18877433
ASIA | 9 | 252836807
SOUTH AMERICA | 9 | 34175583
USA | 9 | 110532368
AFRICA | 9 | 276320987
CANADA | 9 | 69067959


####  What is the total count of transactions for each platform?
````sql
select platform,
       sum(transactions) as total_transactions
from clean_weekly_sales
group by platform;
````
platform | total_transactions
--- | ---
Retail | 1081934227
Shopify | 5925169
#### What is the percentage of sales for Retail vs Shopify for each month?
````sql
with cte_monthly_platform_sales as 
(select month_number,
        calender_year,
	platform,
        sum(sales) as monthly_sales
from clean_weekly_sales
group by month_number,calender_year,platform)

select month_number,calender_year,
      round(100*max(case when platform = 'Retail'
      then monthly_sales else null end)/sum(monthly_sales),2) as retail_percentage,
      round(100*max(case when platform = 'Shopify'
      then monthly_sales else null end)/sum(monthly_sales),2) as shopify_percentage
from cte_monthly_platform_sales
group by month_number,calender_year;
````

