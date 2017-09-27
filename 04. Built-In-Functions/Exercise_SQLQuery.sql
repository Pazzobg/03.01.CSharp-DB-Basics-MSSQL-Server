---===Pr. 1===---

USE SoftUni

SELECT * FROM Employees

SELECT FirstName, LastName 
  FROM Employees
 WHERE FirstName LIKE 'sA%'

 ---===Pr. 2===---

SELECT FirstName, LastName 
  FROM Employees
 WHERE LastName LIKE '%ei%'
 
---===Pr. 3===---

SELECT FirstName
  FROM Employees
 WHERE DepartmentID IN (3, 10)
   AND HireDate BETWEEN '1995/01/01' AND '2005/12/31'


---===Pr. 3 (More solutions)===---

SELECT FirstName
  FROM Employees
 WHERE DepartmentID IN (3, 10)
   AND HireDate BETWEEN '1994' AND '2006'

SELECT FirstName
  FROM Employees
 WHERE DepartmentID IN (3, 10)
   AND DATEPART(YY, HireDate) BETWEEN '1995' AND '2005'

---===Pr. 4===---

SELECT FirstName, LastName	
  FROM Employees
 WHERE NOT JobTitle LIKE '%engineer%'

---===Pr. 5===---

SELECT * FROM Towns

SELECT Name 
  FROM Towns 
 WHERE LEN(Name) IN (5, 6)
 ORDER BY Name
 
---===Pr. 6===---

SELECT TownId, Name 
  FROM Towns
 WHERE Name LIKE '[MKBE]%'
 ORDER BY Name
 
---===Pr. 7===---

SELECT TownId, Name 
  FROM Towns
 WHERE Name LIKE '[^RBD]%'
 ORDER BY Name

---===Pr. 8===---

GO

CREATE VIEW v_EmployeesHiredAfter2000 AS
SELECT FirstName, 
	   LastName 
  FROM Employees
 WHERE DATEPART(YY, HireDate) > 2000

GO

---===Pr. 9===---

SELECT FirstName, 
	   LastName
  FROM Employees
 WHERE LEN(LastName) = 5

---===Pr. 10===---

USE Geography

SELECT * FROM Countries

SELECT CountryName, 
	   ISOCode 
  FROM Countries
 WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'a', '')) >= 3
 ORDER BY IsoCode

---===Pr. 11===---
SELECT * FROM Peaks
SELECT * FROM Rivers

SELECT p.PeakName, 
	   r.RiverName,
	   LOWER(CONCAT(SUBSTRING(p.PeakName, 1, (LEN(p.PeakName) - 1)), r.RiverName)) AS [Mix]
  FROM Peaks AS p, Rivers AS r
 WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
 ORDER BY [Mix]

---===Pr. 12===---

USE Diablo

SELECT Name, Start FROM Games

SELECT TOP(50)
	   Name AS [Game], 
	   FORMAT(Start, 'yyyy-MM-dd') AS [Start]
  FROM Games
 WHERE [Start] BETWEEN '2011-01-01' AND '2012-12-31'
 ORDER BY Start, Name

---===Pr. 13===---

SELECT * FROM USERS

SELECT Username, 
	   RIGHT(Email, (LEN(Email) - CHARINDEX('@', Email))) as [Email Provider]
  FROM Users
ORDER BY [Email Provider], Username
 
---===Pr. 14===---

SELECT Username, 
	   IpAddress 
  FROM Users
 WHERE IpAddress LIKE '___.1%.%.___'
 ORDER BY Username
  
---===Pr. 15===---

SELECT * FROM Games
SELECT CAST([Start] as time) FROM Games

SELECT Name, 
CASE
	WHEN CAST(Start as time) >= '00:00:00' AND CAST(Start as time) < '12:00:00'  
		THEN 'Morning'
	WHEN CAST(Start as time) >= '12:00:00' AND CAST(Start as time) < '18:00:00'  
		THEN 'Afternoon'
	WHEN CAST(Start as time) >= '18:00:00' AND CAST(Start as time) <= '23:59:59'  
		THEN 'Evening'
END AS [Part of the day],
CASE 
	WHEN Duration <= 3 
		THEN 'Extra Short'
	WHEN Duration <= 6 
		THEN 'Short'
	WHEN Duration > 6 
		THEN 'Long' 
	WHEN Duration IS NULL 
		THEN 'Extra Long'
END AS [Duration]
FROM Games
ORDER BY Name, [Duration]

---===Pr. 16===---

USE Orders

SELECT * FROM Orders

SELECT ProductName, 
	   OrderDate, 
	   DATEADD(DD, 3, OrderDate) AS [Pay Due],
	   DATEADD(MM, 1, OrderDate) AS [Deliver Due]
  FROM Orders
  
---===Pr. 17===---

CREATE TABLE People (
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(50) NOT NULL, 
	Birthdate DATETIME NOT NULL, 
	CONSTRAINT PK_Id PRIMARY KEY (Id)
)

INSERT INTO People VALUES
('Victor', '2000-12-07'), 
('Steven', '1992-09-10'),
('Stephen', '1910-09-19'),
('John', '2010-01-06')

SELECT Name, 
DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
FROM People