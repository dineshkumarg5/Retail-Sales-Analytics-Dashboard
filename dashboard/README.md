# 📊 Power BI Dashboard — Sales Analytics

This folder contains the **Power BI dashboard** for the Sales Data Analytics project.

---

## 📁 Files

| File | Description |
|---|---|
| `Sales_Dashboard.pbix` | Power BI Desktop file (requires Power BI Desktop to open) |
| `dashboard_preview.md` | Screenshots and design documentation |
| `README.md` | This file — setup and usage guide |

---

## 🚀 How to Open

### Prerequisites
- **Power BI Desktop** (free) — [Download here](https://powerbi.microsoft.com/desktop/)
- Windows 10/11

### Steps
1. Download and install **Power BI Desktop**
2. Open `Sales_Dashboard.pbix` in Power BI Desktop
3. If prompted to update data source, point to `../dataset/superstore_clean.csv`
4. Click **Refresh** to load latest data
5. Explore the interactive dashboard!

---

## 📋 Dashboard Pages

### Page 1 — Executive Overview
| Visual | Type | Description |
|---|---|---|
| Total Sales KPI | Card | Overall revenue figure |
| Total Profit KPI | Card | Net profit |
| Total Orders KPI | Card | Order count |
| Profit Margin KPI | Card | Margin percentage |
| Sales by Year | Column Chart | Year-over-year comparison |
| Profit by Category | Donut Chart | Category contribution |

### Page 2 — Sales Trends
| Visual | Type | Description |
|---|---|---|
| Monthly Sales Trend | Line Chart | 2014–2017 monthly view |
| Sales by Quarter | Clustered Bar | Q1–Q4 breakdown |
| YoY Growth Rate | Line + Clustered | Dual-axis trend |
| Rolling 3M Average | Line Chart | Smoothed trend |

### Page 3 — Product & Category Analysis
| Visual | Type | Description |
|---|---|---|
| Top 10 Products | Bar Chart | Ranked by revenue |
| Category Matrix | Matrix | Sales + Profit by Category × Region |
| Sub-Category Heatmap | Matrix | Profit margin comparison |
| Discount vs Profit | Scatter Plot | Discount impact |

### Page 4 — Regional Analysis
| Visual | Type | Description |
|---|---|---|
| US Sales Map | Filled Map | State-level sales visualization |
| Region Comparison | Clustered Bar | 4-region performance |
| State Rankings | Table | Sortable state performance |
| Region Profit Gauge | Gauge | Regional margin vs target |

### Page 5 — Customer Insights
| Visual | Type | Description |
|---|---|---|
| Segment Performance | Donut | Consumer/Corporate/Home Office |
| Customer Lifetime Value | Bar | Top 20 customers by LTV |
| RFM Distribution | Scatter | Recency vs Monetary |
| Ship Mode Analysis | Bar | Mode popularity + avg days |

---

## 🎨 Design Theme

- **Color Palette**: Dark Navy (#0F1117) with accent blues and greens
- **Typography**: Segoe UI (Power BI default) with custom styling
- **Layout**: 16:9 widescreen (1280×720)
- **Slicers**: Year, Region, Category, Segment, Ship Mode

---

## 🔄 Data Refresh

To refresh with new data:
1. Replace `dataset/superstore_clean.csv` with updated file
2. Open Power BI Desktop → `Home → Refresh`
3. Publish to Power BI Service for web sharing

---

## 📤 Publishing to Power BI Service

1. Sign in to Power BI Desktop with your Microsoft account
2. Click `Home → Publish`
3. Select your workspace
4. Access at `https://app.powerbi.com`

---

> **Note**: The `.pbix` file requires Power BI Desktop to open.
> Screenshots of all dashboard pages are available in `dashboard_preview.md`.
