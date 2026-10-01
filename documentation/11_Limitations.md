# Project Limitations

## 1. Overview

Every analytical project has limitations related to the available data, time period, business context, and analytical methodology.

This document describes the main limitations of the E-Commerce Sales & Customer Analytics project.

The purpose is to clearly communicate what the analysis can explain and what cannot be concluded from the available dataset.

---

# 2. Missing Customer IDs

A significant number of transaction records do not contain a Customer ID.

Therefore, the project uses two analytical layers:

### Transaction Layer

The complete cleaned transaction dataset is retained for:

- Revenue analysis
- Order analysis
- Unit analysis
- Product analysis
- Geographic analysis
- Time analysis

### Customer Layer

Only transactions with valid Customer IDs are used for:

- Customer-level analysis
- Customer value analysis
- RFM analysis
- Customer segmentation
- Customer risk analysis

Therefore, customer-level results should not be interpreted as representing every transaction in the dataset.

---

# 3. Customer-Level Analysis Represents Identified Customers

The project identifies:

**5,851 customers**

with valid Customer IDs.

Because some transactions are anonymous, customer-level metrics represent the identified-customer population.

For example:

- Identified-customer revenue
- Revenue per identified customer
- RFM segments
- Customer value groups

should be interpreted specifically in the context of identified customers.

---

# 4. Historical Dataset

The analysis is based on historical transaction data covering:

**December 2009 to December 2011**

The dataset therefore represents a specific historical period.

Customer behavior, product demand, and sales patterns may change over time.

Consequently, the findings should not automatically be assumed to represent current business conditions.

---

# 5. No Profitability Data

The dataset contains sales transaction information such as:

- Quantity
- Price
- Revenue
- Product
- Customer
- Country
- Invoice date

However, it does not provide complete business profitability information.

The analysis therefore focuses primarily on:

**Revenue and sales activity**

rather than:

**Profitability or profit margin.**

A product generating high revenue does not necessarily generate the highest profit.

---

# 6. No Marketing Cost Data

The dataset does not contain detailed marketing information such as:

- Advertising spend
- Campaign costs
- Customer acquisition cost
- Campaign conversion rate
- Marketing channel
- Campaign attribution

Therefore, the project cannot determine the return on marketing investment.

---

# 7. No Inventory Information

The dataset does not provide complete inventory information.

Therefore, the project cannot directly determine:

- Current stock levels
- Stock-outs
- Reorder points
- Inventory carrying costs
- Supply constraints

Product sales analysis should therefore be interpreted as historical sales performance rather than current inventory performance.

---

# 8. No Customer Demographic Information

The available dataset does not provide detailed customer demographic information such as:

- Age
- Gender
- Occupation
- Household income
- Education
- Customer preferences

Therefore, the project cannot perform demographic segmentation.

The customer segmentation is based primarily on purchasing behavior through RFM and customer-value analysis.

---

# 9. RFM Is a Behavioral Segmentation Method

RFM segmentation is based on:

- Recency
- Frequency
- Monetary value

It provides a structured description of historical purchasing behavior.

However, RFM does not directly explain:

- Why a customer stopped purchasing
- Customer satisfaction
- Customer preferences
- Competitor activity
- External market conditions

Therefore, RFM segments should be interpreted as behavioral categories rather than explanations of customer motivation.

---

# 10. RFM Reference Date

The RFM analysis uses a reference date after the latest transaction date.

The reference date is:

**2011-12-10**

This is used to calculate customer recency consistently.

Changing the reference date can change customer recency values and potentially affect RFM scores and customer segments.

Therefore, RFM results are specific to the selected analysis period and reference date.

---

# 11. RFM Scoring Assumptions

RFM scores are assigned using a 1–5 scoring system.

The scoring direction is:

- Recency: more recent customers receive higher scores.
- Frequency: higher purchase frequency receives higher scores.
- Monetary: higher monetary value receives higher scores.

The resulting RFM score is constructed from the three component scores.

These scoring rules are analytical design choices and can be modified for a different business context.

---

# 12. Customer Segment Rules Are Business Rules

The RFM customer segments are created using defined combinations of RFM scores.

Examples include:

- Champions
- Loyal Customers
- At Risk
- Needs Attention
- Hibernating
- Potential Loyalists
- Big Spenders
- Recent Customers

These segments are analytical classifications based on the project's defined rules.

They should not be interpreted as machine-learning predictions.

---

# 13. Customer Value Thresholds Are Business Rules

The customer value analysis uses revenue thresholds to classify customers into value groups.

Examples include:

- VIP
- High
- Medium
- Low

These thresholds are business rules defined for the project.

Changing the thresholds would change the customer-value classification.

Therefore, these categories should be interpreted within the context of the current analytical framework.

---

# 14. At-Risk Classification Is Not a Prediction Model

The At Risk customer segment is derived from RFM characteristics.

It does not represent a predictive machine-learning model.

The analysis does not estimate:

- Probability of churn
- Probability of future purchase
- Customer lifetime value
- Future revenue

The At Risk classification should therefore be interpreted as a behavioral segmentation result based on historical transaction data.

---

# 15. Revenue Does Not Equal Profit

The project measures transaction revenue.

Revenue does not account for all business costs.

Therefore, the following cannot be directly calculated from the available dataset:

- Net profit
- Gross margin
- Operating profit
- Contribution margin

Additional financial information would be required for profitability analysis.

---

# 16. Geographic Analysis Limitations

The dataset includes country information.

However, detailed geographic information such as:

- City
- Region
- Postal code
- Delivery location
- Store location

is not used as a complete geographic hierarchy in the project.

Therefore, the geographic analysis primarily focuses on country-level performance.

---

# 17. Time Analysis Limitations

The project analyzes transaction timing using:

- Year
- Month
- Day of week
- Hour

However, the analysis does not incorporate external factors such as:

- Holidays
- Weather
- Competitor promotions
- Economic conditions
- Marketing campaigns
- Major external events

Therefore, observed time-based patterns should not automatically be interpreted as causal effects.

---

# 18. No Causal Analysis

The project is primarily descriptive and analytical.

It identifies:

- Patterns
- Relationships
- Concentrations
- Customer segments
- Sales trends

It does not establish causal relationships.

For example, a change in sales during a particular period does not by itself prove that a specific factor caused the change.

Additional experimental or statistical analysis would be required to establish causality.

---

# 19. Historical Product Analysis

Product performance is based on historical transaction records.

The analysis identifies products with high:

- Revenue
- Unit volume
- Order activity

However, the project does not include:

- Product cost
- Profit margin
- Product lifecycle
- Inventory availability
- Product marketing spend

Therefore, product rankings should be interpreted as historical sales performance rather than complete product profitability rankings.

---

# 20. Anonymous Transactions Affect Customer Metrics

Transactions without Customer IDs remain part of the transaction-level analysis.

However, they cannot be assigned to individual customers.

This means that:

- Total transaction revenue
- Total orders
- Total units

may be higher than the corresponding identified-customer totals.

This distinction is important when comparing transaction-level and customer-level KPIs.

---

# 21. Data Quality Considerations

The project includes data-quality inspection and validation steps.

However, data analysis is dependent on the quality and completeness of the original source dataset.

Potential limitations include:

- Missing customer identifiers
- Historical data inconsistencies
- Cancellation transactions
- Administrative/non-merchandise records
- Product description inconsistencies

The cleaning process addresses the defined analytical requirements, but it cannot recover information that was not present in the source data.

---

# 22. Merchandise Analysis Scope

The project distinguishes merchandise transactions from administrative or non-merchandise records for product-focused analysis.

Certain records such as:

- `DOTCOM`
- Postage
- Administrative charges
- Other non-merchandise records

are treated separately where appropriate.

Therefore, product-level analysis should be interpreted as merchandise-focused analysis rather than a direct analysis of every transaction record.

---

# 23. No Real-Time Data

The Power BI dashboard is based on the finalized project dataset.

It is not a real-time operational monitoring system.

The dashboard therefore reflects the available historical dataset rather than live transactions.

To support real-time monitoring, the underlying data pipeline would need to be connected to a continuously updated source.

---

# 24. No Predictive Analytics

The current project focuses on:

- Descriptive analytics
- Diagnostic analysis
- Customer segmentation
- Business intelligence

It does not currently implement predictive models for:

- Churn prediction
- Sales forecasting
- Customer lifetime value prediction
- Product demand forecasting

These could be developed as future extensions of the project.

---

# 25. No Automated Data Refresh Pipeline

The current project uses a defined data-processing workflow involving:

- Python
- SQL
- Power BI

However, it does not include a fully automated production pipeline that continuously:

1. Extracts new data
2. Cleans the data
3. Loads the database
4. Recalculates analytics
5. Refreshes the dashboard

Therefore, the project should be considered an analytical portfolio project rather than a fully automated production BI system.

---

# 26. Dashboard Interpretation

Power BI provides interactive visualizations and filtering.

However, dashboard results depend on:

- Selected filters
- Selected date ranges
- Customer population
- Data model relationships
- Measure definitions

Therefore, users should consider the selected filters when interpreting individual dashboard values.

---

# 27. Generalization Limitations

The project is based on one specific e-commerce transaction dataset.

The findings therefore cannot automatically be generalized to:

- Other companies
- Other industries
- Other time periods
- Other customer populations
- Current market conditions

The analysis demonstrates an analytical methodology rather than a universal description of e-commerce behavior.

---

# 28. Future Improvements

The project could be extended by adding:

### Predictive Analytics

- Customer churn prediction
- Sales forecasting
- Customer lifetime value prediction
- Product demand forecasting

### Additional Business Data

- Profit margins
- Marketing campaigns
- Customer demographics
- Inventory
- Product costs
- Shipping costs

### Advanced Analytics

- Cohort analysis
- Market basket analysis
- Customer lifetime value
- Churn modeling
- Recommendation systems

### Automation

- Automated ETL
- Scheduled SQL processing
- Automated Power BI refresh
- Data-quality monitoring
- Production data pipelines

---

# 29. Limitation Summary

The most important limitations are:

1. Many transactions do not contain Customer IDs.
2. Customer analysis therefore represents identified customers.
3. The dataset represents a historical period.
4. Revenue does not represent profit.
5. Marketing and inventory data are unavailable.
6. Demographic information is unavailable.
7. RFM is behavioral segmentation rather than predictive modeling.
8. Customer segment and value thresholds are business rules.
9. At Risk classification is not a churn prediction model.
10. The analysis is descriptive and does not establish causality.
11. Geographic analysis primarily focuses on country-level information.
12. The dashboard is not a real-time operational system.
13. The project does not currently include predictive analytics.
14. The project does not contain a fully automated production data pipeline.

---

# 30. Final Perspective

The limitations do not invalidate the analytical findings.

Instead, they define the appropriate scope in which the findings should be interpreted.

The project provides a structured analytical framework for understanding historical e-commerce sales and customer behavior using:

**Python → SQL → RFM → Power BI**

The results are most appropriate for:

- Historical business analysis
- Customer segmentation
- Revenue analysis
- Product performance analysis
- Geographic analysis
- Time-based analysis
- Business intelligence reporting

Future versions can extend the project with additional business data, predictive analytics, automation, and production-grade data pipelines.