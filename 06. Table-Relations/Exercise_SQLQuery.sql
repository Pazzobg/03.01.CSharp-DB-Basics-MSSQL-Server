---===Pr. 1===---

CREATE TABLE Persons(
PersonID INT NOT NULL,				
FirstName VARCHAR(50) NOT NULL,
Salary DECIMAL(8, 2), 
PassportID INT UNIQUE NOT NULL
)

CREATE TABLE Passports(
PassportID INT NOT NULL, 
PassportNumber VARCHAR(20) NOT NULL
CONSTRAINT PK_PassId PRIMARY KEY(PassportID)  
)

INSERT INTO Persons VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101)

SELECT * FROM Persons

INSERT INTO Passports VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

ALTER TABLE Persons
ADD CONSTRAINT PK_PersonId PRIMARY KEY(PersonID)  

ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

---===Pr. 2===---

CREATE TABLE Manufacturers(
ManufacturerID INT,
Name VARCHAR(50), 
EstablishedOn DATE
CONSTRAINT PK_ManufactID PRIMARY KEY (ManufacturerID)
)

CREATE TABLE Models(
ModelID INT,
Name VARCHAR(50),
ManufacturerID INT
CONSTRAINT PK_ModelID PRIMARY KEY (ModelID)
CONSTRAINT FK_Model_Manufact FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers VALUES
(1, 'BMW', '07/03/1916'),
(2,	'Tesla', '01/01/2003'),
(3, 'Lada', '01/05/1966')

INSERT INTO Models VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)

---===Pr. 3===---

CREATE TABLE Students(
StudentID INT, 
Name VARCHAR(50)
CONSTRAINT PK_StudentsId PRIMARY KEY (StudentID)
)

CREATE TABLE Exams(
ExamID INT, 
Name VARCHAR(50)
CONSTRAINT PK_ExamsId PRIMARY KEY (ExamID)
)

CREATE TABLE StudentsExams(
StudentID INT,
ExamID INT,
CONSTRAINT PK_StudentsExamsId PRIMARY KEY (StudentID, ExamID),
CONSTRAINT FK_StudentExam_StudentId FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_StudentExam_ExamId FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

---===Pr. 4===---

CREATE TABLE Teachers(
TeacherID INT, 
Name VARCHAR(50),
ManagerID INT
CONSTRAINT PK_TeachersId PRIMARY KEY(TeacherID), 
CONSTRAINT FK_ManagerId FOREIGN KEY(ManagerID) REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

---===Pr. 5===---

CREATE TABLE Cities(
CityID INT IDENTITY, 
Name VARCHAR(50)
CONSTRAINT PK_CityId PRIMARY KEY (CityId)
)

CREATE TABLE Customers(
CustomerID INT IDENTITY, 
Name VARCHAR(50), 
Birthday DATE, 
CityID INT
CONSTRAINT PK_CustomersId PRIMARY KEY(CustomerID), 
CONSTRAINT FK_CustomersCitiesId FOREIGN KEY(CityID) REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
OrderID INT IDENTITY, 
CustomerID INT
CONSTRAINT PK_OrdersId PRIMARY KEY(OrderID), 
CONSTRAINT FK_OrdersCustomersId FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes(
ItemTypeID INT IDENTITY, 
Name VARCHAR(50)
CONSTRAINT PK_ItemTypesId PRIMARY KEY (ItemTypeId)
)

CREATE TABLE Items(
ItemID INT IDENTITY, 
Name VARCHAR(50), 
ItemTypeID INT
CONSTRAINT PK_ItemsId PRIMARY KEY(ItemID), 
CONSTRAINT FK_ItemsItemTypesId FOREIGN KEY(ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems(
OrderID INT,
ItemID INT,
CONSTRAINT PK_OrdersItemsId PRIMARY KEY (OrderID, ItemID),
CONSTRAINT FK_OrdersItems_OrdersId FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
CONSTRAINT FK_OrdersItems_ItemsId FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
)

---===Pr. 6===---

CREATE TABLE Majors(
MajorID INT IDENTITY, 
Name VARCHAR(50)
CONSTRAINT PK_MajorsId PRIMARY KEY (MajorId)
)

CREATE TABLE Students(
StudentID INT IDENTITY, 
StudentNumber INT, 
StudentName VARCHAR(50), 
MajorID INT
CONSTRAINT PK_StudentsId PRIMARY KEY(StudentID), 
CONSTRAINT FK_StudentsMajorsId FOREIGN KEY(MajorID) REFERENCES Majors(MajorID)
)

CREATE TABLE Subjects(
SubjectID INT IDENTITY, 
SubjectName VARCHAR(50)
CONSTRAINT PK_SubjectsId PRIMARY KEY (SubjectId)
)

CREATE TABLE Agenda(
StudentID INT,
SubjectID INT,
CONSTRAINT PK_StudentsSubjectsId PRIMARY KEY (StudentID, SubjectID),
CONSTRAINT FK_StudSubjStudentsId FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_StudSubjSubjectsId FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
)

CREATE TABLE Payments(
PaymentID INT IDENTITY, 
PaymentDate DATETIME, 
PaymentAmount DECIMAL(8, 2),
StudentID INT
CONSTRAINT PK_PaymentsId PRIMARY KEY (PaymentID), 
CONSTRAINT FK_PmntStudentsId FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
)

---===Pr. 7===---

CREATE TABLE Towns(
TownID INT IDENTITY, 
Name VARCHAR(50)
CONSTRAINT PK_TownsId PRIMARY KEY (TownId)
)

CREATE TABLE Addresses(
AddressID INT IDENTITY, 
AddressText VARCHAR(50), 
TownID INT
CONSTRAINT PK_AddressesId PRIMARY KEY(AddressID), 
CONSTRAINT FK_AddressesTownsId FOREIGN KEY(TownID) REFERENCES Towns(TownID)
)

CREATE TABLE Departments(
DepartmentID INT IDENTITY, 
Name VARCHAR(50), 
ManagerID INT
CONSTRAINT PK_DepartmentsId PRIMARY KEY(DepartmentID)
)

CREATE TABLE Employees(
EmployeeID INT IDENTITY, 
FirstName VARCHAR(50), 
LastName VARCHAR(50), 
MiddleName VARCHAR(50), 
JobTitle VARCHAR(50), 
DepartmentID INT UNIQUE, 
ManagerID INT, 
HireDate DATE, 
Salary DECIMAL(15, 2), 
AddressID INT,
CONSTRAINT PK_EmployeesId PRIMARY KEY(EmployeeID), 
CONSTRAINT FK_EmployeesManagersId FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID), 
CONSTRAINT FK_EmployeesAddressId FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID) 
)

--AT THIS POINT FILL IN DATA IN TABLES 'Employees' AND 'Departments'

ALTER TABLE Departments
ADD CONSTRAINT FK_DepartmentsEmployees FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)

ALTER TABLE Employees
ADD CONSTRAINT FK_EmployeesDeptsId FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID), 

--CONTINUE WITH CREATING TABLES

CREATE TABLE Projects(
ProjectID INT IDENTITY, 
Name VARCHAR(50), 
Description VARCHAR(MAX), 
StartDate DATE, 
EndDate DATE, 
CONSTRAINT PK_ProjectsId PRIMARY KEY(ProjectID)
)

CREATE TABLE EmployeesProjects(
EmployeeID INT,
ProjectID INT,
CONSTRAINT PK_EmplProjId PRIMARY KEY (EmployeeID, ProjectID),
CONSTRAINT FK_EmplProjEmployeesId FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
CONSTRAINT FK_EmplProjProjectsId FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
)

---===Pr. 8===---

CREATE TABLE Continents(
ContinentCode VARCHAR(10), 
ContinentName VARCHAR(20)
CONSTRAINT PK_ContinentsId PRIMARY KEY(ContinentCode)
)

CREATE TABLE Currencies(
CurrencyCode VARCHAR(5), 
Description VARCHAR(500)
CONSTRAINT PK_CurrenciesId PRIMARY KEY(CurrencyCode)
)

CREATE TABLE Rivers(
Id INT IDENTITY,
RiverName VARCHAR(50),
Length DECIMAL(8, 2),
DrainageArea DECIMAL(8, 2),
AverageDischarge DECIMAL(8, 2),
Outflow VARCHAR(50)
CONSTRAINT PK_RiversId PRIMARY KEY(Id)
)

CREATE TABLE Countries(
CountryCode VARCHAR(10), 
IsoCode VARCHAR(10), 
CountryName VARCHAR(10), 
CurrencyCode VARCHAR(5), 
ContinentCode VARCHAR(10), 
Population INT, 
AreaInSqKm DECIMAL(15, 2), 
Capital VARCHAR(50)
CONSTRAINT PK_CountriesId PRIMARY KEY(CountryCode), 
CONSTRAINT FK_CountrieContinents FOREIGN KEY (ContinentCode) REFERENCES Continents(ContinentCode), 
CONSTRAINT FK_CountrieCurrencies FOREIGN KEY (CurrencyCode) REFERENCES Currencies(CurrencyCode)
)

CREATE TABLE CountriesRivers(
RiverId INT,
CountryCode VARCHAR(10),
CONSTRAINT PK_CountriesRiversId PRIMARY KEY (RiverId, CountryCode),
CONSTRAINT FK_CountrRivRiversId FOREIGN KEY (RiverId) REFERENCES Rivers(Id),
CONSTRAINT FK_CountrRivCountriesId FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
)

CREATE TABLE Mountains(
Id INT IDENTITY, 
MountainRange VARCHAR(100)
CONSTRAINT PK_MountainsId PRIMARY KEY(Id)
)

CREATE TABLE MountainsCountries(
MountainId INT,
CountryCode VARCHAR(10),
CONSTRAINT PK_MountainsCountriesId PRIMARY KEY (MountainId, CountryCode),
CONSTRAINT FK_MountCountrMountainsId FOREIGN KEY (MountainId) REFERENCES Mountains(Id),
CONSTRAINT FK_MountCountrCountriesId FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
)

CREATE TABLE Peaks(
Id INT IDENTITY, 
PeakName VARCHAR(50), 
Elevation DECIMAL(8, 2),
MountainId INT 
CONSTRAINT PK_PeaksId PRIMARY KEY(Id), 
CONSTRAINT FK_PeaksMountainId FOREIGN KEY(MountainId) REFERENCES Mountains(Id)
)

---===Pr. 9===---

SELECT m.MountainRange, p.PeakName, Elevation 
  FROM Mountains as m
  JOIN Peaks AS p ON p.MountainId = m.Id
 --WHERE m.Id = 17 also works
 WHERE m.MountainRange = 'Rila'
 ORDER BY p.Elevation DESC