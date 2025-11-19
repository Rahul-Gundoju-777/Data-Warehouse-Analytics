--=============================================
-- Changes-Over-time (Trends)
--=============================================
-- Analyze sales performance over time
select 
YEAR(order_date) order_year, -- Changes over years
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)	

select 
YEAR(order_date) order_year,
month(order_date) order_month, -- Changes over months
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),month(order_date)
ORDER BY YEAR(order_date),month(order_date)

select 
DATETRUNC(month, order_date) order_date, -- Changes over months
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

select 
FORMAT(order_date,'yyyy-MMM') order_date, -- Changes over months
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM')

-- How many new customers were added each year
select 
DATETRUNC(year, create_date) as create_date,
COUNT(customer_key) as total_customers
from gold.dim_customers
GROUP by DATETRUNC(year, create_date)
Order by DATETRUNC(year, create_date)
