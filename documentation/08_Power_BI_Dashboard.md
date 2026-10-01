# Power BI Dashboard

## 1. Overview

The Power BI dashboard was developed as the final interactive visualization layer of the E-Commerce Sales & Customer Analytics project.

The dashboard connects the cleaned transaction data with customer-level RFM analysis to provide an interactive business view of:

- Overall sales performance
- Customer segmentation
- Customer risk and revenue exposure
- Product performance
- Geographic performance
- Time-based sales activity

The dashboard is designed to transform the analytical results from Python and SQL into an interactive business intelligence report.

---

## 2. Power BI Report

Report file:

`powerbi/E-Commerce-Sales-Customer-Analytics.pbix`

The report contains five analytical pages:

1. Executive Overview
2. Customer RFM Analysis
3. Customer Risk & Revenue
4. Product & Sales Performance
5. Geographic & Time Analysis

---

# 3. Data Model

The Power BI model uses the cleaned transaction data together with customer-level analytical tables.

### Main tables

- `cleaned_sales`
- `customer_rfm`
- `Date`
- RFM customer dashboard table

### Main analytical relationship

The transaction layer provides the sales-level information, while the customer-level tables provide RFM and segmentation information.

The Date table is used for time-based analysis and filtering.

The customer-level RFM data is connected using `customer_id`.

This structure allows the dashboard to analyze both transaction-level and customer-level information.

---

# 4. Key Measures

The dashboard includes measures for the major business KPIs.

### Total Revenue

Measures the total revenue generated from the transaction dataset.

### Total Orders

Measures the number of unique invoices/orders.

### Total Units

Measures the total quantity of units sold.

### Total Customers

Measures the number of identified customers.

### Average Order Value

Measures average revenue per order.

The project also uses revenue-per-customer measures where appropriate.

Because the dataset contains transactions without customer IDs, customer-based metrics are interpreted carefully and identified-customer measures are explicitly distinguished from total transaction-level revenue.

---

# 5. Page 1 — Executive Overview

## Purpose

The Executive Overview provides a high-level summary of the overall business performance.

It is designed to allow a user to understand the main sales KPIs quickly before moving into detailed customer, product, geographic, and time analysis.

## Main KPIs

The page displays:

- Total Revenue
- Total Orders
- Total Units
- Identified Customers
- Average Order Value

Key validated values include approximately:

- Revenue: £19.43M
- Orders: 39.5K
- Units: 11.10M
- Identified Customers: 5.851K
- Average Order Value: £492.09

## Main Visuals

The page includes:

- Revenue KPI
- KPI summary cards
- Monthly revenue trend
- Customer segment distribution
- Top countries
- Average Order Value
- Revenue by customer segment
- Date range slicer

## Business Purpose

This page answers questions such as:

- How much revenue was generated?
- How many orders were placed?
- How many units were sold?
- How many customers were identified?
- What is the average order value?
- How does revenue change over time?
- Which customer segments contribute to revenue?
- Which countries generate significant sales?

---

# 6. Page 2 — Customer RFM Analysis

## Purpose

The Customer RFM Analysis page focuses on customer behavior and customer segmentation.

RFM stands for:

- Recency
- Frequency
- Monetary

The RFM analysis classifies identified customers according to their purchasing behavior.

## Main KPIs

The page includes customer segment counts such as:

- Total Customers: 5,851
- Champions: 1,329
- Loyal Customers: 723
- At Risk: 288
- Needs Attention: 1,392
- Hibernating: 1,354
- Potential Loyalists: 627
- Big Spenders: 3
- Recent Customers: 135

## Main Visuals

The page includes:

- Customer segment distribution
- RFM score analysis
- Customer segment counts
- RFM-related customer analysis
- Interactive filters

## Business Purpose

This page helps answer:

- How are customers distributed across RFM segments?
- How many customers are classified as Champions?
- How many customers are At Risk?
- How many customers require attention?
- How large is the potential loyalist group?
- How are customers distributed according to their RFM characteristics?

The page provides a customer-focused view that complements the overall sales analysis.

---

# 7. Page 3 — Customer Risk & Revenue

## Purpose

The Customer Risk & Revenue page focuses on customer risk and the amount of revenue associated with customers requiring attention.

The analysis uses RFM characteristics to identify customer groups that may require different business actions.

## Main KPIs

Key indicators include:

- At-Risk Customers: 288
- Revenue at Risk: approximately £1.02M
- High-Value Customers: 3
- Customers Needing Attention: approximately 1.392K

## Main Visuals

The page includes:

- Segment revenue analysis
- Customer value versus RFM analysis
- Customer risk-related visualizations
- Interactive filters

## Business Purpose

This page helps answer:

- How many customers are classified as At Risk?
- How much revenue is associated with the At Risk segment?
- Which customer groups require attention?
- How does customer value relate to RFM characteristics?
- Where is customer revenue exposure concentrated?

The analysis provides a structured way to identify customer groups for further business investigation.

---

# 8. Page 4 — Product & Sales Performance

## Purpose

The Product & Sales Performance page analyzes product-level and sales-level performance.

It focuses on identifying products generating significant revenue and products with high unit sales.

## Main KPIs

The page includes:

- Total Revenue
- Total Orders
- Total Units
- Unique Products
- Average Order Value

## Main Visuals

The page includes:

- Monthly Revenue Trend
- Top 10 Products by Revenue
- Top 10 Products by Units Sold
- Revenue by Country
- Sales by Day of Week

## Product Analysis

Product performance is evaluated using:

- Revenue
- Units Sold
- Number of Orders

The product-focused analysis excludes administrative/non-merchandise records where appropriate.

`DOTCOM` records are treated separately from merchandise-focused product analysis.

## Business Purpose

This page helps answer:

- Which products generate the highest revenue?
- Which products have the highest unit sales?
- How does sales performance change over time?
- Which countries generate sales?
- On which days does sales activity occur most frequently?

---

# 9. Page 5 — Geographic & Time Analysis

## Purpose

The Geographic & Time Analysis page examines sales distribution across countries and transaction timing.

The page combines geographic and temporal analysis to provide additional context about sales activity.

## Geographic Analysis

The dashboard analyzes revenue across countries.

The validated dataset contains:

- 43 countries

The analysis includes:

- Revenue by Country
- Revenue Share by Country
- Country-level sales comparison

The United Kingdom represents the largest country-level transaction volume in the dataset.

## Time Analysis

The page includes:

- Monthly Revenue by Year
- Sales by Hour
- Time-based KPI analysis

The monthly analysis allows revenue patterns to be compared across the available years.

The hourly analysis shows the distribution of sales activity throughout the day.

## Business Purpose

This page helps answer:

- Which countries generate sales?
- How is revenue distributed geographically?
- How does monthly revenue change across years?
- At what hours is sales activity highest?
- Are there visible time-based patterns in transaction activity?

---

# 10. Dashboard Interactivity

The Power BI report uses interactive features to allow users to explore the data.

These include:

- Slicers
- Cross-filtering
- Visual interactions
- Date filtering
- Customer segment filtering
- Geographic filtering

Users can select a category or segment and observe how the other visuals respond.

This allows the dashboard to be used for exploratory business analysis rather than only static reporting.

---

# 11. Dashboard Design Approach

The dashboard follows a business-oriented analytical flow:

```text
Overall Sales
      ↓
Customer Analysis
      ↓
Customer Risk
      ↓
Product Performance
      ↓
Geographic & Time Analysis