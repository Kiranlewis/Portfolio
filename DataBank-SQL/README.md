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


#### How many different nodes make up the Data Bank network?

''''sql
select count(distinct(node_id)) as Unique_Nodes 
       from customer_nodes;
''''

Unique_Nodes
-|
5


