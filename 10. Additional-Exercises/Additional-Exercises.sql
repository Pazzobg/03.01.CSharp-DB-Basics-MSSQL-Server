---===Pr. 1===---

USE Diablo

SELECT SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider], 
	   COUNT(Email) AS [Number Of Users]
  FROM Users
 GROUP BY SUBSTRING(Email, (CHARINDEX('@', Email) + 1), (LEN(Email) - CHARINDEX('@', Email)))
 ORDER BY [Number Of Users] DESC, [Email Provider]
 
---===Pr. 2===---

SELECT g.Name [Game], 
	   gt.Name [Game Type], 
	   u.Username, 
	   ug.Level, 
	   ug.Cash, 
	   c.Name [Character]
  FROM Games AS g
  JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
  JOIN UsersGames AS ug ON ug.GameId = g.Id
  JOIN Users AS u ON u.Id = ug.UserId
  JOIN Characters AS c ON c.Id = ug.CharacterId
 ORDER BY ug.Level DESC, u.Username, Game
 
---===Pr. 3===---

SELECT u.Username [Username], 
	   g.Name [Game], 
	   COUNT(i.Id) [Items Count], 
	   SUM(i.Price) [Items Price]
  FROM UsersGames ug
  JOIN Users u ON u.Id = ug.UserId
  JOIN Games g ON g.Id = ug.GameId
  JOIN UserGameItems ugi ON ugi.UserGameId = ug.Id
  JOIN Items i ON i.Id = ugi.ItemId
 GROUP BY u.Username, g.Name
HAVING COUNT(i.Id) >= 10
 ORDER BY [Items Count] DESC, [Items Price] DESC, Username

---===Pr. 4===---

---

---===Pr. 5===---

DECLARE @AvgItemsMind INT = (SELECT AVG(Mind) FROM Items i
							 JOIN [Statistics] s ON s.Id = i.StatisticId)
DECLARE @AvgItemsLuck INT = (SELECT AVG(Luck) FROM Items i
							 JOIN [Statistics] s ON s.Id = i.StatisticId)
DECLARE @AvgItemsSpeed INT = (SELECT AVG(Speed) FROM Items i
							 JOIN [Statistics] s ON s.Id = i.StatisticId)

SELECT i.Name, i.Price, i.MinLevel, s.Strength, s.Defence, s.Speed, s.Luck, s.Mind
  FROM Items i 
  JOIN [Statistics] s ON s.Id = i.StatisticId
 WHERE s.Mind > @AvgItemsMind
   AND s.Luck > @AvgItemsLuck
   AND s.Speed > @AvgItemsSpeed
 ORDER BY i.Name
 
---===Pr. 6===---

SELECT i.Name [Item], i.Price, i.MinLevel, gt.Name [Forbidden Game Type]
  FROM Items i
  LEFT JOIN GameTypeForbiddenItems AS gtfo ON gtfo.ItemId = i.Id
  LEFT JOIN GameTypes AS gt ON gt.Id = gtfo.GameTypeId
 ORDER BY [Forbidden Game Type] DESC, Item ASC
 
---===Pr. 7===---

SELECT * FROM UserGameItems WHERE ItemId = 51

SELECT * FROM Users WHERE Username = 'ALEX'
SELECT * FROM UsersGames WHERE UserId = 5 AND GameId = (SELECT Id FROM Games WHERE Name = 'Edinburgh')

DECLARE @UserId INT = (SELECT Id FROM Users WHERE Username = 'Alex')
DECLARE @UserGameId INT = (SELECT Id FROM UsersGames 
							WHERE UserId = @UserId AND  GameId = (SELECT Id FROM Games 
																	WHERE Name = 'Edinburgh'))	--235
DECLARE @BlackguardItemId INT = (SELECT Id FROM Items WHERE [Name] = 'Blackguard')	--51
DECLARE @PotionItemId INT = (SELECT Id FROM Items WHERE [Name] = 'Bottomless Potion of Amplification')
DECLARE @EyeItemId INT = (SELECT Id FROM Items WHERE [Name] = 'Eye of Etlich (Diablo III)')
DECLARE @GemItemId INT = (SELECT Id FROM Items WHERE [Name] = 'Gem of Efficacious Toxin')
DECLARE @GorgetItemId INT = (SELECT Id FROM Items WHERE [Name] = 'Golden Gorget of Leoric')
DECLARE @AmuletItemId INT = (SELECT Id FROM Items WHERE [Name] = 'Hellfire Amulet')
DECLARE @CurrentCash MONEY
DECLARE @CurrentItemPrice MONEY

BEGIN TRANSACTION
	SET @CurrentCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
	SET @CurrentItemPrice = (SELECT Price FROM Items WHERE Id = @BlackguardItemId)
	INSERT INTO	UserGameItems (ItemId, UserGameId)
	VALUES (@BlackguardItemId, @UserGameId)
	UPDATE UsersGames
	SET Cash -= @CurrentItemPrice
	WHERE UsersGames.Id = @UserGameId
	IF (@CurrentCash - @CurrentItemPrice < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough money to buy this item', 16, 1)
		RETURN
	END
COMMIT

BEGIN TRANSACTION
	SET @CurrentCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
	SET @CurrentItemPrice = (SELECT Price FROM Items WHERE Id = @PotionItemId)
	INSERT INTO	UserGameItems (ItemId, UserGameId)
	VALUES (@PotionItemId, @UserGameId)
	UPDATE UsersGames
	SET Cash -= @CurrentItemPrice
	WHERE UsersGames.Id = @UserGameId
	IF (@CurrentCash - @CurrentItemPrice < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough money to buy this item', 16, 1)
		RETURN
	END
COMMIT

BEGIN TRANSACTION
	SET @CurrentCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
	SET @CurrentItemPrice = (SELECT Price FROM Items WHERE Id = @EyeItemId)
	INSERT INTO	UserGameItems (ItemId, UserGameId)
	VALUES (@EyeItemId, @UserGameId)
	UPDATE UsersGames
	SET Cash -= @CurrentItemPrice
	WHERE UsersGames.Id = @UserGameId
	IF (@CurrentCash - @CurrentItemPrice < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough money to buy this item', 16, 1)
		RETURN
	END
COMMIT

BEGIN TRANSACTION
	SET @CurrentCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
	SET @CurrentItemPrice = (SELECT Price FROM Items WHERE Id = @GemItemId)
	INSERT INTO	UserGameItems (ItemId, UserGameId)
	VALUES (@GemItemId, @UserGameId)
	UPDATE UsersGames
	SET Cash -= @CurrentItemPrice
	WHERE UsersGames.Id = @UserGameId
	IF (@CurrentCash - @CurrentItemPrice < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough money to buy this item', 16, 1)
		RETURN
	END
COMMIT

BEGIN TRANSACTION
	SET @CurrentCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
	SET @CurrentItemPrice = (SELECT Price FROM Items WHERE Id = @GorgetItemId)
	INSERT INTO	UserGameItems (ItemId, UserGameId)
	VALUES (@GorgetItemId, @UserGameId)
	UPDATE UsersGames
	SET Cash -= @CurrentItemPrice
	WHERE UsersGames.Id = @UserGameId
	IF (@CurrentCash - @CurrentItemPrice < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough money to buy this item', 16, 1)
		RETURN
	END
COMMIT

BEGIN TRANSACTION
	SET @CurrentCash = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
	SET @CurrentItemPrice = (SELECT Price FROM Items WHERE Id = @AmuletItemId)
	INSERT INTO	UserGameItems (ItemId, UserGameId)
	VALUES (@AmuletItemId, @UserGameId)
	UPDATE UsersGames
	SET Cash -= @CurrentItemPrice
	WHERE UsersGames.Id = @UserGameId
	IF (@CurrentCash - @CurrentItemPrice < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Not enough money to buy this item', 16, 1)
		RETURN
	END
COMMIT

SELECT u.Username, g.Name, ug.Cash, i.Name [Item Name]
  FROM Users u
  LEFT JOIN UsersGames ug ON ug.UserId = u.Id
  LEFT JOIN Games g ON g.Id = ug.GameId
  LEFT JOIN UserGameItems ugi ON ugi.UserGameId = ug.Id
  LEFT JOIN Items i ON i.Id = ugi.ItemId
  WHERE ug.GameId = (SELECT Id FROM GAMES WHERE Name = 'Edinburgh')
 ORDER BY [Item Name]

---===Pr. 8===---

USE Geography

SELECT p.PeakName, m.MountainRange [Mountain], p.Elevation 
  FROM Peaks p
  JOIN Mountains m ON m.Id = p.MountainId
 ORDER BY Elevation DESC, PeakName
 
---===Pr. 8===---

SELECT p.PeakName, m.MountainRange, c.CountryName, cont.ContinentName 
  FROM Peaks p
  LEFT JOIN Mountains m ON m.Id = p.MountainId
  JOIN MountainsCountries mc ON mc.MountainId = m.Id
  JOIN Countries c ON c.CountryCode = mc.CountryCode
  JOIN Continents cont ON cont.ContinentCode = c.ContinentCode
 ORDER BY PeakName, CountryName

---===Pr. 9===---

