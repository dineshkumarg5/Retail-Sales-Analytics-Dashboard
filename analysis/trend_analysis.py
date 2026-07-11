"""
============================================================
trend_analysis.py
Project : Sales Data Analytics
Description : Time-series trend analysis including monthly,
              quarterly, yearly trends, seasonality, and
              growth rate calculations.
Author  : Dinesh
Date    : 2024
============================================================
"""

import pandas as pd
import numpy as np
from pathlib import Path

from sales_analysis import load_data


# ── Monthly Trend ─────────────────────────────────────────────────────────────

def monthly_sales_trend(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute monthly aggregated sales, profit, and order counts.

    Returns
    -------
    pd.DataFrame
        Month-level trend with MoM growth rate.
    """
    monthly = (
        df.groupby(["Order Year", "Order Month", "Month Name"])
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Total_Orders  = ("Order ID", "nunique"),
            Total_Units   = ("Quantity", "sum"),
        )
        .reset_index()
        .sort_values(["Order Year", "Order Month"])
        .round(2)
    )

    # Month-over-month growth
    monthly["MoM_Sales_Growth_%"] = (
        monthly["Total_Sales"].pct_change() * 100
    ).round(2)

    # Profit margin per month
    monthly["Profit_Margin_%"] = (
        monthly["Total_Profit"] / monthly["Total_Sales"] * 100
    ).round(2)

    return monthly.reset_index(drop=True)


# ── Quarterly Trend ───────────────────────────────────────────────────────────

def quarterly_sales_trend(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute quarterly aggregated sales and profit.

    Returns
    -------
    pd.DataFrame
        Quarter-level trend table.
    """
    return (
        df.groupby(["Order Year", "Order Quarter"])
        .agg(
            Total_Sales   = ("Sales",    "sum"),
            Total_Profit  = ("Profit",   "sum"),
            Total_Orders  = ("Order ID", "nunique"),
        )
        .assign(Profit_Margin_Pct=lambda x: (x["Total_Profit"] / x["Total_Sales"] * 100).round(2))
        .round(2)
        .reset_index()
        .sort_values(["Order Year", "Order Quarter"])
    )


# ── Yearly Trend ──────────────────────────────────────────────────────────────

def yearly_sales_trend(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute year-over-year sales, profit, and growth rates.

    Returns
    -------
    pd.DataFrame
        Yearly trend with YoY growth and cumulative totals.
    """
    yearly = (
        df.groupby("Order Year")
        .agg(
            Total_Sales     = ("Sales",       "sum"),
            Total_Profit    = ("Profit",      "sum"),
            Total_Orders    = ("Order ID",    "nunique"),
            Total_Customers = ("Customer ID", "nunique"),
        )
        .reset_index()
        .sort_values("Order Year")
        .round(2)
    )

    # Year-over-year growth
    yearly["YoY_Sales_Growth_%"]  = (yearly["Total_Sales"].pct_change()  * 100).round(2)
    yearly["YoY_Profit_Growth_%"] = (yearly["Total_Profit"].pct_change() * 100).round(2)

    # Cumulative revenue
    yearly["Cumulative_Sales"]  = yearly["Total_Sales"].cumsum().round(2)
    yearly["Cumulative_Profit"] = yearly["Total_Profit"].cumsum().round(2)

    # Profit margin
    yearly["Profit_Margin_%"] = (yearly["Total_Profit"] / yearly["Total_Sales"] * 100).round(2)

    # Avg order value per year
    yearly["Avg_Order_Value"] = (yearly["Total_Sales"] / yearly["Total_Orders"]).round(2)

    return yearly


# ── Seasonality Analysis ──────────────────────────────────────────────────────

def seasonality_by_month(df: pd.DataFrame) -> pd.DataFrame:
    """
    Identify seasonal patterns — average sales per calendar month
    (aggregated across all years).

    Returns
    -------
    pd.DataFrame
        Monthly seasonality with index vs overall average.
    """
    monthly_avg = (
        df.groupby("Order Month")["Sales"]
        .mean()
        .reset_index()
        .rename(columns={"Sales": "Avg_Monthly_Sales"})
    )

    overall_avg = monthly_avg["Avg_Monthly_Sales"].mean()
    monthly_avg["Seasonality_Index"] = (monthly_avg["Avg_Monthly_Sales"] / overall_avg).round(3)

    month_names = {
        1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr",
        5: "May", 6: "Jun", 7: "Jul", 8: "Aug",
        9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"
    }
    monthly_avg["Month_Name"] = monthly_avg["Order Month"].map(month_names)

    return monthly_avg[["Order Month", "Month_Name", "Avg_Monthly_Sales", "Seasonality_Index"]]


def peak_seasons(df: pd.DataFrame) -> dict:
    """
    Identify peak and off-peak months.

    Returns
    -------
    dict
        Summary of peak months, off-peak months, and best quarter.
    """
    seasonality = seasonality_by_month(df)

    peak_months   = seasonality[seasonality["Seasonality_Index"] >= 1.10]["Month_Name"].tolist()
    offpeak_months = seasonality[seasonality["Seasonality_Index"] <= 0.90]["Month_Name"].tolist()

    quarter_sales = quarterly_sales_trend(df).groupby("Order Quarter")["Total_Sales"].mean()
    best_quarter  = f"Q{quarter_sales.idxmax()}"

    return {
        "Peak Months"    : peak_months,
        "Off-Peak Months": offpeak_months,
        "Best Quarter"   : best_quarter,
        "Highest Sales Month": seasonality.loc[seasonality["Avg_Monthly_Sales"].idxmax(), "Month_Name"],
        "Lowest Sales Month" : seasonality.loc[seasonality["Avg_Monthly_Sales"].idxmin(), "Month_Name"],
    }


# ── Rolling Averages ──────────────────────────────────────────────────────────

def rolling_sales_average(df: pd.DataFrame, window: int = 3) -> pd.DataFrame:
    """
    Compute rolling average of monthly sales (smoothed trend line).

    Parameters
    ----------
    window : int
        Rolling window size in months (default 3).

    Returns
    -------
    pd.DataFrame
        Monthly sales with rolling average column.
    """
    monthly = monthly_sales_trend(df)[["Order Year", "Order Month", "Month Name", "Total_Sales"]]
    monthly[f"Rolling_{window}M_Avg"] = (
        monthly["Total_Sales"]
        .rolling(window=window, min_periods=1)
        .mean()
        .round(2)
    )
    return monthly


# ── Category Trend ────────────────────────────────────────────────────────────

def category_trend_by_year(df: pd.DataFrame) -> pd.DataFrame:
    """
    Show yearly sales for each category (pivot format).

    Returns
    -------
    pd.DataFrame
        Pivot: Category rows × Year columns.
    """
    cat_yearly = (
        df.groupby(["Order Year", "Category"])["Sales"]
        .sum()
        .round(2)
        .reset_index()
    )

    pivot = cat_yearly.pivot(index="Category", columns="Order Year", values="Sales").fillna(0)
    pivot["Total"] = pivot.sum(axis=1)
    pivot = pivot.sort_values("Total", ascending=False)

    return pivot


# ── Shipping Trend ────────────────────────────────────────────────────────────

def shipping_trend_by_year(df: pd.DataFrame) -> pd.DataFrame:
    """
    Track average shipping duration trend over the years.

    Returns
    -------
    pd.DataFrame
        Yearly average shipping days per ship mode.
    """
    return (
        df.groupby(["Order Year", "Ship Mode"])["Shipping Days"]
        .agg(["mean", "min", "max", "count"])
        .rename(columns={"mean": "Avg_Days", "min": "Min_Days",
                         "max": "Max_Days", "count": "Order_Count"})
        .round(2)
        .reset_index()
    )


# ── Main (Demo) ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    df = load_data()

    print("\n── Yearly Trend ─────────────────────────────────────────────")
    print(yearly_sales_trend(df).to_string(index=False))

    print("\n── Quarterly Trend ─────────────────────────────────────────")
    print(quarterly_sales_trend(df).to_string(index=False))

    print("\n── Seasonality Index ───────────────────────────────────────")
    print(seasonality_by_month(df).to_string(index=False))

    print("\n── Peak Season Analysis ─────────────────────────────────────")
    peaks = peak_seasons(df)
    for k, v in peaks.items():
        print(f"  {k:<22} : {v}")

    print("\n── Category Trend by Year ───────────────────────────────────")
    print(category_trend_by_year(df).to_string())

    print("\n── 3-Month Rolling Average (Sample) ─────────────────────────")
    print(rolling_sales_average(df, window=3).head(12).to_string(index=False))
