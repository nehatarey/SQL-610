select * from HumanResources.Department;

select * from HumanResources.EmployeeDepartmentHistory;--296 rows



select 
Hrs.LastName
, Hrs.FirstName
from HumanResources.[Hours] as Hrs , Person.Person as Per
where Hrs.LastName=Per.LastName 
and Hrs.FirstName = Per.FirstName
and Hrs.Jobtitle = Per.;

--1. Hours table has 233 rows, but it has no primary key 
SELECT * FROM [HumanResources].[Hours]
--2. Employee table has 290 rows
SELECT * FROM [HumanResources].[Employee]
--3. Join employee table with person.person, 290 rows
SELECT
Emp.BusinessEntityID
,Per.LastName + ', '+Per.FirstName as [Emp Name]
,Emp.JobTitle
from HumanResources.Employee as Emp
JOIN Person.Person  as Per on (Emp.BusinessEntityID=Per.BusinessEntityID)
order by BusinessEntityID desc;
--4. select name and job title from hours, 233 rows
SELECT
LastName + ', ' + FirstName as [Emp Name]
, Jobtitle
from HumanResources.[Hours]
--5. join the step 3 and step 4, 233 rows
SELECT
Emp.BusinessEntityID
,H.LastName + ', ' + H.FirstName as [Emp Name]
, H.Jobtitle
from HumanResources.[Hours] as H, Person.Person as Per, HumanResources.Employee as Emp
where H.LastName = Per.LastName
and H.FirstName = Per.FirstName
and Emp.BusinessEntityID=PEr.BusinessEntityID
order by H.LastName desc;

--ALTER the hours table to have business entity id
ALTER TABLE [HumanResources].[HOURS]
    add [BusinessEntityID] /*new_column_name*/ int /*new_column_datatype*/ NOT NULL /*new_column_nullability*/ DEFAULT 0
GO
--SELECT fromhours
-- Select rows from a Table or View '[TableOrViewName]' in schema '[dbo]'
SELECT 
BusinessEntityID
,LastName +', '+FirstName as [Emp Name]
,Jobtitle
FROM [HumanResources].[HOURS]
ORDER by LastName desc;

--UPDATE the table with business entity ids
UPDATE  H
    SET H.BusinessEntityID = Emp.BusinessEntityID
  from HumanResources.[Hours] as H, Person.Person as Per, HumanResources.Employee as Emp
where H.LastName = Per.LastName
and H.FirstName = Per.FirstName
and Emp.BusinessEntityID=PEr.BusinessEntityID;
       
--End of update

--see group by dept name
select 
--H.LastName + ', ' + H.FirstName as [Emp Name]
--,H.JobTitle
Dept.Name as [Department Name] -- 15 rows
,Dept.GroupName as [Dept Group] --6 tows
,Sum(Coalesce(Week1, 0)+Coalesce(Week2, 0)+Coalesce(Week3, 0)+Coalesce(Week4,0) )as [Monthly Hours]
, COUNT(H.BusinessEntityID) as [Emp count]
--,Dept.GroupName
--,EmpDept.StartDate
--,EmpDept.EndDate
from HumanResources.[Hours] as H
join HumanResources.Employee as Emp on (H.BusinessEntityID=Emp.BusinessEntityID)
join HumanResources.EmployeeDepartmentHistory as EmpDept on (Emp.BusinessEntityID=EmpDept.BusinessEntityID)
join HumanResources.Department as Dept on (EmpDept.DepartmentID=Dept.DepartmentID)
GROUP by Dept.Name ,Dept.GroupName
order by Sum(Coalesce(Week1, 0)+Coalesce(Week2, 0)+Coalesce(Week3, 0)+Coalesce(Week4,0) ) DESC
;
--How many employees are in R&D groupname
SELECT
Emp.BusinessEntityID
,EmpDept.StartDate
, EmpDept.EndDate
,EmpDept.ShiftID
,Dept.GroupName
,Dept.Name
from HumanResources.Employee as Emp
join HumanResources.EmployeeDepartmentHistory as EmpDept on (Emp.BusinessEntityID=EmpDept.BusinessEntityID)
join HumanResources.Department as Dept on (EmpDept.DepartmentID=Dept.DepartmentID)
where Dept.GroupName = 'Research and Development'
order by StartDate desc ; --15 employees and we only have 5 employees data
--From where am i getting 234 employees, Vong, William 224 left one place and joined another  thats why, so added new condition in where clause
select 
H.BusinessEntityID
,H.LastName + ', ' + H.FirstName as [Emp Name]
,H.JobTitle
,Dept.Name as [Department Name] -- 15 rows
,Dept.GroupName as [Dept Group] --6 tows
--,Sum(Coalesce(Week1, 0)+Coalesce(Week2, 0)+Coalesce(Week3, 0)+Coalesce(Week4,0) )as [Monthly Hours]
--, COUNT(H.BusinessEntityID) as [Emp count]
,Dept.GroupName
,EmpDept.StartDate
,EmpDept.EndDate
from HumanResources.[Hours] as H
join HumanResources.Employee as Emp on (H.BusinessEntityID=Emp.BusinessEntityID)
join HumanResources.EmployeeDepartmentHistory as EmpDept on (Emp.BusinessEntityID=EmpDept.BusinessEntityID)
join HumanResources.Department as Dept on (EmpDept.DepartmentID=Dept.DepartmentID)
where EmpDept.EndDate is NULL
order by Emp.BusinessEntityID

--GROUP by Dept.Name ,Dept.GroupName
--order by Sum(Coalesce(Week1, 0)+Coalesce(Week2, 0)+Coalesce(Week3, 0)+Coalesce(Week4,0) ) DESC
;