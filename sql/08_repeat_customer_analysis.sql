-- Repeat vs one-time customers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS order_count
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time customers'
        ELSE 'Repeat customers'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-time customers'
        ELSE 'Repeat customers'
    END
ORDER BY customer_count DESC;

-- Revenue from repeat vs one-time customers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS order_count
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT
        customer_id,
        SUM(line_revenue) AS total_revenue
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN co.order_count = 1 THEN 'One-time customers'
        ELSE 'Repeat customers'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(SUM(cr.total_revenue), 2) AS revenue
FROM customer_orders co
JOIN customer_revenue cr
    ON co.customer_id = cr.customer_id
GROUP BY
    CASE
        WHEN co.order_count = 1 THEN 'One-time customers'
        ELSE 'Repeat customers'
    END
ORDER BY revenue DESC;

-- Top repeat customers by revenue
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS order_count
    FROM online_retail_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    co.customer_id,
    co.order_count,
    ROUND(SUM(orc.line_revenue), 2) AS total_revenue
FROM customer_orders co
JOIN online_retail_clean orc
    ON co.customer_id = orc.customer_id
WHERE co.order_count > 1
GROUP BY co.customer_id, co.order_count
ORDER BY total_revenue DESC
LIMIT 10;