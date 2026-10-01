/*
=========================================================
E-COMMERCE SALES & CUSTOMER ANALYTICS
SQL ANALYSIS — SALES PERFORMANCE
=========================================================

Purpose:
Analyze overall sales performance and identify
key revenue and order trends.

Database: MySQL
Author: Dnyaneshwar G. Lahane
=========================================================
*/

-- =========================================================
-- 1. DATABASE SETUP
-- =========================================================

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;


-- =========================================================
-- 2. SALES TABLE
-- =========================================================

CREATE TABLE IF NOT EXISTS sales (
    invoice VARCHAR(20),
    stockcode VARCHAR(20),
    description VARCHAR(255),
    quantity INT,
    invoicedate DATETIME,
    price DECIMAL(10,2),
    customer_id INT,
    country VARCHAR(100),
    is_cancelled BOOLEAN,
    revenue DECIMAL(12,2)
);
SHOW TABLES;