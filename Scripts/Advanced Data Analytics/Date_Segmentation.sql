--=============================================
-- Data Segmentation
--=============================================
/* Segment products into cost ranges and count 
how many products fall into each segment */
WITH product_segments AS(    -- Creating CTE for better understanding
select
product_key,
product_name,
cost,
CASE WHEN cost<100 THEN 'Below 100'
	When cost BETWEEN 100 and 500 Then '100-500'
    When cost BETWEEN 500 And 1000 Then '500-1000'
    ELSE 'Above 1000'
END cost_range
from gold.dim_products)
select 
cost_range,
COUNT(product_key) as total_products
from product_segments
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based on their spending behaviour:
	- VIP: Customers with atleast 12 months of history and spending more than $5000.
    - Regular: Customers with atleast 12 months of history but spending $5000 or less.
    - New: Customers with a lifespan less then 12 months.
And find the total number of customers by each group.
*/
WITH customer_spending AS (
select 
c.customer_key,
SUM(f.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
DATEDIFF(month, MIN(order_date),MAX(order_date)) as lifespan
from gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
select 
customer_segment,
COUNT(customer_key) as total_customers
from
	(select
	customer_key,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 ELSE 'New'
	End as customer_segment
	from customer_spending)t
Group by customer_segment
Order BY total_customers DESC
