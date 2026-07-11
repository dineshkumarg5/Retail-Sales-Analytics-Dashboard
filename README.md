<div align="center">

# 📊 Retail Sales Analytics Dashboard

### An End-to-End Retail Sales Analytics Portfolio Project

[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Pandas](https://img.shields.io/badge/Pandas-2.1-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org)
[![NumPy](https://img.shields.io/badge/NumPy-1.26-013243?style=for-the-badge&logo=numpy&logoColor=white)](https://numpy.org)
[![Matplotlib](https://img.shields.io/badge/Matplotlib-3.8-11557c?style=for-the-badge)](https://matplotlib.org)
[![Seaborn](https://img.shields.io/badge/Seaborn-0.13-79aec8?style=for-the-badge)](https://seaborn.pydata.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)
[![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org)
[![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

<br/>

*Demonstrating the complete Data Analytics workflow — from raw data to executive insights*

</div>

---

## 📌 Project Overview

This project showcases a **production-quality retail sales analytics pipeline** built on the **Superstore Sales Dataset** — a realistic retail dataset with 9,994 transactions spanning 4 years (2014–2017) across the United States.

The project demonstrates the **complete Data Analyst workflow**:

```
Raw Data → Cleaning → EDA → SQL Analysis → Visualization → Insights → Dashboard
```

It is designed to reflect the kind of work done in entry-level to junior Data Analyst, Business Analyst, and Data Science roles — not a tutorial, but a real portfolio deliverable.

---

## 📈 Repository Overview

| | |
|---|---|
| 📂 **Project Files** | 40 files across 8 folders |
| 📓 **Jupyter Notebooks** | 5 notebooks (Collection → Insights) |
| 📊 **Visualizations** | 10 professional dark-theme charts |
| 🗄️ **SQL Scripts** | 9 scripts (DDL → Triggers → 30 Interview Q&A) |
| 📈 **Power BI Dashboard** | 1 interactive dashboard (5 pages) |
| 📋 **Business Reports** | 2 reports (Full Analysis + Executive Summary) |
| 🐍 **Python Modules** | 3 reusable analysis modules |

---

## 🎯 Project Objectives

| # | Objective | Status |
|---|---|---|
| 1 | Data Collection & Profiling | ✅ Complete |
| 2 | Data Cleaning & Preprocessing | ✅ Complete |
| 3 | Exploratory Data Analysis (EDA) | ✅ Complete |
| 4 | SQL Analysis (DDL to Advanced) | ✅ Complete |
| 5 | Professional Visualizations | ✅ Complete |
| 6 | Customer Segmentation (RFM) | ✅ Complete |
| 7 | Trend & Seasonality Analysis | ✅ Complete |
| 8 | Power BI Dashboard | ✅ Complete |
| 9 | Business Insights & Recommendations | ✅ Complete |

---

## 🛠️ Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| **Language** | Python 3.11 | Core analysis language |
| **Data Manipulation** | Pandas, NumPy | Data wrangling & computation |
| **Visualization** | Matplotlib, Seaborn | Chart creation |
| **Database** | MySQL 8.0 | SQL analysis & stored procedures |
| **Notebooks** | Jupyter Notebook | Interactive analysis |
| **Dashboard** | Power BI Desktop | Business dashboard |
| **Version Control** | Git & GitHub | Project management |

---

## 🎯 Skills Demonstrated

| Category | Skills |
|---|---|
| **Data Engineering** | Data Collection, Data Cleaning, Feature Engineering, Data Preprocessing |
| **Analysis** | Exploratory Data Analysis (EDA), Statistical Analysis, Trend Analysis, Seasonality Detection |
| **SQL** | DDL/DML, Joins, Subqueries, CTEs, Window Functions, Stored Procedures, Triggers |
| **Segmentation** | RFM Customer Segmentation, Cohort Analysis, Behavioural Analytics |
| **Visualization** | Matplotlib, Seaborn, Dark-Theme Chart Design, Heatmaps, Scatter Plots |
| **BI & Reporting** | Power BI Dashboard Development, Business Insight Generation, Executive Reporting |
| **Python** | Pandas, NumPy, Modular Code Design, Reusable Functions |

---

## 📂 Repository Structure

```
Retail-Sales-Analytics-Dashboard/
│
├── 📄 README.md
├── 📄 LICENSE
├── 📄 requirements.txt
├── 📄 .gitignore
├── 📄 generate_outputs.py          ← Run this to regenerate all outputs
│
├── 📂 dataset/
│   ├── superstore_sales.csv        ← Raw Superstore dataset (9,994 rows)
│   ├── superstore_clean.csv        ← Cleaned dataset (generated)
│   └── data_dictionary.md
│
├── 📂 notebooks/
│   ├── 01_data_collection.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_exploratory_data_analysis.ipynb
│   ├── 04_data_visualization.ipynb
│   └── 05_business_insights.ipynb
│
├── 📂 analysis/
│   ├── sales_analysis.py           ← KPIs, category, region, discount
│   ├── customer_segmentation.py    ← RFM scoring & customer segments
│   └── trend_analysis.py           ← Monthly/yearly trends & seasonality
│
├── 📂 sql/
│   ├── 01_ddl_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_basic_queries.sql
│   ├── 04_joins.sql
│   ├── 05_subqueries.sql           ← CTEs, Window Functions
│   ├── 06_views.sql
│   ├── 07_stored_procedures.sql
│   ├── 08_triggers.sql
│   ├── 09_interview_queries.sql    ← 30 SQL interview Q&A
│   └── README.md
│
├── 📂 visualizations/              ← 10 generated chart PNGs
├── 📂 dashboard/
│   ├── Sales_Dashboard.pbix        ← Power BI dashboard
│   ├── dashboard_preview.md
│   └── README.md
│
└── 📂 reports/
    ├── business_insights_report.md
    └── executive_summary.md
```

---

## 📦 Dataset Information

| Attribute | Detail |
|---|---|
| **Name** | Sample Superstore Sales Dataset |
| **Source** | Tableau Public (publicly available) |
| **Period** | January 2014 – December 2017 |
| **Rows** | 9,994 transactions |
| **Columns** | 21 fields |
| **Geography** | United States (49 states) |

### Key Columns

| Column | Type | Description |
|---|---|---|
| `Order ID` | String | Unique order identifier |
| `Order Date` | Date | Date order was placed |
| `Ship Date` | Date | Date order was shipped |
| `Ship Mode` | Categorical | Standard/Second/First/Same Day |
| `Customer ID` | String | Unique customer identifier |
| `Segment` | Categorical | Consumer / Corporate / Home Office |
| `Region` | Categorical | East / West / Central / South |
| `Category` | Categorical | Furniture / Office Supplies / Technology |
| `Sub-Category` | Categorical | 17 sub-categories |
| `Sales` | Float | Revenue from the transaction |
| `Quantity` | Integer | Units ordered |
| `Discount` | Float | Discount rate (0.0 – 1.0) |
| `Profit` | Float | Net profit (can be negative) |

---

## 📊 Sample Visualizations

> All 10 charts are generated automatically by running `generate_outputs.py`

### Monthly Sales & Profit Trend (2014–2017)
![Monthly Sales Trend](visualizations/03_monthly_sales_trend.png)

### Sales & Profit by Category
![Category Sales and Profit](visualizations/01_category_sales_profit.png)

### Profit by Sub-Category (Loss Detection)
![Sub-Category Profit](visualizations/02_subcategory_profit.png)

### Sales vs Profit — Discount Impact
![Sales vs Profit Scatter](visualizations/06_sales_profit_scatter.png)

### Correlation Matrix
![Correlation Matrix](visualizations/09_correlation_matrix.png)

### Top 10 Products by Revenue
![Top 10 Products](visualizations/10_top_products.png)

---

## 📊 Power BI Dashboard

![Retail Sales Analytics Dashboard](images/dashboard_preview.png)

The dashboard features **5 interactive pages** with cross-filtering slicers:

| Page | Content |
|---|---|
| **Executive Overview** | KPI cards, category donut, yearly bar |
| **Sales Trends** | Monthly line, quarterly bars, YoY growth |
| **Products** | Top 10 bar, sub-category profit matrix |
| **Regional** | US filled map, state rankings |
| **Customers** | Segment donut, RFM scatter, LTV table |

**Slicers**: Year · Region · Category · Segment · Ship Mode

> 💡 Open `dashboard/Sales_Dashboard.pbix` in [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free) to explore the fully interactive version.

---

## 🔬 EDA Highlights

### Business KPIs
```
Total Revenue    : $2,297,200
Total Profit     : $286,397
Profit Margin    : 12.47%
Total Orders     : 9,994
Unique Customers : 793
Avg Order Value  : $458.69
```

### Category Performance
| Category | Revenue | Profit | Margin |
|---|---|---|---|
| Technology | $836,154 | $145,455 | 17.4% |
| Furniture | $741,999 | $18,451 | 2.5% |
| Office Supplies | $719,047 | $122,491 | 17.0% |

### Regional Performance
| Region | Revenue | Margin |
|---|---|---|
| West | $725,457 | 14.9% |
| East | $678,781 | 13.5% |
| Central | $501,239 | 7.9% |
| South | $391,723 | 11.9% |

### Customer Segmentation (RFM)
Using **Recency, Frequency, Monetary** scoring, customers were classified into:
- 🏆 **Champions** — Most recent, frequent, and high-value buyers
- 💎 **Loyal Customers** — Consistent, high-value, slightly older purchases
- 🌱 **Potential Loyalists** — Recent buyers with growth potential
- ⚠️ **At Risk** — Previously good customers who've gone quiet
- 😴 **Hibernating** — Low recent activity
- ❌ **Lost** — No recent interaction

---

## 🗄️ SQL Analysis

All SQL scripts are in the `sql/` folder, organized by complexity:

| Concept | File | Examples |
|---|---|---|
| DDL | `01_ddl_create_tables.sql` | CREATE TABLE, PRIMARY KEY, FOREIGN KEY, INDEX |
| DML | `02_insert_data.sql` | INSERT, SET FOREIGN_KEY_CHECKS |
| Core Queries | `03_basic_queries.sql` | SELECT, WHERE, GROUP BY, HAVING, ORDER BY |
| Joins | `04_joins.sql` | INNER, LEFT, RIGHT, SELF, CROSS JOIN |
| Advanced | `05_subqueries.sql` | CTEs, Subqueries, Window Functions |
| Views | `06_views.sql` | CREATE VIEW, Denormalized fact views |
| Procedures | `07_stored_procedures.sql` | Parameterized report procedures |
| Triggers | `08_triggers.sql` | Audit logging, Data integrity |
| Interview | `09_interview_queries.sql` | 30 real DA interview questions |

### Sample Query — RFM Segmentation in SQL
```sql
WITH customer_rfm AS (
    SELECT
        c.customer_id, c.customer_name, c.segment,
        DATEDIFF('2018-01-01', MAX(o.order_date)) AS recency_days,
        COUNT(DISTINCT o.order_id)                 AS frequency,
        ROUND(SUM(oi.sales), 2)                    AS monetary
    FROM customers c
    JOIN orders o      ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id   = oi.order_id
    GROUP BY c.customer_id, c.customer_name, c.segment
)
SELECT *,
    CASE
        WHEN (r_score + f_score + m_score) = 9 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 7 THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 5 THEN 'Potential Loyalists'
        ELSE 'At Risk / Lost'
    END AS customer_segment
FROM customer_rfm;
```

---

## 💡 Business Insights

### 🔴 Critical Issues
1. **Discounts above 30%** cause losses on 58% of transactions → immediate policy change needed
2. **Furniture Tables** sub-category loses -$17,725 annually → reprice or exit
3. **Central Region** has only 7.9% margin → investigate cost structure

### 🟡 Growth Opportunities
4. **Corporate segment** has the highest avg order value ($520) → dedicate account managers
5. **Technology margins are 17%+** → increase marketing budget
6. **30% of customers are At Risk or Hibernating** → RFM re-engagement campaigns

### 🟢 What's Working
7. **Consistent YoY revenue growth** (20%+ in 2017)
8. **West Region** is the most profitable — use as benchmark for others
9. **Copiers sub-category** has 37% margin — expand to underperforming regions

---

## 🚀 How to Run

### Prerequisites
```
Python 3.9+    |    MySQL 8.0+    |    Jupyter Notebook    |    Power BI Desktop
```

### Quick Start
```bash
# 1. Clone the repository
git clone https://github.com/dineshkumarg5/Retail-Sales-Analytics-Dashboard.git
cd Retail-Sales-Analytics-Dashboard

# 2. Install dependencies
pip install -r requirements.txt

# 3. Generate all outputs (clean CSV + 10 charts)
py -3.12 generate_outputs.py

# 4. Launch Jupyter for interactive notebooks
jupyter notebook notebooks/
```

### Run Notebooks in Order
```
01_data_collection.ipynb     → Dataset loading & profiling
02_data_cleaning.ipynb       → Cleaning, types, feature engineering
03_exploratory_data_analysis → 15+ EDA analyses
04_data_visualization.ipynb  → 10 professional charts
05_business_insights.ipynb   → RFM, trends, recommendations
```

### SQL Setup
```bash
mysql -u root -p < sql/01_ddl_create_tables.sql
mysql -u root -p < sql/02_insert_data.sql
# Continue in numeric order through 09
```

---

## 🔮 Future Enhancements

- [ ] **Machine Learning** — Discount optimization model (predict optimal discount)
- [ ] **Churn Prediction** — Classification model for at-risk customers
- [ ] **Demand Forecasting** — Prophet/ARIMA time-series forecasting
- [ ] **Streamlit App** — Interactive web dashboard for non-technical stakeholders
- [ ] **Geographic Expansion** — Zip-code level analysis with demographic overlay
- [ ] **NLP Sentiment** — Customer review analysis

---

## 📂 Quick Links

| Resource | Link |
|---|---|
| 📓 Data Collection | [notebooks/01_data_collection.ipynb](notebooks/01_data_collection.ipynb) |
| 🧹 Data Cleaning | [notebooks/02_data_cleaning.ipynb](notebooks/02_data_cleaning.ipynb) |
| 🔍 EDA | [notebooks/03_exploratory_data_analysis.ipynb](notebooks/03_exploratory_data_analysis.ipynb) |
| 📊 Visualizations | [notebooks/04_data_visualization.ipynb](notebooks/04_data_visualization.ipynb) |
| 💡 Insights | [notebooks/05_business_insights.ipynb](notebooks/05_business_insights.ipynb) |
| 🗄️ SQL Guide | [sql/README.md](sql/README.md) |
| 📋 Business Report | [reports/business_insights_report.md](reports/business_insights_report.md) |
| 📄 Executive Summary | [reports/executive_summary.md](reports/executive_summary.md) |
| 📊 Dashboard Guide | [dashboard/README.md](dashboard/README.md) |
| 📖 Data Dictionary | [dataset/data_dictionary.md](dataset/data_dictionary.md) |

---

## 👤 Author

<div align="center">

**Dinesh Kumar G**

[![GitHub](https://img.shields.io/badge/GitHub-dineshkumarg5-181717?style=for-the-badge&logo=github)](https://github.com/dineshkumarg5)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/dineshkumarg5)
[![Email](https://img.shields.io/badge/Email-Contact-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:dinesh369.official@gmail.com)

*Data Analyst | Python | SQL | Power BI*

</div>

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

*If this project helped you, consider giving it a ⭐ on GitHub!*

**Other Projects**: [FoodLink](https://github.com/dineshkumarg5/FoodLink) · [Web-Based Voting System](https://github.com/dineshkumarg5/Web-Based-Voting-System) · [SQL Practice](https://github.com/dineshkumarg5/SQL-Practice) · [Python Practice](https://github.com/dineshkumarg5/Python-Practice)

</div>
