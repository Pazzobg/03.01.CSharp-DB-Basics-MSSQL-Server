CREATE DATABASE WMS
GO

USE WMS

---===Pr. 1===---

CREATE TABLE Models
(
	ModelId INT IDENTITY NOT NULL,
	Name VARCHAR(50) NOT NULL, 
	CONSTRAINT PK_ModelsID PRIMARY KEY (ModelId),
	CONSTRAINT uq_Model UNIQUE (Name)
)

CREATE TABLE Clients
(
	ClientId INT IDENTITY NOT NULL, 
	FirstName VARCHAR(50) NOT NULL, 
	LastName VARCHAR(50) NOT NULL, 
	Phone VARCHAR(12) NOT NULL, 
	CONSTRAINT PK_ClientsID PRIMARY KEY (ClientId), 
	CONSTRAINT chk_PhoneNmbr CHECK (LEN(Phone) = 12)
)

CREATE TABLE Mechanics
(
	MechanicId INT IDENTITY NOT NULL, 
	FirstName VARCHAR(50) NOT NULL, 
	LastName VARCHAR(50) NOT NULL, 
	Address VARCHAR(255) NOT NULL, 
	CONSTRAINT PK_MechanicsID PRIMARY KEY (MechanicId) 
)

CREATE TABLE Jobs
(
	JobId INT IDENTITY NOT NULL, 
	ModelId INT NOT NULL, 
	Status VARCHAR(11) DEFAULT 'Pending' NOT NULL, 
	ClientId INT NOT NULL, 
	MechanicId INT, 
	IssueDate DATETIME NOT NULL, 
	FinishDate DATETIME,
	CONSTRAINT PK_JobsID PRIMARY KEY (JobId), 
	CONSTRAINT FK_JobsModels FOREIGN KEY (ModelId) REFERENCES Models(ModelId),
	CONSTRAINT FK_JobsClients FOREIGN KEY (ClientId) REFERENCES Clients(ClientId),
	CONSTRAINT FK_JobsMechanics FOREIGN KEY (MechanicId) REFERENCES Mechanics(MechanicId),
	CONSTRAINT chk_Status CHECK (Status = 'Pending' OR Status = 'In Progress' OR Status = 'Finished')
)

CREATE TABLE Orders
(
	OrderId INT IDENTITY NOT NULL, 
	JobId INT NOT NULL, 
	IssueDate DATETIME, 
	Delivered BIT DEFAULT 0 NOT NULL
	CONSTRAINT PK_OrdersID PRIMARY KEY (OrderId), 
	CONSTRAINT FK_Orders_Jobs FOREIGN KEY (JobId) REFERENCES Jobs(JobId)
)

CREATE TABLE Vendors
(
	VendorId INT IDENTITY NOT NULL, 
	Name VARCHAR(50) NOT NULL
	CONSTRAINT PK_VendorsID PRIMARY KEY (VendorId),
	CONSTRAINT uq_VendorName UNIQUE (Name)
)

CREATE TABLE Parts
(
	PartId INT IDENTITY NOT NULL, 
	SerialNumber VARCHAR(50) NOT NULL, 
	Description VARCHAR(255), 
	Price DECIMAL (6, 2) CHECK (Price > 0 AND Price < 10000.00) NOT NULL,
	VendorId INT NOT NULL, 
	StockQty INT CHECK (StockQty >= 0) DEFAULT 0 NOT NULL, 
	CONSTRAINT PK_PartsID PRIMARY KEY (PartId), 
	CONSTRAINT FK_Parts_Vendors FOREIGN KEY (VendorId) REFERENCES Vendors(VendorId),
	CONSTRAINT uq_Serial UNIQUE (SerialNumber)
)

CREATE TABLE OrderParts
(
	OrderId INT NOT NULL, 
	PartId INT NOT NULL,
	Quantity  INT CHECK (Quantity > 0) DEFAULT 1 NOT NULL, 
	CONSTRAINT PK_OrderPartsID PRIMARY KEY (OrderId, PartId),  
	CONSTRAINT FK_OrderParts_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
	CONSTRAINT FK_OrderParts_Parts FOREIGN KEY (PartId) REFERENCES Parts(PartId)
)

CREATE TABLE PartsNeeded
(
	JobId INT NOT NULL, 
	PartId INT NOT NULL, 
	Quantity  INT CHECK (Quantity > 0) DEFAULT 1 NOT NULL, 
	CONSTRAINT PK_PartsNeededID PRIMARY KEY (JobId, PartId),  
	CONSTRAINT FK_PartsNeeded_Jobs FOREIGN KEY (JobId) REFERENCES Jobs(JobId),
	CONSTRAINT FK_PartsNeeded_Parts FOREIGN KEY (PartId) REFERENCES Parts(PartId)
)

---===Pr. 2===---

INSERT INTO Clients (FirstName, LastName, Phone) VALUES
('Teri', 'Ennaco', '570-889-5187'),
('Merlyn', 'Lawler', '201-588-7810'),
('Georgene', 'Montezuma', '925-615-5185'),
('Jettie', 'Mconnell', '908-802-3564'),
('Lemuel', 'Latzke', '631-748-6479'),
('Melodie', 'Knipp', '805-690-1682'),
('Candida', 'Corbley', '908-275-8357')

INSERT INTO Parts (SerialNumber, Description, Price, VendorId) VALUES
('WP8182119', 'Door Boot Seal', 117.86, 2),
('W10780048', 'Suspension Rod', 42.81, 1),
('W10841140', 'Silicone Adhesive', 6.77, 4),
('WPY055980', 'High Temperature Adhesive', 13.94, 3)

---===Pr. 3===---

SELECT * FROM Mechanics WHERE LastName = 'Harnos'

SELECT * FROM Jobs
 WHERE MechanicId = 3

UPDATE Jobs
   SET MechanicId  = 3, Status = 'In Progress'
 WHERE Status = 'Pending'

---===Pr. 4===---

SELECT * FROM OrderParts WHERE OrderId = 19
SELECT * FROM Orders WHERE OrderId = 19

DELETE FROM OrderParts
 WHERE OrderId = 19

DELETE FROM Orders
 WHERE OrderId = 19

---===Pr. 5===---

SELECT FirstName, LastName, Phone
  FROM Clients
 ORDER BY LastName, ClientId

---===Pr. 6===---

SELECT Status, IssueDate 
  FROM Jobs
 WHERE Status <> 'Finished'
 ORDER BY IssueDate, JobId

---===Pr. 7===---

SELECT CONCAT(m.FirstName, ' ', m.LastName) [Mechanic], 
	   j.Status, 
	   IssueDate
  FROM Mechanics m
  JOIN Jobs j ON j.MechanicId = m.MechanicId
 ORDER BY m.MechanicId, j.IssueDate, j.JobId

---===Pr. 8===---

SELECT CONCAT(c.FirstName, ' ', c.LastName) [Client],
	   DATEDIFF(DD, j.IssueDate, '2017/04/24') [Days going], 
	   j.Status
  FROM Clients c
  JOIN Jobs j ON j.ClientId = c.ClientId
 WHERE j.Status <> 'Finished'
 ORDER BY [Days going] DESC, c.ClientId

---===Pr. 9===---

SELECT CONCAT(m.FirstName, ' ', m.LastName) [Mechanic], 
	   AVG(DATEDIFF(DD, j.IssueDate, j.FinishDate)) [AvgDays]
  FROM Jobs j
  JOIN Mechanics m ON m.MechanicId = j.MechanicId
 GROUP BY m.MechanicId, CONCAT(m.FirstName, ' ', m.LastName)
 ORDER BY m.MechanicId

---===Pr. 10===---

SELECT TOP 3
	   CONCAT(m.FirstName, ' ', m.LastName) [Mechanic],
	   COUNT(j.JobId) [Jobs]
  FROM Mechanics m
  JOIN Jobs j ON j.MechanicId = m.MechanicId
 WHERE j.Status <> 'Finished'
 GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId 
HAVING COUNT(j.JobId) > 1
 ORDER BY Jobs DESC, m.MechanicId

---===Pr. 11===---

SELECT CONCAT(m.FirstName, ' ', m.LastName) [Available] 
  FROM Mechanics m
 WHERE m.MechanicId NOT IN (SELECT MechanicId
							  FROM Jobs
							 WHERE FinishDate IS NULL AND MechanicId IS NOT NULL )
 GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
 ORDER BY m.MechanicId

---===Pr. 12===---

SELECT ISNULL(SUM(Price * op.Quantity), 0) [Parts Total]
  FROM PARTS p
  JOIN OrderParts op ON op.PartId = p.PartId
  JOIN Orders o ON o.OrderId = op.OrderId
 WHERE DATEDIFF(WW, IssueDate, '2017/04/27') <= 3

---===Pr. 13===---

SELECT j.JobId, 
	   ISNULL(SUM(p.Price * op.Quantity), 0) [Total]
  FROM Jobs j
  LEFT JOIN Orders o ON o.JobId = j.JobId
  LEFT JOIN OrderParts op ON op.OrderId = o.OrderId
  LEFT JOIN Parts p ON p.PartId = op.PartId
 WHERE j.Status = 'Finished'
 GROUP BY j.JobId
 ORDER BY Total DESC, j.JobId

---===Pr. 14===---

SELECT m.ModelId, 
	   m.Name,
	   CONCAT(AVG(DATEDIFF(DD, j.IssueDate, j.FinishDate)), ' days') [Average Service Time]
  FROM Models m
  JOIN Jobs j ON j.ModelId = m.ModelId
 GROUP BY m.ModelId, m.Name
 ORDER BY AVG(DATEDIFF(DD, j.IssueDate, j.FinishDate)) 

---===Pr. 15===---

SELECT TOP 1 WITH TIES
	   m.Name, 
	   COUNT(j.JobId) [Times Serviced], 
	   (SELECT ISNULL(SUM(op.Quantity * p.Price), 0)
		  FROM Jobs j
		  JOIN Orders o ON o.JobId = j.JobId
		  JOIN OrderParts op ON op.OrderId = o.OrderId
		  JOIN Parts p ON p.PartId = op.PartId
		 WHERE j.ModelId = m.ModelId) [Parts Total]
  FROM Models m
  JOIN Jobs j ON j.ModelId = m.ModelId
 GROUP BY m.Name, m.ModelId
 ORDER BY [Times Serviced] DESC

---===Pr. 16===---

SELECT p.PartId, 
	   p.Description, 
	   SUM(pn.Quantity) [Required], 
	   AVG(p.StockQty) [In Stock], 
	   ISNULL(SUM(op.Quantity), 0) [Ordered]
  FROM Parts p 
  JOIN PartsNeeded pn ON pn.PartId = p.PartId
  JOIN Jobs j ON j.JobId = pn.JobId
  LEFT JOIN Orders o ON o.JobId = j.JobId
  LEFT JOIN OrderParts op ON op.OrderId = o.OrderId
 WHERE j.Status <> 'Finished'
 GROUP BY p.PartId, p.Description
HAVING AVG(p.StockQty) + ISNULL(SUM(op.Quantity), 0) < SUM(pn.Quantity)
 ORDER BY p.PartId

---===Pr. 17===---

GO
CREATE FUNCTION udf_GetCost (@JobId INT)
RETURNS DECIMAL(6, 2)
AS 
BEGIN
	DECLARE @result DECIMAL(6, 2) = (SELECT ISNULL(SUM(op.Quantity * p.Price), 0)
									  FROM Parts p
									  JOIN OrderParts op ON op.PartId = p.PartId
									  JOIN Orders o ON o.OrderId = op.OrderId
									  JOIN Jobs j ON j.JobId = o.JobId
									 WHERE j.JobId = @JobId)
	RETURN @result
END
GO
--SELECT dbo.udf_GetCost(1)

---===Pr. 18===---

CREATE PROC usp_PlaceOrder(@JobId INT, @SerialNumber VARCHAR(50), @Quantity INT)
AS 
BEGIN
	DECLARE @JobStatus VARCHAR(11) = (SELECT [Status] FROM Jobs WHERE JobId = @JobId)
	DECLARE @CurrentJobId INT = (SELECT JobId FROM Jobs WHERE JobId = @JobId)
	DECLARE @PartId INT = (SELECT PartId FROM Parts WHERE SerialNumber = @SerialNumber)

	IF(@Quantity <=0)
	BEGIN;
		THROW 50012, 'Part quantity must be more than zero!', 1
		RETURN
	END
	ELSE IF(@currentJobId  IS NULL)
	BEGIN;
		THROW 50013, 'Job not found!', 1
		RETURN
	END
	ELSE IF(@JobStatus = 'Finished')
	BEGIN;
		THROW 50011, 'This job is not active!', 1
		RETURN
	END
	ELSE IF(@PartId IS NULL)
	BEGIN;
		THROW 50014, 'Part not found!', 1
		RETURN
	END

	DECLARE @OrderId INT = (SELECT o.OrderId
						  FROM Orders o 
						  JOIN OrderParts op ON op.OrderId = o.OrderId
						  JOIN Parts p ON p.PartId = op.PartId
						 WHERE JobId = @JobId AND p.PartId = @PartId AND IssueDate IS NULL)

	IF(@OrderId IS NULL)
	BEGIN
		INSERT INTO Orders(JobId, IssueDate) VALUES
		(@JobId, NULL)

		INSERT INTO OrderParts (OrderId, PartId, Quantity) VALUES
		(IDENT_CURRENT('Orders'), @PartId, @Quantity)
	END
	ELSE
	BEGIN
		DECLARE @PartExistsInOrder INT = (SELECT @@ROWCOUNT FROM OrderParts 
										   WHERE OrderId = @OrderId AND PartId = @PartId)

		IF(@PartExistsInOrder IS NULL)
		BEGIN
			INSERT INTO OrderParts (OrderId, PartId, Quantity) VALUES
			(@OrderId, @PartId, @Quantity)
		END
		ELSE
		BEGIN
			UPDATE OrderParts
			   SET Quantity += @Quantity
			 WHERE OrderId = @OrderId 
			   AND PartId = @PartId
		END
	    
	END
END


CREATE DATABASE WMS
GO

USE WMS

---===Pr. 19===---

SELECT * FROM Orders
SELECT * FROM OrderParts WHERE OrderId = 3
GO
CREATE TRIGGER tr_UpdateStock ON Orders FOR UPDATE
AS
BEGIN
	DECLARE @OldStatus INT = (SELECT Delivered FROM deleted)
	DECLARE @NewStatus INT = (SELECT Delivered FROM inserted)

	IF(@OldStatus = 0 AND @NewStatus = 1)
		BEGIN
			UPDATE Parts
			   SET StockQty += op.Quantity
			 FROM Parts p
			 JOIN OrderParts op ON op.PartId = p.PartId
			 JOIN Orders o ON o.OrderId = op.OrderId
			 JOIN inserted i ON i.OrderId = o.OrderId
			 JOIN deleted d ON d.OrderId = o.OrderId
			WHERE d.Delivered = 0 AND i.Delivered = 1
	END
END

---===Pr. 20===---

--Solution 5/10pts:
WITH cte 
AS
(
	SELECT m.MechanicId, SUM(op.Quantity) AS [Parts] 
	  FROM Mechanics m
	  JOIN Jobs j ON j.MechanicId = m.MechanicId
	  JOIN Orders o ON o.JobId = j.JobId
	  JOIN OrderParts op ON op.OrderId = o.OrderId
	  JOIN Parts p ON p.PartId = op.PartId
	  JOIN Vendors v ON v.VendorId = p.VendorId
	 GROUP BY m.MechanicId
)

SELECT CONCAT(m.FirstName, ' ', m.LastName) [Mechanic], 
	   v.Name [Vendor], 
	   COUNT(*) [Parts], 
	   CAST(CAST(CAST(COUNT(*) AS DECIMAL(6,2)) / cte.Parts * 100 AS int) AS varchar(10)) + '%' [Preference]
  FROM cte
  JOIN Jobs j ON j.MechanicId = cte.MechanicId
  JOIN Orders o ON o.JobId = j.JobId
  JOIN OrderParts op ON op.OrderId = o.OrderId
  JOIN Parts p ON p.PartId = op.PartId
  JOIN Vendors v ON v.VendorId = p.VendorId
  JOIN Mechanics m ON m.MechanicId = j.MechanicId
 GROUP BY CONCAT(m.FirstName, ' ', m.LastName), v.Name, cte.Parts
 ORDER BY Mechanic, Parts DESC, Vendor

--Solution 10/10pts
--WITH CTE_VendorPreference
--AS
--(
--    SELECT m.MechanicId, v.VendorId, SUM(op.Quantity) AS ItemsFromVendor FROM Mechanics AS m
--    JOIN Jobs AS j ON j.MechanicId = m.MechanicId
--    JOIN Orders AS o ON o.JobId = j.JobId
--    JOIN OrderParts op ON op.OrderId = o.OrderId
--    JOIN Parts AS p ON p.PartId = op.PartId
--    JOIN Vendors v ON v.VendorId = p.VendorId
--    GROUP BY m.MechanicId, v.VendorId
--)

--SELECT m.FirstName + ' ' + LastName AS Mechanic,
--       v.Name AS Vendor,
--       c.ItemsFromVendor AS Parts,
--CAST(CAST(CAST(ItemsFromVendor AS DECIMAL(6, 2)) / (SELECT SUM(ItemsFromVendor) FROM CTE_VendorPreference WHERE MechanicId = c.MechanicId) * 100 AS INT) AS VARCHAR(20)) + '%' AS Preference
--FROM CTE_VendorPreference AS c
--JOIN Mechanics m ON m.MechanicId = c.MechanicId
--JOIN Vendors v ON v.VendorId = c.VendorId
--ORDER BY Mechanic, Parts DESC, Vendor