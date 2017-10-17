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

SELECT u.Username, 
  	   g.Name [Game], 
  	   MAX(c.Name) Character,
  	   SUM(statItem.Strength) + MAX(statGT.Strength) + MAX(statChar.Strength) [Strength],
  	   SUM(statItem.Defence) + MAX(statGT.Defence) + MAX(statChar.Defence) [Defence],
  	   SUM(statItem.Speed) + MAX(statGT.Speed) + MAX(statChar.Speed) [Speed],
  	   SUM(statItem.Mind) + MAX(statGT.Mind) + MAX(statChar.Mind) [Mind],
  	   SUM(statItem.Luck) + MAX(statGT.Luck) + MAX(statChar.Luck) [Luck]
  FROM Users u
  JOIN UsersGames ug ON ug.UserId = u.Id
  JOIN Games g ON ug.GameId = g.Id
  JOIN GameTypes gt ON gt.Id = g.GameTypeId
  JOIN [Statistics] statGT ON statGT.Id = gt.BonusStatsId
  JOIN Characters c ON ug.CharacterId = c.Id
  JOIN [Statistics] statChar ON statChar.Id = c.StatisticId
  JOIN UserGameItems ugi ON ugi.UserGameId = ug.Id
  JOIN Items i ON i.Id = ugi.ItemId
  JOIN [Statistics] statItem ON statItem.Id = i.StatisticId
 GROUP BY u.Username, g.Name
 ORDER BY Strength DESC, Defence DESC, Speed DESC, Mind DESC, Luck DESC

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

--SELECT * FROM UserGameItems WHERE ItemId = 51

--SELECT * FROM Users WHERE Username = 'ALEX'
--SELECT * FROM UsersGames WHERE UserId = 5 AND GameId = (SELECT Id FROM Games WHERE Name = 'Edinburgh')

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
 WHERE g.Name = 'Edinburgh'
 ORDER BY [Item Name]

---===Pr. 8===---

USE Geography

SELECT p.PeakName, m.MountainRange [Mountain], p.Elevation 
  FROM Peaks p
  JOIN Mountains m ON m.Id = p.MountainId
 ORDER BY Elevation DESC, PeakName
 
---===Pr. 9===---

SELECT p.PeakName, m.MountainRange, c.CountryName, cont.ContinentName 
  FROM Peaks p
  LEFT JOIN Mountains m ON m.Id = p.MountainId
  JOIN MountainsCountries mc ON mc.MountainId = m.Id
  JOIN Countries c ON c.CountryCode = mc.CountryCode
  JOIN Continents cont ON cont.ContinentCode = c.ContinentCode
 ORDER BY PeakName, CountryName

---===Pr. 10===---

SELECT c.CountryName, 
	   cont.ContinentName,
	   ISNULL(COUNT(r.Id), 0) [RiversCount], 
	   ISNULL(SUM(r.Length), 0) [TotalLength]
  FROM Rivers r
 RIGHT JOIN CountriesRivers cr ON cr.RiverId = r.Id
 RIGHT JOIN Countries c ON c.CountryCode = cr.CountryCode
  JOIN Continents cont ON cont.ContinentCode = c.ContinentCode
 GROUP BY c.CountryName, cont.ContinentName
 ORDER BY RiversCount DESC, TotalLength DESC, c.CountryName

--Slightly different solution ISNULL instead of CASE-WHEN--

SELECT c.CountryName, 
	   cont.ContinentName, 
	   CASE
			WHEN COUNT(r.Id) IS NULL THEN 0
			ELSE COUNT(r.Id)
	   END AS [RiversCount], 
	   CASE
			WHEN SUM(r.Length) IS NULL THEN 0
			ELSE SUM(r.Length)
	   END AS [TotalLength]
  FROM Rivers r
 RIGHT JOIN CountriesRivers cr ON cr.RiverId = r.Id
 RIGHT JOIN Countries c ON c.CountryCode = cr.CountryCode
  JOIN Continents cont ON cont.ContinentCode = c.ContinentCode
 GROUP BY c.CountryName, cont.ContinentName
 ORDER BY RiversCount DESC, TotalLength DESC, c.CountryName

---===Pr. 11===---

SELECT curr.CurrencyCode,
	   curr.Description [Currency], 
	   COUNT(c.CountryName) [NumberOfCountries]
  FROM Currencies curr
  LEFT JOIN Countries c ON c.CurrencyCode = curr.CurrencyCode
 GROUP BY curr.CurrencyCode, Description
 ORDER BY NumberOfCountries DESC, [Currency]

---===Pr. 12===---

SELECT cont.ContinentName,
	   SUM(c.AreaInSqKm ) [CountriesArea], 
	   SUM(CAST(c.Population AS bigint)) [CountriesPopulation]
  FROM Continents cont
  JOIN Countries c ON c.ContinentCode = cont.ContinentCode
 GROUP BY cont.ContinentName
 ORDER BY CountriesPopulation DESC

---===Pr. 13===---

--13.1
CREATE TABLE Monasteries
(
	Id INT IDENTITY NOT NULL, 
	Name VARCHAR(50) NOT NULL,
	CountryCode CHAR(2) NOT NULL
	CONSTRAINT Monasteries_ID PRIMARY KEY (Id), 
	CONSTRAINT FK_Monateries_Countries FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
)

--13.2
INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('S?mela Monastery', 'TR')

--13.3
ALTER TABLE Countries
ADD IsDeleted BIT NOT NULL
CONSTRAINT is_deleted_default DEFAULT 0

--13.4
UPDATE c
   SET c.IsDeleted = 1
  FROM Countries c
 WHERE c.CountryCode IN (SELECT cr.CountryCode 
		  				   FROM CountriesRivers cr 
		  				   JOIN Rivers r ON r.Id = cr.RiverId
		  				  GROUP BY cr.CountryCode
		  				 HAVING COUNT(r.Id) > 3
		  				 )

--3.5
SELECT m.Name, c.CountryName
  FROM Monasteries m
  JOIN Countries c ON c.CountryCode = m.CountryCode
 WHERE c.IsDeleted = 0
 ORDER BY m.Name
 
---===Pr. 14===---

SELECT * FROM Countries
SELECT * FROM Monasteries

--14.1
UPDATE Countries
   SET CountryName = 'Burma'
 WHERE CountryName = 'Myanmar'

--14.2

INSERT INTO Monasteries (Name, CountryCode) VALUES
('Hanga Abbey', (SELECT CountryCode 
				 FROM Countries 
				  WHERE CountryName = 'Tanzania'))

--14.3
INSERT INTO Monasteries (Name, CountryCode) VALUES
('Myin-Tin-Daik', (SELECT CountryCode 
				 FROM Countries 
				  WHERE CountryName = 'Myanmar'))

--14.4
SELECT cont.ContinentName, c.CountryName, COUNT(m.Id) [MonasteriesCount]
  FROM Countries c
  JOIN Continents cont ON cont.ContinentCode = c.ContinentCode
  LEFT JOIN Monasteries m ON m.CountryCode = c.CountryCode
 WHERE c.IsDeleted = 0
 GROUP BY cont.ContinentName, c.CountryName
 ORDER BY MonasteriesCount DESC, c.CountryName



