Script 1: Duplicate_Record_Finder

SELECT Email,
       COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

Script 2: Top_10_Customers
SELECT TOP 10 CustomerID,
       SUM(Amount) AS Revenue
FROM Orders
GROUP BY CustomerID
ORDER BY Revenue DESC;

Script 3: Monthly_Sales_Report

SELECT YEAR(OrderDate) AS SalesYear,
       MONTH(OrderDate) AS SalesMonth,
       SUM(Amount) AS TotalSales
FROM Orders
GROUP BY YEAR(OrderDate),
         MONTH(OrderDate);
