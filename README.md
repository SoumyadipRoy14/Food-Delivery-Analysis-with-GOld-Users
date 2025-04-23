🍔 Food Delivery SQL Analytics Project

This project showcases advanced SQL analytics for a fictional **Food Delivery App**, using realistic data to derive business insights such as revenue trends, customer conversions, product performance, and user behavior.

## 🧠 Objective

The goal is to demonstrate strong data analysis skills using SQL by answering business-critical questions. We work with sales, user, product, and gold user signup data to generate key performance indicators and insights that would be valuable for product, marketing, or growth teams.

## 📊 Dataset Overview

The database consists of four primary tables in the `soumyadipdb` schema:

### 1. `users`
Stores user profile and signup information.

| Column Name   | Type    | Description                  |
|---------------|---------|------------------------------|
| `userid`      | INTEGER | Unique ID of the user        |
| `username`    | VARCHAR | Username                     |
| `signup_date` | DATE    | Date when the user signed up |

### 2. `goldusers_signup`
Tracks which users became premium (gold) users and when.

| Column Name        | Type    | Description                           |
|--------------------|---------|---------------------------------------|
| `userid`           | INTEGER | Foreign key to `users`                |
| `gold_signup_date` | DATE    | Date when the user became gold member |

### 3. `product`
Defines the products available on the platform.

| Column Name     | Type    | Description               |
|-----------------|---------|---------------------------|
| `product_id`    | INTEGER | Unique ID of the product  |
| `product_name`  | TEXT    | Name of the product       |
| `price`         | INTEGER | Price of the product (₹)  |

### 4. `sales`
Tracks all purchase records, including product and date.

| Column Name     | Type    | Description                      |
|-----------------|---------|----------------------------------|
| `userid`        | INTEGER | User who made the purchase       |
| `created_date`  | DATE    | Date of the purchase             |
| `product_id`    | INTEGER | Purchased product (foreign key)  |

---

## 📌 SQL Questions & Solutions

### 1. 📈 Monthly Revenue Trend
**Q:** Calculate the total monthly revenue from sales and identify the top-performing month in terms of revenue.

> Uses: `JOIN`, `GROUP BY`, `DATE_FORMAT`, `ORDER BY`

SELECT 
    DATE_FORMAT(s.created_date, '%Y-%m-01') AS month,
    SUM(p.price) AS total_revenue
FROM 
    soumyadipdb.sales s
JOIN 
    soumyadipdb.product p ON s.product_id = p.product_id
GROUP BY 
    DATE_FORMAT(s.created_date, '%Y-%m-01')
ORDER BY 
    total_revenue DESC;

### 2. ⭐ Gold User Conversion Rate
**Q:** What percentage of users became gold users, and what is the average time (in days) it took for a user to convert?

> Uses: `LEFT JOIN`, `COALESCE`, `ROUND`, date difference

SELECT 
    ROUND(COUNT(g.userid) * 100.0 / COUNT(u.userid), 2) AS conversion_rate_percent,
    ROUND(AVG(g.gold_signup_date - u.signup_date), 2) AS avg_days_to_convert
FROM 
    soumyadipdb.users u
LEFT JOIN 
    soumyadipdb.goldusers_signup g ON u.userid = g.userid;

### 3. 🏆 Top 2 Products by Revenue per Year
**Q:** For each year, list the top 2 products that generated the highest revenue.

> Uses: `WITH`, `RANK()`, `PARTITION BY`, `JOIN`

WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM s.created_date) AS sales_year,
        p.product_id,
        p.product_name,
        SUM(p.price) AS total_revenue
    FROM soumyadipdb.sales s
    JOIN soumyadipdb.product p ON s.product_id = p.product_id
    GROUP BY sales_year, p.product_id, p.product_name
),
ranked_products AS (
    SELECT *,
        RANK() OVER (PARTITION BY sales_year ORDER BY total_revenue DESC) AS rnk
    FROM yearly_sales
)
SELECT * 
FROM ranked_products
WHERE rnk <= 2;


### 4. 📉 Users with Decreasing Purchase Trend
**Q:** Identify users whose purchase count decreased year-over-year.

> Uses: `LAG()`, `OVER`, `WITH`, `PARTITION BY`, `CASE`

WITH yearly_purchases AS (
    SELECT 
        userid,
        EXTRACT(YEAR FROM created_date) AS yr,
        COUNT(*) AS purchase_count
    FROM soumyadipdb.sales
    GROUP BY userid, yr
),
purchase_diff AS (
    SELECT 
        userid,
        yr,
        purchase_count,
        LAG(purchase_count) OVER (PARTITION BY userid ORDER BY yr) AS prev_year_count
    FROM yearly_purchases
)
SELECT * 
FROM purchase_diff
WHERE prev_year_count IS NOT NULL AND purchase_count < prev_year_count;


### 5. 🛒 First Product Purchased by Each User
**Q:** What was the first product purchased by each user?

> Uses: `ROW_NUMBER()`, `JOIN`, `PARTITION BY`, `ORDER BY`

WITH ranked_sales AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY userid ORDER BY created_date) AS rn
    FROM soumyadipdb.sales
)
SELECT 
    rs.userid,
    rs.created_date,
    p.product_name
FROM ranked_sales rs
JOIN soumyadipdb.product p ON rs.product_id = p.product_id
WHERE rs.rn = 1;


### 6. 💰 Top Users by Revenue with Dense Ranking
**Q:** Who are the top-performing users based on total purchase revenue, including users who have not made any purchases yet? Provide their revenue and a dense ranking.

> Uses: `DENSE_RANK()`, `COALESCE`, `LEFT JOIN`, `GROUP BY`
SELECT 
    u.userid,
    u.username,
    COALESCE(SUM(p.price), 0) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY COALESCE(SUM(p.price), 0) DESC) AS revenue_rank
FROM 
    soumyadipdb.users u
LEFT JOIN 
    soumyadipdb.sales s ON u.userid = s.userid
LEFT JOIN 
    soumyadipdb.product p ON s.product_id = p.product_id
GROUP BY 
    u.userid, u.username
ORDER BY 
    revenue_rank;

## 🛠️ Tools Used

- SQL (MySQL syntax)
- DB: Simulated schema `soumyadipdb`
- Query tested in MySQL Workbench / DBeaver / PostgreSQL-compatible engines (with adjustments)

## 📁 Project Structure

```
├── Food Delivery-Gold Users.sql        # Full schema, inserts, and queries
└── README.md                           # Explanation of questions and objectives

## 📌 Future Enhancements

- Add churn prediction based on user inactivity
- Simulate refund/return data
- Visualize results in Power BI or Tableau
