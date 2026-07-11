-- ============================================================
-- File: 04_joins.sql
-- Project: Sales Data Analytics
-- Description: INNER, LEFT, RIGHT, FULL JOIN examples
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

-- ============================================================
-- SECTION 1: INNER JOIN
-- Returns only matching rows from both tables
-- ============================================================

-- J1: Full order details with customer and product info
SELECT
    o.order_id,
    o.order_date,
    o.ship_mode,
    c.customer_name,
    c.segment,
    c.region,
    c.state,
    p.product_name,
    cat.category_name,
    sc.sub_category_name,
    oi.quantity,
    ROUND(oi.sales, 2)      AS sales,
    ROUND(oi.profit, 2)     AS profit,
    oi.discount
FROM orders o
INNER JOIN customers c      ON o.customer_id = c.customer_id
INNER JOIN order_items oi   ON o.order_id = oi.order_id
INNER JOIN products p       ON oi.product_id = p.product_id
INNER JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
INNER JOIN categories cat   ON sc.category_id = cat.category_id
ORDER BY o.order_date DESC
LIMIT 25;

-- J2: Profit by category and region (INNER JOIN 4 tables)
SELECT
    cat.category_name,
    c.region,
    ROUND(SUM(oi.sales), 2)   AS total_sales,
    ROUND(SUM(oi.profit), 2)  AS total_profit,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
INNER JOIN customers c      ON o.customer_id = c.customer_id
INNER JOIN order_items oi   ON o.order_id = oi.order_id
INNER JOIN products p       ON oi.product_id = p.product_id
INNER JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
INNER JOIN categories cat   ON sc.category_id = cat.category_id
GROUP BY cat.category_name, c.region
ORDER BY cat.category_name, total_sales DESC;

-- J3: Customer sales summary with segment and region
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    c.state,
    COUNT(DISTINCT o.order_id)    AS total_orders,
    SUM(oi.quantity)               AS total_items,
    ROUND(SUM(oi.sales), 2)        AS lifetime_sales,
    ROUND(SUM(oi.profit), 2)       AS lifetime_profit,
    ROUND(AVG(oi.sales), 2)        AS avg_order_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.segment, c.region, c.state
ORDER BY lifetime_sales DESC;

-- ============================================================
-- SECTION 2: LEFT JOIN
-- Returns ALL rows from left table + matching from right
-- ============================================================

-- J4: All customers, including those with no orders (LEFT JOIN)
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.state,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    ROUND(COALESCE(SUM(oi.sales), 0), 2) AS total_sales
FROM customers c
LEFT JOIN orders o      ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.segment, c.state
ORDER BY total_sales DESC;

-- J5: All products, including products never ordered
SELECT
    p.product_id,
    p.product_name,
    sc.sub_category_name,
    cat.category_name,
    COUNT(DISTINCT oi.order_id)  AS times_ordered,
    ROUND(COALESCE(SUM(oi.sales), 0), 2) AS total_sales
FROM products p
LEFT JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
LEFT JOIN categories cat    ON sc.category_id = cat.category_id
LEFT JOIN order_items oi    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name, cat.category_name
ORDER BY total_sales DESC;

-- J6: Customers who never placed an order (no order record)
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.state,
    c.region
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ============================================================
-- SECTION 3: RIGHT JOIN
-- Returns ALL rows from right table + matching from left
-- ============================================================

-- J7: All orders, even if customer record is missing
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.segment,
    c.region
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- J8: All sub-categories and their total order count
SELECT
    sc.sub_category_name,
    cat.category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(COALESCE(SUM(oi.sales), 0), 2) AS total_sales
FROM order_items oi
RIGHT JOIN products p       ON oi.product_id = p.product_id
RIGHT JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
INNER JOIN categories cat   ON sc.category_id = cat.category_id
GROUP BY sc.sub_category_name, cat.category_name
ORDER BY total_sales DESC;

-- ============================================================
-- SECTION 4: SELF JOIN
-- Joining a table with itself
-- ============================================================

-- J9: Find customers from the same state (self join on customers)
SELECT
    a.customer_name AS customer_1,
    b.customer_name AS customer_2,
    a.state,
    a.segment
FROM customers a
JOIN customers b
    ON a.state = b.state
   AND a.customer_id <> b.customer_id
   AND a.customer_id < b.customer_id  -- avoid duplicates
ORDER BY a.state
LIMIT 20;

-- ============================================================
-- SECTION 5: CROSS JOIN
-- Cartesian product (all combinations)
-- ============================================================

-- J10: All possible category × region combinations
SELECT
    cat.category_name,
    r.region
FROM categories cat
CROSS JOIN (
    SELECT DISTINCT region FROM customers
) r
ORDER BY cat.category_name, r.region;

-- ============================================================
-- SECTION 6: Multi-table join for comprehensive report
-- ============================================================

-- J11: Complete sales fact report (all dimensions joined)
SELECT
    o.order_id,
    DATE_FORMAT(o.order_date, '%Y-%m')  AS year_month,
    o.ship_mode,
    DATEDIFF(o.ship_date, o.order_date) AS shipping_days,
    c.customer_name,
    c.segment,
    c.city,
    c.state,
    c.region,
    cat.category_name,
    sc.sub_category_name,
    p.product_name,
    oi.quantity,
    ROUND(oi.sales, 2)                  AS sales,
    oi.discount,
    ROUND(oi.profit, 2)                 AS profit,
    ROUND(oi.profit / oi.sales * 100, 2) AS profit_margin_pct,
    CASE
        WHEN oi.profit > 0  THEN 'Profitable'
        WHEN oi.profit = 0  THEN 'Break-even'
        ELSE                     'Loss'
    END AS profit_status
FROM orders o
INNER JOIN customers c      ON o.customer_id = c.customer_id
INNER JOIN order_items oi   ON o.order_id = oi.order_id
INNER JOIN products p       ON oi.product_id = p.product_id
INNER JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
INNER JOIN categories cat   ON sc.category_id = cat.category_id
ORDER BY o.order_date, o.order_id;
