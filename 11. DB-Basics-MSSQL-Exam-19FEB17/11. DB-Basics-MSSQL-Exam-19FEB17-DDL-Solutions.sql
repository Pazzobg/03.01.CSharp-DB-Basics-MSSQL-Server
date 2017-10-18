CREATE DATABASE Bakery
GO

USE Bakery

---===Pr. 1===---

CREATE TABLE Countries
(
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(50) NOT NULL
	CONSTRAINT PK_CountriesID PRIMARY KEY (Id),
	CONSTRAINT uq_Country UNIQUE (Name)
)

CREATE TABLE Distributors
(
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(25) NOT NULL, 
	CountryId INT NOT NULL, 
	AddressText NVARCHAR(30), 
	Summary NVARCHAR(200), 
	CONSTRAINT PK_DistributorsID PRIMARY KEY (Id), 
	CONSTRAINT uq_Distributor UNIQUE (Name),
	CONSTRAINT FK_Distributors_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Ingredients
(
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(30), 
	Description NVARCHAR(200), 
	OriginCountryId INT, 
	DistributorId INT, 
	CONSTRAINT PK_IngredientsID PRIMARY KEY (Id) ,
	CONSTRAINT FK_Ingredients_Countries FOREIGN KEY (OriginCountryId) REFERENCES Countries(Id),
	CONSTRAINT FK_Ingredients_Distributors FOREIGN KEY (DistributorId) REFERENCES Distributors(Id)
)

CREATE TABLE Products
(
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(25), 
	Description NVARCHAR(250), 
	Recipe NVARCHAR(MAX), 
	Price MONEY, 
	CONSTRAINT PK_ProductsID PRIMARY KEY (Id),
	CONSTRAINT uq_ProductName UNIQUE (Name),
	CONSTRAINT chk_ProductPrice CHECK (Price > 0)
)

CREATE TABLE ProductsIngredients
(
	ProductId INT NOT NULL, 
	IngredientId INT NOT NULL, 
	CONSTRAINT PK_ProductsIngredientsID PRIMARY KEY (ProductId, IngredientId),  
	CONSTRAINT FK_ProdIngredProducts FOREIGN KEY (ProductId) REFERENCES Products(Id),
	CONSTRAINT FK_ProdIngredIngredients FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)
)

CREATE TABLE Customers
(
	Id INT IDENTITY NOT NULL, 
	FirstName NVARCHAR(25), 
	LastName NVARCHAR(25), 
	Age INT, 
	Gender CHAR(1),
	PhoneNumber CHAR(10), 
	CountryId INT, 
	CONSTRAINT PK_CustomersID PRIMARY KEY (Id), 
	CONSTRAINT chk_CustomerGender CHECK (Gender = 'M' OR Gender = 'F'),	
	CONSTRAINT FK_Customers_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Feedbacks
(
	Id INT IDENTITY NOT NULL,
	ProductId INT, 
	CustomerId INT, 
	Rate DECIMAL(10, 2), 
	Description NVARCHAR(255),
	CONSTRAINT PK_FeedbacksID PRIMARY KEY (Id),  
	CONSTRAINT FK_Feedbacks_Products FOREIGN KEY (ProductId) REFERENCES Products(Id), 
	CONSTRAINT FK_Feedbacks_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(Id), 
	CONSTRAINT chk_Rate_Value CHECK (Rate BETWEEN 0 AND 10)
)

---===Pr. 2===---

--RUN SKELETON BEFORE PROCEEDING

INSERT INTO Distributors (Name, CountryId, AddressText, Summary) VALUES
('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

INSERT INTO Customers (FirstName, LastName, Age, Gender, PhoneNumber, CountryId) VALUES
('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
('Kendra', 'Loud', 22, 'F', '0063631526', 11),
('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8),
('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
('Tom', 'Loeza', 31, 'M', '0144876096', 23),
('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
('Josefa', 'Opitz', 43, 'F', '0197887645', 17)

---===Pr. 3===---

UPDATE Ingredients
   SET DistributorId = 35
 WHERE Name IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE Ingredients
   SET OriginCountryId = 14
 WHERE OriginCountryId = 8
 
---===Pr. 4===---

DELETE FROM Feedbacks
 WHERE CustomerId = 14
	OR ProductId = 5

---===Pr. 5===---

--RECREATE DB AND FILL IN DATA
--DROP TABLE Feedbacks
--DROP TABLE Customers
--DROP TABLE ProductsIngredients
--DROP TABLE Products
--DROP TABLE Ingredients
--DROP TABLE Distributors
--DROP TABLE Countries

SELECT Name, Price, Description 
  FROM Products
 ORDER BY Price DESC, Name
 
---===Pr. 6===---

SELECT Name, Description, OriginCountryId
  FROM Ingredients
 WHERE OriginCountryId IN (1, 10, 20)
 ORDER BY Id

---===Pr. 7===---

SELECT TOP 15 i.Name, i.Description, c.Name
  FROM Ingredients i 
  JOIN Countries c ON c.Id = i.OriginCountryId
 WHERE c.Name IN ('Bulgaria', 'Greece')
 ORDER BY i.Name, c.Name

---===Pr. 8===---

SELECT TOP 10 p.Name, p.Description, AVG(f.Rate) [AverageRate], COUNT(f.Id) [FeedbacksAmount] 
  FROM Products p 
  JOIN Feedbacks f ON f.ProductId = p.Id
 GROUP BY p.Name, p.Description
 ORDER BY AverageRate DESC, FeedbacksAmount DESC

---===Pr. 9===---

SELECT ProductId, Rate, Description, f.CustomerId, Age, Gender
  FROM Feedbacks f
  JOIN Customers c ON c.Id = f.CustomerId
 WHERE Rate < 5
 ORDER BY ProductId DESC, Rate

---===Pr. 10===---

SELECT CONCAT(FirstName, ' ', LastName) [CustomerName], 
	   PhoneNumber, 
	   Gender
  FROM Customers
 WHERE Id NOT IN (SELECT CustomerId FROM Feedbacks)
 ORDER BY Id

---===Pr. 11===---

SELECT ProductId, 
	   CONCAT(FirstName, ' ', LastName) [CustomerName], 
	   f.Description [FeedbackDescription]
  FROM Feedbacks f
  JOIN Customers c ON c.Id = f.CustomerId
 WHERE CustomerId IN (SELECT CustomerId 
					    FROM Feedbacks
					   GROUP BY CustomerId
					  HAVING COUNT(CustomerId) >= 3)
 ORDER BY ProductId, CustomerName, f.Id

---===Pr. 12===---

SELECT FirstName, Age, PhoneNumber
  FROM Customers cust
  JOIN Countries c ON c.Id = cust.CountryId
 WHERE (Age >= 21 AND FirstName LIKE '%an%')
	OR (PhoneNumber LIKE '%38' AND c.Name <> 'Greece')
 ORDER BY FirstName, Age DESC

---===Pr. 13===---

SELECT d.Name [DistributorName], 
	   i.Name [IngredientName], 
	   p.Name [ProductName], 
	   AVG(f.Rate) [AverageRate]
  FROM Ingredients i 
  JOIN Distributors d ON d.Id = i.DistributorId
  JOIN ProductsIngredients pingr ON pingr.IngredientId = i.Id
  JOIN Products p ON p.Id = pingr.ProductId
  JOIN Feedbacks f ON f.ProductId = p.Id
 GROUP BY d.Name, i.Name, p.Name
HAVING AVG(Rate) between 5 and 8
 ORDER BY DistributorName, IngredientName, ProductName

---===Pr. 14===---

SELECT TOP 1 WITH TIES 
	   co.Name [CountryName], 
	   AVG(f.Rate) [FeedbackRate] 
  FROM Countries co
  JOIN Customers cu ON cu.CountryId = co.Id
  JOIN Feedbacks f ON f.CustomerId = cu.Id
 GROUP BY co.Name
 ORDER BY FeedbackRate DESC

---===Pr. 15===---

SELECT CountryName, DistributorName 
  FROM (SELECT c.Name [CountryName], 
	  	       d.Name [DistributorName], 
	  	       COUNT(i.Id) [IngredientsCount], 
	  	       DENSE_RANK() OVER (PARTITION BY c.Name ORDER BY COUNT(i.Id) DESC) [Ranking]
	      FROM Countries c
	      JOIN Distributors d ON d.CountryId = c.Id
	      JOIN Ingredients i ON i.DistributorId = d.Id
	     GROUP BY d.Name, c.Name) AS dr
 WHERE dr.Ranking = 1
 ORDER BY CountryName, DistributorName

---===Pr. 16===---

GO 

CREATE VIEW v_UserWithCountries AS
SELECT CONCAT(FirstName, ' ', LastName) [CustomerName], 
	   Age, 
	   Gender, 
	   co.Name [CountryName]
  FROM Customers c
  JOIN Countries co ON co.Id = c.CountryId

GO

---===Pr. 17===---

CREATE FUNCTION udf_GetRating (@Name NVARCHAR(25))
RETURNS VARCHAR(10)
AS
BEGIN
  DECLARE @result VARCHAR(10);
  DECLARE @rating DECIMAL(10, 2);

  SET @rating = (SELECT AVG(Rate)
				   FROM Feedbacks f
				   JOIN Products p ON p.Id = f.ProductId
				  WHERE p.Name = @Name)

  IF(@rating < 5)
  BEGIN
	SET @result = 'Bad'
  END
  ELSE IF(@rating <= 8)
  BEGIN
	SET @result = 'Average'
  END
  ELSE IF(@rating > 8)
  BEGIN
	SET @result = 'Good'
  END
  ELSE
  BEGIN
	SET @result = 'No rating'
  END

  RETURN @result;
END

GO

SELECT TOP 5 Id, Name, dbo.udf_GetRating(Name)
  FROM Products
 ORDER BY Id

---===Pr. 18===---

GO

CREATE PROC usp_SendFeedback(@custId INT, @prodId INT, @rating DECIMAL(10, 2), @description NVARCHAR(255))
AS
BEGIN
	BEGIN TRANSACTION
	INSERT INTO Feedbacks (CustomerId, ProductId, Rate, Description) VALUES
	(@custId, @prodId, @rating, @description)
	
	DECLARE @currNumOfFeedbs INT = (SELECT COUNT(Id) 
									  FROM Feedbacks
									 WHERE CustomerId = @custId
									   AND ProductId = @prodId)
	
	IF(@currNumOfFeedbs > 3)
	BEGIN
		RAISERROR('You are limited to only 3 feedbacks per product!', 16, 1)
		ROLLBACK
		RETURN
	END
	ELSE
	BEGIN
		COMMIT
	END
END

GO

EXEC usp_SendFeedback 1, 5, 7.50, 'Average experience'; 
SELECT * FROM Feedbacks WHERE CustomerId = 1 AND ProductId = 5;

---===Pr. 19===---

GO 
CREATE TRIGGER dbo.tr_DeleteProduct ON Products INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM ProductsIngredients
	 WHERE ProductId = (SELECT Id FROM deleted)

	DELETE FROM Feedbacks
	 WHERE ProductId = (SELECT Id FROM deleted)

	DELETE FROM Products
	 WHERE Id = (SELECT Id FROM deleted)
END

---===Pr. 20===---

SELECT ProductName, 
	   ProductAverageRate, 
	   DistributorName, 
	   DistributorCountry
  FROM (SELECT p.Name [ProductName], 
			   AVG(f.Rate) [ProductAverageRate], 
			   d.Name [DistributorName], 
			   c.Name [DistributorCountry],
			   p.Id [ProductId]
		  FROM ( SELECT p.Id
						  FROM Products p
						  JOIN ProductsIngredients prin ON prin.ProductId = p.Id
						  JOIN Ingredients i ON i.Id = prin.IngredientId
						  JOIN Distributors d ON d.Id = i.DistributorId
						 GROUP BY p.Id
						HAVING COUNT(DISTINCT(i.DistributorId)) = 1) AS ProdSingleDistr
		  JOIN Products p ON p.Id = ProdSingleDistr.Id
		  JOIN ProductsIngredients prin ON prin.ProductId = p.Id
		  JOIN Ingredients i ON i.Id = prin.IngredientId
		  JOIN Distributors d ON d.Id = i.DistributorId
		  JOIN Feedbacks f ON f.ProductId = p.Id
		  JOIN Countries c ON c.Id = d.CountryId
		 GROUP BY p.Name, d.Name, c.Name, p.Id
		)   AS result
 ORDER BY result.ProductId