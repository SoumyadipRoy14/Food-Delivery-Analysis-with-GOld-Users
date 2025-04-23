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