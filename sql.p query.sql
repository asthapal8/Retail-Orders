
create table df_orders(
[order_id] int primary key,
[order_date] date,
[ship_mode] varchar(20),
[segment]varchar(20),
[country]varchar(20),
[city]varchar(20),
[state]varchar(20),
[postal_code]varchar(20),
[region]varchar(20),
[category]varchar(20),
[sub_category]varchar(20),
[product_id]varchar(50),
[quantity] int,
[discount] decimal(7,2),
[sale_price]decimal(7,2),
[profit] decimal(7,2))

select* from df_orders

---find top 10 highest revenue generating products
select  top 10 product_id,sum(sale_price)as revenue
from df_orders
group by product_id
order by revenue desc;

----find top 5 highest selling products in each region 
with cte as (
select region,product_id,sum(sale_price)as sales
from df_orders
group by region,product_id)
select* from(
select*,
row_number() over(partition by region order by sales desc)as rn
from cte)as a
where rn <=5


----find month over month growth camparision for 2022 and 2023 sales 
with cte as (
select year(order_date)as order_year,month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date) )
select order_month,
sum(case when order_year=2022 then sales else 0 end) as sales_2022,
sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month;

---- for each category which month had higest sales
with cte as(
select  category,format(order_date,'yyyyMM') as order_year_month ,sum(sale_price) as sales
from df_orders
group by category,format(order_date,'yyyyMM'))
select* from(
select*,
row_number() over(partition by category order by sales desc)as rn
from cte) a
where rn=1
  
 
 -
  ----what is the total sales and total profit overall
  select sum(sale_price)as total_sales,
  sum(profit)as total_profit from df_orders

 ---which ship mode is most frequantly used
 select top 1 ship_mode,count(order_id)as total_orders
 from df_orders
 group by ship_mode
 order by total_orders desc;
 ----which region has the maximum total sales


 select  top 1 region,sum(sale_price) as total_sales
 from df_orders
 group by region
 order by total_sales desc

 --find the top 5 state by profit
 select top 5 state ,sum (profit) as total_profit
 from df_orders
 group by state 
 order by total_profit desc
 


 