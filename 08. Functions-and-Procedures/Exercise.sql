---===Pr. 1===---

USE SoftUni

CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName AS [First Name], 
		   LastName AS [Last Name]
	  FROM Employees
	 WHERE Salary > 35000

--EXEC usp_GetEmployeesSalaryAbove35000

---===Pr. 2===---

CREATE PROC usp_GetEmployeesSalaryAboveNumber(@minSalary DECIMAL(18, 4))
AS
	SELECT FirstName AS [First Name], 
		   LastName AS [Last Name]
	  FROM Employees
	 WHERE Salary >= @minSalary

--EXEC usp_GetEmployeesSalaryAboveNumber 48100

---===Pr. 3===---

CREATE PROC usp_GetTownsStartingWith(@startingStr VARCHAR(25))
AS
	SELECT Name 
	  FROM Towns
	 WHERE LEFT(Name, LEN(@startingStr)) = LEFT(@startingStr, LEN(@startingStr))

--EXEC usp_GetTownsStartingWith 'San'

--Different approach using Wildcards(~RegEx): 
--CREATE PROC usp_GetTownsStartingWith(@startingStr VARCHAR(25))
--AS
--	SELECT Name 
--	  FROM Towns
--	 WHERE Name LIKE CONCAT(@startingStr, '%')

--EXEC usp_GetTownsStartingWith 'San'


---===Pr. 4===---

CREATE PROC usp_GetEmployeesFromTown(@townName VARCHAR(25))
AS
	SELECT e.FirstName AS [First Name], 
		   e.LastName AS [Last Name]
	  FROM Employees AS e
	  JOIN Addresses AS a ON e.AddressID = a.AddressID
	  JOIN Towns AS t ON t.TownID = a.TownID
	 WHERE t.Name = @townName

--EXEC usp_GetEmployeesFromTown 'Seattle'

---===Pr. 5===---

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(7)
AS
BEGIN
	DECLARE @result VARCHAR(7)

	IF(@salary < 30000)
	BEGIN
		SET @result = 'Low'
	END
	ELSE IF(@salary > 50000)
	BEGIN
		SET @result = 'High'
	END
	ELSE
		SET @result = 'Average'

	RETURN @result
END

--SELECT FirstName, LastName, Salary, dbo.ufn_SalaryLevel(Salary) AS [SalaryLevel]
--  FROM Employees

---===Pr. 6===---

CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel VARCHAR(7))
AS
	SELECT FirstName AS [First Name], 
		   LastName AS [Last Name]
	  FROM Employees
	 WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel

--EXEC usp_EmployeesBySalaryLevel 'High'

---===Pr. 7===---

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50)) 
RETURNS BIT
AS
BEGIN
	DECLARE @result BIT = 1
	DECLARE @loopEnd INT = LEN(@word)
	DECLARE @currentLetter CHAR
	DECLARE @i INT = 1;

	WHILE (@i <= @loopEnd)
	BEGIN
		SET @currentLetter = SUBSTRING(@word, @i, 1)

		IF(CHARINDEX(@currentLetter, @setOfLetters) > 0)
		BEGIN
			SET  @i += 1; 
			CONTINUE
		END
		ELSE
		BEGIN
			SET @result = 0; 
			BREAK
		END
	END

	RETURN @result

END

--SELECT SetOfLetters, Word, dbo.ufn_IsWordComprised(SetOfLetters, Word) AS [Result]
--  FROM Test

---===Pr. 8===---

CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
	ALTER TABLE Departments
	ALTER COLUMN ManagerId INT NULL

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
						 SELECT EmployeeID FROM Employees 
						 WHERE DepartmentID = @departmentId
						)

	UPDATE Employees
	   SET ManagerID = NULL
	WHERE ManagerID IN (
						SELECT EmployeeId FROM Employees
						WHERE DepartmentID = @departmentId
					   )

	UPDATE Departments
	   SET ManagerID = NULL
	WHERE ManagerID IN (
						SELECT EmployeeId FROM Employees
						WHERE DepartmentID = @departmentId
					   )

	DELETE FROM Employees
	 WHERE DepartmentID = @departmentId				

	 DELETE FROM Departments
	 WHERE DepartmentID = @departmentId					

SELECT COUNT(EmployeeID)
  FROM Employees
 WHERE DepartmentID = @departmentId

---===Pr. 9===---

USE Bank

CREATE PROC usp_GetHoldersFullName 
AS
	SELECT FirstName + ' ' + LastName as [Full Name]
	FROM AccountHolders

--EXEC usp_GetHoldersFullName

---===Pr. 10===---

CREATE PROC usp_GetHoldersWithBalanceHigherThan (@number MONEY)
AS
	SELECT FirstName, LastName 
	FROM AccountHolders AS ah
	JOIN Accounts AS ac ON ac.AccountHolderId = ah.Id
	GROUP BY FirstName, LastName
	HAVING SUM(Balance) > @number

--EXEC usp_GetHoldersWithBalanceHigherThan 1000000

---===Pr. 11===---

CREATE FUNCTION ufn_CalculateFutureValue(@I MONEY, @R FLOAT, @T INT)
RETURNS MONEY
AS
BEGIN
	RETURN @I * POWER((1 + @R), @T)
END

--SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

---===Pr. 12===---

CREATE PROC usp_CalculateFutureValueForAccount (@accountId INT, @interestRate FLOAT)
AS
	SELECT ac.Id,
		   ah.FirstName, 
		   ah.LastName, 
		   ac.Balance AS [Current Balance], 
		   dbo.ufn_CalculateFutureValue(Balance, 
										@interestRate, 
										5
									   ) AS [Balance in 5 years]
	  FROM AccountHolders AS ah
	  JOIN Accounts AS ac ON ac.AccountHolderId = ah.Id
	 WHERE ac.Id = @accountId

--EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1

---===Pr. 13===---

USE Diablo

CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(50))
RETURNS @SumCash TABLE 
					  (
						SumCash MONEY NOT NULL
					  )
AS 
BEGIN
	INSERT INTO @SumCash
		SELECT SUM(ct.Cash) AS [SumCash]
		  FROM (
		  	    SELECT g.Name,
		  	           ug.Cash, 
		  	           ROW_NUMBER() OVER (ORDER BY ug.Cash DESC) AS [RowNumber]
		  	    FROM UsersGames AS ug
		  	    JOIN Games AS g ON g.Id = ug.GameId
		  	    WHERE g.Name = @gameName
		  	   ) AS ct
		 WHERE ct.RowNumber % 2 <> 0
	RETURN
END