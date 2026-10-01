# Key Business Insights

## 1. Executive Summary

The E-Commerce Sales & Customer Analytics project analyzed transaction-level retail data to understand sales performance, customer behavior, product performance, customer value, customer risk, geography, and time-based sales patterns.

The final transaction dataset contains:

- **993,401 transaction rows**
- **39,492 orders**
- **11,097,626 units sold**
- **5,851 identified customers**
- **£19.43M total revenue**
- **£492.09 average order value**

The analysis combined Python, SQL, RFM customer segmentation, and Power BI to transform raw transaction data into business-focused insights.

---

# 2. Overall Sales Performance

## Insight 1 — The business generated £19.43M in revenue

The final transaction dataset generated approximately:

**£19.43 million in total revenue**

across:

- 39,492 orders
- 11.10 million units
- 5,851 identified customers

This establishes a strong overall sales base and provides the foundation for deeper customer and product analysis.

---

## Insight 2 — Average Order Value was approximately £492.09

The overall Average Order Value (AOV) was:

**£492.09**

AOV provides an indication of the average revenue generated per order and can be used as a benchmark when evaluating customer segments, products, and future sales performance.

---

# 3. Customer Insights

## Insight 3 — Customer behavior is highly concentrated

Customer revenue analysis showed a significant concentration of revenue among the highest-value customers.

Approximate customer revenue concentration:

| Customer Group | Revenue Share |
|---|---:|
| Top 1 Customer | 31.94% |
| Top 5 Customers | 51.94% |
| Top 10 Customers | 63.87% |
| Top 20 Customers | 77.15% |
| Remaining Customers | 22.84% |

This indicates that a relatively small group of customers contributes a substantial portion of identified customer revenue.

This concentration is important when evaluating customer retention and revenue exposure.

---

## Insight 4 — Most identified customers are repeat customers

Customer purchasing behavior showed:

- **4,233 repeat customers**
- **1,618 one-time customers**

This means the identified customer base contains a substantial repeat-purchase component.

Repeat purchasing is particularly relevant for customer retention analysis because repeat customers provide multiple transactions through which customer value and purchasing behavior can be evaluated.

---

# 4. Customer Value Insights

## Insight 5 — Customer value varies substantially across value buckets

Customers were classified into value buckets using business-defined revenue thresholds.

| Customer Value | Avg Orders | Avg Units | Avg Revenue | Avg AOV |
|---|---:|---:|---:|---:|
| VIP | 39.78 | 21,028 | £33,480 | £1,516.57 |
| High | 16.64 | 4,183 | £7,009.69 | £572.53 |
| Medium | 6.87 | 1,365 | £2,247.86 | £427.01 |
| Low | 2.02 | 258 | £420.30 | £234.48 |

The table demonstrates a clear difference in purchasing behavior between customer value groups.

VIP customers show substantially higher average order frequency, units purchased, and revenue compared with lower-value groups.

---

# 5. RFM Customer Segmentation

## Insight 6 — Customer segments reveal different behavioral profiles

RFM analysis classified the 5,851 identified customers into behavioral segments.

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

These segments provide a structured way to understand customer purchasing behavior using:

- Recency
- Frequency
- Monetary value

---

## Insight 7 — Champions contribute the largest share of customer revenue

The Champions segment generated approximately:

**£11.60M**

representing approximately:

**68.69% of customer revenue**

Other major segment contributions included:

| Segment | Approx. Revenue Share |
|---|---:|
| Champions | 68.69% |
| Loyal Customers | 10.77% |
| Needs Attention | 8.39% |
| At Risk | 6.04% |
| Potential Loyalists | 3.79% |
| Hibernating | 2.04% |

The analysis shows that customer revenue contribution differs considerably across RFM segments.

---

# 6. Customer Risk Insights

## Insight 8 — 288 customers were classified as At Risk

The RFM analysis identified:

**288 At-Risk Customers**

These customers represent a customer group requiring attention based on their RFM characteristics.

The purpose of this classification is to identify customers whose historical purchasing behavior indicates a lower current engagement level relative to stronger customer segments.

---

## Insight 9 — Approximately £1.02M of revenue is associated with At-Risk customers

The estimated revenue associated with At-Risk customers was approximately:

**£1.02M**

The analysis further classified this exposure using business-defined customer-value thresholds.

| Risk Value Level | Customers | Revenue |
|---|---:|---:|
| Critical | 4 | £247,745.21 |
| High | 9 | £150,670.13 |
| Medium | 217 | £579,698.49 |
| Low | 58 | £42,695.40 |
| **Total** | **288** | **£1,020,809.23** |

The Critical and High groups together contain:

- **13 customers**
- approximately **£398K in revenue exposure**

This provides a focused area for customer retention analysis.

---

# 7. High-Value Customer Insights

## Insight 10 — Only a small number of customers fall into the highest-value group

The dashboard identified:

**3 High-Value Customers**

These customers represent a very small customer count but have substantial individual customer value.

This illustrates why customer count alone should not be used to understand revenue contribution.

Customer-level revenue analysis provides additional context about the economic importance of individual customers.

---

# 8. Product Performance Insights

## Insight 11 — A small group of products generates substantial revenue

The Top 10 Products by Revenue analysis identified several products with significantly higher revenue contribution than other products.

The highest-revenue product was:

**REGENCY CAKESTAND 3 TIER**

with approximately:

**£330.59K revenue**

The remaining top products included items such as:

- WHITE HANGING HEART T-LIGHT HOLDER
- PAPER CRAFT, LITTLE BIRDIE
- PARTY BUNTING
- JUMBO BAG RED RETROSPOT
- ASSORTED COLOUR BIRD ORNAMENT

These products represent important contributors within the merchandise-focused product analysis.

---

## Insight 12 — Product rankings differ when measured by revenue and units

The Top 10 Products by Revenue and Top 10 Products by Units Sold do not represent exactly the same ranking.

For example, the highest-volume product was:

**WORLD WAR 2 GLIDERS ASSTD DESIGNS**

This demonstrates an important analytical distinction:

**High sales volume does not necessarily mean high revenue.**

Revenue and quantity should therefore be analyzed separately when evaluating product performance.

---

# 9. Geographic Insights

## Insight 13 — The United Kingdom dominates revenue contribution

The United Kingdom generated approximately:

**£16.62M**

which represents approximately:

**85.53% of total revenue**

The next major countries contributed considerably smaller amounts.

Other notable markets included:

- EIRE
- Netherlands
- Germany
- France
- Australia
- Spain
- Switzerland
- Sweden
- Denmark

The geographic analysis therefore shows a strong concentration of revenue in the United Kingdom.

---

# 10. Time-Based Insights

## Insight 14 — November 2011 was the peak sales month

The Geographic & Time Analysis dashboard identified:

**November 2011**

as the peak sales month.

The monthly analysis shows noticeable revenue increases during certain periods, particularly toward the later months of the dataset.

This indicates that sales performance varies considerably over time rather than remaining constant throughout the observation period.

---

## Insight 15 — Sales activity is concentrated during business hours

Hourly analysis shows that sales activity increases substantially during the daytime.

The dashboard identifies:

**12:00**

as the peak sales hour.

Revenue activity is substantially lower during the early morning and later evening hours.

This provides useful context for understanding when transaction activity is most concentrated.

---

# 11. Day-of-Week Insights

## Insight 16 — Thursday recorded the highest sales activity by day of week

The Sales by Day of Week analysis shows that:

**Thursday**

recorded the highest revenue among the days displayed.

Tuesday also showed relatively strong sales activity, while Saturday recorded very low activity compared with the major weekdays.

This demonstrates a clear difference in sales activity across days of the week.

---

# 12. Cross-Analysis Insights

## Insight 17 — Revenue concentration exists at multiple levels

Revenue concentration can be observed across several dimensions:

### Customer level
A small number of customers contribute a large share of customer revenue.

### Geographic level
The United Kingdom contributes approximately 85.53% of total revenue.

### Customer segment level
Champions contribute approximately 68.69% of customer revenue.

### Product level
A limited number of products contribute substantial revenue compared with the wider product portfolio.

This demonstrates why revenue should be analyzed across multiple business dimensions rather than through a single KPI.

---

# 13. Business Risk Insights

## Insight 18 — Customer concentration creates revenue exposure

The customer revenue concentration analysis indicates that a relatively small number of customers account for a large proportion of identified customer revenue.

This means customer-level changes can have a material effect on revenue contribution.

The RFM and customer-value analysis provides a framework for monitoring these customers separately from the broader customer population.

---

## Insight 19 — At-Risk customers represent a measurable revenue exposure

The At-Risk segment contains:

**288 customers**

with approximately:

**£1.02M associated revenue**

The high-value at-risk analysis makes it possible to prioritize the exposure according to customer value.

This transforms a general customer-segmentation result into a more actionable revenue-risk analysis.

---

# 14. Key Analytical Conclusions

The combined Python, SQL, RFM, and Power BI analysis produced the following major findings:

1. Total revenue was approximately **£19.43M**.
2. The dataset contained **39,492 orders**.
3. Approximately **11.10M units** were sold.
4. There were **5,851 identified customers**.
5. Average Order Value was approximately **£492.09**.
6. Revenue was highly concentrated among a relatively small number of customers.
7. **4,233 customers** were repeat customers.
8. **1,618 customers** were one-time customers.
9. **Champions** contributed approximately **68.69% of customer revenue**.
10. **288 customers** were classified as At Risk.
11. Approximately **£1.02M** was associated with the At-Risk segment.
12. **3 customers** were classified as High-Value Customers.
13. **REGENCY CAKESTAND 3 TIER** was the highest-revenue product.
14. **WORLD WAR 2 GLIDERS ASSTD DESIGNS** was the highest-volume product.
15. The **United Kingdom** contributed approximately **85.53% of total revenue**.
16. **November 2011** was the peak sales month.
17. **12:00** was the peak sales hour.
18. **Thursday** recorded the highest sales activity by day of week.

---

# 15. Analytical Value of the Project

This project demonstrates how raw transaction data can be transformed into business intelligence through a complete analytical workflow:

```text
Raw Transaction Data
        ↓
Data Quality Inspection
        ↓
Data Cleaning & Preparation
        ↓
Python Analysis
        ↓
SQL Business Analysis
        ↓
Customer RFM Segmentation
        ↓
Customer Risk Analysis
        ↓
Power BI Visualization
        ↓
Business Insights
        ↓
Business Recommendations