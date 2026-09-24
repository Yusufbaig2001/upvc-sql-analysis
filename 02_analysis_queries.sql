-- ============================================
-- UPVC Manufacturing Operations Analysis
-- Analysis Queries
-- ============================================

USE upvc_company;

-- 1. Monthly Revenue Trend (2024)
WITH monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           SUM(amount) AS revenue
    FROM orders
    WHERE YEAR(order_date) = 2024
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 
             / LAG(revenue) OVER (ORDER BY month), 2) AS growth_pct
FROM monthly
ORDER BY month;

-- 2. Top 2 Customers per City by Total Revenue
WITH ranked AS (
    SELECT c.city, c.customer_name,
           SUM(o.amount) AS total_revenue,
           RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.amount) DESC) AS rnk
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city, c.customer_name
)
SELECT city, customer_name, total_revenue, rnk
FROM ranked
WHERE rnk <= 2
ORDER BY city, rnk;

-- 3. Revenue by Product Type
SELECT product_type,
       SUM(amount) AS total_revenue,
       ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (), 2) AS pct_of_total,
       AVG(quantity) AS avg_quantity
FROM orders
GROUP BY product_type;

-- 4. Customer Loyalty Report
WITH ranked AS (
    SELECT c.customer_name,
           COUNT(o.order_id) AS order_count,
           SUM(o.amount) AS total_revenue,
           RANK() OVER (ORDER BY SUM(o.amount) DESC) AS customer_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
)
SELECT customer_name, order_count, total_revenue, customer_rank,
       CASE 
           WHEN total_revenue > 250000 THEN 'VIP'
           WHEN total_revenue >= 100000 THEN 'Regular'
           ELSE 'Occasional'
       END AS customer_tier,
       MAX(total_revenue) OVER () - total_revenue AS gap_from_top
FROM ranked
ORDER BY total_revenue DESC;

-- 5. Marketing Campaign Performance
SELECT campaign_id, platform, spend, leads_generated,
       ROUND(spend / leads_generated, 2) AS cost_per_lead,
       CASE 
           WHEN spend / leads_generated < 100 THEN 'Excellent'
           WHEN spend / leads_generated BETWEEN 100 AND 150 THEN 'Good'
           ELSE 'Poor'
       END AS performance
FROM campaigns
ORDER BY cost_per_lead ASC;
