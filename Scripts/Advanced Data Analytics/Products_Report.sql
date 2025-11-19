--=============================================
-- Build Product report
--=============================================
/* 
--=============================================
-- Products Report
--=============================================
Purpose:
	- This report consolidates key product metrics and behaviours
Highlights:
	1. Gathers essential fields such as product names, category, sub-category and cost
    2. Segments products by revenue to identify High-performers, Mid-range, or Low-performers.
    3. Aggregates product-level metrics:
		- Total orders
        - Total sales
        - Total Quantity sold
        - Total customers(unique)
        - Lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
        - average order revenue(AOR)
        - average monthly revenue
--=============================================
*/
CREATE VIEW gold.report_products AS
/*---------------------------------------------
1) Basic Query: Retrieves core columns from fact_sales and dim_products
-----------------------------------------------*/
WITH base_query AS
(
	Select 
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
    from gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL -- only consider valid sales dates
)
/*--------------------------------------------------------------------
2) Customer aggregations: Summarizes key metrics at the customer level
--------------------------------------------------------------------*/ 
, product_aggregations as (
select
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan,
    MAX(order_date) as last_order_date,
    COUNT(DISTINCT order_number) as total_orders,
    COUNT(DISTINCT customer_key) as total_customers,
    SUM(sales_amounts) as total_sales,
    SUM(quantity) as total_quantity,
    ROUND(AVG(CAST(sales_amounts as float)/NULLIF(quantity,0)),1) as avg_selling_price
from base_query
GROUP BY
	product_key,
    product_name,
    category,
    subcategory,
    cost,
)
/*--------------------------------------------------------------------
3) Final Query: Combine all the products results into on output
--------------------------------------------------------------------*/ 
select 
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(month, last_sale_date, GETDATE()) as recency_in_months,
    CASE WHEN total_sales > 50000 THEN 'High-performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
         ELSE 'Low_performer'
	END as product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- Avg order revenue(AOR)
    CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales/total_orders
	END as avg_order_revenue,
    -- Avg monthly revenue
    CASE WHEN lifespan = 0 THEN total_sales,
		 ELSE total_sales/lifespan
	END as avg_monthly_revenue
from product_aggregations
