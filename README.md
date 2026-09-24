# UPVC Manufacturing Operations Analysis

## 📋 Business Problem

A UPVC windows and doors manufacturing business needed to understand its production efficiency, customer behavior, and revenue trends to make data-driven decisions.

## 🎯 Objectives

- Analyze monthly revenue trends and identify seasonal patterns.
- Identify top customers by revenue and segment them (VIP / Regular / Occasional).
- Analyze product mix (Windows vs Doors) and its contribution to revenue.
- Rank customers per city to identify regional top performers.
- Analyze marketing campaign performance (cost per lead, ROI).

## 🛠️ Tools Used

- **MySQL** (for data storage and analysis)
- **Excel** (for reporting)

## 🗄️ Database Schema

The database consists of three tables:

- **customers**: customer_id, customer_name, city, customer_type
- **orders**: order_id, customer_id, order_date, product_type, quantity, amount, status
- **campaigns**: campaign_id, platform, start_date, spend, leads_generated

## 🔍 Key SQL Techniques Used

- **Joins**: INNER JOIN, LEFT JOIN
- **Aggregations**: GROUP BY, HAVING, SUM, COUNT, AVG
- **Window Functions**: RANK, DENSE_RANK, LAG
- **Common Table Expressions (CTEs)**
- **Subqueries**: Scalar, multi-row, correlated
- **CASE WHEN** for conditional logic and segmentation
- **Date Functions**: DATE_FORMAT, DATEDIFF, YEAR, MONTH

## 📊 Key Insights

- January 2024 was the highest revenue month, generating over AED 320,000 from completed orders.
- Builders (customer_type) contributed the highest total revenue compared to Retail and Dealer segments.
- Windows are the dominant product type, generating around 70% of total revenue.
- Facebook had the lowest cost-per-lead, while IndiaMART delivered the highest volume of leads.

## 📁 Repository Structure

- `01_database_setup.sql` — Schema and sample data
- `02_analysis_queries.sql` — All analysis queries
- `README.md` — Project documentation

## 🚀 How to Run

1. Open MySQL Workbench.
2. Run `01_database_setup.sql` to create the database and tables.
3. Run `02_analysis_queries.sql` to execute the analysis.

## 👤 Author

**Yusuf Baig**
- LinkedIn: https://www.linkedin.com/in/yusuf-baig-783906210/
- GitHub: https://github.com/Yusufbaig2001
