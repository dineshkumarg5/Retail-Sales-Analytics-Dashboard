-- ============================================================
-- File: 06_views.sql
-- Project: Sales Data Analytics
-- Description: Business Views for reporting and dashboards
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

-- ============================================================
-- VIEW 1: vw_sales_fact
-- Master denormalized sales fact table for BI reporting
-- ============================================================
CREATE OR REPLACE VIEW vw_sales_fact AS
SELECT
    oi.row_id,
    o.order_id,
    o.order_date,
    o.ship_date,
    o.ship_mode,
    DATEDIFF(o.ship_date, o.order_date)     AS shipping_days,
    YEAR(o.order_date)                       AS order_year,
    MONTH(o.order_date)                      AS order_month,
    MONTHNAME(o.order_date)                  AS month_name,
    QUARTER(o.order_date)                    AS order_quarter,
    c.customer_id,
    c.customer_name,
    c.segment,
    c.country,
    c.city,
    c.state,
    c.region,
    p.product_id,
    p.product_name,
    sc.sub_category_name,
    cat.category_name,
    oi.quantity,
    ROUND(oi.sales, 4)                       AS sales,
    ROUND(oi.discount, 2)                    AS discount,
    ROUND(oi.profit, 4)                      AS profit,
    ROUND(oi.profit / oi.sales * 100, 2)     AS profit_margin_pct,
    CASE
        WHEN oi.profit > 0 THEN 'Profit'
        WHEN oi.profit = 0 THEN 'Break Even'
        ELSE 'Loss'
    END                                      AS profit_status
FROM orders o
JOIN customers c         ON o.customer_id = c.customer_id
JOIN order_items oi      ON o.order_id = oi.order_id
JOIN products p          ON oi.product_id = p.product_id
JOIN sub_categories sc   ON p.sub_category_id = sc.sub_category_id
JOIN categories cat      ON sc.category_id = cat.category_id;

-- ============================================================
-- VIEW 2: vw_monthly_sales_trend
-- Monthly aggregated sales for trend analysis
-- ============================================================
CREATE OR REPLACE VIEW vw_monthly_sales_trend AS
SELECT
    YEAR(o.order_date)           AS yr,
    MONTH(o.order_date)          AS mo,
    MONTHNAME(o.order_date)      AS month_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,
    COUNT(DISTINCT o.order_id)   AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity)              AS total_units,
    ROUND(SUM(oi.sales), 2)       AS total_sales,
    ROUND(SUM(oi.profit), 2)      AS total_profit,
    ROUND(AVG(oi.sales), 2)       AS avg_sale_per_item,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    MONTHNAME(o.order_date),
    DATE_FORMAT(o.order_date, '%Y-%m');

-- ============================================================
-- VIEW 3: vw_regional_performance
-- Regional sales performance dashboard view
-- ============================================================
CREATE OR REPLACE VIEW vw_regional_performance AS
SELECT
    c.region,
    c.state,
    COUNT(DISTINCT o.order_id)   AS total_orders,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    ROUND(SUM(oi.sales), 2)      AS total_sales,
    ROUND(SUM(oi.profit), 2)     AS total_profit,
    ROUND(AVG(oi.sales), 2)      AS avg_order_value,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.region, c.state;

-- ============================================================
-- VIEW 4: vw_category_performance
-- Category and sub-category performance
-- ============================================================
CREATE OR REPLACE VIEW vw_category_performance AS
SELECT
    cat.category_name,
    sc.sub_category_name,
    COUNT(DISTINCT oi.order_id)  AS total_orders,
    SUM(oi.quantity)              AS total_units_sold,
    ROUND(SUM(oi.sales), 2)       AS total_sales,
    ROUND(SUM(oi.profit), 2)      AS total_profit,
    ROUND(AVG(oi.discount * 100), 1) AS avg_discount_pct,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct,
    RANK() OVER (PARTITION BY cat.category_name ORDER BY SUM(oi.sales) DESC) AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY cat.category_name, sc.sub_category_name;

-- ============================================================
-- VIEW 5: vw_customer_summary
-- Customer lifetime value and RFM summary
-- ============================================================
CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    c.state,
    MIN(o.order_date)                        AS first_order_date,
    MAX(o.order_date)                        AS last_order_date,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_lifespan_days,
    COUNT(DISTINCT o.order_id)               AS total_orders,
    SUM(oi.quantity)                          AS total_items_bought,
    ROUND(SUM(oi.sales), 2)                   AS lifetime_value,
    ROUND(SUM(oi.profit), 2)                  AS lifetime_profit,
    ROUND(AVG(oi.sales), 2)                   AS avg_order_value,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.segment, c.region, c.state;

-- ============================================================
-- VIEW 6: vw_product_performance
-- Product-level performance summary
-- ============================================================
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    sc.sub_category_name,
    cat.category_name,
    COUNT(DISTINCT oi.order_id)  AS times_ordered,
    SUM(oi.quantity)              AS total_units_sold,
    ROUND(SUM(oi.sales), 2)       AS total_sales,
    ROUND(SUM(oi.profit), 2)      AS total_profit,
    ROUND(AVG(oi.discount * 100), 1) AS avg_discount_pct,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name, cat.category_name;

-- ============================================================
-- Verify views
-- ============================================================
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Query the views
SELECT * FROM vw_monthly_sales_trend ORDER BY yr, mo LIMIT 12;
SELECT * FROM vw_regional_performance ORDER BY total_sales DESC;
SELECT * FROM vw_category_performance ORDER BY total_sales DESC;
