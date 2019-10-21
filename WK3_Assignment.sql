--q1
SELECT TD.EmployeeID, TD.Donation
INTO #TotalDonations
FROM--
    (                                    SELECT EmployeeID, Donation
        FROM Month1
    UNION ALL
        SELECT EmployeeID, Donation
        FROM Month2
    UNION ALL
        SELECT EmployeeID, Donation
        FROM Month3) AS TD
;

SELECT count(*) as [# Of Donations]
from #TotalDonations;
SELECT EmployeeID, Donation
from #TotalDonations;
--Q2--
SELECT DM.Donations, DM.Month
INTO #DonationsbyMonth
FROM
    (   
        SELECT Sum(Donation) AS [Donations], 'Month1' as [Month]
        FROM Month1
    UNION ALL
        SELECT sum(Donation) AS [Donations], 'Month2' as [Month]
        FROM Month2
    UNION ALL
        SELECT SUM(Donation) AS [Donations], 'Month3' as [Month]
        FROM Month3 
) AS DM;
SELECT * FROM #DonationsbyMonth;
SELECT
    SUM(Donations) AS TotalDonations
FROM #DonationsbyMonth; 

--Q3--
SELECT COUNT(*) as Count from #TotalDonations; --354
SELECT count(Distinct EmployeeID) from #TotalDonations; --225

SELECT count(Distinct EmployeeID) from Month1; --Result 107
SELECT count(EmployeeID) from Month1;--Result 107
SELECT count(Distinct EmployeeID) from Month2; -- Result 126
SELECT count(EmployeeID) from Month2; --Result 126
SELECT count(Distinct EmployeeID) from Month3; --Result 120
SELECT count(EmployeeID) from Month3; --Result 121

DROP TABLE IF EXISTS #TotalDonations;
SELECT TD.EmployeeID, TD.Donation
INTO #TotalDonations
FROM
    (                                    
        SELECT EmployeeID, Donation
        FROM Month1
    UNION 
        SELECT EmployeeID, Donation
        FROM Month2
    UNION 
        SELECT EmployeeID, Donation
        FROM Month3
    ) AS TD
;--results in 323 rows, that is also not correct
SELECT * from #TotalDonations;




DROP TABLE IF EXISTS #TotalDonations;
SELECT TD.EmployeeID, TD.Donation
INTO #TotalDonations
FROM
    (                                    
        SELECT DISTINCT EmployeeID, Donation
        FROM Month1
    UNION ALL
        SELECT DISTINCT EmployeeID, Donation
        FROM Month2
    UNION ALL
        SELECT DISTINCT EmployeeID, Donation
        FROM Month3
    ) AS TD
;--353 ROWS
SELECT
    SUM(Donations) AS TotalDonations_Old
FROM #DonationsbyMonth;
SELECT
    SUM(Donation) as TotalDonations_Amended
from #TotalDonations; --old= 38425 new = 38325
--End of Q3


SELECT *
from HumanResources.EmployeePayHistory AS EPH
where EPH.BusinessEntityID = (SELECT BusinessEntityID
from HumanResources.Employee
where NationalIDNumber = '486228782')

