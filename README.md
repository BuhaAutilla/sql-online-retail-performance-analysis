# SQL Online Retail Performance Analysis

## Executive Summary

## Executive Summary

This SQL project analyzes online retail transactional data to understand revenue drivers, customer behavior, product demand, and geographic concentration.

Key results:
- **541,909** raw rows were reduced to **530,100** cleaned rows
- total revenue reached **10,666,684.54**
- the dataset included **19,960** orders and **4,338** identifiable customers
- the **United Kingdom** dominated revenue, orders, and customer count
- **repeat customers** generated the majority of customer-linked revenue
- revenue peaked in **September–November 2011**, suggesting strong seasonality

![Executive summary chart placeholder](images/executive_summary_placeholder.png)

---

## Business Question

Which customers, products, and markets contribute most to commercial performance, and how can SQL-based analysis support better business decisions?

---

## Dataset

This project uses the **Online Retail** public dataset from the UCI Machine Learning Repository.

The dataset contains transactional records from a UK-based online retailer and includes:
- invoice number
- product code
- product description
- quantity
- invoice date
- unit price
- customer ID
- country

### Dataset Scope
- **Raw rows:** 541,909
- **Cleaned rows:** 530,100
- **Unique products:** 3,921
- **Unique countries:** 38

> Source: UCI Online Retail dataset

---

## Tools Used

- **SQL (PostgreSQL)**
- **DBeaver**
- **Git & GitHub**
- **CSV dataset**
- Optional preprocessing with Python

---

## Project Structure

```text
sql-online-retail-performance-analysis/
│
├── README.md
├── .gitignore
│
├── data/
│   ├── raw/
│   │   └── online_retail.csv
│   └── processed/
│
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_data_quality_checks.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_revenue_analysis.sql
│   ├── 05_product_analysis.sql
│   ├── 06_customer_analysis.sql
│   ├── 07_country_analysis.sql
│   ├── 08_repeat_customer_analysis.sql
│   └── 09_business_kpis.sql
│
├── results/
│
├── images/
│   ├── monthly_revenue_placeholder.png
│   ├── top_products_placeholder.png
│   ├── country_revenue_placeholder.png
│   └── repeat_customers_placeholder.png
│
└── docs/

## Analytical Workflow

Imported raw transactional data into PostgreSQL
Performed data quality checks
Created a cleaned working table
Calculated revenue and order KPIs
Analyzed product performance
Analyzed customer behavior
Compared country-level performance
Evaluated repeat vs one-time customer contribution
Translated findings into business recommendations

Data Cleaning Logic

A cleaned table was created from the raw dataset with the following logic:
- removed cancelled invoices (invoice_no LIKE 'C%')
- removed rows where quantity <= 0
- removed rows where unit_price <= 0
- removed rows with missing or blank descriptions
- trimmed text fields
- created a calculated field: line_revenue = quantity * unit_price

This cleaned table became the base for all subsequent analysis.

## Business KPIs

- **Total revenue:** 10,666,684.54
- **Total orders:** 19,960
- **Average order value:** 534.40
- **Total customers (known IDs):** 4,338
- **Average revenue per customer:** 2,054.27
- **Average orders per customer:** 4.27
- **Unique products:** 3,921
- **Unique countries:** 38

## Revenue Insights

The cleaned dataset generated a total revenue of **10,666,684.54** across **19,960** orders, with an average order value of **534.40**.

Revenue was not evenly distributed throughout the year. The strongest sales period was concentrated in the final quarter of 2011.

Top revenue months:
- **November 2011:** 1,509,496.33
- **October 2011:** 1,154,979.30
- **September 2011:** 1,058,590.17

This pattern suggests strong seasonality, with commercial performance accelerating significantly toward the end of the year.

## Product Insights

Order activity was concentrated around a relatively small set of highly recurring products.

Top products by number of orders:
- **WHITE HANGING HEART T-LIGHT HOLDER** — 2,189 orders
- **JUMBO BAG RED RETROSPOT** — 2,089 orders
- **REGENCY CAKESTAND 3 TIER** — 1,988 orders
- **PARTY BUNTING** — 1,685 orders
- **LUNCH BAG RED RETROSPOT** — 1,564 orders

These results suggest that a limited set of products likely played an important role in repeat demand, merchandising strategy, and inventory prioritization.

## Customer Insights

The cleaned dataset included 4,338 customers with known IDs.
Key Customer Metrics
Average revenue per customer: 2,054.27
Average orders per customer: 4.27
Top 3 Customers by Revenue
Customer 14646.0 — 280,206.02
Customer 18102.0 — 259,657.30
Customer 17450.0 — 194,550.79

These results suggest that revenue is concentrated among a relatively small share of high-value customers, which may be important for retention, account prioritization, and customer lifecycle strategy.

## Geographic Insights

The business operated across 38 countries, but commercial performance was highly concentrated geographically.

Top 5 Countries by Revenue
United Kingdom — 9,025,222.08
Netherlands — 285,446.34
EIRE — 283,453.96
Germany — 228,867.14
France — 209,715.11

Top 5 Countries by Number of Orders
United Kingdom — 18,019
Germany — 457
France — 392
EIRE — 288
Belgium — 98

Top 5 Countries by Number of Customers
United Kingdom — 3,920
Germany — 94
France — 87
Spain — 30
Belgium — 25

This indicates a very strong dependence on the UK market, while several smaller European markets still show measurable commercial activity and may represent expansion or optimization opportunities.

## Repeat Purchase Insights

Customer behavior was strongly driven by repeat purchasing.
### Customer Distribution
Repeat customers: 2,845
One-time customers: 1,493

### Revenue Contribution
Repeat customers: 8,295,096.17
One-time customers: 616,311.73

This suggests that repeat customers played a disproportionately important role in overall business performance. Retention and repeat purchase behavior appear to be major commercial drivers in this dataset.

## Key Findings

- The raw dataset contained **541,909** rows, of which **530,100** remained after cleaning.
- Total cleaned revenue reached **10,666,684.54** across **19,960** orders.
- The business showed strong **seasonality**, with revenue peaking in **September–November 2011**.
- Revenue and customer activity were heavily concentrated in the **United Kingdom**.
- A relatively small group of customers generated disproportionately high revenue.
- **Repeat customers** were the main commercial driver, contributing far more revenue than one-time customers.
- Order activity was concentrated around a small number of recurring products.

## Business Interpretation

This analysis highlights several commercially relevant patterns.

1. **Retention appears to matter more than one-time acquisition**
   Repeat customers significantly outperformed one-time customers in revenue contribution, which suggests that retention and reactivation strategies may be more valuable than focusing only on new customer acquisition.

2. **The business is highly dependent on the UK market**
   The United Kingdom dominated revenue, order volume, and customer count. This concentration may provide operational efficiency, but it also creates market dependency risk.

3. **Revenue is concentrated among a smaller set of customers and products**
   High-value customers and frequently ordered products likely deserve focused attention in lifecycle marketing, account prioritization, bundling, and inventory planning.

4. **Commercial performance is seasonal**
   The final quarter showed clear revenue acceleration, which suggests that planning for promotions, stock availability, and fulfillment capacity is especially important ahead of peak months.

## Final Recommendations

Based on the analysis, several business actions would be worth exploring:

- prioritize retention strategies for repeat customers
- identify the characteristics of high-value customers for better segmentation
- monitor dependence on the UK market and evaluate diversification opportunities
- focus inventory and promotional planning on top recurring products
- prepare seasonal campaigns and operational capacity in advance of Q4 peaks
- extend the analysis with cohort, RFM, or customer lifetime value approaches

Author
Larysa Yanushchyk
Data Analyst | Product & Business Analytics | SQL · Python · Tableau