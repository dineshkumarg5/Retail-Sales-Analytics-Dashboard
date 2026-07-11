-- ============================================================
-- File: 08_triggers.sql
-- Project: Sales Data Analytics
-- Description: Triggers for auditing and data integrity
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

DELIMITER $$

-- ============================================================
-- TRIGGER 1: trg_audit_order_insert
-- Logs every new order inserted into the audit_log table
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_audit_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, new_value)
    VALUES (
        'orders',
        'INSERT',
        NEW.order_id,
        CONCAT(
            'order_id=', NEW.order_id,
            ', customer_id=', NEW.customer_id,
            ', order_date=', NEW.order_date,
            ', ship_mode=', NEW.ship_mode
        )
    );
END$$

-- ============================================================
-- TRIGGER 2: trg_audit_order_update
-- Logs any updates to the orders table
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_audit_order_update
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, old_value, new_value)
    VALUES (
        'orders',
        'UPDATE',
        NEW.order_id,
        CONCAT(
            'ship_date=', OLD.ship_date,
            ', ship_mode=', OLD.ship_mode
        ),
        CONCAT(
            'ship_date=', NEW.ship_date,
            ', ship_mode=', NEW.ship_mode
        )
    );
END$$

-- ============================================================
-- TRIGGER 3: trg_audit_order_delete
-- Logs every deleted order for compliance tracking
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_audit_order_delete
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, old_value)
    VALUES (
        'orders',
        'DELETE',
        OLD.order_id,
        CONCAT(
            'order_id=', OLD.order_id,
            ', customer_id=', OLD.customer_id,
            ', order_date=', OLD.order_date
        )
    );
END$$

-- ============================================================
-- TRIGGER 4: trg_audit_order_item_insert
-- Logs all new order_items records
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_audit_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, new_value)
    VALUES (
        'order_items',
        'INSERT',
        CAST(NEW.row_id AS CHAR),
        CONCAT(
            'order_id=', NEW.order_id,
            ', product_id=', NEW.product_id,
            ', sales=', NEW.sales,
            ', profit=', NEW.profit,
            ', discount=', NEW.discount
        )
    );
END$$

-- ============================================================
-- TRIGGER 5: trg_prevent_negative_sales
-- Prevents insertion of order_items with negative sales
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_prevent_negative_sales
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    IF NEW.sales < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Sales value cannot be negative. Insert aborted.';
    END IF;

    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Quantity must be greater than zero. Insert aborted.';
    END IF;

    IF NEW.discount < 0 OR NEW.discount > 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Discount must be between 0 and 1 (0% to 100%). Insert aborted.';
    END IF;
END$$

-- ============================================================
-- TRIGGER 6: trg_prevent_past_ship_date
-- Ensures ship date is not before the order date
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_prevent_past_ship_date
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.ship_date < NEW.order_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Ship date cannot be earlier than order date.';
    END IF;
END$$

-- ============================================================
-- TRIGGER 7: trg_prevent_past_ship_date_update
-- Same check on UPDATE
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_prevent_past_ship_date_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.ship_date < NEW.order_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Ship date cannot be earlier than order date.';
    END IF;
END$$

-- ============================================================
-- TRIGGER 8: trg_audit_customer_update
-- Logs changes to customer records (address, segment changes)
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_audit_customer_update
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    IF OLD.segment != NEW.segment OR OLD.city != NEW.city OR OLD.state != NEW.state THEN
        INSERT INTO audit_log (table_name, action_type, record_id, old_value, new_value)
        VALUES (
            'customers',
            'UPDATE',
            NEW.customer_id,
            CONCAT('segment=', OLD.segment, ', city=', OLD.city, ', state=', OLD.state),
            CONCAT('segment=', NEW.segment, ', city=', NEW.city, ', state=', NEW.state)
        );
    END IF;
END$$

DELIMITER ;

-- ============================================================
-- Verify triggers created
-- ============================================================
SHOW TRIGGERS FROM superstore_db;

-- View audit log
SELECT * FROM audit_log ORDER BY action_at DESC LIMIT 20;
