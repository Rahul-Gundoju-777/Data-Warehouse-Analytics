-- ==================================================
-- Database Exploration
-- ==================================================
-- Explore all objects in the Database
Select * from INFORMATION_SCHEMA.TABLES

-- Explore all columns in the Database
Select * from INFORMATION_SCHEMA.COLUMNS
WHERE Table_name = 'dim_customers'
