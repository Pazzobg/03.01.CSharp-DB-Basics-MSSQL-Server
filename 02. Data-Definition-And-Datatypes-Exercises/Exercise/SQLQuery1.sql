
---===Pr. 1===---

CREATE DATABASE Minions
COLLATE Cyrillic_General_100_CI_AI

USE Minions

---===Pr. 2===---

CREATE TABLE Minions (
	Id INT NOT NULL, 
	Name NVARCHAR(50) NOT NULL, 
	Age INT, 
	CONSTRAINT PK_Id PRIMARY KEY (Id)
)

CREATE TABLE Towns (
	Id INT PRIMARY KEY NOT NULL, 
	Name NVARCHAR(50) NOT NULL
)

SELECT * FROM Minions

SELECT * FROM Towns

---===Pr. 3===---

ALTER TABLE Minions
ADD TownId INT
CONSTRAINT FK_tId FOREIGN KEY (TownId) REFERENCES Towns(Id)

---===Pr. 4===---

INSERT INTO Towns (Id, Name) VALUES
(1, 'Sofia'), 
(2, 'Plovdiv'), 
(3, 'Varna')

INSERT INTO Minions (Id, Name, Age, TownId) VALUES
(1, 'Kevin', 22, 1), 
(2, 'Bob', 15, 3), 
(3, 'Steward', NULL, 2)

SELECT * FROM Minions

SELECT * FROM Towns

---===Pr. 5===---

TRUNCATE TABLE Minions

---===Pr. 6===---

DROP TABLE Minions
DROP TABLE Towns

---===Pr. 7===---

CREATE TABLE People (
	Id INT PRIMARY KEY IDENTITY NOT NULL, 
	Name NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX), 
	Height DECIMAL(15, 2), 
	Weight DECIMAL(15, 2),
	Gender CHAR(1) NOT NULL CONSTRAINT CheckGenderValidity CHECK(Gender IN ('m', 'f')), 
	Birthdate DATE NOT NULL, 
	Biography NVARCHAR(MAX)
)

INSERT INTO People (Name, Height, Weight, Gender, Birthdate, Biography) VALUES 
('Ivan Ivanov', 1.77, 90, 'm', '1990-5-12', 'just some guy'), 
('Petar Petrov', 1.74, 120, 'm', '1981/3/8', 'another guy'), 
('Kolyo Kolev', 1.76, 92, 'm', '1984/4/29', 'yet another guy'), 
('Milyo Milev', 1.72, 88, 'm', '1982/1/4', 'a guy'), 
('Tosho Toshev', 1.79, 99, 'm', '1984/2/11', 'a guy?')

SELECT * FROM People

---===Pr. 8===---

CREATE TABLE Users (
	Id BIGINT PRIMARY KEY IDENTITY NOT NULL, 
	Username VARCHAR(30) NOT NULL,
	Password VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(900), 
	LastLoginTime SMALLDATETIME, 
	IsDeleted BIT,
)

INSERT INTO Users (Username, Password, LastLoginTime) VALUES
('Dimitar Glavchev', 7095, '2017-09-20 18:15'), 
('Hristo Biserov', 2134, '2017-09-1 18:54'), 
('Dimitar Tsonev', 4125, '2017-2-20 18:23'), 
('Iskra Fidosieva', 2222, '2014-09-20 18:11'),
('Hristo Ivanov', 1232, '2017-09-20 18:40')

SELECT * FROM Users

---===Pr. 9===---

ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC071BDB9207

ALTER TABLE Users
ADD CONSTRAINT PK_CompositePK
PRIMARY KEY(Id, Username)

---===Pr. 10===---

ALTER TABLE Users
ADD CONSTRAINT PasswordMinLength
CHECK (LEN(Password) > 5)

---===Pr. 11===---

ALTER TABLE Users
ADD DEFAULT GETDATE()
FOR LastLoginTime

---===Pr. 12===---

ALTER TABLE Users
DROP CONSTRAINT PK_CompositePK

ALTER TABLE Users
ADD CONSTRAINT PK_IdPrimKey
PRIMARY KEY(Id)

ALTER TABLE Users
ADD CONSTRAINT uq_Users
UNIQUE (Username)

ALTER TABLE Users
ADD CONSTRAINT UsernameMinLength
CHECK (LEN(Username) > 3)

---===Pr. 13===---

CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors (
	Id INT IDENTITY NOT NULL, 
	DirectorName NVARCHAR(100) NOT NULL, 
	Notes NVARCHAR(MAX)
	CONSTRAINT PK_Id_Directors PRIMARY KEY (Id)
)

INSERT INTO Directors(DirectorName) VALUES
('George Lucas'), 
('Steven Spielberg'),
('Goran Bregovich'),
('J. J. Abrams'), 
('David Nutter')

CREATE TABLE Genres (
	Id INT IDENTITY NOT NULL, 
	GenreName NVARCHAR(50) NOT NULL, 
	Notes NVARCHAR(MAX)
	CONSTRAINT PK_Id_Genres PRIMARY KEY (Id)
)

INSERT INTO Genres(GenreName) VALUES
('Sci-Fi'), 
('Action'),
('Thriller'),
('Comedy'), 
('Drama')

CREATE TABLE Categories (
	Id INT IDENTITY NOT NULL, 
	CategoryName NVARCHAR(50) NOT NULL, 
	Notes NVARCHAR(MAX)
	CONSTRAINT PK_Id_Categories PRIMARY KEY (Id)
)

INSERT INTO Categories(CategoryName) VALUES
('A'), 
('B'),
('C'),
('D'), 
('M')

CREATE TABLE Movies (
	Id INT IDENTITY NOT NULL, 
	Title NVARCHAR(100) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
	CopyrightYear SMALLINT, 
	Length INT NOT NULL, 
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Rating DECIMAL(4,2) NOT NULL,
	Notes NVARCHAR(MAX)
	CONSTRAINT PK_Id_Movies PRIMARY KEY (Id)
)

INSERT INTO Movies(Title, DirectorId, Length, GenreId, CategoryId, Rating) VALUES
('Star Wars Episode VIII', 1, 2, 1, 3, 9.5), 
('Falling Skies', 2, 1, 1, 3, 9.2), 
('Lost', 4, 1, 3, 4, 9.1), 
('Cherna kotka, bql kotarak', 3, 2, 4, 2, 8.54), 
('Game Of Thrones', 5, 1, 5, 5, 9.8)

---===Pr. 14===---

CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories (
	Id INT IDENTITY NOT NULL,
	CategoryName NVARCHAR(20) NOT NULL, 
	DailyRate DECIMAL(10,2) NOT NULL, 
	WeeklyRate DECIMAL(10,2) NOT NULL, 
	MonthlyRate DECIMAL(10,2) NOT NULL,
	WeekendRate DECIMAL(10,2) NOT NULL
	CONSTRAINT PK_Id_Categories PRIMARY KEY (Id)
)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
('Compact', 49.99, 299.99, 1149.99, 89.99), 
('SUV', 89.99, 539.99, 2199.99, 169.99), 
('Convertible', 99.99, 599.99, 2549.99, 189.99)

CREATE TABLE Cars (
	Id INT IDENTITY NOT NULL,
	PlateNumber NVARCHAR(20) NOT NULL, 
	Manufacturer NVARCHAR(30) NOT NULL, 
	Model NVARCHAR(30) NOT NULL, 
	CarYear NVARCHAR(10) NOT NULL, 
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Doors TINYINT NOT NULL, 
	Picture VARBINARY(MAX), 
	Condition NVARCHAR(20), 
	Available BIT NOT NULL
	CONSTRAINT PK_Id_Cars PRIMARY KEY (Id)
)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Available) VALUES
('CA1234CA', 'Opel', 'Astra', 2015, 1, 4, 1),
('CA4535CA', 'Ford', 'Mustang', 2016, 3, 2, 0),
('CA9999CB', 'Audi', 'Q5', 2016, 2, 4, 1)

CREATE TABLE Employees (
	Id INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	Title NVARCHAR(50), 
	Notes NVARCHAR(1000)
	CONSTRAINT PK_Id_Employees PRIMARY KEY (Id)
)

INSERT INTO Employees(FirstName, LastName) VALUES
('Peter', 'Jackson'),
('John', 'McLane'),
('Jessica', 'Smith')

CREATE TABLE Customers (
	Id INT IDENTITY NOT NULL,
	DriverLicenceNumber VARCHAR(20) NOT NULL,
	FullName NVARCHAR(80) NOT NULL, 
	Address NVARCHAR(200) NOT NULL, 
	City NVARCHAR(50), 
	ZIPCode VARCHAR(10),
	Notes NVARCHAR(1000)
	CONSTRAINT PK_Id_Customers PRIMARY KEY (Id)
)

INSERT INTO Customers(DriverLicenceNumber, FullName, Address, City, ZIPCode) VALUES
('18684584 A5', 'John Snow', 'The Castle', 'Winterfell', '8000WC'),
('18684584 A5', 'Denaeris Targarien', 'The Castle', 'The Desert', '4000AZ'),
('18684584 A5', 'Cersei Lanister', 'The Castle', 'Kings Landing', '1000NY')

CREATE TABLE RentalOrders (
	Id INT IDENTITY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
	TankLevel TINYINT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage INT NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	TotalDays SMALLINT NOT NULL,
	RateApplied NVARCHAR(20) NOT NULL,
	TaxRate DECIMAL(10, 2) NOT NULL,
	OrderStatus NVARCHAR(20) NOT NULL,
	Notes NVARCHAR(1000)
	CONSTRAINT PK_Id_RentalOrders PRIMARY KEY (Id)
)
select * from RentalOrders
INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus) VALUES
(1, 1, 1, 50, 8450, 8650, 200, '20170512', '20170514', 2, 'WeekendRate', 7.5, 'Finished'),
(2, 2, 2, 60, 10500, 12700, 2200, '20170622', '20170630', 8, 'MonthlyRate', 7.5, 'Finished'),
(3, 3, 3, 65, 2250, 2650, 400, '20170920', '20170924', 4, 'WeeklyRate', 7.5, 'In Progress')

---===Pr. 15===---

CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees (
	Id INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	Title NVARCHAR(50), 
	Notes NVARCHAR(1000)
	CONSTRAINT PK_Id_Employees PRIMARY KEY (Id)
)

INSERT INTO Employees(FirstName, LastName) VALUES
('Peter', 'Jackson'),
('John', 'McLane'),
('Jessica', 'Smith')

CREATE TABLE Customers (
	AccountNumber INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	PhoneNumber VARCHAR(20) NOT NULL,
	EmergencyName NVARCHAR(50) NOT NULL, 
	EmergencyNumber VARCHAR(20) NOT NULL,
	Notes NVARCHAR(1000)
	CONSTRAINT PK_Id_Customers PRIMARY KEY (AccountNumber)
)

INSERT INTO Customers(FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber) VALUES
('Ivan', 'Ivanov', '+359 898 498754', 'Tanya Ivanova', '+359 878 486846'),
('Petar', 'Petrov', '+359 888 123432', 'Petya Petrova', '+359 878 651875'),
('Todor', 'Todorov', '+359 898 727282', 'Maria Todorova', '+359 878 728638')

CREATE TABLE RoomStatus (
	RoomStatus NVARCHAR(20) NOT NULL,
	Notes NVARCHAR(400)
	CONSTRAINT PK_Id_RoomStatus PRIMARY KEY (RoomStatus)
)

INSERT INTO RoomStatus (RoomStatus) VALUES
('Free'), 
('Occupied'), 
('Unavailable')

CREATE TABLE RoomTypes (
	RoomType NVARCHAR(15) NOT NULL,
	Notes NVARCHAR(400)
	CONSTRAINT PK_Id_RoomType PRIMARY KEY (RoomType)
)

INSERT INTO RoomTypes(RoomType) VALUES
('SGL'), 
('DBL'), 
('APT')

CREATE TABLE BedTypes (
	BedType NVARCHAR(20) NOT NULL,
	Notes NVARCHAR(400)
	CONSTRAINT PK_Id_BedTypes PRIMARY KEY (BedType)
)

INSERT INTO BedTypes (BedType) VALUES
('Double bed'), 
('Twin Beds'), 
('King-size Bed')

CREATE TABLE Rooms (
	RoomNumber INT NOT NULL,
	RoomType NVARCHAR(15) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
	BedType NVARCHAR(20) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
	Rate DECIMAL NOT NULL,
	RoomStatus NVARCHAR(20) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
	Notes NVARCHAR(400)
	CONSTRAINT PK_Id_Rooms PRIMARY KEY (RoomNumber)
)

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus) VALUES
(214, 'SGL', 'Double bed', 69.90, 'Occupied'), 
(252, 'APT', 'King-size Bed', 144.90, 'Free'),
(117, 'DBL', 'Twin Beds', 99.90, 'Unavailable')


CREATE TABLE Payments (
	Id INT IDENTITY NOT NULL, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATE NOT NULL, 
	AccountNumber VARCHAR(40) NOT NULL, 
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays SMALLINT, 
	AmountCharged DECIMAL NOT NULL,
	TaxRate DECIMAL NOT NULL,
	TaxAmount DECIMAL NOT NULL,
	PaymentTotal DECIMAL NOT NULL,
	Notes NVARCHAR(400)
	CONSTRAINT PK_Id_Payments PRIMARY KEY (Id)
)

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate,     TaxAmount, PaymentTotal) VALUES
(1, '20161212', 'BG7950CITI79845611', '20161210', '20161212', 2, 150, 10, 15, 165),
(2, '20160301', 'DE7601FIBA40684648', '20160225', '20160301', 4, 300, 10, 30, 330),
(3, '20160607', 'BG7062UNCR68546135', '20160606', '20160607', 1, 145, 10, 14.50, 159.50)

CREATE TABLE Occupancies (
	Id INT IDENTITY NOT NULL, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	AccountNumber VARCHAR(40) NOT NULL, 
	RoomNumber INT NOT NULL,
	RateApplied DECIMAL NOT NULL,
	PhoneCharge DECIMAL, 
	Notes NVARCHAR(400)
	CONSTRAINT PK_Id_Occupancies PRIMARY KEY (Id)
)

INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge) VALUES
(1, '20161212', 'BG7950CITI79845611', 214, 69.90, NULL),
(2, '20160301', 'DE7601FIBA40684648', 252, 98.90, 18.47),
(3, '20160607', 'BG7062UNCR68546135', 106, 144.90, 7.63)

---===Pr. 16===---

CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns (
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(50) NOT NULL
	CONSTRAINT PK_Id_Towns PRIMARY KEY (Id)
)

CREATE TABLE Addresses (
	Id INT IDENTITY NOT NULL, 
	AddressText NVARCHAR(200) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
	CONSTRAINT PK_Id_Addresses PRIMARY KEY (Id)
)

CREATE TABLE Departments (
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Id_Departments PRIMARY KEY (Id)
)

CREATE TABLE Employees (
	Id INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL, 
	MiddleName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	JobTitle NVARCHAR(50) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATE, 
	Salary DECIMAL NOT NULL, 
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
	CONSTRAINT PK_Id_Employees PRIMARY KEY (Id)
)

---===Pr. 17===---

BACKUP DATABASE SoftUni
TO DISK = 'D:\SoftUni\3.1. C#-DB-Fundamentals-DB-Basics-MSSQL-Server\02. Data-Definition-And-Datatypes-Exercises\softuni-backup.bak'
	WITH FORMAT,  
      MEDIANAME = 'D_SQLServerBackups',  
      NAME = 'Backup of SU-DataBase-Exercise';  

USE Minions

DROP DATABASE SoftUni

RESTORE DATABASE SoftUni
FROM DISK = 'D:\SoftUni\3.1. C#-DB-Fundamentals-DB-Basics-MSSQL-Server\02. Data-Definition-And-Datatypes-Exercises\softuni-backup.bak'

USE SoftUni

---===Pr. 18===---

INSERT INTO Towns (Name) VALUES
('Sofia'), 
('Plovdiv'), 
('Varna'), 
('Burgas')

INSERT INTO Departments (Name) VALUES
('Engineering'), 
('Sales'), 
('Marketing'), 
('Software Development'), 
('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '01/02/2013', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '02/03/2004', 4000.00), 
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08/28/2016', 525.25), 
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '09/12/2007', 3000.00), 
('Peter', 'Pan', 'Pan', 'Intern', 3, '08/28/2016', 599.88)

---===Pr. 19===---

SELECT * FROM Towns

SELECT * FROM Departments

SELECT * FROM Employees

---===Pr. 20===---

SELECT * FROM Towns ORDER BY Name

SELECT * FROM Departments ORDER BY Name

SELECT * FROM Employees ORDER BY Salary DESC

---===Pr. 21===---

SELECT Name FROM Towns ORDER BY Name

SELECT Name FROM Departments ORDER BY Name

SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

---===Pr. 22===---

UPDATE Employees
SET Salary += Salary * 0.1

SELECT Salary from Employees

---===Pr. 23===---

USE Hotel

UPDATE Payments
SET TaxRate -= TaxRate * 0.03

SELECT TaxRate FROM Payments

---===Pr. 23===---
USE Hotel

TRUNCATE TABLE Occupancies

SELECT * FROM Occupancies