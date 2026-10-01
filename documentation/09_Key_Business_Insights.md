# Key Business Insights

## 1. Overview

This document summarizes the major business insights identified from the E-Commerce Sales & Customer Analytics project.

The insights are derived from the cleaned transaction dataset and the analytical work performed using:

- Python
- SQL
- RFM analysis
- Power BI

The analysis covers:

- Overall sales performance
- Customer behavior
- Customer segmentation
- Customer risk
- Revenue concentration
- Product performance
- Geographic performance
- Time-based sales activity

---

# 2. Overall Sales Performance

The final transaction dataset contains:

| Metric | Value |
|---|---:|
| Total Revenue | £19,433,661.76 |
| Total Orders | 39,492 |
| Total Units Sold | 11,097,626 |
| Identified Customers | 5,851 |
| Average Order Value | £492.09 |

The dataset therefore represents a large volume of transaction activity across multiple countries and products.

The overall KPIs provide the baseline for the customer, product, geographic, and time analyses.

---

# 3. Customer Base

The analysis identified:

**5,851 customers**

with valid customer IDs.

However, not every transaction contains a customer ID.

Therefore, customer-level analysis is performed using the identified-customer population, while transaction-level sales analysis retains the complete transaction layer.

This distinction is important when interpreting customer revenue and customer behavior metrics.

---

# 4. Repeat Customer Behavior

The customer analysis identified:

- Repeat Customers: 4,233
- One-Time Customers: 1,618

Repeat customers therefore represent a substantial portion of the identified customer base.

The SQL analysis also shows that repeat customers contribute significantly more revenue than one-time customers.

This indicates that repeat purchasing is an important component of the overall customer revenue structure.

---

# 5. Customer Revenue Concentration

Customer revenue is concentrated among a relatively small group of customers.

The SQL analysis identified the following revenue concentration:

| Customer Group | Approximate Revenue Share |
|---|---:|
| Top 1 Customer | 31.94% |
| Top 5 Customers | 51.94% |
| Top 10 Customers | 63.87% |
| Top 20 Customers | 77.15% |
| Remaining Customers | 22.84% |

This shows that a relatively small number of customers account for a large share of identified-customer revenue.

This concentration is important when evaluating customer value and customer risk.

---

# 6. Customer Value Distribution

The customer value analysis grouped customers into value categories.

The analysis identified the following characteristics:

| Customer Value | Avg. Orders | Avg. Units | Avg. Revenue | Avg. AOV |
|---|---:|---:|---:|---:|
| VIP | 39.78 | ~21,028 | £33,480 | £1,516.57 |
| High | 16.64 | ~4,183 | £7,009.69 | £572.53 |
| Medium | 6.87 | ~1,365 | £2,247.86 | £427.01 |
| Low | 2.02 | ~258 | £420.30 | £234.48 |

The value analysis demonstrates clear differences in purchasing behavior between customer groups.

Higher-value customers have higher order frequency, unit volume, revenue contribution, and average order value.

---

# 7. RFM Customer Segmentation

The RFM analysis classified identified customers according to:

- Recency
- Frequency
- Monetary value

The major customer segments identified in the project include:

- Champions
- Loyal Customers
- At Risk
- Needs Attention
- Hibernating
- Potential Loyalists
- Big Spenders
- Recent Customers

The RFM framework provides a structured way to understand differences in customer purchasing behavior.

---

# 8. Champions Segment

The Champions segment contains:

**1,329 customers**

The SQL analysis shows that Champions contribute approximately:

**68.69% of customer revenue**

with approximately:

**£11.60M**

in revenue.

This makes the Champions segment a major contributor to identified-customer revenue.

The segment should therefore be considered important when analyzing customer value and revenue concentration.

---

# 9. Loyal Customers

The Loyal Customers segment contains:

**723 customers**

and contributes approximately:

**10.77% of customer revenue**

with approximately:

**£1.82M**

in revenue.

This segment represents customers with established purchasing behavior and meaningful revenue contribution.

---

# 10. Customers Needing Attention

The Needs Attention segment contains approximately:

**1,392 customers**

and contributes approximately:

**8.39% of customer revenue**

with approximately:

**£1.42M**

in revenue.

This segment represents a sizeable customer population and therefore provides an important area for customer engagement analysis.

---

# 11. At-Risk Customers

The At Risk segment contains:

**288 customers**

and contributes approximately:

**6.04% of customer revenue**.

The corresponding revenue exposure is approximately:

**£1.02M**

This indicates that the At Risk segment represents a measurable amount of customer revenue that can be examined through customer-risk analysis.

---

# 12. High-Value At-Risk Customers

The high-value at-risk analysis further classified At Risk customers according to customer revenue.

The analysis identified:

| Risk Value Group | Customers | Revenue |
|---|---:|---:|
| Critical | 4 | £247,745.21 |
| High | 9 | £150,670.13 |
| Medium | 217 | £579,698.49 |
| Low | 58 | £42,695.40 |

Total:

- Customers: 288
- Revenue: approximately £1.02M

The Critical and High groups together represent:

**13 customers**

with approximately:

**£398,415.34**

in revenue.

This highlights the importance of considering both customer count and customer value when examining customer risk.

---

# 13. Product Performance

The product analysis examined:

- Revenue
- Units sold
- Orders

The top products by revenue and units sold were analyzed separately.

The highest-revenue product identified in the Python analysis was:

**REGENCY CAKESTAND 3 TIER**

with approximately:

**£330,590.32**

in revenue.

The SQL product analysis also identified high-volume products based on units sold.

This demonstrates that product performance can differ depending on whether the metric is revenue or unit volume.

---

# 14. Product Revenue vs. Unit Volume

Products can have different rankings depending on the business metric being analyzed.

A product may:

- Sell many units but generate comparatively lower revenue
- Generate high revenue with fewer units
- Have both high unit volume and high revenue

Therefore, the project evaluates both:

- Revenue-based product performance
- Unit-based product performance

This provides a more complete view of product contribution.

---

# 15. Geographic Performance

The geographic analysis identified:

**43 countries**

in the transaction dataset.

The United Kingdom represents the largest transaction volume in the country-level analysis.

Other countries also contribute to the overall revenue distribution.

Country-level analysis helps identify the geographic distribution of sales activity and provides context for international customer and transaction patterns.

---

# 16. Time-Based Sales Activity

The project analyzes sales across:

- Months
- Years
- Days of the week
- Hours of the day

Monthly revenue analysis provides a view of how sales changed throughout the available transaction period.

Hourly analysis provides information about when transaction activity occurs during the day.

Day-of-week analysis provides additional context about sales activity across different weekdays.

---

# 17. Revenue Concentration Insight

The customer revenue concentration analysis demonstrates that customer revenue is not evenly distributed.

The top customers contribute a substantial share of identified-customer revenue.

This means that customer-level analysis is important when interpreting overall business performance.

A total revenue figure alone does not show how revenue is distributed across customers.

---

# 18. Customer Risk and Revenue Exposure

The combination of RFM segmentation and customer value analysis provides a more detailed view of customer risk.

The At Risk segment contains:

**288 customers**

and approximately:

**£1.02M**

in associated revenue.

The high-value at-risk analysis further identifies smaller groups of customers with comparatively larger individual revenue contributions.

This allows the analysis to distinguish between:

- Number of customers at risk
- Revenue associated with those customers
- Individual customer value

---

# 19. Relationship Between Customer Frequency and Revenue

The customer value analysis shows that higher-value customer groups generally have higher purchasing frequency.

For example:

- VIP customers average approximately 39.78 orders
- High-value customers average approximately 16.64 orders
- Medium-value customers average approximately 6.87 orders
- Low-value customers average approximately 2.02 orders

This demonstrates the importance of repeat purchasing behavior in customer value analysis.

---

# 20. Business Insight Summary

The major insights from the project can be summarized as follows:

### Sales

- Total revenue is approximately £19.43M.
- The dataset contains 39,492 orders.
- More than 11.09M units were sold.

### Customers

- 5,851 identified customers were analyzed.
- 4,233 customers are repeat customers.
- 1,618 customers are one-time customers.

### Revenue Concentration

- Revenue is highly concentrated among top customers.
- The top 10 customers account for approximately 63.87% of identified-customer revenue.

### RFM

- 1,329 customers are classified as Champions.
- 723 customers are Loyal Customers.
- 288 customers are At Risk.
- Approximately 1,392 customers are in the Needs Attention segment.

### Risk

- At Risk customers represent approximately £1.02M in revenue.
- 13 Critical and High-value At Risk customers account for approximately £398K.

### Products

- Product performance differs depending on whether revenue or units are analyzed.
- REGENCY CAKESTAND 3 TIER generated approximately £330.59K in revenue.

### Geography

- Sales activity spans 43 countries.
- The United Kingdom represents the largest transaction volume.

### Time

- Sales activity varies across months, weekdays, and hours.
- Time-based analysis provides additional context for understanding transaction patterns.

---

# 21. Overall Analytical Flow

The project combines the findings into the following analytical flow:

```text
Sales Performance
       ↓
Customer Behavior
       ↓
Customer Value
       ↓
RFM Segmentation
       ↓
Customer Risk
       ↓
Product Performance
       ↓
Geographic Analysis
       ↓
Time Analysis