-- Ad HOC Analysis
-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.

SELECT DISTINCT market
FROM dim_customer
WHERE customer = 'Atliq Exclusive' 
AND region = 'APAC';

/* 2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
   unique_products_2020, unique_products_2021, percentage_chg */

WITH product_sales AS
(
SELECT s.*, p.division, p.segment, p.category, p.product, p.variant
FROM fact_sales_monthly s 
CROSS JOIN dim_product p ON s.product_code = p.product_code),

unique_products_2020 AS 
(SELECT DISTINCT product_code
FROM product_sales WHERE fiscal_year = '2020'),

unique_products_2021 AS 
(SELECT DISTINCT product_code
FROM product_sales WHERE fiscal_year = '2021')

SELECT 
(SELECT COUNT(*) FROM unique_products_2020) AS unique_products_2020,
(SELECT COUNT(*) FROM unique_products_2021) AS unique_products_2021,
ROUND(
((SELECT COUNT(*) FROM unique_products_2021)-
(SELECT COUNT(*) FROM unique_products_2020))*100.0/ 
(SELECT COUNT(*) FROM unique_products_2020), 2) AS percentage_chg;

/* 3. Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains
2 fields, segment, product_count */

SELECT  segment, COUNT(*) AS product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;

/* 4. Follow-up: Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment, product_count_2020, product_count_2021, difference */

WITH product_sales AS
(
SELECT s.fiscal_year, p.segment, p.product_code
FROM fact_sales_monthly s 
JOIN dim_product p ON s.product_code = p.product_code
),
product_2020 AS 
(SELECT segment, COUNT(DISTINCT product_code) AS c1
FROM product_sales WHERE fiscal_year = '2020' GROUP BY segment),
product_2021 AS 
(SELECT segment, COUNT(DISTINCT product_code) AS c2
FROM product_sales WHERE fiscal_year = '2021' GROUP BY segment)

SELECT pc1.segment, pc1.c1 AS product_count_2020, pc2.c2 AS product_count_2021,  (pc2.c2 - pc1.c1) AS difference
FROM product_2020 AS pc1 
JOIN  product_2021 AS pc2 ON pc1.segment = pc2.segment
ORDER BY difference DESC;

/* 5. Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields-  product_code, product, manufacturing_cost */

SELECT p.product_code, p.product, MAX(mc.manufacturing_cost) AS manufacturing_cost
FROM dim_product p JOIN fact_manufacturing_cost mc
ON p.product_code = mc.product_code
UNION
SELECT p.product_code, p.product, MIN(mc.manufacturing_cost) AS manufacturing_cost
FROM dim_product p JOIN fact_manufacturing_cost mc
ON p.product_code = mc.product_code;

/* 6. Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields, customer_code, customer, average_discount_percentage */

SELECT c.customer_code, c.customer, ROUND(AVG(pre.pre_invoice_discount_pct),3) AS average_discount_percentage
FROM dim_customer c JOIN fact_pre_invoice_deductions pre ON c.customer_code = pre.customer_code
WHERE pre.fiscal_year = '2021' AND market = 'India'
GROUP BY c.customer_code
ORDER BY average_discount_percentage DESC
LIMIT 5;

/* 7. Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns: Month, Year, Gross sales Amount */ 

WITH cte1 AS (
SELECT MONTHNAME(s.date) AS date_month,MONTH(s.date) AS month_no, YEAR(s.date) AS date_year, (g.gross_price * s.sold_quantity) AS gross_sales
FROM fact_sales_monthly s 
JOIN dim_customer c ON c.customer_code = s.customer_code
JOIN fact_gross_price g ON s.product_code = g.product_code
WHERE c.customer = 'Atliq Exclusive')

SELECT date_month, date_year, CONCAT(ROUND(SUM(gross_sales)/1000000,2),"M") AS gross_sales_amount
FROM cte1
GROUP BY date_year, date_month
ORDER BY date_year, month_no;

/* 8. In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity, Quarter, total_sold_quantity */

WITH cte AS (
    SELECT 
        date, QUARTER(DATE_ADD(date, INTERVAL 4 MONTH)) AS fiscal_quarter, fiscal_year, sold_quantity
    FROM fact_sales_monthly
)
SELECT 
    CONCAT('Q', fiscal_quarter) AS quarter,
    ROUND(SUM(sold_quantity) / 1000000, 2) AS total_sold_quantity
FROM cte
WHERE fiscal_year = 2020
GROUP BY fiscal_quarter
ORDER BY total_sold_quantity DESC;

/* 9. Which channel helped to bring more gross sales in the fiscal year 2021
and the percentage of contribution? The final output contains these fields,
channel, gross_sales_mln, percentage */


WITH cte AS (
SELECT c.channel AS channel, SUM(g.gross_price*s.sold_quantity) AS total_gross_sales
FROM fact_sales_monthly s 
JOIN fact_gross_price g ON s.product_code = g.product_code 
JOIN dim_customer c ON s.customer_code = c.customer_code
WHERE s.fiscal_year = 2021
GROUP BY c.channel)

SELECT channel, ROUND((total_gross_sales/1000000),2) AS gross_sales_mln,
ROUND(total_gross_sales/sum(total_gross_sales) OVER() *100,2) AS percentage
FROM cte
ORDER BY gross_sales_mln DESC;

/* 10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields, division, product_code , product, total_sold_quantity, rank_order */

WITH product_sales AS (
SELECT  p.division, p.product_code, p.product, SUM(s.sold_quantity) AS total_sold_quantity
FROM dim_product AS p 
JOIN fact_sales_monthly s 
ON p.product_code = s.product_code
WHERE s.fiscal_year = '2021'
GROUP BY p.division, p.product_code, p.product),

ranked_products AS(
SELECT division, product_code, product, total_sold_quantity,
RANK() OVER (partition by division ORDER BY total_sold_quantity DESC) AS rank_order
FROM product_sales)

SELECT division, product_code, product, total_sold_quantity, rank_order
FROM ranked_products
WHERE rank_order <= 3
ORDER BY division, rank_order, total_sold_quantity DESC;
