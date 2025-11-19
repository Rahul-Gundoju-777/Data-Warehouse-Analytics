-- ==================================================
-- Measures Exploration
-- ==================================================
-- Find the total sales
select SUM(sales_amount) As total_sales from gold.fact_sales

-- Find how many items are sold
select SUM(quantity) as total_quantity from gold.fact_sales

-- Find the average selling price
select AVG(price) as avg_price from gold.fact_sales

-- Find the total number of orders
select COUNT(order_number) as total_orders from gold.fact_sales\
select COUNT(DISTINCT order_number) as total_orders from gold.fact_sales

-- Find the total number of products
select count(product_key) as total_products from gold.dim_products
select count(DISTINCT product_key) as total_products from gold.dim_products

-- Find the total number of customers
select count(customer_key) as total_customers from gold.dim_customers

-- Find the total number of customers that has placed an order
select count(DISTINCT customer_key) as total_customers from gold.fact_sales

-- Generate a report that shows all the key metrics of the business
select 'Total sales' as measure_name, SUM(sales_amount) As measure_value from gold.fact_sales
UNION ALL
select 'Total quantity', SUM(quantity) from gold.fact_sales
UNION ALL
select 'Average Price', AVG(price) from gold.fact_sales
UNION ALL
select 'Total nr orders', COUNT(DISTINCT order_number) from gold.fact_sales
UNION ALL
select 'Total nr products', count(DISTINCT product_key) from gold.dim_products
UNION ALL
select 'Total nr customers', count(customer_key) from gold.dim_customers
