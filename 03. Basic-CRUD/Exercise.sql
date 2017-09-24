---===Pr. 1===---

USE SoftUni

---===Pr. 2===---

SELECT * FROM Departments

---===Pr. 3===---

SELECT [Name] FROM Departments 

---===Pr. 4===---

SELECT * FROM Employees

SELECT FirstName, LastName, Salary FROM Employees

---===Pr. 5===---

SELECT FirstName, MiddleName, LastName FROM Employees

---===Pr. 6===---

SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address] from Employees

---===Pr. 7===---

SELECT DISTINCT Salary FROM Employees

---===Pr. 8===---

SELECT * FROM Employees
WHERE JobTitle = 'Sales Representative'

---===Pr. 9===---

SELECT FirstName, LastName, JobTitle FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

---===Pr. 10===---

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name] FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

---===Pr. 11===---

SELECT FirstName, LastName FROM Employees
WHERE ManagerID IS NULL

---===Pr. 12===---

SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

---===Pr. 13===---

SELECT TOP 5 FirstName, LastName FROM Employees
ORDER BY Salary DESC

---===Pr. 14===---

SELECT FirstName, LastName FROM Employees
WHERE NOT (DepartmentID = 4)

---===Pr. 15===---

SELECT * FROM Employees
ORDER BY Salary DESC, 
		 FirstName,
		 LastName DESC,
		 MiddleName 

---===Pr. 16===---

GO 

CREATE VIEW V_EmployeesSalaries AS 
SELECT FirstName, LastName, Salary FROM Employees

GO

---===Pr. 17===---

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], 
	   JobTitle AS [Job Title]
  FROM Employees

GO

---===Pr. 17 SECOND SOLUTION===---

GO
CREATE VIEW V_EmployeeNameJobTitle  AS
SELECT FirstName + ' ' + 
CASE 
	WHEN MiddleName IS NULL THEN ''
	ELSE MiddleName
END + ' ' + LastName AS [Full name], 
	  JobTitle AS [Job Title]
FROM Employees

GO

---===Pr. 18===---

SELECT DISTINCT JobTitle FROM Employees

---===Pr. 19===---

SELECT TOP 10 * FROM Projects
ORDER BY StartDate, Name

---===Pr. 20===---

SELECT TOP 7 FirstName, LastName, HireDate FROM Employees
ORDER BY HireDate DESC

---===Pr. 21===---

SELECT * FROM Employees
SELECT * FROM Departments

UPDATE Employees
SET Salary += Salary * 0.12
WHERE (DepartmentID = 1 OR DepartmentID = 2 OR DepartmentID = 4 OR DepartmentID = 11)

SELECT Salary FROM Employees

---===Pr. 22===---

USE Geography

SELECT * FROM Peaks
SELECT PeakName FROM Peaks
ORDER BY PeakName

---===Pr. 23===---

SELECT TOP 30 CountryName, Population FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY Population DESC, CountryName 

---===Pr. 24===---

SELECT CountryName, CountryCode, 
CASE 
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	ELSE 'Not Euro'
END AS [Currency]
FROM Countries
ORDER BY CountryName

---===Pr. 25===---

USE Diablo

SELECT Name FROM Characters
ORDER BY Name