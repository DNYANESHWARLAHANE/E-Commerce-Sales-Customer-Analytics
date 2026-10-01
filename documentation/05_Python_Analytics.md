# Python Analytics

## 1. Overview

Python was used as the primary analytical layer for inspecting, cleaning,
transforming, validating, and analyzing the e-commerce transaction data.

The Python analysis was performed using Jupyter Notebooks, primarily with
Pandas and NumPy. The workflow was designed to make the data preparation
and analytical process reproducible and structured.

The Python workflow was divided into four notebooks:

1. `01_Data_Quality_Inspection.ipynb`
2. `02_Data_Cleaning_Preparation.ipynb`
3. `03_Sales_Product_Analytics_new.ipynb`
4. `04_Customer_Analytics_new.ipynb`

The notebooks follow a sequential workflow from raw-data inspection to
transaction-level analysis and customer-level RFM analysis.

---

## 2. Python Analytics Workflow

The Python workflow can be summarized as:

```text
Raw Online Retail II Dataset
        ↓
Data Quality Inspection
        ↓
Data Cleaning & Preparation
        ↓
Cleaned Transaction Dataset
        ↓
Sales & Product Analytics
        ↓
Customer Analytics
        ↓
RFM Analysis
        ↓
Customer Segmentation
        ↓
Validation