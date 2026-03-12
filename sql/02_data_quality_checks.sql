-- Row count
SELECT COUNT(*) AS total_rows
FROM online_retail_raw;

-- Preview
SELECT *
FROM online_retail_raw
LIMIT 10;

-- Date range
SELECT
    MIN(invoice_date) AS min_invoice_date,
    MAX(invoice_date) AS max_invoice_date
FROM online_retail_raw;

-- Null checks
SELECT
    COUNT(*) AS null_descriptions
FROM online_retail_raw
WHERE description IS NULL;

SELECT
    COUNT(*) AS null_customer_ids
FROM online_retail_raw
WHERE customer_id IS NULL;

SELECT
    COUNT(*) AS null_invoice_dates
FROM online_retail_raw
WHERE invoice_date IS NULL;

-- Duplicate check
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    COUNT(*) AS duplicate_count
FROM online_retail_raw
GROUP BY
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Negative or zero quantity
SELECT
    COUNT(*) AS non_positive_quantity_rows
FROM online_retail_raw
WHERE quantity <= 0;

-- Negative or zero price
SELECT
    COUNT(*) AS non_positive_unit_price_rows
FROM online_retail_raw
WHERE unit_price <= 0;

-- Cancellation invoices
SELECT
    COUNT(*) AS cancelled_invoices
FROM online_retail_raw
WHERE invoice_no LIKE 'C%';

-- Unique customers
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM online_retail_raw
WHERE customer_id IS NOT NULL;

-- Unique products
SELECT
    COUNT(DISTINCT stock_code) AS unique_products
FROM online_retail_raw;

-- Country coverage
SELECT
    COUNT(DISTINCT country) AS unique_countries
FROM online_retail_raw;

-- Top countries by row count
SELECT
    country,
    COUNT(*) AS row_count
FROM online_retail_raw
GROUP BY country
ORDER BY row_count DESC
LIMIT 10;