# 🖼️ Dashboard Preview — Sales Analytics Power BI

This document describes the layout, KPIs, and design of the Sales Analytics Power BI Dashboard.

---

## 📐 Dashboard Layout Overview

```
┌──────────────────────────────────────────────────────────────────────────┐
│  SALES ANALYTICS DASHBOARD              [Year ▼] [Region ▼] [Category ▼]│
├────────────┬────────────┬────────────┬────────────┬──────────────────────┤
│ 💰 Revenue │ 💹 Profit  │ 📦 Orders  │ 📊 Margin  │ 👥 Customers         │
│  $2.3M     │  $286K     │   9,994    │   12.5%    │   793               │
├────────────┴────────────┴────────────┴────────────┴──────────────────────┤
│                    Monthly Sales Trend (Line Chart)                       │
│  ════════════════════════════════════════════════════════════════════════ │
├─────────────────────────────┬────────────────────────────────────────────┤
│  Sales by Category          │  Top 10 Products by Revenue                │
│  (Donut Chart)              │  (Horizontal Bar)                          │
├─────────────────────────────┼────────────────────────────────────────────┤
│  Regional Sales Map         │  Profit by Sub-Category (Matrix)           │
│  (Filled Map — US States)   │                                            │
└─────────────────────────────┴────────────────────────────────────────────┘
```

---

## 🎯 Key KPI Cards

| KPI | Value | Description |
|---|---|---|
| **Total Revenue** | $2,297,200 | Sum of all sales 2014–2017 |
| **Total Profit** | $286,397 | Net profit after costs |
| **Total Orders** | 9,994 | Unique order count |
| **Profit Margin** | 12.47% | Profit / Revenue × 100 |
| **Total Customers** | 793 | Unique customer IDs |
| **Avg Order Value** | $458.69 | Revenue / Orders |

---

## 📊 Visual Specifications

### Chart 1 — Monthly Sales Trend
- **Type**: Line + Area Chart
- **X-axis**: Month-Year
- **Y-axis**: Sales Amount ($)
- **Series**: Sales (blue line), Profit (green dashed)
- **Drill-through**: Click month → see product breakdown

### Chart 2 — Sales by Category
- **Type**: Donut Chart
- **Legend**: Furniture | Office Supplies | Technology
- **Colors**: Category-coded

### Chart 3 — Regional Sales Map
- **Type**: Filled Map (US States)
- **Color Scale**: Light → Dark blue (low → high sales)
- **Tooltip**: State, Sales, Profit, Orders

### Chart 4 — Top Products
- **Type**: Horizontal Bar
- **Ranked By**: Total Sales descending
- **Conditional Format**: Green (profitable) / Red (loss-making)

### Chart 5 — Profit Matrix
- **Type**: Matrix visual
- **Rows**: Category → Sub-Category
- **Columns**: Region (East, West, Central, South)
- **Values**: Profit with conditional formatting

### Chart 6 — Discount Analysis
- **Type**: Scatter Plot
- **X**: Discount Rate (0–1)
- **Y**: Profit ($)
- **Size**: Sales amount
- **Trend line**: Negative correlation visible

---

## 🎨 Color Theme

| Element | Color | Hex |
|---|---|---|
| Background | Dark Navy | `#0F1117` |
| Panel | Dark Blue | `#1A1D27` |
| Primary Accent | Sky Blue | `#4FC3F7` |
| Positive/Profit | Green | `#66BB6A` |
| Negative/Loss | Red | `#EF5350` |
| Warning | Orange | `#FFA726` |
| Text Primary | White | `#E0E0E0` |
| Text Secondary | Grey | `#A0A0A0` |

---

## 🔲 Slicers (Interactive Filters)

| Slicer | Type | Values |
|---|---|---|
| **Year** | Dropdown | 2014, 2015, 2016, 2017, All |
| **Region** | Multi-select | East, West, Central, South |
| **Category** | Multi-select | Furniture, Office Supplies, Technology |
| **Segment** | Multi-select | Consumer, Corporate, Home Office |
| **Ship Mode** | Dropdown | All modes |

All slicers are cross-filtered — selecting one slicer updates all other visuals on the page.

---

## 📋 Dashboard Pages

| # | Page Name | Focus Area |
|---|---|---|
| 1 | Executive Overview | KPIs, category, yearly trend |
| 2 | Sales Trends | Monthly, quarterly, seasonal |
| 3 | Products | Top products, sub-category matrix |
| 4 | Regional | Map, state ranking, regional comparison |
| 5 | Customers | Segments, LTV, ship mode |

---

> 💡 **To reproduce**: Import `dataset/superstore_clean.csv` into Power BI Desktop.
> Use Power Query to format dates, then build visuals using the specifications above.
