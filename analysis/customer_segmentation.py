"""
============================================================
customer_segmentation.py
Project : Sales Data Analytics
Description : RFM-based customer segmentation analysis.
              Recency, Frequency, Monetary model to classify
              customers into actionable business segments.
Author  : Dinesh
Date    : 2024
============================================================
"""

import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime

# Import the loader from the sibling module
from sales_analysis import load_data


# ── Configuration ─────────────────────────────────────────────────────────────
SNAPSHOT_DATE = datetime(2018, 1, 1)   # Reference date for recency calculation


# ── RFM Calculation ───────────────────────────────────────────────────────────

def calculate_rfm(df: pd.DataFrame, snapshot_date: datetime = SNAPSHOT_DATE) -> pd.DataFrame:
    """
    Compute RFM (Recency, Frequency, Monetary) metrics per customer.

    Parameters
    ----------
    df            : Raw Superstore DataFrame (output of load_data())
    snapshot_date : Reference date for recency calculation

    Returns
    -------
    pd.DataFrame
        Customer-level RFM DataFrame.
    """
    rfm = (
        df.groupby(["Customer ID", "Customer Name", "Segment", "Region"])
        .agg(
            Last_Purchase  = ("Order Date", "max"),
            Frequency      = ("Order ID",   "nunique"),
            Monetary       = ("Sales",      "sum"),
        )
        .reset_index()
    )

    # Recency: days since last purchase
    rfm["Recency"] = (snapshot_date - rfm["Last_Purchase"]).dt.days
    rfm["Monetary"] = rfm["Monetary"].round(2)

    return rfm


def score_rfm(rfm: pd.DataFrame, n_quartiles: int = 4) -> pd.DataFrame:
    """
    Assign R, F, M scores (1–4) based on quartile ranking.

    Parameters
    ----------
    rfm          : Output of calculate_rfm()
    n_quartiles  : Number of scoring tiers (default 4)

    Returns
    -------
    pd.DataFrame
        RFM DataFrame with individual scores and combined RFM score.
    """
    rfm = rfm.copy()

    # Recency: lower days = better → score inversely
    rfm["R_Score"] = pd.qcut(
        rfm["Recency"], q=n_quartiles,
        labels=list(range(n_quartiles, 0, -1)),
        duplicates="drop"
    ).astype(int)

    # Frequency: higher = better
    rfm["F_Score"] = pd.qcut(
        rfm["Frequency"].rank(method="first"),
        q=n_quartiles,
        labels=list(range(1, n_quartiles + 1)),
        duplicates="drop"
    ).astype(int)

    # Monetary: higher = better
    rfm["M_Score"] = pd.qcut(
        rfm["Monetary"], q=n_quartiles,
        labels=list(range(1, n_quartiles + 1)),
        duplicates="drop"
    ).astype(int)

    # Combined RFM score string and total
    rfm["RFM_Score"]  = rfm["R_Score"].astype(str) + rfm["F_Score"].astype(str) + rfm["M_Score"].astype(str)
    rfm["RFM_Total"]  = rfm["R_Score"] + rfm["F_Score"] + rfm["M_Score"]

    return rfm


def assign_segments(rfm_scored: pd.DataFrame) -> pd.DataFrame:
    """
    Map RFM scores to human-readable customer segments.

    Segment Definitions
    -------------------
    Champions         : R=4, high F & M
    Loyal Customers   : High F, decent R & M
    Potential Loyalists: Recent but lower F
    At Risk           : Previously high value, low recency
    New Customers     : Recent, low F
    Hibernating       : Low R, low F
    Lost              : Very low R, very low F & M

    Returns
    -------
    pd.DataFrame
        RFM with 'Customer_Segment' column.
    """
    def segment(row):
        r, f, m = row["R_Score"], row["F_Score"], row["M_Score"]
        total = row["RFM_Total"]

        if r == 4 and f == 4 and m >= 3:
            return "🏆 Champions"
        elif r >= 3 and f >= 3 and m >= 3:
            return "💎 Loyal Customers"
        elif r >= 3 and f <= 2:
            return "🌱 Potential Loyalists"
        elif r >= 3 and f == 1 and m == 1:
            return "🆕 New Customers"
        elif r == 2 and total >= 7:
            return "⚠️  At Risk"
        elif r == 2 and total < 7:
            return "😴 Hibernating"
        else:
            return "❌ Lost"

    rfm_scored = rfm_scored.copy()
    rfm_scored["Customer_Segment"] = rfm_scored.apply(segment, axis=1)
    return rfm_scored


def rfm_segment_summary(rfm_segmented: pd.DataFrame) -> pd.DataFrame:
    """
    Summarise segment counts and monetary value.

    Returns
    -------
    pd.DataFrame
        Segment-level summary table.
    """
    return (
        rfm_segmented.groupby("Customer_Segment")
        .agg(
            Customer_Count  = ("Customer ID",   "count"),
            Avg_Recency     = ("Recency",        "mean"),
            Avg_Frequency   = ("Frequency",      "mean"),
            Avg_Monetary    = ("Monetary",        "mean"),
            Total_Monetary  = ("Monetary",        "sum"),
        )
        .sort_values("Total_Monetary", ascending=False)
        .round(2)
    )


# ── Cohort Analysis ───────────────────────────────────────────────────────────

def cohort_analysis(df: pd.DataFrame) -> pd.DataFrame:
    """
    Build a simple year-based customer cohort table.

    Returns
    -------
    pd.DataFrame
        Pivot table: cohort year × active year → customer count.
    """
    df = df.copy()

    # First purchase year = cohort year
    first_order = (
        df.groupby("Customer ID")["Order Date"]
        .min()
        .reset_index()
        .rename(columns={"Order Date": "Cohort Date"})
    )
    first_order["Cohort Year"] = first_order["Cohort Date"].dt.year

    df = df.merge(first_order[["Customer ID", "Cohort Year"]], on="Customer ID")
    df["Order Year"] = df["Order Date"].dt.year

    cohort_table = (
        df.groupby(["Cohort Year", "Order Year"])["Customer ID"]
        .nunique()
        .reset_index()
        .rename(columns={"Customer ID": "Customers"})
    )

    return cohort_table.pivot(
        index="Cohort Year",
        columns="Order Year",
        values="Customers"
    ).fillna(0).astype(int)


# ── Segment-level Behaviour ───────────────────────────────────────────────────

def segment_category_preference(df: pd.DataFrame, rfm_segmented: pd.DataFrame) -> pd.DataFrame:
    """
    Show which product categories each customer segment prefers.

    Returns
    -------
    pd.DataFrame
        Segment × Category sales pivot table.
    """
    df_seg = df.merge(
        rfm_segmented[["Customer ID", "Customer_Segment"]],
        on="Customer ID",
        how="left"
    )

    pivot = (
        df_seg.groupby(["Customer_Segment", "Category"])["Sales"]
        .sum()
        .round(2)
        .unstack("Category")
        .fillna(0)
    )

    return pivot


# ── Main (Demo) ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    df = load_data()

    print("\n[1] Computing RFM metrics ...")
    rfm = calculate_rfm(df)

    print("[2] Scoring RFM ...")
    rfm_scored = score_rfm(rfm)

    print("[3] Assigning segments ...")
    rfm_final = assign_segments(rfm_scored)

    print("\n── RFM Sample (Top 10) ──────────────────────────────────────")
    print(rfm_final[["Customer Name", "Segment", "Recency", "Frequency",
                      "Monetary", "R_Score", "F_Score", "M_Score",
                      "RFM_Total", "Customer_Segment"]].head(10).to_string(index=False))

    print("\n── Segment Summary ──────────────────────────────────────────")
    print(rfm_segment_summary(rfm_final).to_string())

    print("\n── Cohort Analysis ──────────────────────────────────────────")
    print(cohort_analysis(df).to_string())

    print("\n── Segment × Category Preference ────────────────────────────")
    print(segment_category_preference(df, rfm_final).to_string())
