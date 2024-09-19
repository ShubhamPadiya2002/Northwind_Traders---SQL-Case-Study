CREATE DATABASE northwind_trd;

USE northwind_trd;

SELECT * FROM order_details;

ALTER TABLE order_details
ADD COLUMN Sales Decimal;

UPDATE order_details
SET Sales = (unitPrice-(unitPrice*discount)) * quantity;


----------------------------------------

# LIST OUT COMPANY'S NAME & THEIR TOTAL SALES.

SELECT s.companyName,sum(Sales) AS 'Total Sales' FROM order_details AS od
JOIN orders AS o ON o.orderID = od.orderID
JOIN shippers AS s ON o.shipperID = s.shipperID
GROUP BY s.companyName; 

# LIST OUT NAME OF CUSTOMER WHOSE SALES ORDER IS MORE THAN 50.

SELECT c.contactName,count(*) AS No_f_orders FROM order_details AS od
JOIN orders AS o ON o.orderID = od.orderID
JOIN customers AS c ON c.customerID = o.customerID
GROUP BY c.contactName
HAVING No_f_orders > 50;

# FIND OUT TOP 5 PRODUCT BASED ON 'NO OF ORDERS'.

SELECT p.productName,count(*) AS No_f_orders FROM order_details AS od
JOIN products AS p ON p.productID = od.productID
GROUP BY p.productName
ORDER BY No_f_orders DESC
LIMIT 5;

# LIST DOWN PRODUCT CATEGORY WITH THEIR AVGERAGE PRICE.

SELECT c.categoryName,avg(unitPrice) AS 'Avg_Price' FROM products AS p
JOIN categories AS c ON c.categoryID = p.categoryID
GROUP BY c.categoryName; 

# LIST DOWN THE NAME OF PRODUCT WHICH COME UNDER CATEGORY OF BEVERAGES AND ALSO NO_OF_ORDER MORE THAN 40.

SELECT p.ProductName , count(o.orderID) AS No_f_order FROM order_details AS o
JOIN products AS p ON o.productID = p.productID
JOIN categories AS c ON p.categoryID = c.categoryID
WHERE c.categoryName = 'Beverages'
GROUP BY p.ProductName
HAVING No_f_order > 40;

# SHOW THE LIST OF CATEGORY WITH RESEPECTIVE TO THEIR MAX PRICE OF EACH CATEGORY.

SELECT c.categoryName ,max(p.unitPrice) AS 'Max Price' FROM products AS p
JOIN categories AS c ON p.categoryID = c.categoryID
GROUP BY c.categoryName;

# LIST THE NAME OF COMPANIES WHICH CONTACT PERSON IS EITHER 'OWNER' OR 'SALES MANAGER'

SELECT companyName  FROM customers AS c
WHERE contactTitle = 'Owner' OR contactTitle = 'Sales Manager';

# SHOW THE NAMES OF PRODUCT WHICH PER UNIT PRICE IS BETWEEN 50 TO 100.

SELECT productName FROM products
WHERE unitPrice BETWEEN 50 AND 100;

# LIST OUT THE NAME OF PRODUCT WHICH UNIT_PRICE IS MORE THAN HIGHEST UNIT_PRICE OF CATEGORYID 3.

SELECT productName FROM products
WHERE unitPrice > (SELECT max(unitPrice) FROM products WHERE categoryID = 3);

# DISPLAY THE NAME OF PRODUCTS WHICH UNIT_PRICE IS MORE THAN HIGHEST UNIT_PRICE OF CATEGORY 'CONFECTIONS'.

SELECT productName FROM products AS p
WHERE unitPrice > 
              (SELECT max(unitPrice) FROM products AS p
              JOIN categories AS c ON p.categoryID = c.categoryID
			  WHERE categoryName = 'Confections');


# Find out the customer Name who sales higher than the average sales of their country.

WITH CustomerSales AS (
    SELECT 
        contactName,
        country,
        SUM(od.Sales) AS indiv_clt_sale
    FROM 
        order_details AS od
    JOIN 
        orders AS o ON od.orderID = o.orderID
    JOIN 
        customers AS c ON o.customerID = c.customerID
    GROUP BY 
        contactName, c.country
),
CountryAverageSales AS (
    SELECT
        country,
        AVG(cs.indiv_clt_sale) AS avg_country_sales
    FROM
        CustomerSales AS cs
    GROUP BY
        cs.country
)
SELECT 
    cs.contactName,
    cs.indiv_clt_sale
FROM 
    CustomerSales AS cs
JOIN 
    CountryAverageSales AS cas ON cs.country = cas.country
WHERE 
    cs.indiv_clt_sale > cas.avg_country_sales;

---------------------------------------------------------------

# HOW MUCH SALES (%) OF DAIRY PRODUCT AMOUNG ALL PRODUCT CATEGORY ?

SELECT c.CategoryName , concat(round((sum(Sales) / (SELECT sum(Sales) FROM order_details) * 100),2),'%') AS 'Sales Percent(%)'
FROM order_details AS o
JOIN  products AS p ON o.productID  = p.productID
JOIN categories AS c ON p.categoryID = c.categoryID
GROUP BY c.CategoryName; 


------------------------------------------------------------------

# WHICH MONTHS IN 2014 HAVE SALES MORE THAN THE AVERAGE MONTHLY SALES OF 2014 YEAR.

SELECT month(orderDate) as monthno ,monthname(orderDate) AS monthnam ,sum(Sales) AS Sales1 FROM order_details AS od
JOIN orders AS o ON od.orderID  = o.orderID
WHERE year(orderDate) = 2014
GROUP BY monthno ,monthnam
HAVING Sales1 > 
               (SELECT sum(Sales)/12 FROM order_details AS od
				JOIN orders AS o ON od.orderID  = o.orderID
                WHERE year(orderDate) = 2014);














