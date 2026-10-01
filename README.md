# E-Commerce Sales & Customer Analytics

## 📊 Project Overview

**E-Commerce Sales & Customer Analytics** is an end-to-end data analytics project designed to analyze e-commerce transaction data and transform raw sales records into actionable business insights.

The project combines **Python, SQL, RFM Customer Segmentation, and Power BI** to analyze:

- Sales performance
- Customer behavior
- Customer value
- Customer segmentation
- Customer risk
- Product performance
- Geographic performance
- Time-based sales patterns

The final output is an interactive **5-page Power BI dashboard** supported by Python-based data preparation, MySQL analysis, RFM segmentation, and detailed project documentation.

---

## 🎯 Business Objective

The main objective of this project is to understand how an e-commerce business is performing across **sales, customers, products, geography, and time**, while identifying valuable and at-risk customer groups.

The analysis follows the business flow:

> **Sales → Customers → Products → Risk → Geography → Time**

The project answers practical business questions such as:

- How much revenue has the business generated?
- How many orders and units were sold?
- Which products generate the most revenue?
- Which products have the highest sales volume?
- Which customers contribute the most revenue?
- Which customers are loyal or at risk?
- How is revenue distributed across customer segments?
- How concentrated is revenue among customers?
- Which countries generate the most revenue?
- Which months and hours show higher sales activity?
- Which customer groups require attention?

---

# 📁 Project Structure

```text
E-Commerce-Sales-Customer-Analytics/
│
├── data/
│   ├── online_retail_II.xlsx
│   └── cleaned_sales.csv
│
├── documentation/
│   ├── FINAL_PROJECT_VALIDATION.md
│   ├── 01_Project_Overview.md
│   ├── 02_Business_Questions.md
│   ├── 03_Dataset_and_Data_Dictionary.md
│   ├── 04_Data_Cleaning_and_Preparation.md
│   ├── 05_Python_Analytics.md
│   ├── 06_SQL_Analytics.md
│   ├── 07_RFM_Methodology.md
│   ├── 08_Power_BI_Dashboard.md
│   ├── 09_Key_Business_Insights.md
│   ├── 10_Business_Recommendations.md
│   └── 11_Limitations.md
│
├── notebooks/
│   ├── 01_Data_Quality_Inspection.ipynb
│   ├── 02_Data_Cleaning_Preparation.ipynb
│   ├── 03_Sales_Product_Analytics_new.ipynb
│   ├── 04_Customer_Analytics_new.ipynb
│   └── backup/
│       ├── 03_Sales_Product_Analytics_old.ipynb
│       └── 04_Customer_Analytics_old.ipynb
│
├── powerbi/
│   └── E-Commerce-Sales-Customer-Analytics.pbix
│
├── screenshots/
│   ├── 01_Executive_Overview.png
│   ├── 02_Customer_RFM_Analysis.png
│   ├── 03_Customer_Risk_Revenue.png
│   ├── 04_Product_Sales_Performance.png
│   ├── 05_Geographic_Time_Analysis.png
│   └── ...
│
├── sql/
│   ├── 01_sales_performance.sql
│   ├── ecommerce_customer_analytics.sql
│   ├── ecommerce_customer_analytics_FINAL.sql
│   └── backup/
│
├── .gitignore
├── README.md
└── E-Commerce Analytics.session.sql