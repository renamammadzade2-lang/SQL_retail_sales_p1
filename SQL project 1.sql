--create table
drop table if exists retail_sales;

create table retail_sales (
    transactions_id   int primary key,
    sale_date         date,
    sale_time         time,
    customer_id       int,
    gender            varchar(15),
    age               int,
    category          varchar(15),
    quantiy           int,
    price_per_unit    float,
    cogs              float,
    total_sales       float
);

SELECT * FROM retail_sales

select 
	count(*)
from retail_sales 

-- Data clearing
-- Null dəyərlərin olub-olmamasını yoxlayaq

select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

select * from retail_sales
where customer_id is null

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sales is null;

-- Bir necə Null dəyərlərin olduğu sətrin silinməsi
delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sales is null;


-- Data exploration

-- How many sales we have?
select count(*) as total_sales from retail_sales

--How many uniuque customers we have?
select count( distinct customer_id) from retail_sales

--How many uniuque category we have?
select distinct category from retail_sales


--Data Analysis & Business Key Problems & Answers 


--- S.1 '2022-11-05 tarixində edilən satışlar üçün bütün sütunları əldə etmək üçün SQL sorğusu yazın
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
Select * 
from retail_sales
where sale_date ='2022-11-05'


--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--S.2 Noyabr 2022-ci ildə kateqoriyanın "Geyim" olduğu və satılan miqdarın 4-dan çox olduğu bütün əməliyyatları əldə etmək üçün SQL sorğusu yazın.
Select * from retail_sales
where  category = 'Clothing' 
	and quantiy >=4
	and to_char(sale_date,'YYYY-MM')='2022-11'



--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--S.3 Hər bir kateqoriya üzrə ümumi satışları (total_sale) hesablamaq üçün SQL sorğusu yazın.

select 	
	category,
	sum(total_sales) as net_sale,
	count(*) as total_orders
from retail_sales
group by category

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--S.4 “Gözəllik” kateqoriyasından əşyalar almış müştərilərin orta yaşını tapmaq üçün SQL sorğusu yazın.

select 
	round(avg(age),2) 
from retail_sales
where category='Beauty'

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--S.5 Total_sale 1000-dən çox olan bütün əməliyyatları tapmaq üçün SQL sorğusu yazın.

select * from retail_sales
where total_sales > 1000


--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--S.6 Hər bir kateqoriya üzrə hər bir cins tərəfindən edilən əməliyyatların ümumi sayını (transaction_id) tapmaq üçün SQL sorğusu yazın.

select 
	category,
	gender, 
	count(*) as total_trans 
from retail_sales
group by category,gender

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--S.7 Hər ay üçün orta satışı hesablamaq üçün SQL sorğusu yazın. Hər ilin ən çox satılan ayını tapın.

select * 
from 		(
	select 
		extract( Year from sale_date),
		extract( Month from sale_date),
		avg(total_sales) as sales,
		rank () over(partition by extract( Year from sale_date) order by avg(total_sales) desc ) as rank
	from retail_sales
group by 1,2 
		     )
where rank=1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
--S.8 Ən yüksək ümumi satışlara əsasən ilk 5 müştərini tapmaq üçün SQL sorğusu yazın

select 
	customer_id,
	sum(total_sales)
from retail_sales
group by customer_id
order by 2 desc
limit 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--S.9 Hər kateqoriyadan əşyalar almış unikal müştərilərin sayını tapmaq üçün SQL sorğusu yazın.
Select 
	category,
	COUNT(distinct customer_id) as cnt_unique_cus
from retail_sales
group by 1
	

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
--S.10 Hər növbə və sifarişlərin sayını yaratmaq üçün SQL sorğusu yazın (Nümunə Səhər <=12, Günorta 12 və 17 arası, Axşam >17)

select 
    case 
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
         else 'Evening'
    end as shift,
    count(*) as order_count
from retail_sales
group by 
    case 
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
          else 'Evening'
    end;

--- 2 ci  həll

with hourly_sale as(

select 
    case 
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
         else 'Evening'
    end as shift
from retail_sales )

select 
	shift ,
	count(*)
from hourly_sale
group by shift
 
-- end of project


	