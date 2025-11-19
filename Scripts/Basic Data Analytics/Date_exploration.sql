-- ==================================================
-- Date Exploration
-- ==================================================
-- Find the Date of first and last order
-- How many years of sales are available
select 
MIN(order_date) first_order_date,
MAX(order_date) last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) as order_range_years,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as order_range_month
from gold.fact_sales

-- Find the youngest and oldest customers
select 
MIN(birthdate) as oldest_birthdate,
MAX(birthdate) as youngest_birthdate,
DATEDIFF(year, MIN(birthdate), GETDATE()) as oldest_age,
DATEDIFF(year, MAX(birthdate), GETDATE()) as youngest_age
from gold.dim_customers
