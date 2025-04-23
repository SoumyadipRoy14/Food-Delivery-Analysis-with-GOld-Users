drop table if exists soumyadipdb.goldusers_signup;
CREATE TABLE soumyadipdb.goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO soumyadipdb.goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),
(3,'2017-04-21'),
(2, '2017-11-15'),
(7, '2020-01-20'),
(9, '2021-07-01');
select * from soumyadipdb.goldusers_signup;


drop table if exists soumyadipdb.users;
CREATE TABLE soumyadipdb.users(userid integer,username varchar(100),signup_date date); 

INSERT INTO soumyadipdb.users(userid,username,signup_date) 
 VALUES (1,'A','2014-09-02'),
(2,'B','2015-01-15'),
(3,'C','2014-04-11'),
(4, 'D', '2015-05-05'),
(5, 'E', '2016-06-15'),
(6, 'F', '2017-08-22'),
(7, 'G', '2018-01-30'),
(8, 'H', '2019-11-11'),
(9, 'I', '2020-02-14'),
(10, 'J', '2021-03-03');
select * from soumyadipdb.users;

drop table if exists soumyadipdb.sales;
CREATE TABLE soumyadipdb.sales(userid integer,created_date date,product_id integer); 

INSERT INTO soumyadipdb.sales(userid, created_date, product_id) 
VALUES 
(1, '2017-04-19', 2),
(3, '2019-12-18', 1),
(2, '2020-07-20', 3),
(1, '2019-10-23', 2),
(1, '2018-03-19', 3),
(3, '2016-12-20', 2),
(1, '2016-11-09', 1),
(1, '2016-05-20', 3),
(2, '2017-09-24', 1),
(1, '2017-03-11', 2),
(1, '2016-03-11', 1),
(3, '2016-11-10', 1),
(3, '2017-12-07', 2),
(3, '2016-12-15', 2),
(2, '2017-11-08', 2),
(2, '2018-09-10', 3),
(4, '2018-05-15', 1),
(5, '2019-08-10', 3),
(6, '2020-10-21', 4),
(7, '2021-03-05', 2),
(8, '2022-07-19', 5),
(9, '2023-01-12', 2),
(10, '2023-06-22', 6),
(5, '2021-10-10', 4),
(6, '2022-11-11', 1),
(8, '2022-08-20', 6),
(9, '2023-12-25', 5),
(10, '2024-04-18', 3),
(2, '2023-05-17', 6),
(3, '2024-01-01', 4),
(7, '2024-09-09', 5);

select * from soumyadipdb.sales;

drop table if exists soumyadipdb.product;
CREATE TABLE soumyadipdb.product(product_id integer,product_name text,price integer); 

INSERT INTO soumyadipdb.product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330),
(4, 'p4', 450),
(5, 'p5', 620),
(6, 'p6', 780);
select * from soumyadipdb.product;

select * from soumyadipdb.sales;
select * from soumyadipdb.product;
select * from soumyadipdb.goldusers_signup;
select * from soumyadipdb.users;


-- Question 1: Monthly Revenue Trend
-- Q: Calculate the total monthly revenue from sales, and identify the top-performing month in terms of revenue.

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
    
-- Question 2: Gold User Conversion Rate
-- Q: What percentage of users became gold users, and what is the average time (in days) it took for a user to convert?

SELECT 
    ROUND(COUNT(g.userid) * 100.0 / COUNT(u.userid), 2) AS conversion_rate_percent,
    ROUND(AVG(g.gold_signup_date - u.signup_date), 2) AS avg_days_to_convert
FROM 
    soumyadipdb.users u
LEFT JOIN 
    soumyadipdb.goldusers_signup g ON u.userid = g.userid;
    
-- Question 3: Top 2 Products by Revenue for Each Year
-- Q: For each year, list the top 2 products that generated the highest revenue.

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

-- Question 4: Users with Decreasing Purchase Trend
-- Q: Identify users whose purchase count decreased year-over-year.

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

-- Question 5: First Product Purchased by Each User
-- Q: What was the first product purchased by each user?

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

-- Question 6: Who are the top-performing users based on total purchase revenue, including users who have not made any purchases yet? Provide their revenue and a dense ranking based on total revenue.

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