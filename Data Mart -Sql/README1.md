# Data Mart #
## Case study questions & answers ##
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

  Created a table with the following Schema using CREATE TABLE and INSERT INTO commands
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
region  | varchar(20)
platform | varchar(20)
segment | varchar(10)
customer | varchar(20)
transactions | int
sales | int



