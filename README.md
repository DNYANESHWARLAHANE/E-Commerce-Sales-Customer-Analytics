# 🛒 E-Commerce Sales & Customer Analytics

> End-to-end Data Analytics portfolio project using Python, SQL, RFM Customer Segmentation, and Power BI.

**Author:** Dnyaneshwar G. Lahane  
**Focus:** Data Analytics  
**Tools:** Python • Pandas • NumPy • MySQL • SQL • Power BI • Git • GitHub

---

## 📌 Project Overview

This project analyzes e-commerce transaction data to understand sales performance, customer behavior, product performance, customer risk, geographic patterns, and time-based sales activity.

The project follows an end-to-end analytics workflow:

**Raw Data → Data Cleaning → Python Analysis → SQL Analysis → RFM Segmentation → Power BI Dashboard → Business Insights → Recommendations**

The objective is to transform transaction-level data into structured, business-ready insights that can support customer management, product decisions, sales monitoring, and operational planning.

---

## 🎯 Project Objectives

The project was designed to answer practical business questions such as:

- How many orders and units were sold?
- What is the total revenue generated?
- Which products generate the most revenue?
- Which products have the highest sales volume?
- Which customers generate the most value?
- How many customers are repeat customers?
- How does revenue contribution vary across customer segments?
- How much revenue is associated with at-risk customers?
- Which countries generate the most sales?
- At what hours is sales activity highest?
- How does sales performance change over time?
- How can customer and sales data support business decisions?

---

## 📊 Key Project Metrics

| Metric | Value |
|---|---:|
| Transaction Rows | 993,401 |
| Total Revenue | £19,433,661.76 |
| Total Orders | 39,492 |
| Units Sold | 11,097,626 |
| Identified Customers | 5,851 |
| Average Order Value | £492.09 |
| Countries Represented | 43 |
| Final Dataset Columns | 10 |

---

## 🗂️ Dataset

### Source

The project uses the **UCI Online Retail II dataset**.

Original workbook:

`data/online_retail_II.xlsx`

The workbook contains two source sheets:

- `Year 2009-2010`
- `Year 2010-2011`

### Authoritative Final Dataset

The cleaned transaction dataset used throughout the project is:

`data/cleaned_sales.csv`

Final transaction layer:

- **993,401 rows**
- **39,492 orders**
- **11,097,626 units**
- **5,851 identified customers**
- **£19.43M revenue**

---

## 🧹 Data Cleaning & Preparation

The data preparation process included:

- Inspecting the original workbook and source sheets
- Standardizing column names
- Standardizing data types
- Handling missing values
- Validating transaction records
- Calculating revenue using:

```text
Revenue = Quantity × Price