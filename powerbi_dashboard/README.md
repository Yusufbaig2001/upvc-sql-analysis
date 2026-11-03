# UPVC Sales & Customer Analytics

An SQL and Power BI analytics project exploring sales performance, customer behaviour, product revenue and marketing campaign efficiency for a UPVC doors and windows business.

The project uses a relational MySQL database and business-focused SQL queries to analyse customer orders, completed sales, product performance, city-wise revenue and lead generation.

> **Dataset disclaimer:** This project uses a small illustrative sample dataset containing 6 customers, 10 orders and 4 marketing campaigns. Figures are not actual company financial results.

## Power BI Dashboard

![Executive Summary](powerbi_dashboard/page1_executive.png)

The interactive dashboard contains three analytical pages:

- **Executive Summary:** Revenue KPIs, monthly sales trend and product mix.
- **Customer Analytics:** Customer segmentation, customer rankings and city-wise sales.
- **Operations Overview:** Order status, monthly orders and product performance by customer type.

**Tools:** Power BI Desktop, DAX and Power Query.

[View dashboard documentation](powerbi_dashboard/README.md)

## Business Problem

A UPVC doors and windows business needs visibility into its sales and customer data to understand:

- Which products generate the most completed sales?
- Which cities contribute the most revenue?
- Who are the highest-value customers?
- How many orders are completed, pending or cancelled?
- Which marketing platforms generate leads at a lower cost?

## Project Objectives

- Analyse completed sales and order status.
- Track monthly sales performance.
- Compare revenue across product types.
- Identify top customers and customer segments.
- Analyse city-wise sales performance.
- Measure campaign Cost Per Lead (CPL).
- Build an interactive Power BI dashboard.

## Tools & Technologies

| Technology | Application |
|---|---|
| MySQL | Relational database and SQL analysis |
| Power BI | Interactive dashboard |
| DAX | Measures and customer segmentation |
| Power Query | Data preparation and transformation |

## Database Schema

The project contains three relational tables.

### 1. Customers

| Column | Description |
|---|---|
| customer_id | Unique customer identifier |
| customer_name | Customer name |
| city | Customer city |
| customer_type | Retail, Builder or Dealer |

### 2. Orders

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer reference |
| order_date | Order date |
| product_type | Window or Door |
| quantity | Units ordered |
| amount | Order amount |
| status | Completed, Pending or Cancelled |

### 3. Campaigns

| Column | Description |
|---|---|
| campaign_id | Unique campaign identifier |
| platform | Marketing platform |
| start_date | Campaign start date |
| spend | Campaign expenditure |
| leads_generated | Leads generated |

## SQL Analysis

The project includes 15 business analysis queries covering:

1. Database overview and validation.
2. Order status analysis.
3. Completed sales summary.
4. Monthly completed sales trend.
5. Revenue by product type.
6. Top customers by completed sales.
7. Top customers in each city.
8. Revenue by customer type.
9. City-wise sales performance.
10. Customer loyalty segmentation.
11. Repeat customer analysis.
12. Marketing campaign performance.
13. Marketing platform comparison.
14. Order value by status.
15. Overall business summary.

## SQL Concepts Demonstrated

- SELECT, WHERE and ORDER BY
- GROUP BY and HAVING
- INNER JOIN
- Aggregate functions: SUM, COUNT and AVG
- CASE WHEN conditional logic
- Common Table Expressions (CTEs)
- Window functions: RANK and LAG
- Date functions: DATE_FORMAT and YEAR
- Subqueries
- NULLIF for safe division

## Key Analytical Areas

The sample data supports analysis of:

- Completed sales versus pending and cancelled order values.
- Product revenue contribution.
- Customer revenue rankings and repeat purchases.
- City and customer-type comparisons.
- Campaign cost per lead and platform performance.

Because the dataset is small, the results should be treated as SQL and dashboard demonstrations rather than statistically reliable business conclusions.

## Repository Structure

```text
upvc-sql-analysis/
│
├── 01_database_setup.sql
├── 02_analysis_queries.sql
├── README.md
│
└── powerbi_dashboard/
    ├── upvc_dashboard.pbix
    ├── page1_executive.png
    ├── page2_customers.png
    ├── page3_operations.png
    └── README.md
```

## How to Run

1. Install MySQL 8.0 or later.
2. Open MySQL Workbench.
3. Execute `01_database_setup.sql` to create the database and insert sample records.
4. Execute `02_analysis_queries.sql` to run the analysis.
5. Open `upvc_dashboard.pbix` in Power BI Desktop to explore the dashboard.

## Project Limitations

- The dataset contains only 6 customers, 10 orders and 4 campaigns.
- The dataset is illustrative and does not represent verified company results.
- The project analyses sales and customer operations, not factory manufacturing performance.
- No production output, machine efficiency, material consumption, defects or rejection data is available.
- Campaign revenue attribution is not available, so ROAS cannot be calculated from this dataset.

## AI-Assisted Development

AI tools, including ChatGPT, were used to support SQL query development, troubleshooting, explanations and documentation. The project is intended to demonstrate understanding of the analytical concepts and the ability to interpret results, rather than to claim that every query was independently authored.

## Author

**Yusuf Baig**  
Aspiring Data Analyst | Open to opportunities in Dubai, UAE

- [LinkedIn](https://www.linkedin.com/in/yusuf-baig-783906210/)
- [GitHub](https://github.com/Yusufbaig2001)
