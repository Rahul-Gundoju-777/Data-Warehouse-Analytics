--=============================================
-- Part to Whole Analysis
--=============================================
-- Which category contribute the most to overall sales ?
WITH category_sales AS (
Select 
category,
SUM(sales_amount) total_sales
from gold.fact_sales F
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY category)
Select 
category,
total_sales,
SUM(total_sales) OVER() overall_sales,
CONCAT(ROUND((CAST(total_sales as FLOAT)/SUM(total_sales) OVER())*100, 2), '%') AS percentage_of_total 
from category_sales
ORDER BY total_sales DESC
