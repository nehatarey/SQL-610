/*--QUESTION 1*/
/* START of stored proc Employees */
USE AdventureWorks2016;  
GO
CREATE PROCEDURE dbo.uspEmployees
AS
SET NOCOUNT ON
SELECT
    E.BusinessEntityID AS 'Employee ID'
        , E1.LastName +', ' + E1.FirstName AS 'Employee Name'
     --, E.TeamName
        , M1.LastName as 'Manager Last Name'
        , E.JobTitle
        , E.HireDate
        , E.SickLeaveHours
        , E.VacationHours
        , E.BirthDate

From HumanResources.Employee E
    Join HumanResources.Employee M
    on E.EmployeeManagerID = M.ManagerID
    Join Person.Person E1
    on E.BusinessEntityID = E1.BusinessEntityID
    Join Person.Person M1
    on M.BusinessEntityID = M1.BusinessEntityID
Where M.ManagerID Is Not Null And E.JobTitle Not Like 'Vice%'
and M1.LastName = 'Tamburello'
Order by E.TeamName, E.BusinessEntityID;
GO
/* End of stored proc Employees */
exec dbo.uspEmployees;
--enf of question 1
--may be name the stored proc as uspGetEmployees
--Alternative approach
/*--QUESTION 1*/
/* START of stored proc Employees */
USE AdventureWorks2016;  
GO
CREATE PROCEDURE dbo.uspGetEmployees
AS
SET NOCOUNT ON
SELECT 
    *
    FROM HumanResources.Employee;
GO
--END
EXEC dbo.uspGetEmployees;
--Question 2

USE AdventureWorks2016;  
GO
ALTER PROCEDURE dbo.uspGetEmployees  @JobTitle nvarchar(30) = NULL
AS
SET NOCOUNT ON
SELECT 
    Emp.BusinessEntityID
    , PER.FirstName + ' ' + Per.LastName as EmployeeName 
    , Emp.JobTitle
    FROM HumanResources.Employee as Emp
    join Person.Person as Per on (Emp.BusinessEntityID = Per.BusinessEntityID)
    Where JobTitle = ISNULL(@JobTitle, 'Design Engineer');
GO
--END
EXEC dbo.uspGetEmployees;
--or
EXEC dbo.uspGetEmployees @JobTitle = 'Senior Tool Designer';
--or
EXEC dbo.uspGetEmployees 'Engineering Manager';
/*******END OF QUESTION 2*****************************/
USE AdventureWorks2016;  
GO
CREATE FUNCTION  dbo.uspGetEmployees  @JobTitle nvarchar(30) = NULL
AS
SET NOCOUNT ON
SELECT 
    *
    FROM HumanResources.Employee
    Where JobTitle = ISNULL(@JobTitle, 'Design Engineer');
GO
--QUESTION THREE
USE AdventureWorks2016;  
GO
CREATE PROCEDURE dbo.uspGetEmployeeTimeOff  
@FirstName nvarchar(30) = NULL, 
@LastName nvarchar(30) = NULL
AS
SET NOCOUNT ON
SELECT
    PER.FirstName + ' ' + Per.LastName as EmployeeName -- add emp id
    , Emp.VacationHours -- add no. of sick leaves availed, no. of vacation days availed
    , Emp.SickLeaveHours
FROM HumanResources.Employee AS Emp
JOIN Person.Person AS Per ON (EMP.BusinessEntityID = Per.BusinessEntityID)
WHERE Per.FirstName = @FirstName
and Per.LastName = @LastName;

GO
--Executing the procedure
EXEC uspGetEmployeeTimeOff; --returns zero records
EXEC uspGetEmployeeTimeOff 'Karen', 'Berge';
EXEC dbo.uspGetEmployeeTimeOff 
/* think about changing the parameters to conditonal