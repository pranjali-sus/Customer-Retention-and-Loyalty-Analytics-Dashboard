CREATE DATABASE Instacart;
USE Instacart;

-- Total Customers
SELECT COUNT(DISTINCT user_id) AS total_customers FROM orders;

-- Total Orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Total Pruducts Purchased
SELECT COUNT(*) AS total_products_purchased FROM order_products_prior;

-- Reorder Rate
SELECT ROUND(AVG(reordered) * 100, 2) AS reorder_rate FROM order_products_prior;

-- Loyal Customers
SELECT COUNT(*) AS loyal_customers;

-- Top 10 Products
SELECT p.product_name, COUNT(*) AS purchase_count
FROM order_products_prior op
JOIN products p
ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY purchase_count DESC
LIMIT 10;

-- Top Departments by Purchase
SELECT d.department, COUNT(*) AS purchases
FROM order_products_prior op
JOIN products p
ON op.product_id = p.product_id
JOIN departments d
ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY purchases DESC;

-- Top Aisles by Purchase
SELECT a.aisle, COUNT(*) AS purchases
FROM order_products_prior op
JOIN products p
ON op.product_id = p.product_id
JOIN aisles a
ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY purchases DESC
LIMIT 10;

-- Average Orders Per Customer
SELECT ROUND(AVG(total_orders),2) AS avg_orders_per_customer
FROM (
    SELECT user_id, MAX(order_number) AS total_orders FROM orders
    GROUP BY user_id
) t;

-- Customer Ranking
SELECT user_id, MAX(order_number) AS total_orders,
    DENSE_RANK() OVER (
        ORDER BY MAX(order_number) DESC
    ) AS customer_rank
FROM orders
GROUP BY user_id;

-- Customer Segmentation
SELECT user_id, MAX(order_number) AS total_orders,
    CASE
        WHEN MAX(order_number) >= 20 THEN 'Loyal'
        WHEN MAX(order_number) >= 10 THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment
FROM orders
GROUP BY user_id;

-- Monthly Order Distribution
SELECT order_dow, COUNT(*) AS total_orders FROM orders
GROUP BY order_dow
ORDER BY order_dow;

-- Top Reordered Products
SELECT p.product_name, SUM(op.reordered) AS reorder_count
FROM order_products_prior op
JOIN products p
ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY reorder_count DESC
LIMIT 10;