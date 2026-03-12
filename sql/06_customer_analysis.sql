-- Customers with known IDs only
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM online_retail_clean
WHERE customer_id IS NOT NULL;

-- Top 3 customers by revenue
SELECT
    customer_id,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM online_retail_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 3;

-- Top 10 customers by number of orders
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM online_retail_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Average revenue per customer
SELECT
    ROUND(AVG(customer_revenue), 2) AS avg_revenue_per_customer
FROM (
    SELECT
        customer_id,
        SUM(line_revenue) AS customer_revenue
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
) t;

-- Average number of orders per customer
SELECT
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS order_count
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
) t;

-- Top 10 customers by quantity purchased
SELECT
    customer_id,
    SUM(quantity) AS total_quantity
FROM online_retail_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_quantity DESC
LIMIT 10;