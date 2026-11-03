-- =========================================================
-- UPVC SALES & CUSTOMER ANALYTICS
-- Database: upvc_company
-- MySQL 8.0+
-- =========================================================

USE upvc_company;


-- =========================================================
-- 1. DATABASE OVERVIEW
-- Check total customers, orders and campaigns.
-- =========================================================

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM campaigns) AS total_campaigns;


-- =========================================================
-- 2. ORDER STATUS ANALYSIS
-- Understand completed, pending and cancelled orders.
-- =========================================================

SELECT
    status,
    COUNT(*) AS total_orders,
    SUM(amount) AS order_value,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS order_percentage
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- =========================================================
-- 3. COMPLETED SALES SUMMARY
-- Only completed orders are treated as realised sales.
-- =========================================================

SELECT
    COUNT(*) AS completed_orders,
    SUM(quantity) AS total_units_sold,
    SUM(amount) AS completed_sales,
    ROUND(AVG(amount), 2) AS average_order_value,
    ROUND(
        SUM(amount) / NULLIF(SUM(quantity), 0),
        2
    ) AS average_value_per_unit
FROM orders
WHERE status = 'Completed';


-- =========================================================
-- 4. MONTHLY COMPLETED SALES TREND
-- LAG compares with the previous available month.
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        COUNT(*) AS completed_orders,
        SUM(amount) AS monthly_revenue
    FROM orders
    WHERE status = 'Completed'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
monthly_comparison AS (
    SELECT
        sales_month,
        completed_orders,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    completed_orders,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM monthly_comparison
ORDER BY sales_month;


-- =========================================================
-- 5. REVENUE BY PRODUCT TYPE
-- Completed orders only.
-- =========================================================

SELECT
    product_type,
    COUNT(*) AS completed_orders,
    SUM(quantity) AS units_sold,
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS average_order_value,
    ROUND(
        SUM(amount) * 100.0
        / NULLIF(
            (SELECT SUM(amount)
             FROM orders
             WHERE status = 'Completed'),
            0
        ),
        2
    ) AS revenue_contribution_pct
FROM orders
WHERE status = 'Completed'
GROUP BY product_type
ORDER BY total_revenue DESC;


-- =========================================================
-- 6. TOP CUSTOMERS BY COMPLETED SALES
-- =========================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.customer_type,
    COUNT(o.order_id) AS completed_orders,
    SUM(o.amount) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city,
    c.customer_type
ORDER BY total_revenue DESC;


-- =========================================================
-- 7. TOP 2 CUSTOMERS IN EACH CITY
-- CTE + RANK window function.
-- =========================================================

WITH customer_sales AS (
    SELECT
        c.city,
        c.customer_id,
        c.customer_name,
        SUM(o.amount) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.status = 'Completed'
    GROUP BY
        c.city,
        c.customer_id,
        c.customer_name
),
ranked_customers AS (
    SELECT
        city,
        customer_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS city_rank
    FROM customer_sales
)
SELECT
    city,
    customer_name,
    total_revenue,
    city_rank
FROM ranked_customers
WHERE city_rank <= 2
ORDER BY city, city_rank;


-- =========================================================
-- 8. REVENUE BY CUSTOMER TYPE
-- Completed orders only.
-- =========================================================

SELECT
    c.customer_type,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(o.order_id) AS completed_orders,
    SUM(o.amount) AS total_revenue,
    ROUND(AVG(o.amount), 2) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_type
ORDER BY total_revenue DESC;


-- =========================================================
-- 9. CITY-WISE SALES PERFORMANCE
-- =========================================================

SELECT
    c.city,
    COUNT(o.order_id) AS completed_orders,
    SUM(o.quantity) AS units_sold,
    SUM(o.amount) AS total_revenue,
    ROUND(AVG(o.amount), 2) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.city
ORDER BY total_revenue DESC;


-- =========================================================
-- 10. CUSTOMER LOYALTY ANALYSIS
-- Classify customers using completed order revenue.
-- =========================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) AS order_count,
        SUM(o.amount) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.status = 'Completed'
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_name,
    order_count,
    total_revenue,
    CASE
        WHEN total_revenue > 250000 THEN 'VIP'
        WHEN total_revenue >= 100000 THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS customer_rank
FROM customer_summary
ORDER BY total_revenue DESC;


-- =========================================================
-- 11. REPEAT CUSTOMER ANALYSIS
-- Customers with more than one completed order.
-- =========================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS completed_orders,
    SUM(o.amount) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY completed_orders DESC, total_revenue DESC;


-- =========================================================
-- 12. MARKETING CAMPAIGN PERFORMANCE
-- CPL = campaign spend / leads generated.
-- =========================================================

SELECT
    campaign_id,
    platform,
    start_date,
    spend,
    leads_generated,
    ROUND(
        spend / NULLIF(leads_generated, 0),
        2
    ) AS cost_per_lead,
    CASE
        WHEN leads_generated = 0 OR leads_generated IS NULL
            THEN 'Not Available'
        WHEN spend / leads_generated < 100
            THEN 'Excellent'
        WHEN spend / leads_generated <= 150
            THEN 'Good'
        ELSE 'Needs Review'
    END AS campaign_rating
FROM campaigns
ORDER BY cost_per_lead ASC;


-- =========================================================
-- 13. MARKETING PLATFORM SUMMARY
-- Weighted CPL = total spend / total leads.
-- =========================================================

SELECT
    platform,
    COUNT(*) AS total_campaigns,
    SUM(spend) AS total_spend,
    SUM(leads_generated) AS total_leads,
    ROUND(
        SUM(spend) / NULLIF(SUM(leads_generated), 0),
        2
    ) AS weighted_cost_per_lead
FROM campaigns
GROUP BY platform
ORDER BY weighted_cost_per_lead ASC;


-- =========================================================
-- 14. ORDER VALUE BY STATUS
-- Compare order values without treating all as sales.
-- =========================================================

SELECT
    status,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(amount) AS total_order_value,
    ROUND(AVG(amount), 2) AS average_order_value
FROM orders
GROUP BY status
ORDER BY total_order_value DESC;


-- =========================================================
-- 15. OVERALL BUSINESS SUMMARY
-- Completed sales and outstanding order values are separate.
-- =========================================================

SELECT
    COUNT(*) AS all_orders,
    SUM(status = 'Completed') AS completed_orders,
    SUM(status = 'Pending') AS pending_orders,
    SUM(status = 'Cancelled') AS cancelled_orders,
    SUM(CASE
        WHEN status = 'Completed' THEN amount
        ELSE 0
    END) AS completed_sales,
    SUM(CASE
        WHEN status = 'Pending' THEN amount
        ELSE 0
    END) AS pending_order_value,
    SUM(CASE
        WHEN status = 'Cancelled' THEN amount
        ELSE 0
    END) AS cancelled_order_value
FROM orders;
