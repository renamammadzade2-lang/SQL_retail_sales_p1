# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. --S.1 '2022-11-05 tarixində edilən satışlar üçün bütün sütunları əldə etmək üçün SQL sorğusu yazın

   -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05 :
```sql
Select * 
from retail_sales
where sale_date ='2022-11-05'
```

2. --Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

   --S.2 Noyabr 2022-ci ildə kateqoriyanın "Geyim" olduğu və satılan miqdarın 4-dan çox olduğu bütün əməliyyatları əldə etmək üçün SQL sorğusu yazın.:
```sql
Select * from retail_sales
where  category = 'Clothing' 
	and quantiy >=4
	and to_char(sale_date,'YYYY-MM')='2022-11'
```

3. --Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

   --S.3 Hər bir kateqoriya üzrə ümumi satışları (total_sale) hesablamaq üçün SQL sorğusu yazın.:
```sql
select 	
	category,
	sum(total_sales) as net_sale,
	count(*) as total_orders
from retail_sales
group by category
```

4. --Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

   --S.4 “Gözəllik” kateqoriyasından əşyalar almış müştərilərin orta yaşını tapmaq üçün SQL sorğusu yazın.:
```sql
select 
	round(avg(age),2) 
from retail_sales
where category='Beauty'
```

5. --Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

   --S.5 Total_sale 1000-dən çox olan bütün əməliyyatları tapmaq üçün SQL sorğusu yazın.:
```sql
select * from retail_sales
where total_sales > 1000
```

6.--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

  --S.6 Hər bir kateqoriya üzrə hər bir cins tərəfindən edilən əməliyyatların ümumi sayını (transaction_id) tapmaq üçün SQL sorğusu yazın.:
```sql
select 
	category,
	gender, 
	count(*) as total_trans 
from retail_sales
group by category,gender
```

7. --Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

   --S.7 Hər ay üçün orta satışı hesablamaq üçün SQL sorğusu yazın. Hər ilin ən çox satılan ayını tapın. :
```sql
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
```

8. --Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

   --S.8 Ən yüksək ümumi satışlara əsasən ilk 5 müştərini tapmaq üçün SQL sorğusu yazın:
```sql
select 
	customer_id,
	sum(total_sales)
from retail_sales
group by customer_id
order by 2 desc
limit 5
```

9. --Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

   --S.9 Hər kateqoriyadan əşyalar almış unikal müştərilərin sayını tapmaq üçün SQL sorğusu yazın.:
```sql
Select 
	category,
	COUNT(distinct customer_id) as cnt_unique_cus
from retail_sales
group by 1
```

10. --Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

    --S.10 Hər növbə və sifarişlərin sayını yaratmaq üçün SQL sorğusu yazın (Nümunə Səhər <=12, Günorta 12 və 17 arası, Axşam >17):
```sql
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

----------

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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **LinkedIn**: [Connect with me professionally]((https://www.linkedin.com/in/rana-mammadazada/))

Thank you for your support, and I look forward to connecting with you!





