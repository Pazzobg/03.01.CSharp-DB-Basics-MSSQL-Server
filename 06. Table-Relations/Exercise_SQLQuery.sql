CREATE DATABASE Relationships

USE Relationships

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

---===Pr. 9===---

SELECT m.MountainRange, p.PeakName, Elevation 
  FROM Mountains as m
  JOIN Peaks AS p ON p.MountainId = m.Id
 --WHERE m.Id = 17 also works
 WHERE m.MountainRange = 'Rila'
 ORDER BY p.Elevation DESC