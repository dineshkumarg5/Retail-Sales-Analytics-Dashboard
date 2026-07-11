-- ============================================================
-- File: 09_interview_queries.sql
-- Project: Sales Data Analytics
-- Description: Top 30 SQL Interview Questions & Answers
--              (Data Analyst / Business Analyst level)
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

-- ============================================================
-- Q1. Find the total revenue, total profit, and profit margin.
-- ============================================================
SELECT
    ROUND(SUM(sales), 2)                        AS total_revenue,
    ROUND(SUM(profit), 2)                       AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)   AS profit_margin_pct
FROM order_items;

-- ============================================================
-- Q2. Which category generates the highest revenue?
-- ============================================================
SELECT
    cat.category_name,
    ROUND(SUM(oi.sales), 2) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY total_sales DESC
LIMIT 1;

-- ============================================================
-- Q3. Find the top 5 customers by total spending.
-- ============================================================
SELECT
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_spent DESC
LIMIT 5;

-- ============================================================
-- Q4. Which region has the highest profit margin?
-- ============================================================
SELECT
    c.region,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.region
ORDER BY profit_margin_pct DESC
LIMIT 1;

-- ============================================================
-- Q5. List all products that have never generated a profit.
-- ============================================================
SELECT
    p.product_name,
    sc.sub_category_name,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
GROUP BY p.product_id, p.product_name, sc.sub_category_name
HAVING total_profit <= 0
ORDER BY total_profit ASC;

-- ============================================================
-- Q6. Find the year-over-year sales growth.
-- ============================================================
WITH yearly AS (
    SELECT
        YEAR(o.order_date) AS yr,
        ROUND(SUM(oi.sales), 2) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date)
)
SELECT
    yr,
    total_sales,
    LAG(total_sales) OVER (ORDER BY yr) AS prev_year_sales,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY yr))
        / LAG(total_sales) OVER (ORDER BY yr) * 100, 2) AS yoy_growth_pct
FROM yearly;

-- ============================================================
-- Q7. Which state has the most loss-making orders?
-- ============================================================
SELECT
    c.state,
    COUNT(*) AS loss_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.profit < 0
GROUP BY c.state
ORDER BY loss_orders DESC
LIMIT 5;

-- ============================================================
-- Q8. What is the average shipping time per ship mode?
-- ============================================================
SELECT
    ship_mode,
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 1) AS avg_shipping_days,
    MIN(DATEDIFF(ship_date, order_date))            AS min_days,
    MAX(DATEDIFF(ship_date, order_date))            AS max_days
FROM orders
GROUP BY ship_mode
ORDER BY avg_shipping_days;

-- ============================================================
-- Q9. Find the second highest revenue-generating product.
-- ============================================================
SELECT product_name, total_sales FROM (
    SELECT
        p.product_name,
        ROUND(SUM(oi.sales), 2) AS total_sales,
        DENSE_RANK() OVER (ORDER BY SUM(oi.sales) DESC) AS rnk
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
) ranked
WHERE rnk = 2;

-- ============================================================
-- Q10. Which month has the highest average daily sales?
-- ============================================================
SELECT
    MONTHNAME(o.order_date) AS month_name,
    ROUND(SUM(oi.sales) / COUNT(DISTINCT o.order_date), 2) AS avg_daily_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY avg_daily_sales DESC
LIMIT 3;

-- ============================================================
-- Q11. Find customers who placed orders in every year (2014–2017).
-- ============================================================
SELECT
    c.customer_name,
    COUNT(DISTINCT YEAR(o.order_date)) AS years_active
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING years_active = 4
ORDER BY c.customer_name;

-- ============================================================
-- Q12. What percentage of orders had a discount applied?
-- ============================================================
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) AS discounted_orders,
    ROUND(SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_discounted
FROM order_items;

-- ============================================================
-- Q13. What is the impact of discounts on profit?
-- (Compare avg profit for discounted vs non-discounted)
-- ============================================================
SELECT
    CASE WHEN discount > 0 THEN 'Discounted' ELSE 'No Discount' END AS discount_status,
    COUNT(*) AS transaction_count,
    ROUND(AVG(sales), 2)  AS avg_sales,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM order_items
GROUP BY discount_status;

-- ============================================================
-- Q14. Find the top sub-category with negative profit in each region.
-- ============================================================
WITH regional_subcat AS (
    SELECT
        c.region,
        sc.sub_category_name,
        ROUND(SUM(oi.profit), 2) AS total_profit,
        RANK() OVER (PARTITION BY c.region ORDER BY SUM(oi.profit)) AS rnk
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
    JOIN orders o ON oi.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.region, sc.sub_category_name
)
SELECT region, sub_category_name, total_profit
FROM regional_subcat
WHERE rnk = 1 AND total_profit < 0;

-- ============================================================
-- Q15. Which customer segment is most profitable?
-- ============================================================
SELECT
    c.segment,
    ROUND(SUM(oi.profit), 2)                        AS total_profit,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS margin_pct,
    COUNT(DISTINCT o.order_id)                       AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.segment
ORDER BY total_profit DESC;

-- ============================================================
-- Q16. Retrieve orders where shipping took more than 5 days.
-- ============================================================
SELECT
    o.order_id,
    c.customer_name,
    o.ship_mode,
    o.order_date,
    o.ship_date,
    DATEDIFF(o.ship_date, o.order_date) AS shipping_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE DATEDIFF(o.ship_date, o.order_date) > 5
ORDER BY shipping_days DESC;

-- ============================================================
-- Q17. Find the rolling 3-month average of monthly sales.
-- ============================================================
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS yr_mo,
        YEAR(o.order_date) AS yr,
        MONTH(o.order_date) AS mo,
        ROUND(SUM(oi.sales), 2) AS monthly_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY yr_mo, yr, mo
)
SELECT
    yr_mo,
    monthly_sales,
    ROUND(AVG(monthly_sales) OVER (
        ORDER BY yr, mo
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3mo_avg
FROM monthly
ORDER BY yr, mo;

-- ============================================================
-- Q18. List products sold in all four regions.
-- ============================================================
SELECT
    p.product_name,
    COUNT(DISTINCT c.region) AS region_count
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY p.product_id, p.product_name
HAVING region_count = 4
ORDER BY p.product_name;

-- ============================================================
-- Q19. Find the most popular ship mode for each segment.
-- ============================================================
WITH mode_count AS (
    SELECT
        c.segment,
        o.ship_mode,
        COUNT(*) AS cnt,
        RANK() OVER (PARTITION BY c.segment ORDER BY COUNT(*) DESC) AS rnk
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.segment, o.ship_mode
)
SELECT segment, ship_mode, cnt AS order_count
FROM mode_count
WHERE rnk = 1;

-- ============================================================
-- Q20. Calculate the profit margin percentile for each product.
-- ============================================================
SELECT
    p.product_name,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS margin_pct,
    ROUND(PERCENT_RANK() OVER (
        ORDER BY SUM(oi.profit) / SUM(oi.sales)
    ) * 100, 1) AS margin_percentile
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY margin_pct DESC;

-- ============================================================
-- Q21. Find duplicate orders (same order_id with multiple entries).
-- ============================================================
SELECT
    order_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
HAVING item_count > 1
ORDER BY item_count DESC;

-- ============================================================
-- Q22. Which product has the highest quantity sold but lowest profit?
-- ============================================================
SELECT
    p.product_name,
    SUM(oi.quantity)              AS total_qty_sold,
    ROUND(SUM(oi.profit), 2)      AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_qty_sold DESC, total_profit ASC
LIMIT 10;

-- ============================================================
-- Q23. Show YTD (Year-to-Date) sales cumulated for 2017.
-- ============================================================
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')  AS year_month,
    ROUND(SUM(oi.sales), 2)             AS monthly_sales,
    ROUND(SUM(SUM(oi.sales)) OVER (
        PARTITION BY YEAR(o.order_date)
        ORDER BY MONTH(o.order_date)
    ), 2) AS ytd_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), YEAR(o.order_date), MONTH(o.order_date)
ORDER BY MONTH(o.order_date);

-- ============================================================
-- Q24. Which city generates the most revenue in the South region?
-- ============================================================
SELECT
    c.city,
    c.state,
    ROUND(SUM(oi.sales), 2) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.region = 'South'
GROUP BY c.city, c.state
ORDER BY total_sales DESC
LIMIT 5;

-- ============================================================
-- Q25. What is the average order value by year?
-- ============================================================
SELECT
    YEAR(o.order_date) AS yr,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales), 2)    AS total_sales,
    ROUND(SUM(oi.sales) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY yr;

-- ============================================================
-- Q26. Which sub-categories have a profit margin below 5%?
-- ============================================================
SELECT
    sc.sub_category_name,
    cat.category_name,
    ROUND(SUM(oi.sales), 2)  AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) / SUM(oi.sales) * 100, 2) AS margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sub_categories sc ON p.sub_category_id = sc.sub_category_id
JOIN categories cat ON sc.category_id = cat.category_id
GROUP BY sc.sub_category_name, cat.category_name
HAVING margin_pct < 5
ORDER BY margin_pct ASC;

-- ============================================================
-- Q27. Find customers who made only 1 purchase (one-time buyers).
-- ============================================================
SELECT
    c.customer_name,
    c.segment,
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment, c.region
HAVING total_orders = 1;

-- ============================================================
-- Q28. Retrieve the first and last purchase date per customer.
-- ============================================================
SELECT
    c.customer_name,
    c.segment,
    MIN(o.order_date) AS first_purchase,
    MAX(o.order_date) AS last_purchase,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_lifespan_days
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY customer_lifespan_days DESC;

-- ============================================================
-- Q29. Rank all states by sales within each region.
-- ============================================================
SELECT
    c.region,
    c.state,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    RANK() OVER (PARTITION BY c.region ORDER BY SUM(oi.sales) DESC) AS state_rank_in_region
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.region, c.state
ORDER BY c.region, state_rank_in_region;

-- ============================================================
-- Q30. Build a complete executive summary report.
-- ============================================================
SELECT 'Total Orders'       AS metric, CAST(COUNT(DISTINCT o.order_id) AS CHAR) AS value FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
UNION ALL
SELECT 'Total Customers',   CAST(COUNT(DISTINCT o.customer_id) AS CHAR) FROM orders o
UNION ALL
SELECT 'Total Revenue',     CONCAT('$', FORMAT(SUM(sales), 2)) FROM order_items
UNION ALL
SELECT 'Total Profit',      CONCAT('$', FORMAT(SUM(profit), 2)) FROM order_items
UNION ALL
SELECT 'Profit Margin',     CONCAT(ROUND(SUM(profit)/SUM(sales)*100,2), '%') FROM order_items
UNION ALL
SELECT 'Avg Order Value',   CONCAT('$', FORMAT(AVG(sales), 2)) FROM order_items
UNION ALL
SELECT 'Total Units Sold',  CAST(SUM(quantity) AS CHAR) FROM order_items;
