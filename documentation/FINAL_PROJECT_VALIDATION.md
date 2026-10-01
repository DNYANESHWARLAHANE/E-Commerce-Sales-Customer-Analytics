# Final Project Validation

## 1. Project Overview

**Project Name:** E-Commerce Sales & Customer Analytics

**Purpose:**  
Validate consistency between the Python notebooks, SQL analysis,
and Power BI dashboard using the final authoritative transaction dataset.

---

## 2. Authoritative Transaction Dataset

**Source:**

`data/cleaned_sales.csv`

**Final transaction rows:**  
993,401

**Total Revenue:**  
£19,433,661.76

**Total Orders:**  
39,492

**Total Units Sold:**  
11,097,626

**Identified Customers:**  
5,851

**Average Order Value:**  
£492.09

---

## 3. Python Validation

### Sales & Product Analytics

**Notebook:**

`notebooks/03_Sales_Product_Analytics.ipynb`

**Transaction rows:**  
993,401

**Transaction revenue:**  
£19,433,661.76

**Orders:**  
39,492

**Units:**  
11,097,626

**Identified customers:**  
5,851

**Final transaction dataset unchanged:**  
True

---

### Customer Analytics

**Notebook:**

`notebooks/04_Customer_Analytics.ipynb`

**Customer-level rows:**  
5,851

**RFM rows:**  
5,851

**Unique RFM customers:**  
5,851

**Duplicate customer IDs:**  
0

**Missing customer IDs in RFM layer:**  
0

**Segmented customers:**  
5,851

**RFM one-row-per-customer:**  
True

---

## 4. SQL Validation

**Database:**

`ecommerce_analytics`

**Primary transaction layer:**

`clean_sales`

SQL analysis includes:

- Overall sales KPIs
- Monthly revenue analysis
- Product performance
- Geographic sales analysis
- Customer revenue analysis
- Repeat customer analysis
- Revenue concentration analysis
- Customer value analysis
- RFM segmentation
- Customer segment performance
- High-value at-risk customer analysis
- Final reconciliation checks

---

## 5. Power BI Validation

**Report:**

`powerbi/E-Commerce-Sales-Customer-Analytics.pbix`

### Dashboard Pages

1. Executive Overview
2. Customer RFM Analysis
3. Customer Risk & Revenue
4. Product & Sales Performance
5. Geographic & Time Analysis

### Key Transaction KPIs

**Revenue:**  
£19.43M

**Orders:**  
39.5K

**Units:**  
11.10M

**Identified Customers:**  
5.851K

**Average Order Value:**  
£492.09

---

## 6. RFM Customer Validation

**Total RFM Customers:**  
5,851

### Customer Segments

| Customer Segment | Customers |
|---|---:|
| Champions | 1,329 |
| Loyal Customers | 723 |
| At Risk | 288 |
| Needs Attention | 1,392 |
| Hibernating | 1,354 |
| Potential Loyalists | 627 |
| Big Spenders | 3 |
| Recent Customers | 135 |
| **Total** | **5,851** |

The segment counts reconcile to the total identified customer population of 5,851.

---

## 7. Cross-Layer Validation

The same authoritative transaction dataset was used as the basis for the analytical workflow.

### Transaction-Level Validation

| Metric | Value |
|---|---:|
| Transaction Rows | 993,401 |
| Revenue | £19,433,661.76 |
| Orders | 39,492 |
| Units | 11,097,626 |
| Identified Customers | 5,851 |

These values were validated across the project workflow.

### Customer-Level Validation

| Validation Check | Result |
|---|---:|
| Customer-level rows | 5,851 |
| RFM rows | 5,851 |
| Unique RFM customers | 5,851 |
| Duplicate customer IDs | 0 |
| Missing customer IDs in RFM | 0 |
| Segmented customers | 5,851 |
| One RFM row per customer | True |

### Analytical Layer Validation

The project contains the following analytical layers:

```text
Authoritative Transaction Dataset
            ↓
      Python Analysis
            ↓
       SQL Analysis
            ↓
      Customer-Level Data
            ↓
       RFM Analysis
            ↓
    Customer Segmentation
            ↓
      Power BI Dashboard