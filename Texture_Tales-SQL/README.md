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
1|NULL|Womens|Category
2|NULL|Mens|Category
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
