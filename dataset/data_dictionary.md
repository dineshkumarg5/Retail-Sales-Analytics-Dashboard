# 📋 Data Dictionary — Superstore Sales Dataset

## Overview
The Superstore Sales dataset is a fictional retail dataset commonly used for data analytics practice. It contains order-level transactional data from a US-based office supply & technology superstore.

| Attribute | Value |
|---|---|
| **Source** | Sample Superstore (Tableau Public) |
| **Time Period** | 2014 – 2017 |
| **Total Records** | ~9,994 rows |
| **Total Columns** | 21 |
| **File Format** | CSV |
| **File Size** | ~1 MB |

---

## Column Descriptions

| # | Column Name | Data Type | Description | Example |
|---|---|---|---|---|
| 1 | `Row ID` | Integer | Unique identifier for each row | 1, 2, 3 |
| 2 | `Order ID` | String | Unique identifier for each order | CA-2016-152156 |
| 3 | `Order Date` | Date (MM/DD/YYYY) | Date when the order was placed | 11/8/2016 |
| 4 | `Ship Date` | Date (MM/DD/YYYY) | Date when the order was shipped | 11/11/2016 |
| 5 | `Ship Mode` | Categorical | Shipping method chosen | Second Class, Standard Class, First Class, Same Day |
| 6 | `Customer ID` | String | Unique identifier for each customer | CG-12520 |
| 7 | `Customer Name` | String | Full name of the customer | Claire Gute |
| 8 | `Segment` | Categorical | Customer market segment | Consumer, Corporate, Home Office |
| 9 | `Country` | String | Country of the customer | United States |
| 10 | `City` | String | City of the customer | Henderson |
| 11 | `State` | String | US State of the customer | Kentucky |
| 12 | `Postal Code` | Integer | Postal/ZIP code | 42420 |
| 13 | `Region` | Categorical | Sales region | East, West, Central, South |
| 14 | `Product ID` | String | Unique identifier for each product | FUR-BO-10001798 |
| 15 | `Category` | Categorical | Product category | Furniture, Office Supplies, Technology |
| 16 | `Sub-Category` | Categorical | Product sub-category | Bookcases, Chairs, Labels, Phones |
| 17 | `Product Name` | String | Full product name | Bush Somerset Collection Bookcase |
| 18 | `Sales` | Float (USD) | Revenue from the order line | 261.96 |
| 19 | `Quantity` | Integer | Number of units ordered | 2 |
| 20 | `Discount` | Float (0.0–1.0) | Discount rate applied | 0.0 (0%), 0.2 (20%) |
| 21 | `Profit` | Float (USD) | Net profit from the order line (can be negative) | 41.91 |

---

## Categorical Column Values

### Ship Mode
| Value | Description |
|---|---|
| Standard Class | Slowest, cheapest shipping (5–7 days) |
| Second Class | Mid-speed shipping (3–4 days) |
| First Class | Fast shipping (2–3 days) |
| Same Day | Same-day delivery |

### Segment
| Value | Description |
|---|---|
| Consumer | Individual retail customers |
| Corporate | Business/enterprise customers |
| Home Office | Small home office buyers |

### Region
| Value | States Covered |
|---|---|
| East | New York, Pennsylvania, Florida, Ohio, etc. |
| West | California, Washington, Colorado, etc. |
| Central | Texas, Illinois, Michigan, Minnesota, etc. |
| South | Georgia, North Carolina, Kentucky, etc. |

### Category
| Value | Sub-Categories |
|---|---|
| Furniture | Bookcases, Chairs, Furnishings, Tables |
| Office Supplies | Art, Binders, Envelopes, Fasteners, Labels, Paper, Storage, Appliances |
| Technology | Accessories, Copiers, Machines, Phones |

---

## Key Business Metrics

| Metric | Formula |
|---|---|
| **Total Revenue** | `SUM(Sales)` |
| **Total Profit** | `SUM(Profit)` |
| **Profit Margin** | `SUM(Profit) / SUM(Sales) * 100` |
| **Avg Order Value** | `SUM(Sales) / COUNT(DISTINCT Order ID)` |
| **Shipping Days** | `Ship Date - Order Date` |
| **Discount Impact** | Correlation between Discount and Profit |

---

## Data Quality Notes
- No missing values in core columns
- `Profit` can be **negative** (loss) — especially in Tables and Bookcases sub-categories
- High discounts (>30%) frequently result in negative profit
- `Postal Code` may need to be treated as string to preserve leading zeros
- `Order Date` and `Ship Date` stored as strings — convert to datetime for analysis
