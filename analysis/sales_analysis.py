"""
============================================================
sales_analysis.py
Project : Sales Data Analytics
Description : Core sales analysis functions for the
              Superstore Sales dataset.
Author  : Dinesh
Date    : 2024
============================================================
"""

import pandas as pd
import numpy as np
from pathlib import Path


# ── Paths ────────────────────────────────────────────────────────────────────
DATA_PATH = Path(__file__).parent.parent / "dataset" / "superstore_sales.csv"


# ── Data Loading ─────────────────────────────────────────────────────────────

def load_data(filepath: str | Path = DATA_PATH) -> pd.DataFrame:
    """
    Load the Superstore sales CSV and apply standard type conversions.

    Returns
    -------
    pd.DataFrame
        Clean DataFrame with proper dtypes.
    """
    df = pd.read_csv(filepath)

    # Convert date columns
    df["Order Date"] = pd.to_datetime(df["Order Date"], dayfirst=False)
    df["Ship Date"]  = pd.to_datetime(df["Ship Date"],  dayfirst=False)

    # Derived time columns
    df["Order Year"]    = df["Order Date"].dt.year
    df["Order Month"]   = df["Order Date"].dt.month
    df["Month Name"]    = df["Order Date"].dt.strftime("%b")
    df["Order Quarter"] = df["Order Date"].dt.quarter
    df["Shipping Days"] = (df["Ship Date"] - df["Order Date"]).dt.days

    # Profit margin per row
    df["Profit Margin %"] = np.where(
        df["Sales"] != 0,
        (df["Profit"] / df["Sales"]) * 100,
        0
    ).round(2)

    # Profit status flag
    df["Profit Status"] = df["Profit"].apply(
        lambda p: "Profit" if p > 0 else ("Loss" if p < 0 else "Break Even")
    )

    return df


# ── KPI Functions ─────────────────────────────────────────────────────────────

def get_kpis(df: pd.DataFrame) -> dict:
    """
    Calculate top-level business KPIs.

    Returns
    -------
    dict
        Dictionary of key performance indicators.
    """
    return {
        "Total Orders"      : df["Order ID"].nunique(),
        "Total Customers"   : df["Customer ID"].nunique(),
        "Total Products"    : df["Product ID"].nunique(),
        "Total Revenue"     : round(df["Sales"].sum(), 2),
        "Total Profit"      : round(df["Profit"].sum(), 2),
        "Profit Margin %"   : round(df["Profit"].sum() / df["Sales"].sum() * 100, 2),
        "Avg Order Value"   : round(df.groupby("Order ID")["Sales"].sum().mean(), 2),
        "Total Units Sold"  : int(df["Quantity"].sum()),
        "Loss Orders"       : int((df["Profit"] < 0).sum()),
        "Avg Shipping Days" : round(df["Shipping Days"].mean(), 1),
    }


def print_kpis(df: pd.DataFrame) -> None:
    """Pretty-print all KPIs to the console."""
    kpis = get_kpis(df)
    print("=" * 50)
    print("  SALES PERFORMANCE KPIs")
    print("=" * 50)
    for key, value in kpis.items():
        if "Revenue" in key or "Profit" in key or "Value" in key:
            print(f"  {key:<25} : ${value:,.2f}")
        elif "%" in key:
            print(f"  {key:<25} : {value:.2f}%")
        else:
            print(f"  {key:<25} : {value:,}")
    print("=" * 50)


# ── Sales Breakdown Functions ─────────────────────────────────────────────────

def sales_by_category(df: pd.DataFrame) -> pd.DataFrame:
    """Return sales and profit aggregated by Category."""
    return (
        df.groupby("Category")
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Total_Orders  = ("Order ID", "nunique"),
            Total_Units   = ("Quantity", "sum"),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .sort_values("Total_Sales", ascending=False)
        .round(2)
    )


def sales_by_sub_category(df: pd.DataFrame) -> pd.DataFrame:
    """Return sales and profit aggregated by Sub-Category."""
    return (
        df.groupby(["Category", "Sub-Category"])
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Total_Orders  = ("Order ID", "nunique"),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .sort_values("Total_Sales", ascending=False)
        .round(2)
    )


def sales_by_region(df: pd.DataFrame) -> pd.DataFrame:
    """Return sales and profit aggregated by Region."""
    return (
        df.groupby("Region")
        .agg(
            Total_Sales     = ("Sales",       "sum"),
            Total_Profit    = ("Profit",      "sum"),
            Total_Orders    = ("Order ID",    "nunique"),
            Total_Customers = ("Customer ID", "nunique"),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .sort_values("Total_Sales", ascending=False)
        .round(2)
    )


def sales_by_state(df: pd.DataFrame, top_n: int = 15) -> pd.DataFrame:
    """Return top N states by total sales."""
    return (
        df.groupby(["State", "Region"])
        .agg(
            Total_Sales  = ("Sales",    "sum"),
            Total_Profit = ("Profit",   "sum"),
            Total_Orders = ("Order ID", "nunique"),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .sort_values("Total_Sales", ascending=False)
        .head(top_n)
        .round(2)
    )


def sales_by_segment(df: pd.DataFrame) -> pd.DataFrame:
    """Return sales breakdown by customer Segment."""
    return (
        df.groupby("Segment")
        .agg(
            Total_Sales     = ("Sales",       "sum"),
            Total_Profit    = ("Profit",      "sum"),
            Total_Customers = ("Customer ID", "nunique"),
            Total_Orders    = ("Order ID",    "nunique"),
            Avg_Order_Value = ("Sales",       "mean"),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .sort_values("Total_Sales", ascending=False)
        .round(2)
    )


# ── Product Analysis ──────────────────────────────────────────────────────────

def top_products_by_sales(df: pd.DataFrame, n: int = 10) -> pd.DataFrame:
    """Return top N products by total revenue."""
    return (
        df.groupby("Product Name")
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Total_Units   = ("Quantity", "sum"),
            Order_Count   = ("Order ID", "nunique"),
        )
        .sort_values("Total_Sales", ascending=False)
        .head(n)
        .round(2)
    )


def top_products_by_profit(df: pd.DataFrame, n: int = 10) -> pd.DataFrame:
    """Return top N products by net profit."""
    return (
        df.groupby("Product Name")
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Total_Units   = ("Quantity", "sum"),
        )
        .sort_values("Total_Profit", ascending=False)
        .head(n)
        .round(2)
    )


def worst_products_by_profit(df: pd.DataFrame, n: int = 10) -> pd.DataFrame:
    """Return top N loss-making products."""
    return (
        df.groupby("Product Name")
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Avg_Discount  = ("Discount", "mean"),
        )
        .sort_values("Total_Profit", ascending=True)
        .head(n)
        .round(2)
    )


# ── Discount Analysis ─────────────────────────────────────────────────────────

def discount_impact_analysis(df: pd.DataFrame) -> pd.DataFrame:
    """
    Analyse how discount bands correlate with profit margin.

    Returns
    -------
    pd.DataFrame
        Discount band summary with avg sales, avg profit, and margin %.
    """
    bins   = [-0.01, 0.0, 0.10, 0.20, 0.30, 0.40, 1.0]
    labels = ["0% (No Discount)", "1-10%", "11-20%", "21-30%", "31-40%", "40%+"]

    df = df.copy()
    df["Discount Band"] = pd.cut(df["Discount"], bins=bins, labels=labels)

    return (
        df.groupby("Discount Band", observed=True)
        .agg(
            Transactions    = ("Sales",    "count"),
            Avg_Sales       = ("Sales",    "mean"),
            Avg_Profit      = ("Profit",   "mean"),
            Total_Sales     = ("Sales",    "sum"),
            Total_Profit    = ("Profit",   "sum"),
            Loss_Count      = ("Profit",   lambda x: (x < 0).sum()),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .round(2)
    )


# ── Shipping Analysis ─────────────────────────────────────────────────────────

def shipping_analysis(df: pd.DataFrame) -> pd.DataFrame:
    """
    Analyse shipping performance by ship mode.

    Returns
    -------
    pd.DataFrame
        Ship mode summary with avg, min, max shipping days.
    """
    return (
        df.groupby("Ship Mode")
        .agg(
            Total_Orders    = ("Order ID",      "nunique"),
            Avg_Ship_Days   = ("Shipping Days", "mean"),
            Min_Ship_Days   = ("Shipping Days", "min"),
            Max_Ship_Days   = ("Shipping Days", "max"),
            Total_Sales     = ("Sales",          "sum"),
        )
        .sort_values("Avg_Ship_Days")
        .round(2)
    )


# ── Main (Demo) ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    df = load_data()
    print(f"\nDataset loaded: {df.shape[0]:,} rows × {df.shape[1]} columns\n")
    print_kpis(df)

    print("\n── Sales by Category ──")
    print(sales_by_category(df).to_string())

    print("\n── Sales by Region ──")
    print(sales_by_region(df).to_string())

    print("\n── Top 5 Products by Revenue ──")
    print(top_products_by_sales(df, n=5).to_string())

    print("\n── Discount Impact ──")
    print(discount_impact_analysis(df).to_string())

    print("\n── Shipping Analysis ──")
    print(shipping_analysis(df).to_string())
