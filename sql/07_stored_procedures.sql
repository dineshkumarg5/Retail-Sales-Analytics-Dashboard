-- ============================================================
-- File: 07_stored_procedures.sql
-- Project: Sales Data Analytics
-- Description: Stored Procedures for automated reporting
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

DELIMITER $$

-- ============================================================
-- SP1: GetSalesSummary
-- Returns overall KPIs for the business
-- Usage: CALL GetSalesSummary();
-- ============================================================
CREATE PROCEDURE IF NOT EXISTS GetSalesSummary()
BEGIN
    SELECT
        COUNT(DISTINCT o.order_id)                          AS total_orders,
        COUNT(DISTINCT o.customer_id)                       AS total_customers,
        COUNT(DISTINCT p.product_id)                        AS total_products,
        ROUND(SUM(oi.sales), 2)                             AS total_revenue,
        ROUND(SUM(oi.profit), 2)                            AS total_profit,
        ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2)     AS profit_margin_pct,
        ROUND(AVG(oi.sales), 2)                             AS avg_sale_value,
        SUM(oi.quantity)                                     AS total_units_sold,
        MIN(o.order_date)                                   AS data_start_date,
        MAX(o.order_date)                                   AS data_end_date
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id;
END$$

-- ============================================================
-- SP2: GetSalesByRegion
-- Returns sales and profit breakdown by region
-- Usage: CALL GetSalesByRegion();
-- ============================================================
CREATE PROCEDURE IF NOT EXISTS GetSalesByRegion()
BEGIN
    SELECT
        c.region,
        COUNT(DISTINCT o.order_id)   AS total_orders,
        COUNT(DISTINCT c.customer_id) AS unique_customers,
        ROUND(SUM(oi.sales), 2)      AS total_sales,
        ROUND(SUM(oi.profit), 2)     AS total_profit,
        ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct,
        ROUND(SUM(oi.sales) * 100.0 / (SELECT SUM(sales) FROM order_items), 2) AS sales_share_pct
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.region
    ORDER BY total_sales DESC;
END$$

-- ============================================================
-- SP3: GetTopProducts
-- Returns top N products by sales
-- Usage: CALL GetTopProducts(10);
-- ============================================================
CREATE PROCEDURE IF NOT EXISTS GetTopProducts(IN top_n INT)
BEGIN
    SELECT
        p.product_name,
        sc.sub_category_name,
        cat.category_name,
        COUNT(DISTINCT oi.order_id)  AS times_ordered,
        SUM(oi.quantity)              AS total_units,
        ROUND(SUM(oi.sales), 2)       AS total_sales,
        ROUND(SUM(oi.profit), 2)      AS total_profit,
        ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS margin_pct
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
    JOIN categories cat ON sc.category_id = cat.category_id
    GROUP BY p.product_id, p.product_name, sc.sub_category_name, cat.category_name
    ORDER BY total_sales DESC
    LIMIT top_n;
END$$

-- ============================================================
-- SP4: GetMonthlyReport
-- Returns monthly sales for a specific year
-- Usage: CALL GetMonthlyReport(2017);
-- ============================================================
CREATE PROCEDURE IF NOT EXISTS GetMonthlyReport(IN p_year INT)
BEGIN
    SELECT
        MONTH(o.order_date)             AS month_num,
        MONTHNAME(o.order_date)         AS month_name,
        COUNT(DISTINCT o.order_id)      AS total_orders,
        ROUND(SUM(oi.sales), 2)         AS total_sales,
        ROUND(SUM(oi.profit), 2)        AS total_profit,
        ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS margin_pct
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = p_year
    GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
    ORDER BY month_num;
END$$

-- ============================================================
-- SP5: GetCustomerDetails
-- Returns full order history for a given customer ID
-- Usage: CALL GetCustomerDetails('CG-12520');
-- ============================================================
CREATE PROCEDURE IF NOT EXISTS GetCustomerDetails(IN p_customer_id VARCHAR(20))
BEGIN
    -- Customer profile
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        c.region,
        c.state,
        MIN(o.order_date)            AS first_purchase,
        MAX(o.order_date)            AS last_purchase,
        COUNT(DISTINCT o.order_id)   AS total_orders,
        ROUND(SUM(oi.sales), 2)      AS lifetime_value,
        ROUND(SUM(oi.profit), 2)     AS lifetime_profit
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment, c.region, c.state;

    -- Order history
    SELECT
        o.order_id,
        o.order_date,
        o.ship_mode,
        p.product_name,
        cat.category_name,
        oi.quantity,
        ROUND(oi.sales, 2)   AS sales,
        ROUND(oi.profit, 2)  AS profit
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
    JOIN categories cat ON sc.category_id = cat.category_id
    WHERE o.customer_id = p_customer_id
    ORDER BY o.order_date DESC;
END$$

-- ============================================================
-- SP6: GetDiscountImpactAnalysis
-- Analyzes how different discount bands affect profit
-- Usage: CALL GetDiscountImpactAnalysis();
-- ============================================================
CREATE PROCEDURE IF NOT EXISTS GetDiscountImpactAnalysis()
BEGIN
    SELECT
        CASE
            WHEN oi.discount = 0          THEN '0% (No Discount)'
            WHEN oi.discount <= 0.10      THEN '1-10%'
            WHEN oi.discount <= 0.20      THEN '11-20%'
            WHEN oi.discount <= 0.30      THEN '21-30%'
            WHEN oi.discount <= 0.40      THEN '31-40%'
            ELSE '40%+'
        END AS discount_band,
        COUNT(*)                         AS total_transactions,
        ROUND(AVG(oi.sales), 2)          AS avg_sales,
        ROUND(AVG(oi.profit), 2)         AS avg_profit,
        ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct,
        SUM(CASE WHEN oi.profit < 0 THEN 1 ELSE 0 END) AS loss_transactions
    FROM order_items oi
    GROUP BY
        CASE
            WHEN oi.discount = 0          THEN '0% (No Discount)'
            WHEN oi.discount <= 0.10      THEN '1-10%'
            WHEN oi.discount <= 0.20      THEN '11-20%'
            WHEN oi.discount <= 0.30      THEN '21-30%'
            WHEN oi.discount <= 0.40      THEN '31-40%'
            ELSE '40%+'
        END
    ORDER BY MIN(oi.discount);
END$$

DELIMITER ;

-- ============================================================
-- Test stored procedures
-- ============================================================
CALL GetSalesSummary();
CALL GetSalesByRegion();
CALL GetTopProducts(5);
CALL GetMonthlyReport(2017);
CALL GetCustomerDetails('CG-12520');
CALL GetDiscountImpactAnalysis();
