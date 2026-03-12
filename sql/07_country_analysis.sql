-- Top 5 countries by revenue
SELECT
    country,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM online_retail_clean
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 countries by number of orders
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM online_retail_clean
GROUP BY country
ORDER BY total_orders DESC
LIMIT 5;

-- Top 5 countries by number of customers
SELECT
    country,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM online_retail_clean
WHERE customer_id IS NOT NULL
GROUP BY country
ORDER BY unique_customers DESC
LIMIT 5;

-- Average order value by country
WITH order_totals AS (
    SELECT
        country,
        invoice_no,
        SUM(line_revenue) AS order_revenue
    FROM online_retail_clean
    GROUP BY country, invoice_no
)
SELECT
    country,
    ROUND(AVG(order_revenue), 2) AS avg_order_value
FROM order_totals
GROUP BY country
ORDER BY avg_order_value DESC
LIMIT 10;