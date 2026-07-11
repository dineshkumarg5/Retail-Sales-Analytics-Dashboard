-- ============================================================
-- File: 03_basic_queries.sql
-- Project: Sales Data Analytics
-- Description: Core SELECT, WHERE, GROUP BY, HAVING, ORDER BY
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

-- ============================================================
-- SECTION 1: BASIC SELECT QUERIES
-- ============================================================

-- Q1: View all orders
SELECT * FROM orders LIMIT 10;

-- Q2: View all order items with product details
SELECT
    oi.row_id,
    oi.order_id,
    p.product_name,
    oi.sales,
    oi.quantity,
    oi.discount,
    oi.profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LIMIT 20;

-- Q3: Total Sales, Total Profit, Total Orders (KPIs)
SELECT
    COUNT(DISTINCT o.order_id)              AS total_orders,
    COUNT(DISTINCT o.customer_id)           AS total_customers,
    ROUND(SUM(oi.sales), 2)                 AS total_sales,
    ROUND(SUM(oi.profit), 2)                AS total_profit,
    ROUND(SUM(oi.profit)/SUM(oi.sales)*100, 2) AS profit_margin_pct,
    ROUND(AVG(oi.sales), 2)                 AS avg_order_value,
    SUM(oi.quantity)                        AS total_units_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- ============================================================
-- SECTION 2: WHERE CLAUSE FILTERING
-- ============================================================

-- Q4: Orders from the West region
SELECT
    o.order_id,
    c.customer_name,
    c.state,
    ROUND(SUM(oi.sales), 2) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.region = 'West'
GROUP BY o.order_id, c.customer_name, c.state;

-- Q5: High-value orders (Sales > $1,000)
SELECT
    oi.order_id,
    p.product_name,
    oi.sales,
    oi.profit,
    oi.discount
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.sales > 1000
ORDER BY oi.sales DESC;

-- Q6: Orders with negative profit (loss-making)
SELECT
    oi.order_id,
    p.product_name,
    oi.sales,
    oi.profit,
    oi.discount,
    ROUND((oi.profit / oi.sales) * 100, 2) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.profit < 0
ORDER BY oi.profit ASC;

-- Q7: Consumer segment orders in 2017
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.city,
    c.state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.segment = 'Consumer'
  AND YEAR(o.order_date) = 2017
ORDER BY o.order_date DESC;

-- Q8: Products with discount greater than 30%
SELECT
    p.product_name,
    sc.sub_category_name,
    cat.category_name,
    oi.discount,
    oi.sales,
    oi.profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
WHERE oi.discount > 0.30
ORDER BY oi.discount DESC;

-- ============================================================
-- SECTION 3: GROUP BY ANALYSIS
-- ============================================================

-- Q9: Sales and Profit by Category
SELECT
    cat.category_name,
    COUNT(DISTINCT oi.order_id)             AS total_orders,
    SUM(oi.quantity)                         AS total_units,
    ROUND(SUM(oi.sales), 2)                  AS total_sales,
    ROUND(SUM(oi.profit), 2)                 AS total_profit,
    ROUND(SUM(oi.profit)/SUM(oi.sales)*100, 2) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY total_sales DESC;

-- Q10: Sales by Region
SELECT
    c.region,
    COUNT(DISTINCT o.order_id)       AS total_orders,
    COUNT(DISTINCT o.customer_id)    AS total_customers,
    ROUND(SUM(oi.sales), 2)          AS total_sales,
    ROUND(SUM(oi.profit), 2)         AS total_profit,
    ROUND(AVG(oi.sales), 2)          AS avg_sale
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.region
ORDER BY total_sales DESC;

-- Q11: Monthly Sales Trend
SELECT
    YEAR(o.order_date)                  AS year,
    MONTH(o.order_date)                 AS month,
    MONTHNAME(o.order_date)             AS month_name,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    ROUND(SUM(oi.sales), 2)             AS monthly_sales,
    ROUND(SUM(oi.profit), 2)            AS monthly_profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY year, month;

-- Q12: Sales by Customer Segment
SELECT
    c.segment,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    COUNT(DISTINCT c.customer_id)       AS total_customers,
    ROUND(SUM(oi.sales), 2)             AS total_sales,
    ROUND(SUM(oi.profit), 2)            AS total_profit,
    ROUND(AVG(oi.sales), 2)             AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.segment
ORDER BY total_sales DESC;

-- Q13: Top 10 States by Sales
SELECT
    c.state,
    c.region,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    ROUND(SUM(oi.sales), 2)             AS total_sales,
    ROUND(SUM(oi.profit), 2)            AS total_profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state, c.region
ORDER BY total_sales DESC
LIMIT 10;

-- Q14: Ship Mode Usage Analysis
SELECT
    o.ship_mode,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    ROUND(SUM(oi.sales), 2)             AS total_sales,
    ROUND(AVG(DATEDIFF(o.ship_date, o.order_date)), 1) AS avg_shipping_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.ship_mode
ORDER BY total_orders DESC;

-- ============================================================
-- SECTION 4: HAVING CLAUSE
-- ============================================================

-- Q15: Categories with Profit Margin < 10%
SELECT
    cat.category_name,
    ROUND(SUM(oi.sales), 2)                 AS total_sales,
    ROUND(SUM(oi.profit), 2)                AS total_profit,
    ROUND(SUM(oi.profit)/SUM(oi.sales)*100, 2) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY cat.category_name
HAVING profit_margin_pct < 10;

-- Q16: States with more than 5 orders
SELECT
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales), 2)    AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state
HAVING total_orders > 5
ORDER BY total_orders DESC;

-- Q17: Sub-categories with total sales over $5,000
SELECT
    sc.sub_category_name,
    cat.category_name,
    ROUND(SUM(oi.sales), 2)    AS total_sales,
    ROUND(SUM(oi.profit), 2)   AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY sc.sub_category_name, cat.category_name
HAVING total_sales > 5000
ORDER BY total_sales DESC;

-- ============================================================
-- SECTION 5: ORDER BY / TOP N
-- ============================================================

-- Q18: Top 10 Best-Selling Products by Revenue
SELECT
    p.product_name,
    sc.sub_category_name,
    cat.category_name,
    ROUND(SUM(oi.sales), 2)    AS total_sales,
    ROUND(SUM(oi.profit), 2)   AS total_profit,
    SUM(oi.quantity)            AS total_units
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name, cat.category_name
ORDER BY total_sales DESC
LIMIT 10;

-- Q19: Top 10 Most Profitable Products
SELECT
    p.product_name,
    sc.sub_category_name,
    ROUND(SUM(oi.profit), 2)   AS total_profit,
    ROUND(SUM(oi.sales), 2)    AS total_sales,
    ROUND(SUM(oi.profit)/SUM(oi.sales)*100, 2) AS margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name
ORDER BY total_profit DESC
LIMIT 10;

-- Q20: Top 10 Loss-Making Products
SELECT
    p.product_name,
    sc.sub_category_name,
    ROUND(SUM(oi.profit), 2)   AS total_profit,
    ROUND(SUM(oi.sales), 2)    AS total_sales,
    ROUND(SUM(oi.discount)*100, 1) AS avg_discount_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name
ORDER BY total_profit ASC
LIMIT 10;
