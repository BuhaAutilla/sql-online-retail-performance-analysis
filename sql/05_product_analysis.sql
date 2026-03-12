-- Top 10 products by revenue
SELECT
    stock_code,
    description,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM online_retail_clean
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 products by quantity sold
SELECT
    stock_code,
    description,
    SUM(quantity) AS total_quantity_sold
FROM online_retail_clean
GROUP BY stock_code, description
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Product contribution frequency
SELECT
    COUNT(DISTINCT stock_code) AS unique_products_after_cleaning
FROM online_retail_clean;

-- Top 5 products by number of orders
SELECT
    stock_code,
    description,
    COUNT(DISTINCT invoice_no) AS order_count
FROM online_retail_clean
GROUP BY stock_code, description
ORDER BY order_count DESC
LIMIT 5;