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

**Sample Table:**

week_date|region|platform|segment|customer|transactions|sales
----------|--------|
battery   |   39988|
assault   |   20086|
homicide  |     803|








