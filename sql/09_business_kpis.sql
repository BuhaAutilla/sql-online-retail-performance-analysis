-- Total revenue
SELECT
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM online_retail_clean;

-- Total orders
SELECT
    COUNT(DISTINCT invoice_no) AS total_orders
FROM online_retail_clean;

-- Total customers with known ID
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM online_retail_clean
WHERE customer_id IS NOT NULL;

-- Average order value
WITH order_totals AS (
    SELECT
        invoice_no,
        SUM(line_revenue) AS order_revenue
    FROM online_retail_clean
    GROUP BY invoice_no
)
SELECT
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM order_totals;

-- Average revenue per customer
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(line_revenue) AS customer_revenue
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    ROUND(AVG(customer_revenue), 2) AS average_revenue_per_customer
FROM customer_totals;

-- Average orders per customer
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS order_count
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    ROUND(AVG(order_count), 2) AS average_orders_per_customer
FROM customer_orders;

-- Total unique products
SELECT
    COUNT(DISTINCT stock_code) AS unique_products
FROM online_retail_clean;

-- Total countries
SELECT
    COUNT(DISTINCT country) AS unique_countries
FROM online_retail_clean;