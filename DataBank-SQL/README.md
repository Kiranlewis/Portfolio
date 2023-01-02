# Data Bank #
Email : arunsaikirans@gmail.com

Linkedin : https://www.linkedin.com/in/arunsaikiran-senthilkumar-0a1914171/

## Overview ##
  * Neo-Banks are a recent development in the financial sector; they are new 
banks that solely operate online.
  * This case study focuses on metrics calculations, business growth, and smart 
data analysis to assist the company more accurately estimate and plan for the 
future.

## Case study questions & answers ##
**Schema used**

Insert image here erd diagram


#### Different nodes make in the Data Bank network

````sql

select count(distinct(node_id)) as Unique_Nodes 
       from customer_nodes;
````

Unique_Nodes
-|
5


#### Nodes in each region
````sql

select reg.region_name as region_name ,
       count(nod.node_id) as count
       from regions reg inner join customer_nodes nod
on reg.region_id = nod.region_id
group by reg.region_name
order by count desc;
````
region_name|count
----|----
Australia|770
America|735
Africa|714
Asia|665
Europe|616

#### Customers divided among the regions
````sql

select reg.region_id,
       count(customer_id) as customers
from customer_nodes nod inner join regions reg
on nod.region_id = reg.region_id
group by region_id
order by region_id;
````
region_id|customers
----|----
1|770
2|735
3|714
4|665
5|616


#### Total amount of transaction for each region
````sql
select reg.region_name,reg.region_id,sum(tra.txn_amount) as total_transaction_amount
from regions reg inner join customer_nodes nod
on reg.region_id = nod.region_id
inner join customer_transactions tra
on nod.customer_id = tra.customer_id
group by region_id
order by total_transaction_amount desc;
````
region_name|region_id|total_transaction_amount
----|----|----
Australia|1|4611768
America|2|4406276
Africa|3|4233481
Asia|4|4057879
Europe|5|3401552

#### Average time taken to move clients to a new node
````sql
select round(avg(datediff(end_date,start_date)),2) as average_days from customer_nodes
where end_date != '9999-12-31';
````

#### Total count and total amount for each transaction type
````sql
select count(*) as count ,
       txn_type,
       sum(txn_amount) as total_amount
from customer_transactions
group by txn_type;
````
count | txn_type | total_amount
--- | --- | ---
2671|deposit|1359168
1580|withdrawal|793003
1617|purchase|806537


#### Average deposit count and amount of past deposits across all customers
````sql
select round(count(customer_id)/(select count(distinct customer_id) from customer_transactions)) as average_deposit_count,
       concat('$',round(avg(txn_amount),2)) as average_txn_amount
from customer_transactions where txn_type = 'deposit';
````
average_deposit_count | average_txn_amount
--- | --- 
5|$508.86
