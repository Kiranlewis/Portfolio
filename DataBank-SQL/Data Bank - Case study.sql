use data_bank;

-- Different node is Data Bank network
select count(distinct(node_id)) as Unique_Nodes from customer_nodes;

-- Nodes in each region
select reg.region_name as region_name ,count(nod.node_id) as count
from regions reg inner join customer_nodes nod
on reg.region_id = nod.region_id
group by reg.region_name
order by count desc;

-- Number of Customers divided among regions
select reg.region_id,count(customer_id) as customers
from customer_nodes nod inner join regions reg
on nod.region_id = reg.region_id
group by region_id
order by region_id;

-- Total amount of transaction for each region
select reg.region_name,reg.region_id,sum(tra.txn_amount) as total_transaction_amount
from regions reg inner join customer_nodes nod
on reg.region_id = nod.region_id
inner join customer_transactions tra
on nod.customer_id = tra.customer_id
group by region_id
order by total_transaction_amount desc;

-- Average time taken to move clients to a new node
select round(avg(datediff(end_date,start_date)),2) as average_days from customer_nodes
where end_date != '9999-12-31';


-- Unique count and total amount for each transaction type
 select * from customer_transactions;
select count(*) as unique_count ,txn_type,sum(txn_amount) as total_amount
from customer_transactions
group by txn_type;

-- average number and size of past deposits across all customers
select round(count(customer_id)/(select count(distinct customer_id) from customer_transactions)) as average_deposit_count,
concat('$',round(avg(txn_amount),2)) as average_txn_amount
from customer_transactions where txn_type = 'deposit';



-- For each month - how many Data Bank customers make more than 1 deposit and at least either 1 purchase or 1 withdrawal in a single month

with transaction_count_per_month_cte  as 
(select customer_id,month(txn_date) as txn_month,
sum(if(txn_type='deposit',1,0)) as deposit_count,
sum(if(txn_type='withdrawal',1,0)) as withdrawal_count,
sum(if(txn_type='purchase',1,0)) as purchase_count
from customer_transactions
group by customer_id,txn_month)

select txn_month,count(distinct customer_id) as customer_count
from transaction_count_per_month_cte
where deposit_count >1 and withdrawal_count = 1 or purchase_count = 1
group by txn_month;


    
