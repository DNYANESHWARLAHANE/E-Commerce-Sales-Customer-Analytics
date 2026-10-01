# Dataset and Data Dictionary

## 1. Dataset Overview

### Original Dataset

The project is based on the **Online Retail II** e-commerce transaction dataset.

The original workbook is:

`data/online_retail_II.xlsx`

The workbook contains two sheets:

- `Year 2009-2010`
- `Year 2010-2011`

The original transaction data contains information about:

- Invoices
- Products
- Quantities
- Transaction dates
- Prices
- Customers
- Countries

These fields provide the foundation for sales, product, customer, geographic, and time-based analysis.

---

## 2. Final Analytical Dataset

After the data quality inspection and preparation stages, the project uses the following authoritative transaction dataset:

`data/cleaned_sales.csv`

The final dataset contains:

| Metric | Value |
|---|---:|
| Transaction Rows | 993,401 |
| Unique Orders | 39,492 |
| Total Units Sold | 11,097,626 |
| Identified Customers | 5,851 |
| Total Revenue | £19,433,661.76 |
| Average Order Value | £492.09 |
| First Transaction | 2009-12-01 07:45:00 |
| Last Transaction | 2011-12-09 12:50:00 |

The final transaction layer preserves anonymous transactions so that overall sales KPIs remain aligned with the authoritative transaction dataset.

Customer-level analysis uses transactions with valid Customer IDs.

---

## 3. Final Dataset Columns

The final `cleaned_sales.csv` dataset contains **10 columns**:

```text
invoice
stockcode
description
quantity
invoicedate
price
customer_id
country
is_cancelled
revenue