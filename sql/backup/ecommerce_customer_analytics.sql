SHOW VARIABLES LIKE 'local_infile';
USE ecommerce_analytics;

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
SELECT COUNT(*) AS total_rows
FROM ecommerce_analytics.sales;
SELECT *
FROM ecommerce_analytics.sales
LIMIT 10;
SELECT
    MIN(invoicedate) AS first_date,
    MAX(invoicedate) AS last_date,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT stockcode) AS unique_products
FROM ecommerce_analytics.sales;
SELECT
    COUNT(*) AS total_rows,
    SUM(invoice IS NULL) AS missing_invoice,
    SUM(stockcode IS NULL) AS missing_stockcode,
    SUM(description IS NULL) AS missing_description,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(invoicedate IS NULL) AS missing_date,
    SUM(price IS NULL) AS missing_price,
    SUM(customer_id IS NULL) AS missing_customer,
    SUM(country IS NULL) AS missing_country,
    SUM(is_cancelled IS NULL) AS missing_cancelled,
    SUM(revenue IS NULL) AS missing_revenue
FROM ecommerce_analytics.sales;
SELECT
    is_cancelled,
    COUNT(*) AS total_rows,
    SUM(revenue) AS total_revenue
FROM ecommerce_analytics.sales
GROUP BY is_cancelled;
SELECT
    COUNT(*) AS total_rows,
    SUM(quantity < 0) AS negative_quantity,
    SUM(quantity = 0) AS zero_quantity,
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity
FROM ecommerce_analytics.sales;
SELECT
    COUNT(*) AS total_rows,
    SUM(price < 0) AS negative_price,
    SUM(price = 0) AS zero_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM ecommerce_analytics.sales;
SELECT
    invoice,
    stockcode,
    description,
    quantity,
    invoicedate,
    price,
    customer_id,
    country,
    revenue
FROM ecommerce_analytics.sales
WHERE price = 0
ORDER BY invoicedate;
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id <= 0) AS invalid_customer_ids,
    MIN(customer_id) AS minimum_customer_id,
    MAX(customer_id) AS maximum_customer_id,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM ecommerce_analytics.sales;
SELECT
    customer_id,
    COUNT(*) AS total_rows
FROM ecommerce_analytics.sales
WHERE customer_id <= 0
GROUP BY customer_id
ORDER BY total_rows DESC;
SELECT
    customer_id,
    COUNT(*) AS total_rows
FROM ecommerce_analytics.sales
WHERE customer_id <= 0
GROUP BY customer_id;
USE ecommerce_analytics;

CREATE OR REPLACE VIEW customer_sales AS
SELECT *
FROM sales
WHERE customer_id > 0;
SELECT COUNT(*) AS customer_rows
FROM customer_sales;
SELECT
    invoice,
    stockcode,
    description,
    quantity,
    invoicedate,
    customer_id,
    country,
    price,
    revenue
FROM sales
WHERE price = 0
ORDER BY invoicedate;
USE ecommerce_analytics;

CREATE OR REPLACE VIEW clean_sales AS
SELECT *
FROM sales
WHERE customer_id > 0
  AND price > 0;
SELECT COUNT(*) AS clean_rows
FROM clean_sales;
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT stockcode) AS unique_products,
    COUNT(DISTINCT country) AS countries,
    MIN(invoicedate) AS first_transaction,
    MAX(invoicedate) AS last_transaction,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_transaction_revenue
FROM clean_sales;
SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS month,
    COUNT(*) AS transactions,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DATE_FORMAT(invoicedate, '%Y-%m')
ORDER BY month;

-- =====================================================
-- BEST AND WORST MONTHS BY REVENUE
-- =====================================================

-- Top 5 months
SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS month,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DATE_FORMAT(invoicedate, '%Y-%m')
ORDER BY revenue DESC
LIMIT 5;


-- Bottom 5 months
SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS month,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS revenue
FROM clean_sales
GROUP BY DATE_FORMAT(invoicedate, '%Y-%m')
ORDER BY revenue ASC
LIMIT 5;

-- =====================================================
-- PRODUCT PERFORMANCE ANALYSIS
-- =====================================================

-- Top 10 products by revenue
SELECT
    stockcode,
    description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM clean_sales
GROUP BY stockcode, description
ORDER BY total_revenue DESC
LIMIT 10;


-- Top 10 products by quantity sold
SELECT
    stockcode,
    description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM clean_sales
GROUP BY stockcode, description
ORDER BY units_sold DESC
LIMIT 10;

-- =====================================================
-- PRODUCT REVENUE CONCENTRATION / PARETO ANALYSIS
-- =====================================================

WITH product_revenue AS (
    SELECT
        stockcode,
        description,
        ROUND(SUM(revenue), 2) AS product_revenue
    FROM clean_sales
    GROUP BY stockcode, description
),

ranked_products AS (
    SELECT
        stockcode,
        description,
        product_revenue,
        SUM(product_revenue) OVER (
            ORDER BY product_revenue DESC
        ) AS cumulative_revenue,
        SUM(product_revenue) OVER () AS total_revenue
    FROM product_revenue
)

SELECT
    stockcode,
    description,
    product_revenue,
    ROUND(cumulative_revenue, 2) AS cumulative_revenue,
    ROUND(
        cumulative_revenue / total_revenue * 100,
        2
    ) AS cumulative_revenue_pct
FROM ranked_products
ORDER BY product_revenue DESC;

-- =====================================================
-- 80% REVENUE CONTRIBUTION ANALYSIS
-- =====================================================

WITH product_revenue AS (
    SELECT
        stockcode,
        description,
        SUM(revenue) AS product_revenue
    FROM clean_sales
    GROUP BY stockcode, description
),

ranked_products AS (
    SELECT
        stockcode,
        description,
        product_revenue,
        SUM(product_revenue) OVER (
            ORDER BY product_revenue DESC
        ) AS cumulative_revenue,
        SUM(product_revenue) OVER () AS total_revenue
    FROM product_revenue
)

SELECT
    COUNT(*) AS products_needed_for_80pct,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM product_revenue) * 100,
        2
    ) AS pct_of_products
FROM ranked_products
WHERE cumulative_revenue <= total_revenue * 0.80;

-- =====================================================
-- CUSTOMER PERFORMANCE ANALYSIS
-- =====================================================

-- Top 10 customers by revenue
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM clean_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Top 10 customers by number of orders
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM clean_sales
GROUP BY customer_id
ORDER BY orders DESC
LIMIT 10;

-- Top 10 customers by revenue
SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM clean_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer Revenue Segmentation

SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue,
    CASE
        WHEN SUM(revenue) >= 10000 THEN 'High Value'
        WHEN SUM(revenue) >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM clean_sales
GROUP BY customer_id
ORDER BY total_revenue DESC;

-- Customer Segment Summary

WITH customer_segments AS (
    SELECT
        customer_id,
        ROUND(SUM(revenue), 2) AS total_revenue,
        CASE
            WHEN SUM(revenue) >= 10000 THEN 'High Value'
            WHEN SUM(revenue) >= 5000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM clean_sales
    GROUP BY customer_id
)

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS segment_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_segments
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

-- Top 10 Customers Revenue Contribution

WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank
    FROM customer_revenue
)

SELECT
    COUNT(*) AS top_10_customers,
    ROUND(SUM(total_revenue), 2) AS top_10_revenue,
    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_revenue) * 100,
        2
    ) AS revenue_contribution_pct
FROM ranked_customers
WHERE customer_rank <= 10;
-- Country Performance Analysis

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

-- Top 10 Countries by Revenue

SELECT
    country,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) /
        (SELECT SUM(revenue) FROM clean_sales) * 100,
        2
    ) AS revenue_contribution_pct
FROM clean_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- Revenue per Customer by Country

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT customer_id),
        2
    ) AS revenue_per_customer
FROM clean_sales
GROUP BY country
HAVING COUNT(DISTINCT customer_id) >= 5
ORDER BY revenue_per_customer DESC;

-- Country Revenue Concentration

WITH country_revenue AS (
    SELECT
        country,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM clean_sales
    GROUP BY country
),

ranked_countries AS (
    SELECT
        country,
        total_revenue,
        ROUND(
            total_revenue /
            (SELECT SUM(total_revenue) FROM country_revenue) * 100,
            2
        ) AS revenue_contribution_pct,
        ROUND(
            SUM(total_revenue) OVER (
                ORDER BY total_revenue DESC
            )
            /
            (SELECT SUM(total_revenue) FROM country_revenue) * 100,
            2
        ) AS cumulative_revenue_pct
    FROM country_revenue
)

SELECT
    country,
    total_revenue,
    revenue_contribution_pct,
    cumulative_revenue_pct
FROM ranked_countries
ORDER BY total_revenue DESC;

-- Country Customer Value Analysis

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT customer_id),
        2
    ) AS revenue_per_customer
FROM clean_sales
GROUP BY country
HAVING COUNT(DISTINCT customer_id) >= 5
ORDER BY revenue_per_customer DESC;

-- Bottom Countries by Customer Value

SELECT
    country,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT customer_id),
        2
    ) AS revenue_per_customer
FROM clean_sales
GROUP BY country
HAVING COUNT(DISTINCT customer_id) >= 5
ORDER BY revenue_per_customer ASC;
-- Country Revenue Efficiency

SELECT
    country,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT invoice),
        2
    ) AS revenue_per_order
FROM clean_sales
GROUP BY country
HAVING COUNT(DISTINCT invoice) >= 5
ORDER BY revenue_per_order DESC;

-- Customer Repeat Purchase Analysis

SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM clean_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT invoice) > 1
ORDER BY orders DESC, total_revenue DESC;

-- Repeat vs One-Time Customers

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders
    FROM clean_sales
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_orders),
        2
    ) AS customer_percentage
FROM customer_orders
GROUP BY
    CASE
        WHEN orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY customers DESC;

-- Revenue by Customer Type

WITH customer_revenue AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0 /
        (SELECT SUM(total_revenue) FROM customer_revenue),
        2
    ) AS revenue_percentage
FROM customer_revenue
GROUP BY
    CASE
        WHEN orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY total_revenue DESC;

-- Average Revenue per Customer Type

WITH customer_revenue AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue,
    ROUND(MIN(total_revenue), 2) AS min_customer_revenue,
    ROUND(MAX(total_revenue), 2) AS max_customer_revenue
FROM customer_revenue
GROUP BY
    CASE
        WHEN orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY avg_customer_revenue DESC;

-- Repeat Customer Revenue Impact

WITH customer_revenue AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        total_revenue,
        CASE
            WHEN orders = 1 THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM customer_revenue
)

SELECT
    customer_type,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_segments) * 100,
        2
    ) AS revenue_percentage,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_segments
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Customer Revenue Concentration / Pareto Analysis

WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM customer_revenue
)

SELECT
    COUNT(*) AS customers_needed_for_80pct,
    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM customer_revenue) * 100,
        2
    ) AS pct_of_customers
FROM ranked_customers
WHERE cumulative_revenue <= overall_revenue * 0.80;

-- Top 10 Customers Revenue Contribution

WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank
    FROM customer_revenue
)

SELECT
    COUNT(*) AS top_10_customers,
    ROUND(SUM(total_revenue), 2) AS top_10_revenue,
    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_revenue) * 100,
        2
    ) AS revenue_contribution_pct
FROM ranked_customers
WHERE customer_rank <= 10;

-- Top 10 Customers: Revenue & Order Value

SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT invoice),
        2
    ) AS revenue_per_order
FROM clean_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer Purchase Frequency Segmentation

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        orders,
        total_revenue,
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
    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_segments) * 100,
        2
    ) AS revenue_percentage,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_segments
GROUP BY frequency_segment
ORDER BY total_revenue DESC;

-- Customer Segment Revenue Opportunity

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        orders,
        total_revenue,
        CASE
            WHEN orders = 1 THEN 'One-Time'
            WHEN orders BETWEEN 2 AND 5 THEN 'Occasional'
            WHEN orders BETWEEN 6 AND 20 THEN 'Regular'
            ELSE 'Loyal'
        END AS frequency_segment
    FROM customer_orders
),

segment_metrics AS (
    SELECT
        frequency_segment,
        COUNT(*) AS customers,
        AVG(total_revenue) AS avg_revenue
    FROM customer_segments
    GROUP BY frequency_segment
)

SELECT
    s.frequency_segment,
    s.customers,
    ROUND(s.avg_revenue, 2) AS current_avg_revenue,

    ROUND(
        CASE
            WHEN s.frequency_segment = 'One-Time'
                THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Occasional')

            WHEN s.frequency_segment = 'Occasional'
                THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Regular')

            WHEN s.frequency_segment = 'Regular'
                THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Loyal')

            ELSE s.avg_revenue
        END,
        2
    ) AS next_segment_avg_revenue,

    ROUND(
        s.customers *
        (
            CASE
                WHEN s.frequency_segment = 'One-Time'
                    THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Occasional')

                WHEN s.frequency_segment = 'Occasional'
                    THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Regular')

                WHEN s.frequency_segment = 'Regular'
                    THEN (SELECT avg_revenue FROM segment_metrics WHERE frequency_segment = 'Loyal')

                ELSE s.avg_revenue
            END
            - s.avg_revenue
        ),
        2
    ) AS potential_incremental_revenue

FROM segment_metrics s
ORDER BY potential_incremental_revenue DESC;

-- Customer Revenue Concentration Analysis

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,
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

    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_revenue) * 100,
        2
    ) AS revenue_contribution_pct

FROM ranked_customers
GROUP BY
    CASE
        WHEN customer_rank <= total_customers * 0.01 THEN 'Top 1%'
        WHEN customer_rank <= total_customers * 0.05 THEN 'Top 5%'
        WHEN customer_rank <= total_customers * 0.10 THEN 'Top 10%'
        WHEN customer_rank <= total_customers * 0.20 THEN 'Top 20%'
        ELSE 'Remaining 80%'
    END
ORDER BY
    CASE customer_group
        WHEN 'Top 1%' THEN 1
        WHEN 'Top 5%' THEN 2
        WHEN 'Top 10%' THEN 3
        WHEN 'Top 20%' THEN 4
        ELSE 5
    END;
    
    -- Customer Lifetime Value Distribution

WITH customer_revenue AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(quantity) AS units_purchased,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM clean_sales
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        orders,
        units_purchased,
        total_revenue,

        CASE
            WHEN total_revenue >= 10000 THEN 'VIP'
            WHEN total_revenue >= 5000 THEN 'High Value'
            WHEN total_revenue >= 1000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS value_segment

    FROM customer_revenue
)

SELECT
    value_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_revenue) * 100,
        2
    ) AS revenue_contribution_pct,

    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue

FROM customer_segments

GROUP BY value_segment

ORDER BY total_revenue DESC;

-- Customer Value Segment Behavior Analysis

WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS orders,
        SUM(quantity) AS units_purchased,
        ROUND(SUM(revenue), 2) AS total_revenue,

        ROUND(
            SUM(revenue) / COUNT(DISTINCT invoice),
            2
        ) AS avg_order_value

    FROM clean_sales
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        orders,
        units_purchased,
        total_revenue,
        avg_order_value,

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

    ROUND(AVG(orders), 2) AS avg_orders,

    ROUND(AVG(units_purchased), 2) AS avg_units_purchased,

    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue,

    ROUND(AVG(avg_order_value), 2) AS avg_order_value

FROM customer_segments

GROUP BY value_segment

ORDER BY avg_customer_revenue DESC;

-- Customer Recency Analysis

WITH customer_activity AS (
    SELECT
        customer_id,

        MIN(invoicedate) AS first_purchase_date,

        MAX(invoicedate) AS last_purchase_date,

        COUNT(DISTINCT invoice) AS orders,

        ROUND(SUM(revenue), 2) AS total_revenue

    FROM clean_sales

    GROUP BY customer_id
)

SELECT
    customer_id,

    first_purchase_date,

    last_purchase_date,

    orders,

    total_revenue,

    DATEDIFF(
        DATE('2011-12-10'),
        DATE(last_purchase_date)
    ) AS days_since_last_purchase

FROM customer_activity

ORDER BY days_since_last_purchase DESC;

-- RFM Customer Analysis

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales

    GROUP BY customer_id
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary

FROM customer_rfm

ORDER BY monetary DESC;

-- RFM Scoring

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales

    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,

    recency_score,
    frequency_score,
    monetary_score,

    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score

FROM rfm_scores

ORDER BY
    monetary DESC;
    
    -- RFM Customer Segmentation

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales

    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,

    recency_score,
    frequency_score,
    monetary_score,

    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score,

    CASE

        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
        THEN 'Champions'

        WHEN recency_score >= 3
             AND frequency_score >= 4
        THEN 'Loyal Customers'

        WHEN recency_score >= 4
             AND frequency_score BETWEEN 2 AND 3
        THEN 'Potential Loyalists'

        WHEN recency_score >= 4
             AND monetary_score >= 4
             AND frequency_score <= 2
        THEN 'Big Spenders'

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

ORDER BY monetary DESC;

-- Customer Segment Performance

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        recency_score,
        frequency_score,
        monetary_score,

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
    customer_segment,

    COUNT(*) AS customers,

    ROUND(SUM(monetary), 2) AS total_revenue,

    ROUND(
        SUM(monetary) /
        (SELECT SUM(monetary) FROM customer_segments) * 100,
        2
    ) AS revenue_percentage,

    ROUND(AVG(monetary), 2) AS avg_customer_revenue,

    ROUND(AVG(frequency), 2) AS avg_orders

FROM customer_segments

GROUP BY customer_segment

ORDER BY total_revenue DESC;

-- RFM Segment Priority Analysis

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        recency_score,
        frequency_score,
        monetary_score,

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
),

segment_metrics AS (
    SELECT
        customer_segment,

        COUNT(*) AS customers,

        ROUND(SUM(monetary), 2) AS total_revenue,

        ROUND(AVG(monetary), 2) AS avg_customer_revenue,

        ROUND(AVG(frequency), 2) AS avg_orders

    FROM customer_segments

    GROUP BY customer_segment
)

SELECT
    customer_segment,
    customers,
    total_revenue,
    avg_customer_revenue,
    avg_orders,

    CASE

        WHEN customer_segment = 'Champions'
        THEN 'Protect & Reward'

        WHEN customer_segment = 'At Risk'
        THEN 'Win Back'

        WHEN customer_segment = 'Loyal Customers'
        THEN 'Retain & Upsell'

        WHEN customer_segment = 'Potential Loyalists'
        THEN 'Increase Engagement'

        WHEN customer_segment = 'Big Spenders'
        THEN 'Personalized Retention'

        WHEN customer_segment = 'Recent Customers'
        THEN 'Convert to Repeat'

        WHEN customer_segment = 'Hibernating'
        THEN 'Reactivation Campaign'

        ELSE 'Targeted Engagement'

    END AS recommended_action

FROM segment_metrics

ORDER BY total_revenue DESC;

-- High-Value At-Risk Customers

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        recency_score,
        frequency_score,
        monetary_score,

        CONCAT(
            recency_score,
            frequency_score,
            monetary_score
        ) AS rfm_score,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
            THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
            THEN 'Big Spenders'

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
    rfm_score,
    customer_segment,

    CASE
        WHEN monetary >= 50000
        THEN 'Critical'

        WHEN monetary >= 10000
        THEN 'High'

        WHEN monetary >= 1000
        THEN 'Medium'

        ELSE 'Low'
    END AS customer_value

FROM customer_segments

WHERE customer_segment = 'At Risk'

ORDER BY monetary DESC;

-- Revenue Opportunity by Customer Segment

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
            THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
            THEN 'Big Spenders'

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
    customer_segment,

    COUNT(*) AS customers,

    ROUND(SUM(monetary), 2) AS total_revenue,

    ROUND(AVG(monetary), 2) AS avg_customer_revenue,

    ROUND(AVG(frequency), 2) AS avg_orders,

    CASE
        WHEN customer_segment = 'At Risk'
        THEN 'High Priority - Win Back'

        WHEN customer_segment = 'Hibernating'
        THEN 'Reactivation Opportunity'

        WHEN customer_segment = 'Potential Loyalists'
        THEN 'Growth Opportunity'

        WHEN customer_segment = 'Loyal Customers'
        THEN 'Retention & Upsell'

        WHEN customer_segment = 'Champions'
        THEN 'Protect High-Value Base'

        ELSE 'Targeted Engagement'

    END AS business_priority

FROM customer_segments

GROUP BY customer_segment

ORDER BY total_revenue DESC;

-- At-Risk Customer Priority Summary

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        recency_score,
        frequency_score,
        monetary_score,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
            THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
            THEN 'Big Spenders'

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
),

at_risk_customers AS (
    SELECT
        *,
        CASE
            WHEN monetary >= 50000
                THEN 'Critical'

            WHEN monetary >= 10000
                THEN 'High'

            WHEN monetary >= 1000
                THEN 'Medium'

            ELSE 'Low'
        END AS customer_value

    FROM customer_segments

    WHERE customer_segment = 'At Risk'
)

SELECT
    customer_value,

    COUNT(*) AS customers,

    ROUND(SUM(monetary), 2) AS revenue_at_risk,

    ROUND(AVG(monetary), 2) AS avg_customer_value

FROM at_risk_customers

GROUP BY customer_value

ORDER BY
    CASE customer_value
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;
    
    -- At-Risk Revenue Recovery Scenario

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        monetary,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
            THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
            THEN 'Big Spenders'

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
),

at_risk_revenue AS (
    SELECT
        SUM(monetary) AS total_revenue_at_risk
    FROM customer_segments
    WHERE customer_segment = 'At Risk'
)

SELECT
    ROUND(total_revenue_at_risk, 2) AS revenue_at_risk,

    ROUND(total_revenue_at_risk * 0.25, 2)
        AS recovery_25_pct,

    ROUND(total_revenue_at_risk * 0.50, 2)
        AS recovery_50_pct,

    ROUND(total_revenue_at_risk * 0.75, 2)
        AS recovery_75_pct

FROM at_risk_revenue;

-- =====================================================
-- RFM DASHBOARD DATASET
-- =====================================================

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        recency_score,
        frequency_score,
        monetary_score,

        CONCAT(
            recency_score,
            frequency_score,
            monetary_score
        ) AS rfm_score,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
            THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
            THEN 'Big Spenders'

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
        WHEN monetary >= 50000
            THEN 'Critical'

        WHEN monetary >= 10000
            THEN 'High'

        WHEN monetary >= 1000
            THEN 'Medium'

        ELSE 'Low'

    END AS customer_value

FROM customer_segments

ORDER BY monetary DESC;

CREATE TABLE rfm_customer_dashboard AS

WITH customer_rfm AS (
    SELECT
        customer_id,

        DATEDIFF(
            DATE('2011-12-10'),
            DATE(MAX(invoicedate))
        ) AS recency,

        COUNT(DISTINCT invoice) AS frequency,

        ROUND(SUM(revenue), 2) AS monetary

    FROM clean_sales
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score

    FROM customer_rfm
),

customer_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        recency_score,
        frequency_score,
        monetary_score,

        CONCAT(
            recency_score,
            frequency_score,
            monetary_score
        ) AS rfm_score,

        CASE
            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
            THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                 AND frequency_score <= 2
            THEN 'Big Spenders'

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

SELECT *
FROM rfm_customer_dashboard
ORDER BY monetary DESC;

SELECT COUNT(*) AS total_customers
FROM rfm_customer_dashboard;