/*Begin Q1*/
SELECT
    PP.Name as [Product Name]
    , PP.DaysToManufacture
    , CASE 
        WHEN PP.DaysToManufacture < 4 THEN 'Under 4 days'
        WHEN PP.DaysToManufacture >= 4 THEN 'More than 4 days'
        ELSE 'Not sufficient info'
    END AS [Timeframe]
from Production.Product PP
where PP.DaysToManufacture <> 0
ORDER BY  PP.DaysToManufacture DESC;
/*End Q1*/
/*Begin Q2*/
--Considering only the products that require more than 0 days to manufacture
SELECT
    COUNT(CASE WHEN PP.DaysToManufacture < 4 THEN 1 ELSE NULL END) as 'Under 4 days',
    COUNT(CASE WHEN PP.DaysToManufacture >= 4 THEN  1 ELSE NULL END) as 'More than 4 days'
from Production.Product PP
where PP.DaysToManufacture <> 0;
--From the Sales Order tables, first checking the count

SELECT COUNT(*) 
FROM Production.Product PP
    JOIN Sales.SalesOrderDetail SOD ON (SOD.ProductID=PP.ProductID)
WHERE PP.DaysToManufacture <> 0 
-- Above query with FILTER gives count=58723

--Case query
SELECT
    CASE 
        WHEN PP.DaysToManufacture < 4 THEN 'Under 4 days'
        WHEN PP.DaysToManufacture >= 4 THEN 'More than 4 days'
        ELSE 'Not sufficient info'
       END AS [Timeframe]
    , COUNT(SOD.ProductID) AS TotalPRoducts
FROM Production.Product PP
    JOIN Sales.SalesOrderDetail SOD ON (SOD.ProductID=PP.ProductID)
WHERE PP.DaysToManufacture <> 0
GROUP by CASE 
        WHEN PP.DaysToManufacture < 4 THEN 'Under 4 days'
        WHEN PP.DaysToManufacture >= 4 THEN 'More than 4 days'
        ELSE 'Not sufficient info'
        END
/*End Q2*/
/*Begin Q3*/
SELECT * from Sales.SalesTerritory;--Shows 5 US territories
SELECT * from Person.StateProvince WHERE CountryRegionCode = 'US';-- shows 53 
--Only considering US states- 51 and DC, NYC: hence 53
SELECT
    SP.TerritoryID
    , SP.Name
    ,SP.CountryRegionCode
    , CASE 
        WHEN SP.TerritoryID = 1  THEN 'Western Market'
        WHEN SP.TerritoryID = 2  THEN 'North Eastern Market'
        WHEN SP.TerritoryID = 3  THEN 'Mid-Western Market'
        WHEN SP.TerritoryID = 4  THEN 'South Western Market'
        WHEN SP.TerritoryID = 5  THEN 'South Eastern Market'
        ELSE 'UNKNOWN'
        END AS [Market]
FROM Person.StateProvince AS SP
WHERE SP.TerritoryID BETWEEN 1 and 5
    AND SP.CountryRegionCode = 'US'
ORDER BY SP.TerritoryID;
--OR

SELECT
    SP.TerritoryID
    , SP.Name
    , CASE 
        WHEN SP.TerritoryID IN (1,2,4,5) THEN ST.Name+'ern Market'
        WHEN SP.TerritoryID = 3  THEN 'Mid-Western Market'
        ELSE 'UNKNOWN'
        END AS [Market]
FROM Person.StateProvince AS SP
    JOIN Sales.SalesTerritory AS ST ON (SP.TerritoryID=ST.TerritoryID)
WHERE SP.TerritoryID BETWEEN 1 and 5
    AND SP.CountryRegionCode = 'US'
ORDER BY SP.TerritoryID;
/*END Q3*/

---Q4

SELECT
    ST.TerritoryID
    , CASE 
        WHEN ST.TerritoryID IN (1,2,4,5) THEN ST.Name+'ern Market'
        WHEN ST.TerritoryID = 3  THEN 'Mid-Western Market'
        ELSE 'UNKNOWN'
        END AS [Market]
--INTO #SalesTerritoryReport_2
    , ST.SalesYTD
FROM Sales.SalesTerritory AS ST
WHERE ST.TerritoryID BETWEEN 1 and 5
ORDER BY ST.TerritoryID;

SELECT
    ST.TerritoryID
    , CASE 
        WHEN ST.TerritoryID= 1  THEN 'Western Market'
        WHEN ST.TerritoryID = 2  THEN 'North Eastern Market'
        WHEN ST.TerritoryID = 3  THEN 'Mid-Western Market'
        WHEN ST.TerritoryID = 4  THEN 'South Western Market'
        WHEN ST.TerritoryID = 5  THEN 'South Eastern Market'
        ELSE 'UNKNOWN'
        END AS [Market]
    , ST.SalesYTD AS [Year to Date Sales]
FROM Sales.SalesTerritory AS ST 
WHERE ST.TerritoryID BETWEEN 1 and 5
    AND ST.CountryRegionCode = 'US'
ORDER BY ST.TerritoryID;

SELECT * from Sales.SalesTerritory;--Shows 5 US territories
SELECT * from Person.StateProvince WHERE CountryRegionCode = 'US';-- shows 53 
--Only considering US states- 51 and DC, NYC: hence 53
SELECT * from Sales.SalesPerson;
/*Begin Q5*/
SELECT
    Sum(SOH.TotalDue) as StateTotal
    ,Addr.StateProvinceID
    ,SP.Name
    , CASE 
        WHEN SOH.TerritoryID= 1  THEN 'Western Market'
        WHEN SOH.TerritoryID = 2  THEN 'North Eastern Market'
        WHEN SOH.TerritoryID = 3  THEN 'Mid-Western Market'
        WHEN SOH.TerritoryID = 4  THEN 'South Western Market'
        WHEN SOH.TerritoryID = 5  THEN 'South Eastern Market'
        ELSE 'UNKNOWN'
        END AS [Market]
from 
sales.SalesOrderHeader as SOH
join Person.Address as Addr on (SOH.BillToAddressID=Addr.AddressID)
join Person.StateProvince as SP on (Addr.StateProvinceID=SP.StateProvinceID)
WHERE 
    SP.CountryRegionCode = 'US' 
    and SOH.TerritoryID in (1, 2, 3, 4, 5)
    and SOH.OrderDate BETWEEN '2014-01-01' and '2014-06-30'
GROUP by Addr.StateProvinceID, SP.Name,SOH.TerritoryID, SP.CountryRegionCode
ORDER by SOH.TerritoryID;
/*End Q5*/

SELECT * from Sales.SalesOrderHeader where 
TerritoryID in (1, 2, 3, 4, 5)
and OrderDate BETWEEN '2014-01-01' and '2014-06-30'
order by OrderDate desc
--4366 rows
select * from Person.Address