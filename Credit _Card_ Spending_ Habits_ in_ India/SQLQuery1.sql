--CREATE TABLE credit_card_transactions
--(
--    City VARCHAR(255),
--    Date DATE,
--    Card_Type VARCHAR(255),
--    Exp_Type VARCHAR(255),
--    Gender VARCHAR(255),
--    Amount INT
--);

--Load csv file from local system to credit_card_transactions table

--COPY credit_card_transactions(City, Date, Card_Type, Exp_Type, Gender, Amount)
--FROM 'E:\Study\Portfolio_Projects\SQL\Credit Card Spending Habits in India\Credit card transactions - India.csv'
--DELIMITER ','
--CSV HEADER;


-- Basic Check

select * from credit_card_transactions;
select count(*) from credit_card_transactions;

---TASK 1 :  write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

SELECT TOP 5 city,
       SUM(amount) AS total_spending,
       CAST(SUM(amount) * 100.0 / (SELECT SUM(CAST(amount AS BIGINT)) FROM credit_card_transactions) AS DECIMAL(10, 2)) AS percentage_of_total
FROM credit_card_transactions
GROUP BY city
ORDER BY total_spending DESC;

--- TASK 2 :  write a query to print highest spend month and amount spent in that month for each card type
with cte as(
select month(date) as month ,year(date) as year,[card type], sum(amount) as total_spending from credit_card_transactions
group by month(date),year(date),[card type]
--order by total_spending desc
),
cte1 as(
select month,year,[card type] , total_spending , rank() over(partition by  [card type] order by total_spending desc ) as rn from cte
)
select * from cte1 where rn =1


-- TASK 3 : write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

with cte as
(select * , SUM(CAST(amount AS BIGINT)) over(partition by  [card type]  order  by date rows between UNBOUNDED PRECEDING AND CURRENT ROW) as running_amount 
from credit_card_transactions
),
cte1 as(
select *,rank() over(partition by [card type] order by running_amount desc) as rn from cte where running_amount < 1000000)
select * from cte1 where rn =1



--- TASK 4 : write a query to find city which had lowest percentage spend for gold card type

Select TOP 1 city,sum(amount) as spending, 
CAST(SUM(amount) * 100.0 / (SELECT SUM(CAST(amount AS BIGINT)) FROM credit_card_transactions where [card type] = 'Gold') AS DECIMAL(10, 6)) AS percentage_of_total_for_gold
from credit_card_transactions 
where [card type] = 'Gold' 
group by city
order by sum(amount) 





--- TASK 5 : write a query to print 3 columns: city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

with cte as (
select city,[Exp Type] as lowest_expense_type,sum(amount) as total_spending,
rank() over(partition by city order by sum(amount)) as rn
from credit_card_transactions
group by city,[Exp Type]
)
,cte1 as (
select city,[Exp Type] as highest_expense_type,sum(amount) as total_spending,
rank() over(partition by city order by sum(amount) desc) as rn1
from credit_card_transactions
group by city,[Exp Type]
)
select cte.city , cte1.highest_expense_type,cte.lowest_expense_type from cte inner join cte1 on
cte.city = cte1.city and cte.rn=1 and cte1.rn1= 1




--- TASK 6 : write a query to find percentage contribution of spends by females for each expense type


select Gender,[Exp Type],sum(amount) as total_spending ,
CAST(SUM(amount) * 100.0 / (SELECT SUM(CAST(amount AS BIGINT)) FROM credit_card_transactions where Gender = 'F') AS DECIMAL(10, 2)) AS percentage_of_total
from credit_card_transactions
where Gender = 'F'
group by Gender,[Exp Type];





-- TASK 7 : which card and expense type combination saw highest month over month growth in Jan-2014


select  TOP 1 [card type],[Exp Type],
sum(case when year(date) = 2013 and month(date) = 12 then amount else 0 end )as Dec_2013_spending,
sum(case when year(date) = 2014 and month(date) = 01 then amount else 0 end )as Jan_2014_spending,
(sum(case when year(date) = 2014 and month(date) = 01 then amount else 0 end )  -
sum(case when year(date) = 2013 and month(date) = 12 then amount else 0 end ) )*100 / 
(sum(case when year(date) = 2013 and month(date) = 12 then amount else 0 end )) as profit_growth
from credit_card_transactions
group by [card type],[Exp Type]
order by (sum(case when year(date) = 2014 and month(date) = 01 then amount else 0 end )  -
sum(case when year(date) = 2013 and month(date) = 12 then amount else 0 end ) ) desc 





-- TASK 8 : during weekends which city has highest total spend to total no of transcations ratio 


SELECT TOP 1 city, sum(amount) as total_spend , count(amount) as no_of_transactions,
sum(amount) / count(amount) as ratio
FROM credit_card_transactions
where DATEPART(WEEKDAY, date) in (7,1) -- For Weekend
group by city
order by ratio desc;





--- TASK 9: which city took least number of days to reach its 500th transaction after first transaction in that city


with cte as
(select city,date as date_500,row_number() over(partition by city order by date) as rn from credit_card_transactions),
cte1 as 
(
select city,min(date) as initial_date from credit_card_transactions group by city
)
select TOP 1 cte.city,cte1.initial_date,cte.date_500 ,
DATEDIFF(day,cte1.initial_date,cte.date_500) as date_diff
from cte inner join cte1 
on cte.city = cte1.city
and cte.rn = 500
order by date_diff