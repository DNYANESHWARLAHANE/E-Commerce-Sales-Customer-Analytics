-- ================================================================
-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- FINAL PROFESSIONAL SQL SCRIPT
-- Database: ecommerce_analytics
-- Engine: MySQL 8+
-- Purpose: Rebuild the analytical layer used by SQL, Python and Power BI
-- ================================================================

USE ecommerce_analytics;

-- ================================================================
-- 01. DATA LOAD
-- ================================================================
-- NOTE: Update the LOCAL INFILE path below if the project folder
-- is moved to another machine or directory.

SHOW VARIABLES LIKE 'local_infile';

TRUNCATE TABLE sales;

LOAD DATA LOCAL INFILE 'C:/Users/lahan/Documents/E-Commerce-Sales-Customer-Analytics/data/cleaned_sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    invoice,
    stockcode,
    description,
    quantity,
    invoicedate,
    price,
    customer_id,
    country,
    is_cancelled,
    revenue
);

-- ================================================================
-- 02. RAW TRANSACTION VALIDATION
-- ================================================================

SELECT COUNT(*) AS total_rows
FROM sales;

SELECT *
FROM sales
LIMIT 10;

SELECT
    MIN(invoicedate) AS first_date,
    MAX(invoicedate) AS last_date,
    COUNT(DISTINCT invoice) AS unique_orders,
    COUNT(DISTINCT customer_id) AS identified_customers,
    COUNT(DISTINCT stockcode) AS unique_stockcodes,
    COUNT(DISTINCT country) AS countries,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_units
FROM sales;

SELECT
    COUNT(*) AS total_rows,
    SUM(invoice IS NULL) AS missing_invoice,
    SUM(stockcode IS NULL) AS missing_stockcode,
    SUM(description IS NULL) AS missing_description,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(invoicedate IS NULL) AS missing_date,
    SUM(price IS NULL) AS missing_price,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(country IS NULL) AS missing_country,
    SUM(is_cancelled IS NULL) AS missing_cancelled_flag,
    SUM(revenue IS NULL) AS missing_revenue
FROM sales;

SELECT
    is_cancelled,
    COUNT(*) AS rows_count,
    ROUND(SUM(revenue), 2) AS revenue
FROM sales
GROUP BY is_cancelled
ORDER BY is_cancelled;

SELECT
    COUNT(*) AS total_rows,
    SUM(quantity < 0) AS negative_quantity_rows,
    SUM(quantity = 0) AS zero_quantity_rows,
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity
FROM sales;

SELECT
    COUNT(*) AS total_rows,
    SUM(price < 0) AS negative_price_rows,
    SUM(price = 0) AS zero_price_rows,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM sales;

SELECT
    COUNT(*) AS invalid_customer_id_rows,
    MIN(customer_id) AS minimum_customer_id,
    MAX(customer_id) AS maximum_customer_id
FROM sales
WHERE customer_id IS NOT NULL
  AND customer_id <= 0;

-- ================================================================
-- 03. ANALYTICAL VIEWS
--
-- clean_sales       = all non-cancelled transaction rows
-- customer_sales    = identified-customer transactions
-- merchandise_sales  = product/merchandise transactions only
-- ================================================================

CREATE OR REPLACE VIEW clean_sales AS
SELECT *
FROM sales
WHERE UPPER(TRIM(is_cancelled)) = 'FALSE';

CREATE OR REPLACE VIEW customer_sales AS
SELECT *
FROM clean_sales
WHERE customer_id IS NOT NULL
  AND customer_id > 0
  AND price > 0;

CREATE OR REPLACE VIEW merchandise_sales AS
SELECT *
FROM clean_sales
WHERE price > 0
  AND UPPER(TRIM(COALESCE(stockcode, ''))) NOT IN (
        'M', 'POST', 'AMAZONFEE', 'C2', 'BANK CHARGES', 'DOT', 'DOTCOM'
  )
  AND UPPER(TRIM(COALESCE(description, ''))) NOT IN (
        'MANUAL', 'POSTAGE', 'DOTCOM POSTAGE', 'BANK CHARGES', 'AMAZON FEE'
  );

-- View-level reconciliation
SELECT
    (SELECT COUNT(*) FROM sales) AS transaction_rows,
    (SELECT COUNT(*) FROM clean_sales) AS clean_sales_rows,
    (SELECT COUNT(*) FROM customer_sales) AS identified_customer_rows,
    (SELECT COUNT(*) FROM merchandise_sales) AS merchandise_rows;

SELECT
    ROUND((SELECT SUM(revenue) FROM sales), 2) AS transaction_revenue,
    ROUND((SELECT SUM(revenue) FROM clean_sales), 2) AS clean_sales_revenue,
    ROUND((SELECT SUM(revenue) FROM merchandise_sales), 2) AS merchandise_revenue;

-- ================================================================
-- 04. EXECUTIVE SALES KPIs
-- ================================================================

SELECT
    COUNT(*) AS transaction_rows,
    COUNT(DISTINCT invoice) AS total_orders,
    SUM(quantity) AS total_units,
    COUNT(DISTINCT customer_id) AS identified_customers,
    COUNT(DISTINCT stockcode) AS unique_stockcodes,
    COUNT(DISTINCT country) AS countries,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS average_order_value,
    MIN(invoicedate) AS first_transaction,
    MAX(invoicedate) AS last_transaction
FROM clean_sales;

-- Identified-customer revenue KPIs
SELECT
    COUNT(DISTINCT customer_id) AS identified_customers,
    ROUND(SUM(revenue), 2) AS identified_customer_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2) AS revenue_per_identified_customer,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS identified_customer_aov
FROM customer_sales;

-- ================================================================
-- 05. MONTHLY SALES PERFORMANCE
-- ================================================================

SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS month_key,
    COUNT(*) AS transactions,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS identified_customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DATE_FORMAT(invoicedate, '%Y-%m')
ORDER BY month_key;

SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS month_key,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DATE_FORMAT(invoicedate, '%Y-%m')
ORDER BY revenue DESC
LIMIT 5;

SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS month_key,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DATE_FORMAT(invoicedate, '%Y-%m')
ORDER BY revenue ASC
LIMIT 5;

-- ================================================================
-- 06. PRODUCT PERFORMANCE
-- Product analysis uses merchandise_sales so service/administrative
-- codes such as DOTCOM are not presented as products.
-- ================================================================

SELECT
    stockcode,
    description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM merchandise_sales
GROUP BY stockcode, description
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    stockcode,
    description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM merchandise_sales
GROUP BY stockcode, description
ORDER BY units_sold DESC
LIMIT 10;

SELECT
    stockcode,
    description,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS revenue_per_order
FROM merchandise_sales
GROUP BY stockcode, description
ORDER BY total_revenue DESC
LIMIT 50;

-- Product average selling price
SELECT
    stockcode,
    description,
    ROUND(SUM(revenue) / NULLIF(SUM(quantity), 0), 2) AS average_selling_price,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM merchandise_sales
GROUP BY stockcode, description
HAVING SUM(quantity) > 0
ORDER BY revenue DESC
LIMIT 20;

-- ================================================================
-- 07. PRODUCT PARETO / REVENUE CONCENTRATION
-- ================================================================

WITH product_revenue AS (
    SELECT
        stockcode,
        description,
        SUM(revenue) AS product_revenue
    FROM merchandise_sales
    GROUP BY stockcode, description
),
ranked_products AS (
    SELECT
        stockcode,
        description,
        product_revenue,
        SUM(product_revenue) OVER (
            ORDER BY product_revenue DESC, stockcode
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(product_revenue) OVER () AS total_revenue
    FROM product_revenue
)
SELECT
    stockcode,
    description,
    ROUND(product_revenue, 2) AS product_revenue,
    ROUND(cumulative_revenue, 2) AS cumulative_revenue,
    ROUND(cumulative_revenue / NULLIF(total_revenue, 0) * 100, 2) AS cumulative_revenue_pct
FROM ranked_products
ORDER BY product_revenue DESC;

-- Number of products required to reach at least 80% of merchandise revenue
WITH product_revenue AS (
    SELECT
        stockcode,
        description,
        SUM(revenue) AS product_revenue
    FROM merchandise_sales
    GROUP BY stockcode, description
),
ranked_products AS (
    SELECT
        stockcode,
        description,
        product_revenue,
        SUM(product_revenue) OVER (
            ORDER BY product_revenue DESC, stockcode
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(product_revenue) OVER () AS total_revenue
    FROM product_revenue
)
SELECT
    COUNT(*) AS products_needed_to_reach_80pct,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM product_revenue) * 100, 2) AS pct_of_products
FROM ranked_products
WHERE cumulative_revenue - product_revenue < total_revenue * 0.80;

-- ================================================================
-- 08. COUNTRY PERFORMANCE
-- ================================================================

SELECT
    country,
    COUNT(*) AS transactions,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_transaction_revenue
FROM clean_sales
GROUP BY country
ORDER BY total_revenue DESC;

SELECT
    country,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF((SELECT SUM(revenue) FROM clean_sales), 0) * 100, 2) AS revenue_contribution_pct
FROM clean_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT customer_id), 0), 2) AS revenue_per_customer
FROM customer_sales
GROUP BY country
HAVING COUNT(DISTINCT customer_id) >= 5
ORDER BY revenue_per_customer DESC;

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT customer_id), 0), 2) AS revenue_per_customer
FROM customer_sales
GROUP BY country
HAVING COUNT(DISTINCT customer_id) >= 5
ORDER BY revenue_per_customer ASC;

SELECT
    country,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT invoice), 0), 2) AS revenue_per_order
FROM clean_sales
GROUP BY country
HAVING COUNT(DISTINCT invoice) >= 5
ORDER BY revenue_per_order DESC;

-- Country revenue concentration
WITH country_revenue AS (
    SELECT country, SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY country
), ranked_countries AS (
    SELECT
        country,
        total_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC, country
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM country_revenue
)
SELECT
    country,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_revenue / NULLIF(overall_revenue, 0) * 100, 2) AS revenue_contribution_pct,
    ROUND(cumulative_revenue / NULLIF(overall_revenue, 0) * 100, 2) AS cumulative_revenue_pct
FROM ranked_countries
ORDER BY total_revenue DESC;

-- ================================================================
-- 09. TIME ANALYSIS
-- ================================================================

SELECT
    DAYNAME(invoicedate) AS day_of_week,
    DAYOFWEEK(invoicedate) AS day_number,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DAYNAME(invoicedate), DAYOFWEEK(invoicedate)
ORDER BY day_number;

SELECT
    HOUR(invoicedate) AS sales_hour,
    COUNT(*) AS transactions,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY HOUR(invoicedate)
ORDER BY sales_hour;

-- ================================================================
-- 10. CUSTOMER PERFORMANCE
-- Customer-level analysis uses identified customers only.
-- ================================================================

SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM customer_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM customer_sales
GROUP BY customer_id
ORDER BY orders DESC, total_revenue DESC
LIMIT 10;

SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT invoice), 0), 2) AS revenue_per_order
FROM customer_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- ================================================================
-- 11. CUSTOMER VALUE SEGMENTATION
-- Business thresholds are documented rules, not ML classifications.
-- VIP >= 10,000; High Value >= 5,000; Medium Value >= 1,000.
-- ================================================================

WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(quantity) AS units_purchased,
        SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
), customer_segments AS (
    SELECT
        *,
        CASE
            WHEN total_revenue >= 10000 THEN 'VIP'
            WHEN total_revenue >= 5000 THEN 'High Value'
            WHEN total_revenue >= 1000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS value_segment
    FROM customer_metrics
)
SELECT
    value_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF((SELECT SUM(total_revenue) FROM customer_metrics), 0) * 100, 2) AS revenue_percentage,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_segments
GROUP BY value_segment
ORDER BY total_revenue DESC;

SELECT
    value_segment,
    COUNT(*) AS customers,
    ROUND(AVG(orders), 2) AS avg_orders,
    ROUND(AVG(units_purchased), 2) AS avg_units_purchased,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue,
    ROUND(AVG(total_revenue / NULLIF(orders, 0)), 2) AS avg_order_value
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(quantity) AS units_purchased,
        SUM(revenue) AS total_revenue,
        CASE
            WHEN SUM(revenue) >= 10000 THEN 'VIP'
            WHEN SUM(revenue) >= 5000 THEN 'High Value'
            WHEN SUM(revenue) >= 1000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS value_segment
    FROM customer_sales
    GROUP BY customer_id
) s
GROUP BY value_segment
ORDER BY avg_customer_revenue DESC;

-- ================================================================
-- 12. REPEAT VS ONE-TIME CUSTOMERS
-- ================================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
)
SELECT
    CASE WHEN orders = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END AS customer_type,
    COUNT(*) AS customers,
    ROUND(COUNT(*) / NULLIF((SELECT COUNT(*) FROM customer_orders), 0) * 100, 2) AS customer_percentage
FROM customer_orders
GROUP BY CASE WHEN orders = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END
ORDER BY customers DESC;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
)
SELECT
    CASE WHEN orders = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END AS customer_type,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF((SELECT SUM(total_revenue) FROM customer_orders), 0) * 100, 2) AS revenue_percentage,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_orders
GROUP BY CASE WHEN orders = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END
ORDER BY total_revenue DESC;

-- ================================================================
-- 13. CUSTOMER PURCHASE FREQUENCY
-- ================================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
), frequency_segments AS (
    SELECT
        *,
        CASE
            WHEN orders = 1 THEN 'One-Time'
            WHEN orders BETWEEN 2 AND 5 THEN 'Occasional'
            WHEN orders BETWEEN 6 AND 20 THEN 'Regular'
            ELSE 'Loyal'
        END AS frequency_segment
    FROM customer_orders
)
SELECT
    frequency_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF((SELECT SUM(total_revenue) FROM customer_orders), 0) * 100, 2) AS revenue_percentage,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM frequency_segments
GROUP BY frequency_segment
ORDER BY total_revenue DESC;

-- Revenue opportunity if customers progress to the next frequency segment
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
), frequency_segments AS (
    SELECT
        *,
        CASE
            WHEN orders = 1 THEN 'One-Time'
            WHEN orders BETWEEN 2 AND 5 THEN 'Occasional'
            WHEN orders BETWEEN 6 AND 20 THEN 'Regular'
            ELSE 'Loyal'
        END AS frequency_segment
    FROM customer_orders
), segment_metrics AS (
    SELECT frequency_segment, COUNT(*) AS customers, AVG(total_revenue) AS avg_revenue
    FROM frequency_segments
    GROUP BY frequency_segment
)
SELECT
    s.frequency_segment,
    s.customers,
    ROUND(s.avg_revenue, 2) AS current_avg_revenue,
    ROUND(CASE
        WHEN s.frequency_segment = 'One-Time' THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Occasional')
        WHEN s.frequency_segment = 'Occasional' THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Regular')
        WHEN s.frequency_segment = 'Regular' THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Loyal')
        ELSE s.avg_revenue
    END, 2) AS next_segment_avg_revenue,
    ROUND(s.customers * (CASE
        WHEN s.frequency_segment = 'One-Time' THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Occasional')
        WHEN s.frequency_segment = 'Occasional' THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Regular')
        WHEN s.frequency_segment = 'Regular' THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Loyal')
        ELSE s.avg_revenue
    END - s.avg_revenue), 2) AS potential_incremental_revenue
FROM segment_metrics s
ORDER BY potential_incremental_revenue DESC;

-- ================================================================
-- 14. CUSTOMER REVENUE CONCENTRATION / PARETO
-- ================================================================

WITH customer_revenue AS (
    SELECT customer_id, SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
), ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC, customer_id) AS customer_rank,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC, customer_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_rank,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(cumulative_revenue / NULLIF(overall_revenue, 0) * 100, 2) AS cumulative_revenue_pct
FROM ranked_customers
ORDER BY customer_rank
LIMIT 100;

WITH customer_revenue AS (
    SELECT customer_id, SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
), ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC, customer_id) AS customer_rank
    FROM customer_revenue
)
SELECT
    COUNT(*) AS top_10_customers,
    ROUND(SUM(total_revenue), 2) AS top_10_revenue,
    ROUND(SUM(total_revenue) / NULLIF((SELECT SUM(total_revenue) FROM customer_revenue), 0) * 100, 2) AS revenue_contribution_pct
FROM ranked_customers
WHERE customer_rank <= 10;

-- Customer concentration groups
WITH customer_revenue AS (
    SELECT customer_id, SUM(revenue) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
), ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC, customer_id) AS customer_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_revenue
)
SELECT
    CASE
        WHEN customer_rank <= total_customers * 0.01 THEN 'Top 1%'
        WHEN customer_rank <= total_customers * 0.05 THEN 'Top 5%'
        WHEN customer_rank <= total_customers * 0.10 THEN 'Top 10%'
        WHEN customer_rank <= total_customers * 0.20 THEN 'Top 20%'
        ELSE 'Remaining 80%'
    END AS customer_group,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS revenue,
    ROUND(SUM(total_revenue) / NULLIF((SELECT SUM(total_revenue) FROM customer_revenue), 0) * 100, 2) AS revenue_contribution_pct
FROM ranked_customers
GROUP BY CASE
    WHEN customer_rank <= total_customers * 0.01 THEN 'Top 1%'
    WHEN customer_rank <= total_customers * 0.05 THEN 'Top 5%'
    WHEN customer_rank <= total_customers * 0.10 THEN 'Top 10%'
    WHEN customer_rank <= total_customers * 0.20 THEN 'Top 20%'
    ELSE 'Remaining 80%'
END
ORDER BY FIELD(customer_group, 'Top 1%', 'Top 5%', 'Top 10%', 'Top 20%', 'Remaining 80%');

-- ================================================================
-- 15. CUSTOMER RECENCY
-- ================================================================

WITH analysis_date AS (
    SELECT DATE_ADD(DATE(MAX(invoicedate)), INTERVAL 1 DAY) AS as_of_date
    FROM customer_sales
), customer_activity AS (
    SELECT
        customer_id,
        MIN(invoicedate) AS first_purchase_date,
        MAX(invoicedate) AS last_purchase_date,
        COUNT(DISTINCT invoice) AS orders,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM customer_sales
    GROUP BY customer_id
)
SELECT
    ca.customer_id,
    ca.first_purchase_date,
    ca.last_purchase_date,
    ca.orders,
    ca.total_revenue,
    DATEDIFF(ad.as_of_date, DATE(ca.last_purchase_date)) AS days_since_last_purchase
FROM customer_activity ca
CROSS JOIN analysis_date ad
ORDER BY days_since_last_purchase DESC;

-- ================================================================
-- 16. CANONICAL RFM DATASET
-- Recency score: higher = more recent.
-- Therefore NTILE is ordered DESC on recency days.
-- Frequency and monetary: higher values receive higher scores.
-- ================================================================

DROP TABLE IF EXISTS rfm_customer_dashboard;

CREATE TABLE rfm_customer_dashboard AS
WITH analysis_date AS (
    SELECT DATE_ADD(DATE(MAX(invoicedate)), INTERVAL 1 DAY) AS as_of_date
    FROM customer_sales
), customer_rfm AS (
    SELECT
        cs.customer_id,
        DATEDIFF(ad.as_of_date, DATE(MAX(cs.invoicedate))) AS recency,
        COUNT(DISTINCT cs.invoice) AS frequency,
        ROUND(SUM(cs.revenue), 2) AS monetary
    FROM customer_sales cs
    CROSS JOIN analysis_date ad
    GROUP BY cs.customer_id, ad.as_of_date
), rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC, customer_id) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC, customer_id) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC, customer_id) AS monetary_score
    FROM customer_rfm
), customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        recency_score,
        frequency_score,
        monetary_score,
        (recency_score * 100 + frequency_score * 10 + monetary_score) AS rfm_score,
        CASE
            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
                THEN 'Champions'
            WHEN recency_score >= 3
                 AND frequency_score >= 4
                THEN 'Loyal Customers'
            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
                THEN 'Big Spenders'
            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
                THEN 'Potential Loyalists'
            WHEN recency_score <= 2
                 AND frequency_score >= 4
                THEN 'At Risk'
            WHEN recency_score <= 2
                 AND frequency_score <= 2
                 AND monetary_score <= 2
                THEN 'Hibernating'
            WHEN recency_score >= 4
                THEN 'Recent Customers'
            ELSE 'Needs Attention'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,
    customer_segment,
    CASE
        WHEN monetary >= 50000 THEN 'Critical'
        WHEN monetary >= 10000 THEN 'High'
        WHEN monetary >= 1000 THEN 'Medium'
        ELSE 'Low'
    END AS customer_value
FROM customer_segments;

-- ================================================================
-- 17. RFM DATASET VALIDATION
-- ================================================================

SELECT COUNT(*) AS rfm_customers
FROM rfm_customer_dashboard;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(customer_id IS NULL) AS missing_customer_ids
FROM rfm_customer_dashboard;

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(SUM(monetary) / NULLIF((SELECT SUM(monetary) FROM rfm_customer_dashboard), 0) * 100, 2) AS revenue_percentage,
    ROUND(AVG(monetary), 2) AS avg_customer_revenue,
    ROUND(AVG(frequency), 2) AS avg_orders
FROM rfm_customer_dashboard
GROUP BY customer_segment
ORDER BY total_revenue DESC;

SELECT
    customer_value,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(AVG(monetary), 2) AS avg_customer_value
FROM rfm_customer_dashboard
GROUP BY customer_value
ORDER BY FIELD(customer_value, 'Critical', 'High', 'Medium', 'Low');

-- ================================================================
-- 18. RFM BUSINESS PRIORITY
-- ================================================================

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(AVG(monetary), 2) AS avg_customer_revenue,
    ROUND(AVG(frequency), 2) AS avg_orders,
    CASE
        WHEN customer_segment = 'Champions' THEN 'Protect & Reward'
        WHEN customer_segment = 'Loyal Customers' THEN 'Retain & Upsell'
        WHEN customer_segment = 'Big Spenders' THEN 'Personalized Retention'
        WHEN customer_segment = 'Potential Loyalists' THEN 'Increase Engagement'
        WHEN customer_segment = 'At Risk' THEN 'Win Back'
        WHEN customer_segment = 'Hibernating' THEN 'Reactivation Campaign'
        WHEN customer_segment = 'Recent Customers' THEN 'Convert to Repeat'
        ELSE 'Targeted Engagement'
    END AS recommended_action
FROM rfm_customer_dashboard
GROUP BY customer_segment
ORDER BY total_revenue DESC;

-- ================================================================
-- 19. HIGH-VALUE AT-RISK CUSTOMERS
-- Value thresholds are business rules:
-- Critical >= 50,000; High >= 10,000; Medium >= 1,000; else Low.
-- ================================================================

SELECT
    customer_id,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    rfm_score,
    customer_value
FROM rfm_customer_dashboard
WHERE customer_segment = 'At Risk'
ORDER BY monetary DESC;

SELECT
    customer_value,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS revenue_at_risk,
    ROUND(AVG(monetary), 2) AS avg_customer_value
FROM rfm_customer_dashboard
WHERE customer_segment = 'At Risk'
GROUP BY customer_value
ORDER BY FIELD(customer_value, 'Critical', 'High', 'Medium', 'Low');

SELECT
    ROUND(SUM(monetary), 2) AS total_revenue_at_risk,
    ROUND(SUM(monetary) * 0.25, 2) AS recovery_25_pct,
    ROUND(SUM(monetary) * 0.50, 2) AS recovery_50_pct,
    ROUND(SUM(monetary) * 0.75, 2) AS recovery_75_pct
FROM rfm_customer_dashboard
WHERE customer_segment = 'At Risk';

-- ================================================================
-- 20. FINAL PROJECT RECONCILIATION
-- Expected values are based on the authoritative cleaned_sales.csv
-- used by the project. The query reports PASS/REVIEW rather than
-- silently changing data.
-- ================================================================

SELECT
    COUNT(*) AS transaction_rows,
    ROUND(SUM(revenue), 2) AS transaction_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    SUM(quantity) AS total_units,
    COUNT(DISTINCT customer_id) AS identified_customers,
    CASE
        WHEN COUNT(*) = 993401
         AND ROUND(SUM(revenue), 2) = 19433661.76
         AND COUNT(DISTINCT invoice) = 39492
         AND SUM(quantity) = 11097626
         AND COUNT(DISTINCT customer_id) = 5851
        THEN 'PASS'
        ELSE 'REVIEW'
    END AS reconciliation_status
FROM clean_sales;

SELECT
    (SELECT COUNT(*) FROM clean_sales) AS transaction_rows,
    (SELECT COUNT(*) FROM rfm_customer_dashboard) AS rfm_rows,
    (SELECT COUNT(DISTINCT customer_id) FROM rfm_customer_dashboard) AS unique_rfm_customers,
    CASE
        WHEN (SELECT COUNT(*) FROM rfm_customer_dashboard)
           = (SELECT COUNT(DISTINCT customer_id) FROM customer_sales)
         AND (SELECT COUNT(*) FROM rfm_customer_dashboard)
           = (SELECT COUNT(DISTINCT customer_id) FROM rfm_customer_dashboard)
        THEN 'PASS'
        ELSE 'REVIEW'
    END AS rfm_reconciliation_status;

SELECT
    COUNT(*) AS clean_sales_rows,

    SUM(
        CASE
            WHEN price > 0
             AND UPPER(TRIM(COALESCE(stockcode, ''))) NOT IN (
                 'M',
                 'POST',
                 'AMAZONFEE',
                 'C2',
                 'BANK CHARGES',
                 'DOT',
                 'DOTCOM'
             )
             AND UPPER(TRIM(COALESCE(description, ''))) NOT IN (
                 'MANUAL',
                 'POSTAGE',
                 'DOTCOM POSTAGE',
                 'BANK CHARGES',
                 'AMAZON FEE'
             )
            THEN 1
            ELSE 0
        END
    ) AS merchandise_rows,

    SUM(
        CASE
            WHEN price > 0
             AND UPPER(TRIM(COALESCE(stockcode, ''))) NOT IN (
                 'M',
                 'POST',
                 'AMAZONFEE',
                 'C2',
                 'BANK CHARGES',
                 'DOT',
                 'DOTCOM'
             )
             AND UPPER(TRIM(COALESCE(description, ''))) NOT IN (
                 'MANUAL',
                 'POSTAGE',
                 'DOTCOM POSTAGE',
                 'BANK CHARGES',
                 'AMAZON FEE'
             )
            THEN 0
            ELSE 1
        END
    ) AS excluded_rows,

    ROUND(SUM(revenue), 2) AS clean_sales_revenue,

    ROUND(
        SUM(
            CASE
                WHEN price > 0
                 AND UPPER(TRIM(COALESCE(stockcode, ''))) NOT IN (
                     'M',
                     'POST',
                     'AMAZONFEE',
                     'C2',
                     'BANK CHARGES',
                     'DOT',
                     'DOTCOM'
                 )
                 AND UPPER(TRIM(COALESCE(description, ''))) NOT IN (
                     'MANUAL',
                     'POSTAGE',
                     'DOTCOM POSTAGE',
                     'BANK CHARGES',
                     'AMAZON FEE'
                 )
                THEN revenue
                ELSE 0
            END
        ),
        2
    ) AS merchandise_revenue,

    ROUND(
        SUM(
            CASE
                WHEN price > 0
                 AND UPPER(TRIM(COALESCE(stockcode, ''))) NOT IN (
                     'M',
                     'POST',
                     'AMAZONFEE',
                     'C2',
                     'BANK CHARGES',
                     'DOT',
                     'DOTCOM'
                 )
                 AND UPPER(TRIM(COALESCE(description, ''))) NOT IN (
                     'MANUAL',
                     'POSTAGE',
                     'DOTCOM POSTAGE',
                     'BANK CHARGES',
                     'AMAZON FEE'
                 )
                THEN 0
                ELSE revenue
            END
        ),
        2
    ) AS excluded_revenue

FROM clean_sales;

-- ================================================================
-- END OF FINAL SQL SCRIPT
-- ================================================================

