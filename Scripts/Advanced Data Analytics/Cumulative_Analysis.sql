--=============================================
-- Cumulative Analysis
--=============================================
-- Calculate the total sales per month 
-- and the running total of sales over time
-- and the moving average of price over time
select 
order_date,
total_sales,
avg_price,
SUM(total_sales) OVER(Order by order_date) as running_total_sales,
AVG(avg_price) OVER(order by order_date) as moving_avg_price
from 
	(
	select
	DATETRUNC(year,order_date) order_date,
	SUM(sales_amount) as total_sales,
	AVG(price) avg_price
	from gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(year, order_date)
	)t
