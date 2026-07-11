"""
generate_outputs.py
===================
Standalone script that produces all project outputs:
  1. dataset/superstore_clean.csv   -- cleaned dataset
  2. visualizations/*.png           -- 10 professional charts

Run with: py -3.12 generate_outputs.py
"""
import sys, io
# Force UTF-8 output so emoji/special chars work on Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

import os

# ── Ensure working directory is the project root ────────────────────────────
script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')          # non-interactive backend (no display needed)
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import seaborn as sns
import warnings
from pathlib import Path

warnings.filterwarnings('ignore')

# ── Paths ────────────────────────────────────────────────────────────────────
DATA_PATH = Path('dataset/superstore_sales.csv')
CLEAN_PATH = Path('dataset/superstore_clean.csv')
VIZ_DIR   = Path('visualizations')
VIZ_DIR.mkdir(exist_ok=True)

# ── Dark Theme ────────────────────────────────────────────────────────────────
plt.rcParams.update({
    'figure.dpi'        : 130,
    'figure.facecolor'  : '#0F1117',
    'axes.facecolor'    : '#1A1D27',
    'axes.edgecolor'    : '#2D3147',
    'axes.labelcolor'   : '#E0E0E0',
    'text.color'        : '#E0E0E0',
    'xtick.color'       : '#A0A0A0',
    'ytick.color'       : '#A0A0A0',
    'grid.color'        : '#2D3147',
    'grid.alpha'        : 0.4,
    'axes.spines.top'   : False,
    'axes.spines.right' : False,
    'font.family'       : 'DejaVu Sans',
    'font.size'         : 11,
})

COLORS = ['#4FC3F7', '#AB47BC', '#66BB6A', '#FFA726', '#EF5350', '#26C6DA', '#FF7043']
BG     = '#0F1117'

def savefig(name):
    plt.savefig(VIZ_DIR / name, dpi=150, bbox_inches='tight', facecolor=BG)
    plt.close()
    print(f'  [SAVED] {name}')

# ============================================================
# STEP 1 — Load & clean data
# ============================================================
print('\n[STEP 1] Loading and cleaning dataset ...')

df = pd.read_csv(DATA_PATH)

# Column standardization
df.columns = (df.columns.str.strip()
                         .str.lower()
                         .str.replace(' ', '_', regex=False)
                         .str.replace('-', '_', regex=False))

# Date conversion
df['order_date'] = pd.to_datetime(df['order_date'], dayfirst=False)
df['ship_date']  = pd.to_datetime(df['ship_date'],  dayfirst=False)

# String columns
df['postal_code']    = df['postal_code'].astype(str).str.zfill(5)
df['customer_name']  = df['customer_name'].str.strip().str.title()
df['city']           = df['city'].str.strip().str.title()
df['state']          = df['state'].str.strip().str.title()

# Categoricals
for col in ['category', 'sub_category', 'region', 'segment', 'ship_mode']:
    if col in df.columns:
        df[col] = df[col].astype('category')

# Feature engineering
df['order_year']        = df['order_date'].dt.year
df['order_month']       = df['order_date'].dt.month
df['month_name']        = df['order_date'].dt.strftime('%b')
df['order_quarter']     = df['order_date'].dt.quarter
df['shipping_days']     = (df['ship_date'] - df['order_date']).dt.days
df['profit_margin_pct'] = np.where(df['sales'] != 0,
                                   (df['profit'] / df['sales'] * 100).round(2), 0)
df['revenue_per_unit']  = (df['sales'] / df['quantity']).round(2)
df['has_discount']      = (df['discount'] > 0).astype(int)

bins   = [-0.01, 0.0, 0.10, 0.20, 0.30, 0.40, 1.0]
labels = ['No Discount', '1-10%', '11-20%', '21-30%', '31-40%', '40%+']
df['discount_band'] = pd.cut(df['discount'], bins=bins, labels=labels)

# Remove duplicates
df = df.drop_duplicates()

df.to_csv(CLEAN_PATH, index=False)
print(f'  [OK] superstore_clean.csv saved  ({df.shape[0]:,} rows x {df.shape[1]} columns)')

# ============================================================
# STEP 2 — Generate visualizations
# ============================================================
print('\n[STEP 2] Generating visualizations ...')

# -- Chart 1: Sales & Profit by Category -----------------------------------------
cat_data = (df.groupby('category', observed=True)
              .agg(Total_Sales=('sales','sum'), Total_Profit=('profit','sum'))
              .reset_index().sort_values('Total_Sales', ascending=False))

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle('Sales & Profit by Category', fontsize=16, fontweight='bold', color='white', y=1.01)

bars = axes[0].bar(cat_data['category'], cat_data['Total_Sales']/1000,
                   color=COLORS[:3], edgecolor='none', width=0.5)
axes[0].set_title('Total Revenue by Category', color='white', fontsize=13)
axes[0].set_ylabel('Revenue ($K)', color='white')
axes[0].yaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}K'))
for bar in bars:
    axes[0].text(bar.get_x()+bar.get_width()/2, bar.get_height()+1,
                 f'${bar.get_height():,.0f}K', ha='center', fontsize=10, color='white')

profit_colors = ['#66BB6A' if p>0 else '#EF5350' for p in cat_data['Total_Profit']]
bars2 = axes[1].bar(cat_data['category'], cat_data['Total_Profit']/1000,
                    color=profit_colors, edgecolor='none', width=0.5)
axes[1].set_title('Total Profit by Category', color='white', fontsize=13)
axes[1].set_ylabel('Profit ($K)', color='white')
axes[1].yaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}K'))
axes[1].axhline(0, color='white', linewidth=0.8, linestyle='--', alpha=0.5)
for bar in bars2:
    ypos = bar.get_height()+0.5 if bar.get_height()>=0 else bar.get_height()-3
    axes[1].text(bar.get_x()+bar.get_width()/2, ypos,
                 f'${bar.get_height():,.1f}K', ha='center', fontsize=10, color='white')
plt.tight_layout()
savefig('01_category_sales_profit.png')

# ── Chart 2: Sub-Category Profit (Horizontal Bar) ────────────────────────────
subcat = (df.groupby('sub_category', observed=True)['profit']
            .sum().reset_index().sort_values('profit'))

fig, ax = plt.subplots(figsize=(12, 8))
colors = ['#EF5350' if p<0 else '#66BB6A' for p in subcat['profit']]
bars = ax.barh(subcat['sub_category'], subcat['profit']/1000, color=colors, edgecolor='none')
ax.set_title('Profit by Sub-Category\n(Red = Loss  |  Green = Profit)',
             fontsize=14, fontweight='bold', color='white')
ax.set_xlabel('Total Profit ($K)', color='white')
ax.axvline(0, color='white', linewidth=1, linestyle='--', alpha=0.6)
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.1f}K'))
plt.tight_layout()
savefig('02_subcategory_profit.png')

# ── Chart 3: Monthly Sales Trend ─────────────────────────────────────────────
monthly = (df.groupby(['order_year','order_month'], observed=True)
             .agg(Total_Sales=('sales','sum'), Total_Profit=('profit','sum'))
             .reset_index().sort_values(['order_year','order_month']))
monthly['period'] = (monthly['order_year'].astype(str) + '-' +
                     monthly['order_month'].astype(str).str.zfill(2))

fig, ax = plt.subplots(figsize=(16, 6))
x = range(len(monthly))
ax.plot(x, monthly['Total_Sales']/1000, color='#4FC3F7', linewidth=2.5,
        marker='o', markersize=4, label='Sales')
ax.fill_between(x, monthly['Total_Sales']/1000, alpha=0.2, color='#4FC3F7')
ax.plot(x, monthly['Total_Profit']/1000, color='#66BB6A', linewidth=2,
        linestyle='--', marker='s', markersize=3, label='Profit')
ax.set_title('Monthly Sales & Profit Trend (2014–2017)', fontsize=14, fontweight='bold', color='white')
ax.set_ylabel('Amount ($K)', color='white')
ax.set_xlabel('Period', color='white')
ax.legend(framealpha=0.3)
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}K'))
tick_idx = list(range(0, len(monthly), 3))
ax.set_xticks(tick_idx)
ax.set_xticklabels([monthly.iloc[i]['period'] for i in tick_idx], rotation=45, ha='right', fontsize=8)
plt.tight_layout()
savefig('03_monthly_sales_trend.png')

# ── Chart 4: Region & Segment Pie ────────────────────────────────────────────
fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle('Sales Distribution by Region & Segment', fontsize=15, fontweight='bold', color='white')

region_data = df.groupby('region', observed=True)['sales'].sum().sort_values(ascending=False)
w, t, at = axes[0].pie(region_data.values, labels=region_data.index, autopct='%1.1f%%',
                        colors=COLORS, startangle=140, pctdistance=0.75,
                        wedgeprops=dict(edgecolor=BG, linewidth=2))
for tx in t:  tx.set_color('white')
for at_ in at: at_.set_color('white'); at_.set_fontsize(10)
axes[0].set_title('Sales Share by Region', color='white', fontsize=12, pad=15)

seg_data = df.groupby('segment', observed=True)['sales'].sum().sort_values(ascending=False)
w2, t2, at2 = axes[1].pie(seg_data.values, labels=seg_data.index, autopct='%1.1f%%',
                           colors=['#4FC3F7','#AB47BC','#66BB6A'], startangle=140,
                           pctdistance=0.75, wedgeprops=dict(edgecolor=BG, linewidth=2))
for tx in t2:  tx.set_color('white')
for at_ in at2: at_.set_color('white'); at_.set_fontsize(10)
axes[1].set_title('Sales Share by Customer Segment', color='white', fontsize=12, pad=15)
plt.tight_layout()
savefig('04_region_segment_pie.png')

# ── Chart 5: Heatmap Year × Month ────────────────────────────────────────────
pivot = (df.groupby(['order_year','order_month'], observed=True)['sales']
           .sum().unstack('order_month').fillna(0))
month_map = {1:'Jan',2:'Feb',3:'Mar',4:'Apr',5:'May',6:'Jun',
             7:'Jul',8:'Aug',9:'Sep',10:'Oct',11:'Nov',12:'Dec'}
pivot.columns = [month_map.get(c,c) for c in pivot.columns]

fig, ax = plt.subplots(figsize=(14, 5))
sns.heatmap(pivot/1000, ax=ax, cmap='YlOrRd', annot=True, fmt='.0f',
            linewidths=0.5, linecolor=BG, cbar_kws={'label':'Sales ($K)','shrink':0.8})
ax.set_title('Monthly Sales Heatmap — Year × Month ($K)', fontsize=14, fontweight='bold', color='white', pad=15)
ax.set_xlabel('Month', color='white'); ax.set_ylabel('Year', color='white')
ax.tick_params(colors='white')
plt.tight_layout()
savefig('05_monthly_heatmap.png')

# ── Chart 6: Sales vs Profit Scatter ─────────────────────────────────────────
fig, ax = plt.subplots(figsize=(12, 7))
sc = ax.scatter(df['sales'], df['profit'], c=df['discount'],
                cmap='RdYlGn_r', alpha=0.6, s=30, edgecolors='none')
cb = plt.colorbar(sc, ax=ax)
cb.set_label('Discount Rate', color='white')
cb.ax.yaxis.set_tick_params(color='white')
plt.setp(cb.ax.yaxis.get_ticklabels(), color='white')
ax.axhline(0, color='white', linewidth=1, linestyle='--', alpha=0.5)
ax.set_title('Sales vs Profit  (colored by Discount Rate)', fontsize=14, fontweight='bold', color='white')
ax.set_xlabel('Sales ($)', color='white'); ax.set_ylabel('Profit ($)', color='white')
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}'))
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}'))
ax.text(0.98, 0.02, '⚠️  High discount → negative profit',
        transform=ax.transAxes, color='#FFA726', fontsize=10, ha='right')
plt.tight_layout()
savefig('06_sales_profit_scatter.png')

# -- Chart 7: Box Plot by Category (using seaborn for compatibility) -----------
fig, ax = plt.subplots(figsize=(12, 6))
cat_order = list(df.groupby('category', observed=True)['sales']
                   .median().sort_values(ascending=False).index)
palette = {cat: col for cat, col in zip(cat_order, COLORS)}
sns.boxplot(data=df, x='category', y='sales', order=cat_order,
            palette=palette, ax=ax, linewidth=1.5,
            medianprops=dict(color='white', linewidth=2))
ax.set_title('Sales Distribution by Category (Box Plot)', fontsize=14, fontweight='bold', color='white')
ax.set_xlabel('Category', color='white')
ax.set_ylabel('Sales ($)', color='white')
ax.set_yscale('log')
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'${x:,.0f}'))
ax.text(0.01, 0.98, 'Log scale applied', transform=ax.transAxes,
        color='#A0A0A0', fontsize=9, va='top')
plt.tight_layout()
savefig('07_category_sales_boxplot.png')

# ── Chart 8: Profit Histogram ─────────────────────────────────────────────────
fig, ax = plt.subplots(figsize=(12, 6))
ax.hist(df['profit'], bins=60, color='#4FC3F7', alpha=0.75, edgecolor='none')
ax.axvline(df['profit'].mean(),   color='#FFA726', linewidth=2, linestyle='--',
           label=f'Mean: ${df["profit"].mean():,.2f}')
ax.axvline(df['profit'].median(), color='#66BB6A', linewidth=2, linestyle='-.',
           label=f'Median: ${df["profit"].median():,.2f}')
ax.axvline(0, color='#EF5350', linewidth=1.5, linestyle=':', label='Break Even')
ax.set_title('Profit Distribution — All Transactions', fontsize=14, fontweight='bold', color='white')
ax.set_xlabel('Profit ($)', color='white'); ax.set_ylabel('Frequency', color='white')
ax.legend(framealpha=0.3)
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}'))
loss_pct = (df['profit']<0).sum()/len(df)*100
ax.text(0.98, 0.95, f'Loss transactions: {loss_pct:.1f}%',
        transform=ax.transAxes, color='#EF5350', fontsize=10, ha='right', va='top')
plt.tight_layout()
savefig('08_profit_histogram.png')

# ── Chart 9: Correlation Matrix ───────────────────────────────────────────────
num_cols = ['sales','quantity','discount','profit','shipping_days','profit_margin_pct','revenue_per_unit']
available = [c for c in num_cols if c in df.columns]
corr = df[available].corr()

fig, ax = plt.subplots(figsize=(10, 8))
mask = np.triu(np.ones_like(corr, dtype=bool))
sns.heatmap(corr, ax=ax, mask=mask, cmap='coolwarm', annot=True, fmt='.2f',
            vmin=-1, vmax=1, center=0, square=True,
            linewidths=0.5, linecolor=BG, annot_kws={'size':9})
ax.set_title('Correlation Matrix — Numeric Variables', fontsize=14, fontweight='bold', color='white', pad=15)
ax.tick_params(colors='white')
plt.tight_layout()
savefig('09_correlation_matrix.png')

# ── Chart 10: Top 10 Products ─────────────────────────────────────────────────
top10 = (df.groupby('product_name')
           .agg(Total_Sales=('sales','sum'), Total_Profit=('profit','sum'))
           .sort_values('Total_Sales', ascending=False)
           .head(10).reset_index())

fig, ax = plt.subplots(figsize=(13, 7))
colors = ['#66BB6A' if p>0 else '#EF5350' for p in top10['Total_Profit']]
bars = ax.barh(top10['product_name'].str[:45], top10['Total_Sales']/1000,
               color=colors, edgecolor='none')
for bar, profit in zip(bars, top10['Total_Profit']/1000):
    ax.text(bar.get_width()+0.5, bar.get_y()+bar.get_height()/2,
            f'${bar.get_width():.1f}K  |  P: ${profit:.1f}K',
            ha='left', va='center', fontsize=8.5, color='white')
ax.set_title('Top 10 Products by Revenue  (Green = Profitable  |  Red = Loss)',
             fontsize=13, fontweight='bold', color='white')
ax.set_xlabel('Total Sales ($K)', color='white')
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x,_: f'${x:,.0f}K'))
ax.invert_yaxis()
plt.tight_layout()
savefig('10_top_products.png')

# ============================================================
print('\n[DONE] All outputs generated successfully!')
print('  >> dataset/superstore_clean.csv')
print('  >> visualizations/ (10 charts)')
