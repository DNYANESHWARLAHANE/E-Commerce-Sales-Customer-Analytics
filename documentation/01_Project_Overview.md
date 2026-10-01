# E-Commerce Sales & Customer Analytics

## 1. Project Overview

The **E-Commerce Sales & Customer Analytics** project is an end-to-end data analytics project focused on analyzing e-commerce transaction data to understand sales performance, customer behavior, product performance, revenue patterns, and customer value.

The project follows a complete analytics workflow starting from raw transactional data and progressing through data quality inspection, data cleaning, Python-based analysis, SQL business analysis, RFM customer segmentation, and interactive Power BI dashboard development.

The objective is to transform large-scale transactional data into structured business insights that can support sales analysis, customer analysis, product performance analysis, and business decision-making.

---

## 2. Project Objective

The main objective of the project is to analyze e-commerce transaction data and answer important business questions related to:

- Overall sales performance
- Revenue and order trends
- Product performance
- Customer purchasing behavior
- Repeat purchasing behavior
- Customer revenue contribution
- Customer value
- Customer segmentation
- Customer risk
- Geographic sales performance
- Time-based sales patterns

The project also demonstrates how different analytics tools can be combined into a single end-to-end workflow.

---

## 3. Business Context

E-commerce businesses generate large volumes of transactional data containing information about orders, products, customers, dates, prices, quantities, and locations.

However, raw transactional data does not directly provide business insights.

The data needs to be:

1. Inspected for quality issues
2. Cleaned and prepared
3. Analyzed at transaction level
4. Aggregated at customer level
5. Segmented using analytical techniques
6. Visualized through dashboards
7. Interpreted into business insights

This project follows that complete process.

---

## 4. Dataset

The project uses the **Online Retail II** dataset.

The original dataset contains two yearly sheets:

- Year 2009-2010
- Year 2010-2011

The final authoritative transaction dataset used throughout the project is:

`data/cleaned_sales.csv`

The final cleaned transaction dataset contains:

- 993,401 transaction rows
- 39,492 unique invoices/orders
- 11,097,626 units
- 5,851 identified customers
- Approximately £19.43 million in revenue

The transaction date range is:

**1 December 2009 → 9 December 2011**

---

## 5. Technology Stack

The project uses multiple tools for different stages of the analytics workflow.

### Python

Python was used for:

- Data quality inspection
- Data cleaning
- Data preprocessing
- Exploratory data analysis
- Sales analysis
- Product analysis
- Customer analysis
- RFM analysis
- Customer segmentation

Main libraries include:

- Pandas
- NumPy
- Matplotlib
- Jupyter Notebook

---

### SQL / MySQL

MySQL was used for:

- Data loading
- Data validation
- Sales analysis
- Monthly analysis
- Product analysis
- Customer analysis
- Revenue concentration analysis
- Repeat customer analysis
- Customer value analysis
- RFM segmentation
- High-value at-risk customer analysis

Database:

`ecommerce_analytics`

---

### Power BI

Power BI was used to create the final interactive dashboard.

The dashboard provides analysis of:

- Overall business performance
- Customer segmentation
- Customer risk
- Revenue
- Product performance
- Geographic performance
- Time-based sales patterns

---

### Excel

Excel can also be used as a supporting business-analysis and validation tool for spreadsheet-based calculations and data inspection.

---

## 6. Project Workflow

The complete project workflow is:

```text
Online Retail II Dataset
        ↓
Data Quality Inspection
        ↓
Data Cleaning & Preparation
        ↓
Final Cleaned Transaction Dataset
        ↓
Python Sales & Product Analysis
        ↓
Python Customer Analysis
        ↓
RFM Analysis & Customer Segmentation
        ↓
SQL Business Analysis
        ↓
Power BI Data Model
        ↓
Interactive Power BI Dashboard
        ↓
Business Insights
        ↓
Business Recommendations
        ↓
Final Project Validation