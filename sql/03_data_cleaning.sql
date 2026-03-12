DROP TABLE IF EXISTS online_retail_clean;

CREATE TABLE online_retail_clean AS
SELECT
    TRIM(invoice_no) AS invoice_no,
    TRIM(stock_code) AS stock_code,
    TRIM(description) AS description,
    quantity,
    invoice_date,
    unit_price,
    NULLIF(TRIM(customer_id), '') AS customer_id,
    TRIM(country) AS country,
    (quantity * unit_price) AS line_revenue
FROM online_retail_raw
WHERE
    quantity > 0
    AND unit_price > 0
    AND invoice_no NOT LIKE 'C%'
    AND description IS NOT NULL
    AND TRIM(description) <> '';

-- Optional: inspect cleaned data
SELECT COUNT(*) AS cleaned_rows
FROM online_retail_clean;

SELECT *
FROM online_retail_clean
LIMIT 10;

-- Check remaining null customer IDs
SELECT COUNT(*) AS null_customer_ids_after_cleaning
FROM online_retail_clean
WHERE customer_id IS NULL;