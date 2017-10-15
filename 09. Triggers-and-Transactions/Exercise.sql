---===Pr. 1===---

USE Bank
GO
--CREATE TABLE Logs
--(
--	LogId INT PRIMARY KEY IDENTITY, 
--	AccountId INT NOT NULL, 
--	OldSum DECIMAL(15, 2) NOT NULL, 
--	NewSum DECIMAL(15, 2) NOT NULL
--)


CREATE TRIGGER dbo.tr_TransactionsLog ON Accounts FOR UPDATE
AS
BEGIN
	DECLARE @AccountId INT = (SELECT Id FROM deleted)
	DECLARE @OldAmount MONEY = (SELECT Balance FROM deleted )
	DECLARE @NewAmount MONEY = (SELECT Balance FROM inserted)
	INSERT INTO Logs VALUES
	(@AccountId, @OldAmount, @NewAmount)
END

--CREATE TRIGGER dbo.tr_TransactionsLog ON Accounts FOR UPDATE
--AS
--BEGIN
--	INSERT INTO Logs (AccountId, OldSum, NewSum)
--	SELECT i.Id, d.Balance, i.Balance 
--	  FROM deleted AS d JOIN inserted AS i ON i.Id = d.Id
--END

GO

---===Pr. 2===---

--CREATE TABLE NotificationEmails
--(
--	Id INT PRIMARY KEY IDENTITY, 
--	Recipient INT NOT NULL, 
--	Subject VARCHAR(50), 
--	Body VARCHAR(200)
--)
GO

CREATE TRIGGER tr_SendNotificationEmail ON Logs FOR INSERT
AS
BEGIN
	DECLARE @Recipient INT = (SELECT AccountId FROM inserted)
	DECLARE @CurrentDateTime DATETIME = GETDATE()
	DECLARE @OldAmount MONEY = (SELECT OldSum FROM inserted)
	DECLARE @NewAmount MONEY = (SELECT NewSum FROM inserted)
	DECLARE @EmailSubject VARCHAR(50) = CONCAT('Balance change for account: ', @Recipient)
	DECLARE @EmailBody VARCHAR(200) = CONCAT
											('On ', 
											 @CurrentDateTime, 
											 ' your balance was changed from ',
											 @OldAmount, 
											 '  to ', 
											 @NewAmount, 
											 '.'
											)
	INSERT INTO NotificationEmails VALUES
	(@Recipient, @EmailSubject, @EmailBody)
END

---===Pr. 3===---

CREATE OR ALTER PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4))
AS
BEGIN
	UPDATE Accounts
	SET Balance += @MoneyAmount
	WHERE Id = @AccountId
END

---===Pr. 4===---

CREATE OR ALTER PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4))
AS
BEGIN
	UPDATE Accounts
	SET Balance -= @MoneyAmount
	WHERE Id = @AccountId
END

---===Pr. 5 The Judge-way===---

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4))
AS
BEGIN
	EXEC dbo.usp_WithdrawMoney @SenderId, @Amount
	EXEC dbo.usp_DepositMoney @ReceiverId, @Amount
END

---===Pr. 5 The Logical way (accepted by Judge as well)===---

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4))
AS
BEGIN
	BEGIN TRANSACTION
		EXEC dbo.usp_WithdrawMoney @SenderId, @Amount
		EXEC dbo.usp_DepositMoney @ReceiverId, @Amount

		IF(@Amount <= 0)
		BEGIN;
			THROW 50000, 'Invalid Amount!', 2
			ROLLBACK
			RETURN
		END
		ELSE IF(not EXISTS(SELECT Id FROM Accounts WHERE Id = @SenderId) OR 
				not EXISTS(SELECT Id FROM Accounts WHERE Id = @ReceiverId))
		BEGIN;
			THROW 50000, 'Invalid Account!', 3
			ROLLBACK
			RETURN
		END
		ELSE IF((SELECT Balance FROM Accounts WHERE Id = @ReceiverId) < 0)
		BEGIN;
			THROW 50000, 'Insufficient funds!', 4
			ROLLBACK
			RETURN
		END
	COMMIT	
END

---===Pr. 6===---
GO
USE Diablo
GO
--6.1
CREATE TRIGGER tr_RestrictHigherLevelItems 
ON UserGameItems AFTER INSERT
AS
	DECLARE @UserLevel INT = (SELECT ug.[Level] FROM inserted AS ugi 
							  JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId)
	DECLARE @ItemMinLevel INT = (SELECT it.MinLevel FROM inserted AS ugi 
								 JOIN Items AS it ON it.Id = ugi.ItemId)

	IF(@UserLevel < @ItemMinLevel)
	BEGIN
		RAISERROR('Your level is too low to acquire this item!', 16, 1)
		ROLLBACK
		RETURN
	END

GO

--6.2

UPDATE UsersGames
SET Cash += 50000
WHERE GameId = (SELECT Id FROM Games WHERE Name = 'Bali')
  AND UserId IN (
				SELECT Id 
				  FROM Users 
				 WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 
									'buildingdeltoid', 'monoxidecos'))

--6.3.1

--INSERT INTO UserGameItems (ItemId, UserGameId)
--SELECT Items.Id, ug.Id 
--  FROM Items
--  JOIN UserGameItems AS ugi ON ugi.ItemId = Items.Id
--  JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId
-- WHERE ((Items.Id BETWEEN 251 AND 299) OR (Items.Id BETWEEN 501 AND 539))
--   AND UserId IN (SELECT Id FROM Users
--				   WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 
--									'buildingdeltoid', 'monoxidecos'))
--   AND GameId = (SELECT Id FROM Games WHERE Name = 'Bali')


--6.3.2
--...

--6.4

SELECT u.Username, g.Name, ug.Cash, it.Name AS [Item Name] 
  FROM UsersGames AS ug
  JOIN Users AS u ON u.Id = ug.UserId
  JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
  JOIN Games AS g ON g.Id = ug.GameId
  JOIN Items AS it ON it.Id = ugi.ItemId
 WHERE g.Name = 'Bali'
 ORDER BY u.Username, [Item Name]

---===Pr. 7===---

DECLARE @IdUserGame INT = (SELECT Id FROM UsersGames
WHERE UserId = (SELECT Id FROM Users WHERE Username ='Stamat')
AND GameId = (SELECT Id FROM Games WHERE Name = 'Safflower'))

DECLARE @CurrentCash MONEY = (SELECT Cash FROM UsersGames WHERE Id = @IdUserGame)
DECLARE @PlayerLevel INT = (SELECT [Level] FROM UsersGames WHERE Id = @IdUserGame)
DECLARE @TotalCost MONEY
DECLARE @ItemMinLevel INT
DECLARE @ItemMaxLevel INT

SET @ItemMinLevel = 11
SET @ItemMaxLevel = 12
SET @TotalCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @ItemMinLevel AND @ItemMaxLevel)

IF(@TotalCost <= @CurrentCash AND @PlayerLevel >= @ItemMaxLevel)
BEGIN
	BEGIN TRANSACTION
		INSERT INTO UserGameItems (ItemId, UserGameId)
		(SELECT Id, @IdUserGame FROM Items WHERE MinLevel BETWEEN @ItemMinLevel AND @ItemMaxLevel)

		UPDATE UsersGames
		SET Cash -= @TotalCost WHERE UsersGames.Id = @IdUserGame
	COMMIT
END

SET @ItemMinLevel = 19
SET @ItemMaxLevel = 21
SET @TotalCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @ItemMinLevel AND @ItemMaxLevel)

IF(@TotalCost <= @CurrentCash AND @PlayerLevel >= @ItemMaxLevel)
BEGIN
	BEGIN TRANSACTION
		INSERT INTO UserGameItems (ItemId, UserGameId)
		(SELECT Id, @IdUserGame FROM Items WHERE MinLevel BETWEEN @ItemMinLevel AND @ItemMaxLevel)

		UPDATE UsersGames
		SET Cash -= @TotalCost WHERE UsersGames.Id = @IdUserGame
	COMMIT
END

SELECT i.Name AS [Item Name] FROM UserGameItems AS ugi
  JOIN	Items AS i ON i.Id = ugi.ItemId
 WHERE UserGameId = @IdUserGame
 ORDER BY [Item Name]

---===Pr. 8===---

USE SoftUni

CREATE PROCEDURE usp_AssignProject(@emloyeeId INT, @projectID INT) 
AS
	BEGIN TRANSACTION
		INSERT INTO EmployeesProjects
		VALUES (@emloyeeId, @projectID)

		IF(
			(SELECT COUNT(ProjectID) 
			  FROM EmployeesProjects
			 WHERE EmployeeID = @emloyeeId)
			 > 3
		  )
		BEGIN
			RAISERROR('The employee has too many projects!', 16, 1)
			ROLLBACK
			RETURN
		END
	COMMIT

--SELECT * FROM EmployeesProjects
--EXEC dbo.usp_AssignProject 1, 58

---===Pr. 9===---

--CREATE TABLE Deleted_Employees
--(EmployeeId INT PRIMARY KEY IDENTITY, 
-- FirstName VARCHAR(50) NOT NULL, 
-- LastName VARCHAR(50) NOT NULL, 
-- MiddleName VARCHAR(50), 
-- JobTitle VARCHAR(50) NOT NULL, 
-- DeparmentId INT NOT NULL, 
-- Salary MONEY NOT NULL
--) 

CREATE TRIGGER tr_DeleteEmployee ON Employees AFTER DELETE
AS
	
	INSERT INTO Deleted_Employees
	SELECT FirstName, 
		   LastName, 
		   MiddleName, 
		   JobTitle, 
		   DepartmentID, 
		   Salary
	  FROM deleted