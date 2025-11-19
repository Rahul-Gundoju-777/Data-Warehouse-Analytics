-- =============================================
-- Build Customer report
-- =============================================
/*
--=============================================
-- Customers Report
--=============================================
Purpose:
	- This report consolidates key customer metrics and behaviours
Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories(VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
		- Total orders
        - Total sales
        - Total Quantity Purchased
        - Total Products
        - Lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
        - average order value
        - average monthly spend
--=============================================
*/
CREATE VIEW gold.report_customers AS
/*---------------------------------------------
1) Basic Query: Retrieves core columns from tables
-----------------------------------------------*/
WITH base_query AS
(
	Select 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ', c.last_name) as customer_name,
	DATEDIFF(year, c.birthdate, GETDATE()) age
	from gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
	WHERE order_date IS NOT NULL
)
/*--------------------------------------------------------------------
2) Customer aggregations: Summarizes key metrics at the customer level
--------------------------------------------------------------------*/ 
, customer_aggregations AS 
(
select
	c.customer_key,
	c.customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) as total_orders,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	COUNT(DISTINCT product_key) as total_products,
	MAX(order_date) as last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
from base_query
GROUP BY 
	c.customer_key,
	c.customer_number,
	customer_name,
	age
)
/*--------------------------------------------------------------------
3) Final Query: Combine all the customers results into on output
--------------------------------------------------------------------*/ 
select 
c.customer_key,
c.customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
     WHEN age between 30 and 39 THEN '30-39'
     WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END as age_group,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	 ELSE 'New'
End as customer_segment,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) as Recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- Compute average order value (AVO)
CASE WHEN total_orders=0 THEN 0
	 ELSE total_sales/total_orders
END as avg_order_value,
-- Compute average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
	 ELSE total_sales/lifespan
END as avg_monthly_spend
from customer_aggregations
