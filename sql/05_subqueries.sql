-- ============================================================
-- File: 05_subqueries.sql
-- Project: Sales Data Analytics
-- Description: Subqueries, CTEs, and Window Functions
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

-- ============================================================
-- SECTION 1: SCALAR SUBQUERIES
-- ============================================================

-- SQ1: Products with above-average sales
SELECT
    p.product_name,
    sc.sub_category_name,
    ROUND(SUM(oi.sales), 2) AS total_sales
FROM order_items oi
JOIN products p      ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name
HAVING SUM(oi.sales) > (
    SELECT AVG(sub.total_sales)
    FROM (
        SELECT SUM(sales) AS total_sales
        FROM order_items
        GROUP BY product_id
    ) sub
)
ORDER BY total_sales DESC;

-- SQ2: Customers who spent more than the average customer
SELECT
    c.customer_name,
    c.segment,
    c.region,
    ROUND(SUM(oi.sales), 2) AS total_spent
FROM customers c
JOIN orders o    ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.segment, c.region
HAVING SUM(oi.sales) > (
    SELECT AVG(cust_sales.total_spent)
    FROM (
        SELECT SUM(oi2.sales) AS total_spent
        FROM customers c2
        JOIN orders o2 ON c2.customer_id = o2.customer_id
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        GROUP BY c2.customer_id
    ) cust_sales
)
ORDER BY total_spent DESC;

-- ============================================================
-- SECTION 2: CORRELATED SUBQUERIES
-- ============================================================

-- SQ3: For each order, show if it's above the avg for that region
SELECT
    o.order_id,
    c.region,
    c.customer_name,
    ROUND(SUM(oi.sales), 2) AS order_sales,
    ROUND((
        SELECT AVG(oi2.sales)
        FROM orders o2
        JOIN customers c2 ON o2.customer_id = c2.customer_id
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE c2.region = c.region
    ), 2) AS region_avg_sales,
    CASE
        WHEN SUM(oi.sales) > (
            SELECT AVG(oi2.sales)
            FROM orders o2
            JOIN customers c2 ON o2.customer_id = c2.customer_id
            JOIN order_items oi2 ON o2.order_id = oi2.order_id
            WHERE c2.region = c.region
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.region, c.customer_name
ORDER BY order_sales DESC;

-- ============================================================
-- SECTION 3: CTEs (Common Table Expressions)
-- ============================================================

-- SQ4: CTE - Monthly sales with growth rate calculation
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date)  AS yr,
        MONTH(o.order_date) AS mo,
        MONTHNAME(o.order_date) AS month_name,
        ROUND(SUM(oi.sales), 2) AS total_sales,
        ROUND(SUM(oi.profit), 2) AS total_profit
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date), MONTHNAME(o.order_date)
),
sales_with_lag AS (
    SELECT
        yr,
        mo,
        month_name,
        total_sales,
        total_profit,
        LAG(total_sales) OVER (ORDER BY yr, mo) AS prev_month_sales
    FROM monthly_sales
)
SELECT
    yr,
    mo,
    month_name,
    total_sales,
    total_profit,
    prev_month_sales,
    ROUND(
        CASE
            WHEN prev_month_sales IS NULL THEN NULL
            ELSE (total_sales - prev_month_sales) / prev_month_sales * 100
        END, 2
    ) AS mom_growth_pct
FROM sales_with_lag
ORDER BY yr, mo;

-- SQ5: CTE - RFM Analysis (Recency, Frequency, Monetary)
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        c.region,
        DATEDIFF('2018-01-01', MAX(o.order_date))   AS recency_days,
        COUNT(DISTINCT o.order_id)                   AS frequency,
        ROUND(SUM(oi.sales), 2)                      AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name, c.segment, c.region
),
rfm_scored AS (
    SELECT *,
        CASE
            WHEN recency_days <= 90   THEN 3
            WHEN recency_days <= 180  THEN 2
            ELSE 1
        END AS r_score,
        CASE
            WHEN frequency >= 5  THEN 3
            WHEN frequency >= 2  THEN 2
            ELSE 1
        END AS f_score,
        CASE
            WHEN monetary >= 1000 THEN 3
            WHEN monetary >= 500  THEN 2
            ELSE 1
        END AS m_score
    FROM customer_rfm
)
SELECT
    customer_id,
    customer_name,
    segment,
    region,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_total,
    CASE
        WHEN (r_score + f_score + m_score) = 9 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 7 THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 5 THEN 'Potential Loyalists'
        WHEN (r_score + f_score + m_score) >= 3 THEN 'At Risk'
        ELSE 'Lost'
    END AS customer_segment
FROM rfm_scored
ORDER BY rfm_total DESC;

-- SQ6: CTE - Cumulative Sales by Year
WITH yearly_sales AS (
    SELECT
        YEAR(o.order_date) AS yr,
        ROUND(SUM(oi.sales), 2) AS annual_sales,
        ROUND(SUM(oi.profit), 2) AS annual_profit
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date)
)
SELECT
    yr,
    annual_sales,
    annual_profit,
    ROUND(SUM(annual_sales) OVER (ORDER BY yr), 2)  AS cumulative_sales,
    ROUND(annual_profit / annual_sales * 100, 2)     AS profit_margin_pct,
    ROUND(
        (annual_sales - LAG(annual_sales) OVER (ORDER BY yr))
        / LAG(annual_sales) OVER (ORDER BY yr) * 100
    , 2) AS yoy_growth_pct
FROM yearly_sales
ORDER BY yr;

-- ============================================================
-- SECTION 4: WINDOW FUNCTIONS
-- ============================================================

-- SQ7: Rank products by sales within each category
SELECT
    cat.category_name,
    p.product_name,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    RANK() OVER (
        PARTITION BY cat.category_name
        ORDER BY SUM(oi.sales) DESC
    ) AS sales_rank_in_category,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.sales) DESC
    ) AS overall_sales_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY cat.category_name, p.product_id, p.product_name
ORDER BY cat.category_name, sales_rank_in_category;

-- SQ8: Running total of sales per customer
SELECT
    c.customer_name,
    o.order_date,
    ROUND(SUM(oi.sales), 2) AS order_sales,
    ROUND(SUM(SUM(oi.sales)) OVER (
        PARTITION BY c.customer_id
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS running_total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, o.order_id, o.order_date
ORDER BY c.customer_name, o.order_date;

-- SQ9: Percentile ranking of orders by sales amount
SELECT
    o.order_id,
    c.customer_name,
    ROUND(SUM(oi.sales), 2) AS order_sales,
    NTILE(4) OVER (ORDER BY SUM(oi.sales)) AS sales_quartile,
    ROUND(PERCENT_RANK() OVER (ORDER BY SUM(oi.sales)) * 100, 1) AS sales_percentile
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name
ORDER BY order_sales DESC;
