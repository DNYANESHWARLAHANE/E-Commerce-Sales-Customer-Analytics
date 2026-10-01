# Data Cleaning and Preparation

## 1. Purpose

The data cleaning and preparation stage converts the original Online Retail II transaction data into a structured dataset suitable for Python analysis, SQL analysis, customer-level analysis, product analysis, and Power BI reporting.

The preparation process focused on:

- Understanding the original dataset structure
- Validating data quality
- Standardizing field names and data types
- Handling transaction-level data quality issues
- Creating a consistent revenue field
- Preserving customer identification information
- Separating transaction-level and customer-level analysis
- Preparing merchandise data for product-level analysis
- Creating a reliable analytical dataset for SQL and Power BI

---

## 2. Source Data

The original source file is:

`data/online_retail_II.xlsx`

The workbook contains two sheets:

- `Year 2009-2010`
- `Year 2010-2011`

The two source sheets represent different periods of the same e-commerce transaction dataset.

The source data contains transaction-level information including:

- Invoice
- Stock Code
- Description
- Quantity
- Invoice Date
- Price
- Customer ID
- Country

The two sheets were combined and standardized during the data preparation process.

---

## 3. Data Quality Inspection

The initial inspection was performed to understand the structure and quality of the transaction data before analytical processing.

The inspection included:

- Dataset dimensions
- Column names
- Data types
- Missing values
- Duplicate records
- Invoice values
- Product identifiers
- Product descriptions
- Transaction quantities
- Product prices
- Customer identifiers
- Transaction dates
- Country values
- Cancellation indicators
- Revenue values

The purpose of this stage was to identify potential data-quality issues and determine which records required special analytical treatment.

---

## 4. Transaction Structure Standardization

The transaction data was standardized into a consistent analytical structure.

The final transaction fields are:

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