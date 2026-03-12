-- Total revenue
SELECT
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM online_retail_clean;

-- Revenue by month
SELECT
    DATE_TRUNC('month', invoice_date) AS revenue_month,
    ROUND(SUM(line_revenue), 2) AS monthly_revenue
FROM online_retail_clean
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY revenue_month;

-- Orders by month
SELECT
    DATE_TRUNC('month', invoice_date) AS order_month,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM online_retail_clean
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY order_month;

-- Average order value by month
WITH order_totals AS (
    SELECT
        invoice_no,
        DATE_TRUNC('month', invoice_date) AS order_month,
        SUM(line_revenue) AS order_revenue
    FROM online_retail_clean
    GROUP BY invoice_no, DATE_TRUNC('month', invoice_date)
)
SELECT
    order_month,
    ROUND(AVG(order_revenue), 2) AS avg_order_value
FROM order_totals
GROUP BY order_month
ORDER BY order_month;

-- Top 3 revenue months
SELECT
    DATE_TRUNC('month', invoice_date) AS revenue_month,
    ROUND(SUM(line_revenue), 2) AS monthly_revenue
FROM online_retail_clean
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY monthly_revenue DESC
LIMIT 3;