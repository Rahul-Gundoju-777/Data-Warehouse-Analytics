--=============================================
-- Performance Analysis
--=============================================
-- Analyze the yearly performance of products by comparing each product's 
-- sales to both its average sales performance and the previous year's sales
WITH yearly_product_sales  AS (
select 
YEAR(f.order_date) order_year,
p.product_name,
SUM(f.sales_amount) as current_sales
from gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name
)

select 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(partition by product_name) avg_sales,
current_sales-AVG(current_sales) OVER(partition by product_name) diff_avg,
CASE WHEN current_sales-AVG(current_sales) OVER(partition by product_name)>0 THEN 'Above Avg'
	WHEN current_sales-AVG(current_sales) OVER(partition by product_name)<0 THEN 'Below Avg'
	ElSE 'Avg'
END avg_change, -- year over year analysis
LAG(current_sales) OVER(partition by product_name order by order_year ASC) previous_sales ,
current_sales-LAG(current_sales) OVER(partition by product_name order by order_year) diff_previousyear,
CASE WHEN current_sales-LAG(current_sales) OVER(partition by product_name order by order_year)>0 THEN 'Increase'
	WHEN current_sales-LAG(current_sales) OVER(partition by product_name order by order_year)<0 THEN 'Decrease'
	ElSE 'No change'
END py_change
from yearly_product_sales
ORDER by product_name, order_year
