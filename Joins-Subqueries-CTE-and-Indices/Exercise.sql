---===Pr. 1===---

USE SoftUni

SELECT TOP 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText 
  FROM Employees AS e
  JOIN Addresses AS a ON a.AddressID = e.AddressID
 ORDER BY e.AddressID

---===Pr. 2===---

SELECT TOP 50 e.FirstName, e.LastName, t.Name, a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a ON a.AddressID = e.AddressID
  JOIN Towns AS t ON t.TownID = a.TownID
 ORDER BY e.FirstName, e.LastName

---===Pr. 3===---

SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name AS [DepartmentName]
  FROM Employees AS e
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
 WHERE d.Name = 'Sales'

---===Pr. 4===---

SELECT TOP 5 e.EmployeeID, e.FirstName, e.Salary, d.Name AS [DepartmentName]
  FROM Employees AS e
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
 WHERE e.Salary > 15000
 ORDER BY d.DepartmentID

---===Pr. 5===---

SELECT TOP 3 e.EmployeeID, e.FirstName 
  FROM Employees AS e
  LEFT JOIN EmployeesProjects as ep ON ep.EmployeeID = e.EmployeeID
 WHERE ep.ProjectID IS NULL
 ORDER BY e.EmployeeID

---===Pr. 6===---

SELECT e.FirstName, e.LastName, e.HireDate, d.Name AS [DeptName]
  FROM Employees AS e
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
 WHERE d.Name IN ('Sales', 'Finance')
--  OR WHERE d.DepartmentID IN (3, 10) 
   AND e.HireDate > '1999-01-01'

---===Pr. 7===---

SELECT TOP 5 
	   e.EmployeeID, 
	   e.FirstName, 
	   p.Name AS [ProjectName] 
  FROM Employees AS e
  JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p ON ep.ProjectID = p.ProjectID
 WHERE p.StartDate > '2002/08/13' AND p.EndDate IS NULL
 ORDER BY e.EmployeeID
 
---===Pr. 8===---

SELECT e.EmployeeID, 
	   e.FirstName, 
	   CASE
			WHEN p.StartDate > '2005-01-01' THEN NULL
			ELSE p.Name
	   END AS [ProjectName]
  FROM Employees AS e
  JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p ON ep.ProjectID = p.ProjectID
 WHERE e.EmployeeID = 24

---===Pr. 9===---

SELECT e.EmployeeID, e.FirstName, m.EmployeeID AS [ManagerId], m.FirstName 
  FROM Employees AS e
  JOIN Employees AS m ON e.ManagerID = m.EmployeeID
 WHERE e.ManagerID IN (3, 7)
 ORDER BY e.EmployeeID

---===Pr. 10===---

SELECT TOP 50 
	   e.EmployeeID, 
	   e.FirstName + ' ' + e.LastName as [EmployeeName], 
	   m.FirstName + ' ' + m.LastName AS [ManagerName], 
	   d.Name AS [DepartmentName] 
  FROM Employees AS e
  JOIN Employees AS m ON m.EmployeeID = e.ManagerID
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
 ORDER BY e.EmployeeID

---===Pr. 11===---

SELECT MIN(AvgDeptsSals.AvgSalary) AS [MinAverageSalary] 
  FROM (
	    SELECT DepartmentID, AVG(SALARY) AS [AvgSalary]
	      FROM Employees
	     GROUP BY DepartmentID
	   ) AS AvgDeptsSals

---===Pr. 12===---

USE Geography

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation 
  FROM Mountains AS m
  JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
  JOIN Peaks AS p ON p.MountainId = m.Id
 WHERE mc.CountryCode = 'BG'
   AND p.Elevation > 2835
 ORDER BY p.Elevation DESC
 
---===Pr. 13===---

SELECT mc.CountryCode, COUNT(MountainRange) AS [MountainRanges]
  FROM Mountains AS m
  JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
 GROUP BY mc.CountryCode
HAVING mc.CountryCode IN ('BG', 'RU', 'US')

---===Pr. 14===---

SELECT TOP 5 c.CountryName, r.RiverName 
  FROM Countries AS c
  LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
  LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
 WHERE c.ContinentCode = 'AF'
 ORDER BY c.CountryName

---===Pr. 15===---

SELECT ct.ContinentCode, 
	   ct.CurrencyCode, 
	   ct.CurrencyUsage 
  FROM (
		SELECT c.ContinentCode, 
			   c.CurrencyCode, 
			   COUNT(c.CurrencyCode) AS [CurrencyUsage], 
			   DENSE_RANK() OVER(PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) as [Ranking]
		FROM Countries AS c
		JOIN Currencies AS curr ON curr.CurrencyCode = c.CurrencyCode
		GROUP BY c.CurrencyCode, c.ContinentCode
		HAVING COUNT(c.CurrencyCode) > 1
	   ) AS ct
 WHERE Ranking = 1
 ORDER BY ct.ContinentCode --works as well without this ordering

---===Pr. 16===---

SELECT COUNT(C.CountryCode) AS [CountryCode] 
  FROM Countries AS c
  LEFT JOIN MountainsCountries AS m ON m.CountryCode = c.CountryCode
 WHERE m.MountainId IS NULL

---===Pr. 17===---

SELECT TOP 5 
	   FullTable.CountryName, 
	   FullTable.HighestPeakElevation, 
	   FullTable.LongestRiverLength 
  FROM (
	   SELECT c.CountryName, 
			  p.Elevation AS [HighestPeakElevation], 
			  r.Length AS [LongestRiverLength], 
			  DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC, r.Length DESC) AS [Ranking]
		 FROM Countries AS c
		 LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
		 LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
		 LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
		 LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
		 LEFT JOIN Peaks AS p ON p.MountainId = m.Id
		 ) AS FullTable
   WHERE FullTable.Ranking = 1
   ORDER BY  HighestPeakElevation DESC, 
		 LongestRiverLength DESC,
		 FullTable.CountryName;

---===Pr. 17 Another Solution (easier and more simple)===---

SELECT TOP 5
	   c.CountryName, 
  	   MAX(p.Elevation) AS [HighestPeakElevation], 
  	   MAX(r.Length) AS [LongestRiverLength]
  FROM Countries AS c
  LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
  LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
  LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
  LEFT JOIN Peaks AS p ON p.MountainId = mc.MountainId
 GROUP BY c.CountryName
 ORDER BY HighestPeakElevation DESC, 
	   LongestRiverLength DESC,
	   c.CountryName;

---===Pr. 18===---

SELECT TOP 5
	   Source.CountryName AS [Country],
	   CASE
			WHEN Source.PeakName IS NULL THEN '(no highest peak)'
			ELSE Source.PeakName
	   END AS [Highest Peak Name], 
	   CASE
			WHEN Source.Elevation IS NULL THEN 0
			ELSE Source.Elevation
	   END AS [Highest Peak Elevation], 
	   CASE
			WHEN Source.MountainRange IS NULL THEN '(no mountain)'
			ELSE Source.MountainRange
	   END AS [Mountain] 
  FROM (
        SELECT c.CountryName, 
        	   p.PeakName, 
        	   p.Elevation, 
        	   m.MountainRange, 
        	   DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS [Ranking]
		  FROM Countries AS c
		  LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
		  LEFT JOIN Mountains AS m ON m.Id= mc.MountainId
		  LEFT JOIN Peaks AS p ON p.MountainId = m.Id
        ) AS Source
WHERE Ranking = 1
ORDER BY Country, 
	     [Highest Peak Elevation]