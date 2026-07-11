-- ============================================================
-- File: 01_ddl_create_tables.sql
-- Project: Sales Data Analytics
-- Description: DDL - Create all tables for Superstore Sales DB
-- Author: Dinesh
-- Date: 2024
-- ============================================================

-- Create and use the database
CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;

-- ============================================================
-- TABLE: customers
-- Stores unique customer information
-- ============================================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id     VARCHAR(20)     PRIMARY KEY,
    customer_name   VARCHAR(100)    NOT NULL,
    segment         ENUM('Consumer', 'Corporate', 'Home Office') NOT NULL,
    country         VARCHAR(50)     DEFAULT 'United States',
    city            VARCHAR(100)    NOT NULL,
    state           VARCHAR(50)     NOT NULL,
    postal_code     VARCHAR(10),
    region          ENUM('East', 'West', 'Central', 'South') NOT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: categories
-- Product category master table
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    category_id     INT             AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(50)     NOT NULL UNIQUE,
    description     VARCHAR(255)
);

-- ============================================================
-- TABLE: sub_categories
-- Product sub-category master table
-- ============================================================
CREATE TABLE IF NOT EXISTS sub_categories (
    sub_category_id     INT             AUTO_INCREMENT PRIMARY KEY,
    sub_category_name   VARCHAR(50)     NOT NULL,
    category_id         INT             NOT NULL,
    CONSTRAINT fk_subcat_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: products
-- Product master table
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    product_id      VARCHAR(25)     PRIMARY KEY,
    product_name    VARCHAR(255)    NOT NULL,
    sub_category_id INT             NOT NULL,
    CONSTRAINT fk_product_subcat FOREIGN KEY (sub_category_id)
        REFERENCES sub_categories(sub_category_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: orders
-- Order header information
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id        VARCHAR(20)     PRIMARY KEY,
    order_date      DATE            NOT NULL,
    ship_date       DATE            NOT NULL,
    ship_mode       ENUM('Standard Class', 'Second Class', 'First Class', 'Same Day') NOT NULL,
    customer_id     VARCHAR(20)     NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id) ON DELETE RESTRICT,
    CONSTRAINT chk_ship_after_order CHECK (ship_date >= order_date)
);

-- ============================================================
-- TABLE: order_items
-- Order line-level detail with sales, profit, discount
-- ============================================================
CREATE TABLE IF NOT EXISTS order_items (
    row_id          INT             AUTO_INCREMENT PRIMARY KEY,
    order_id        VARCHAR(20)     NOT NULL,
    product_id      VARCHAR(25)     NOT NULL,
    sales           DECIMAL(10, 4)  NOT NULL CHECK (sales >= 0),
    quantity        INT             NOT NULL CHECK (quantity > 0),
    discount        DECIMAL(4, 2)   NOT NULL DEFAULT 0.00 CHECK (discount BETWEEN 0 AND 1),
    profit          DECIMAL(10, 4)  NOT NULL,
    CONSTRAINT fk_item_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_item_product FOREIGN KEY (product_id)
        REFERENCES products(product_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: audit_log
-- Tracks all INSERT/UPDATE/DELETE operations for auditing
-- ============================================================
CREATE TABLE IF NOT EXISTS audit_log (
    log_id          INT             AUTO_INCREMENT PRIMARY KEY,
    table_name      VARCHAR(50)     NOT NULL,
    action_type     ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id       VARCHAR(50),
    action_by       VARCHAR(100)    DEFAULT USER(),
    action_at       TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    old_value       TEXT,
    new_value       TEXT
);

-- ============================================================
-- INDEXES for query optimization
-- ============================================================
CREATE INDEX idx_orders_date         ON orders(order_date);
CREATE INDEX idx_orders_customer     ON orders(customer_id);
CREATE INDEX idx_items_order         ON order_items(order_id);
CREATE INDEX idx_items_product       ON order_items(product_id);
CREATE INDEX idx_customers_region    ON customers(region);
CREATE INDEX idx_customers_segment   ON customers(segment);
CREATE INDEX idx_customers_state     ON customers(state);
CREATE INDEX idx_products_subcat     ON products(sub_category_id);

-- ============================================================
-- Verification
-- ============================================================
SHOW TABLES;
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
