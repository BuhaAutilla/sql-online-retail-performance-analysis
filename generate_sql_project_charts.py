from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd


BASE_DIR = Path(r"C:\Users\buhaa\Documents\sql-online-retail-performance-analysis")
CSV_PATH = BASE_DIR / "data" / "raw" / "online_retail.csv"
IMAGES_DIR = BASE_DIR / "images"


def load_data(csv_path: Path) -> pd.DataFrame:
    df = pd.read_csv(csv_path, encoding="utf-8-sig")
    df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"], errors="coerce")
    return df


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    cleaned = df.copy()

    cleaned["Description"] = cleaned["Description"].astype("string").str.strip()
    cleaned["InvoiceNo"] = cleaned["InvoiceNo"].astype("string").str.strip()
    cleaned["StockCode"] = cleaned["StockCode"].astype("string").str.strip()
    cleaned["Country"] = cleaned["Country"].astype("string").str.strip()

    cleaned = cleaned[
        (cleaned["Quantity"] > 0)
        & (cleaned["UnitPrice"] > 0)
        & (~cleaned["InvoiceNo"].str.startswith("C", na=False))
        & (cleaned["Description"].notna())
        & (cleaned["Description"] != "")
    ].copy()

    cleaned["line_revenue"] = cleaned["Quantity"] * cleaned["UnitPrice"]
    return cleaned


def save_kpi_summary_chart(df: pd.DataFrame, output_dir: Path) -> None:
    total_revenue = df["line_revenue"].sum()
    total_orders = df["InvoiceNo"].nunique()

    known_customers = df[df["CustomerID"].notna()].copy()
    total_customers = known_customers["CustomerID"].nunique()

    order_totals = df.groupby("InvoiceNo", as_index=False)["line_revenue"].sum()
    average_order_value = order_totals["line_revenue"].mean()

    customer_totals = known_customers.groupby("CustomerID", as_index=False)["line_revenue"].sum()
    average_revenue_per_customer = customer_totals["line_revenue"].mean()

    customer_orders = known_customers.groupby("CustomerID", as_index=False)["InvoiceNo"].nunique()
    average_orders_per_customer = customer_orders["InvoiceNo"].mean()

    unique_products = df["StockCode"].nunique()
    unique_countries = df["Country"].nunique()

    kpis = [
        ("Total Revenue", f"{total_revenue:,.2f}"),
        ("Total Orders", f"{total_orders:,}"),
        ("Average Order Value", f"{average_order_value:,.2f}"),
        ("Total Customers", f"{total_customers:,}"),
        ("Avg Revenue per Customer", f"{average_revenue_per_customer:,.2f}"),
        ("Avg Orders per Customer", f"{average_orders_per_customer:,.2f}"),
        ("Unique Products", f"{unique_products:,}"),
        ("Unique Countries", f"{unique_countries:,}"),
    ]

    fig, ax = plt.subplots(figsize=(10, 6))
    ax.axis("off")

    table = ax.table(
        cellText=[[label, value] for label, value in kpis],
        colLabels=["KPI", "Value"],
        loc="center",
        cellLoc="left",
    )

    table.auto_set_font_size(False)
    table.set_fontsize(11)
    table.scale(1, 1.8)

    plt.title("KPI Summary", pad=20)
    plt.tight_layout()
    fig.savefig(output_dir / "kpi_summary.png", dpi=200, bbox_inches="tight")
    plt.close(fig)


def save_monthly_revenue_chart(df: pd.DataFrame, output_dir: Path) -> None:
    monthly = (
        df.assign(revenue_month=df["InvoiceDate"].dt.to_period("M").dt.to_timestamp())
        .groupby("revenue_month", as_index=False)["line_revenue"]
        .sum()
        .sort_values("revenue_month")
    )

    fig = plt.figure(figsize=(10, 5))
    plt.bar(monthly["revenue_month"].dt.strftime("%Y-%m"), monthly["line_revenue"])
    plt.title("Monthly Revenue")
    plt.xlabel("Month")
    plt.ylabel("Revenue")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    fig.savefig(output_dir / "monthly_revenue.png", dpi=200)
    plt.close(fig)


def save_top_products_chart(df: pd.DataFrame, output_dir: Path) -> None:
    top_products = (
        df.groupby(["StockCode", "Description"], as_index=False)["InvoiceNo"]
        .nunique()
        .rename(columns={"InvoiceNo": "order_count"})
        .sort_values("order_count", ascending=False)
        .head(5)
        .sort_values("order_count")
    )

    fig = plt.figure(figsize=(10, 6))
    plt.barh(top_products["Description"], top_products["order_count"])
    plt.title("Top 5 Products by Order Count")
    plt.xlabel("Order Count")
    plt.ylabel("Product")
    plt.tight_layout()
    fig.savefig(output_dir / "top_products_by_orders.png", dpi=200)
    plt.close(fig)


def save_top_countries_chart(df: pd.DataFrame, output_dir: Path) -> None:
    top_countries = (
        df.groupby("Country", as_index=False)["line_revenue"]
        .sum()
        .sort_values("line_revenue", ascending=False)
        .head(5)
    )

    fig = plt.figure(figsize=(9, 5))
    plt.bar(top_countries["Country"], top_countries["line_revenue"])
    plt.title("Top 5 Countries by Revenue")
    plt.xlabel("Country")
    plt.ylabel("Revenue")
    plt.xticks(rotation=20, ha="right")
    plt.tight_layout()
    fig.savefig(output_dir / "top_countries_by_revenue.png", dpi=200)
    plt.close(fig)


def save_repeat_vs_one_time_chart(df: pd.DataFrame, output_dir: Path) -> None:
    known_customers = df[df["CustomerID"].notna()].copy()

    customer_orders = (
        known_customers.groupby("CustomerID", as_index=False)["InvoiceNo"]
        .nunique()
        .rename(columns={"InvoiceNo": "order_count"})
    )

    customer_revenue = (
        known_customers.groupby("CustomerID", as_index=False)["line_revenue"]
        .sum()
        .rename(columns={"line_revenue": "total_revenue"})
    )

    customer_summary = customer_orders.merge(customer_revenue, on="CustomerID", how="inner")
    customer_summary["customer_type"] = customer_summary["order_count"].apply(
        lambda x: "One-time customers" if x == 1 else "Repeat customers"
    )

    revenue_split = (
        customer_summary.groupby("customer_type", as_index=False)["total_revenue"]
        .sum()
        .set_index("customer_type")
        .reindex(["Repeat customers", "One-time customers"])
        .reset_index()
    )

    fig = plt.figure(figsize=(8, 5))
    plt.bar(revenue_split["customer_type"], revenue_split["total_revenue"])
    plt.title("Revenue: Repeat vs One-time Customers")
    plt.xlabel("Customer Type")
    plt.ylabel("Revenue")
    plt.tight_layout()
    fig.savefig(output_dir / "repeat_vs_one_time_revenue.png", dpi=200)
    plt.close(fig)


def main() -> None:
    IMAGES_DIR.mkdir(parents=True, exist_ok=True)

    df = load_data(CSV_PATH)
    cleaned = clean_data(df)

    save_kpi_summary_chart(cleaned, IMAGES_DIR)
    save_monthly_revenue_chart(cleaned, IMAGES_DIR)
    save_top_products_chart(cleaned, IMAGES_DIR)
    save_top_countries_chart(cleaned, IMAGES_DIR)
    save_repeat_vs_one_time_chart(cleaned, IMAGES_DIR)

    print("Charts saved to:", IMAGES_DIR)
    print("- kpi_summary.png")
    print("- monthly_revenue.png")
    print("- top_products_by_orders.png")
    print("- top_countries_by_revenue.png")
    print("- repeat_vs_one_time_revenue.png")


if __name__ == "__main__":
    main()