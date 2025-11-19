-- ==================================================
-- Dimensions Exploration
-- ==================================================
-- Explore all countries our customers come from
Select DISTINCT country from gold.dim_customers

-- Explore all categories "The major divisions"
Select DISTINCT category, subcategory, product_name from gold.dim_products
ORDER BY 1,2,3
