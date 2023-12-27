CREATE DATABASE paytm_epurchase ;
USE paytm_epurchase ; 
CREATE TABLE paytm (
`S.no` INTEGER,
`Name` VARCHAR(50),	
Shipping_city	VARCHAR(50),
Category_Grouped	VARCHAR(50),
Category	VARCHAR(50),
Sub_category	VARCHAR(50),
Product_Gender	VARCHAR(50),
Segment	VARCHAR(50),
Class	VARCHAR(50),
Family	VARCHAR(50),
Brand	VARCHAR(50),
Brick	VARCHAR(50),
Item_NM	VARCHAR(100),
Color VARCHAR(20),
Size VARCHAR(20),	
Sale_Flag VARCHAR(25),	
Payment_Method VARCHAR(20),	
coupon_money_effective	FLOAT,
Coupon_Percentage	INTEGER,
Quantity INTEGER,
Cost_Price FLOAT,
Item_Price INTEGER,
Special_Price_effective	FLOAT,
paid_pr_effective FLOAT,	
Value_CM1 FLOAT,	
Value_CM2 FLOAT,	
Special_price INTEGER,	
Paid_pr INTEGER
);
SELECT COUNT(*) FROM paytm;

-- checking for  duplicates
SELECT `S.no`, COUNT(`S.no`),`Name`
FROM paytm
GROUP BY `S.no`
HAVING COUNT(`S.no`) > 1;

# In our data there are to many missing values in 'Category_Grouped' column we first fill the null values using mode values
UPDATE paytm
SET  Category_Grouped = NULL
WHERE  Category_Grouped = '';

# find the mode 
 SELECT Category_Grouped
  FROM paytm
  WHERE Category_Grouped IS NOT NULL
  GROUP BY Category_Grouped
  ORDER BY COUNT(Category_Grouped) DESC
  LIMIT 1;
  -- here we get mode as 'Others' 
  
UPDATE paytm
JOIN (
  SELECT Category_Grouped
  FROM paytm
  WHERE Category_Grouped IS NOT NULL
  GROUP BY Category_Grouped
  ORDER BY COUNT(Category_Grouped) DESC
  LIMIT 1
) AS ModeQuery ON paytm.Category_Grouped IS NULL
SET paytm.Category_Grouped = ModeQuery.Category_Grouped;
SELECT *
FROM paytm
WHERE Category_Grouped IS NULL;

# 1) How many unique categories are there?

SELECT Category_Grouped FROM paytm GROUP BY Category_Grouped;

# 2)  List the top 5 shipping cities in terms of the number of orders?
SELECT shipping_city, COUNT(*) AS OrderCount 
FROM paytm 
GROUP BY shipping_city 
ORDER BY OrderCount DESC 
LIMIT 5;

# 3)  Show me a table with all the data for products that belong to the "Electronics" category.
SELECT * FROM paytm 
WHERE Category = 'Electronics';
-- There is no data for products that belong to the "Electronics" category

# 4) Filter the data to show only rows with a "Sale_Flag" of 'Yes'.
SELECT * FROM paytm WHERE Sale_Flag = 'On Sale';

# 5) Sort the data by "Item_Price" in descending order. What is the most expensive item?
SELECT * FROM paytm ORDER BY Item_Price DESC LIMIT 1;

# 6) Apply conditional formatting to highlight all products with a "Special_Price_effective" value below $50 in red 
SELECT * FROM paytm WHERE Special_Price_effective < 50;

# 7) Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender."
SELECT Product_Gender, AVG(Quantity) AS AvgQuantity
FROM paytm
WHERE Category_Grouped = 'Apparels'
GROUP BY Product_Gender;

# 8) Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios.
SELECT
    *,
    Value_CM1 / Value_CM2 AS CM_Ratio
FROM
     paytm
ORDER BY
    CM_Ratio DESC
LIMIT 5;

# 9) Identify the top 3 "Class" categories with the highest total sales.
SELECT Class, SUM(Item_Price * Quantity) AS TotalSales
FROM paytm
GROUP BY Class
ORDER BY TotalSales DESC
LIMIT 3;

#  Identify products with a "Paid_pr" higher than the average in their respective "Family" and "Brand" groups.

SELECT
    t.`S.no`,
    t.`Name`,
    t.Family,
    t.Brand,
    t.Paid_pr
FROM
    paytm t
JOIN (
    SELECT
        Family,
        Brand,
        AVG(Paid_pr) AS AvgPaid_pr
    FROM
        paytm
    GROUP BY
        Family, Brand
) AS avg_table ON t.Family = avg_table.Family AND t.Brand = avg_table.Brand
WHERE
    t.Paid_pr > avg_table.AvgPaid_pr;

