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
### Schema ###
Column Name  | Data type
------------- | -------------
week_date  | date
region  | varchar(100)
platform | varchar(100)
segment | varchar(100)
customer | varchar(100)
transactions | int
sales | int

**Results:**

weekdate | region | platform | segment | customer_type | transactions | sales
-------- | -------- | -------- | -------- | -------- | -------- | 
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




