# 🗄️ SQL Analysis — Superstore Sales

This folder contains all SQL scripts for the **Sales Data Analytics** project.  
All scripts are written for **MySQL 8.0+** and follow professional naming conventions.

---

## 📁 Script Index

| File | Description | Key Concepts |
|---|---|---|
| `01_ddl_create_tables.sql` | Database schema creation | `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY`, `INDEXES` |
| `02_insert_data.sql` | Sample data population | `INSERT INTO`, `SET FOREIGN_KEY_CHECKS` |
| `03_basic_queries.sql` | Core business queries | `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY` |
| `04_joins.sql` | Multi-table joins | `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `SELF JOIN`, `CROSS JOIN` |
| `05_subqueries.sql` | Advanced querying | Subqueries, CTEs, Window Functions (`RANK`, `LAG`, `NTILE`) |
| `06_views.sql` | Business reporting views | `CREATE VIEW`, Denormalized fact views |
| `07_stored_procedures.sql` | Automated reporting | `CREATE PROCEDURE`, Parameters, Multi-result sets |
| `08_triggers.sql` | Data integrity & auditing | `AFTER INSERT`, `BEFORE DELETE`, `SIGNAL SQLSTATE` |
| `09_interview_queries.sql` | Interview preparation | 30 real DA/BA interview SQL questions |

---

## 🗃️ Database Schema

```
superstore_db
├── categories          (category_id PK)
├── sub_categories      (sub_category_id PK → category_id FK)
├── products            (product_id PK → sub_category_id FK)
├── customers           (customer_id PK)
├── orders              (order_id PK → customer_id FK)
├── order_items         (row_id PK → order_id FK, product_id FK)
└── audit_log           (log_id PK — trigger-populated)
```

### Entity Relationship Diagram
```
categories ──< sub_categories ──< products ──< order_items >── orders >── customers
                                                                    │
                                                                audit_log
```

---

## 🚀 How to Run

### Prerequisites
- MySQL 8.0+ installed and running
- MySQL Workbench or DBeaver (recommended)

### Step-by-Step Execution

```bash
# 1. Connect to MySQL
mysql -u root -p

# 2. Run scripts in order
source sql/01_ddl_create_tables.sql
source sql/02_insert_data.sql
source sql/03_basic_queries.sql
source sql/04_joins.sql
source sql/05_subqueries.sql
source sql/06_views.sql
source sql/07_stored_procedures.sql
source sql/08_triggers.sql

# 3. Run interview queries for practice
source sql/09_interview_queries.sql
```

Or in MySQL Workbench:  
**File → Open SQL Script → Run (Ctrl+Shift+Enter)**

---

## 📊 Key Business Queries Summary

| Analysis | Script | Query # |
|---|---|---|
| Total Revenue & KPIs | `03_basic_queries.sql` | Q3 |
| Sales by Region | `03_basic_queries.sql` | Q10 |
| Monthly Sales Trend | `03_basic_queries.sql` | Q11 |
| Top 10 Products | `03_basic_queries.sql` | Q18 |
| Loss-Making Products | `03_basic_queries.sql` | Q20 |
| RFM Segmentation | `05_subqueries.sql` | SQ5 |
| YoY Growth Rate | `05_subqueries.sql` | SQ6 |
| Category Performance | `06_views.sql` | VIEW 4 |

---

## 💡 SQL Concepts Demonstrated

- ✅ DDL — `CREATE`, `ALTER`, `DROP`, `TRUNCATE`
- ✅ DML — `INSERT`, `UPDATE`, `DELETE`, `SELECT`
- ✅ Aggregate Functions — `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
- ✅ Joins — `INNER`, `LEFT`, `RIGHT`, `SELF`, `CROSS`
- ✅ Subqueries — Scalar, Correlated, Inline views
- ✅ CTEs — `WITH` clause, multi-CTE chains
- ✅ Window Functions — `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LAG`, `LEAD`, `NTILE`, `PERCENT_RANK`
- ✅ Views — Business reporting, denormalized fact views
- ✅ Stored Procedures — Parameterized reports
- ✅ Triggers — Audit logging, data integrity enforcement
- ✅ String Functions — `CONCAT`, `FORMAT`, `DATE_FORMAT`
- ✅ Date Functions — `YEAR`, `MONTH`, `MONTHNAME`, `DATEDIFF`
- ✅ Conditional Logic — `CASE WHEN`, `COALESCE`, `NULLIF`
