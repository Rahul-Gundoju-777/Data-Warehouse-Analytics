-- ==================================================
-- RANKING ANALYSIS
-- ==================================================
-- Which 5 products generate the highest revenue ??
select TOP 5
p.product_name,
SUM(f.sales_amount) total_revenue
from gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

select * from
	(select
	p.product_name,
	SUM(f.sales_amount) total_revenue,
	ROW_NUMBER() OVER(order by SUM(f.sales_amount) DESC) rank_products
	from gold.fact_sales f 
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name)t
Where rank_products<=5


-- What are the 5 worst-performing products interms of sales ??
select TOP 5
p.product_name,
SUM(f.sales_amount) total_revenue
from gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

-- Find top 10 customers who have generated the highest revenue and 3 customers with the fewest orders placed
select TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT order_number) as total_orders
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders
