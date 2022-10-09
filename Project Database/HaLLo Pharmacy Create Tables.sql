CREATE DATABASE HalloPharmacy
USE HalloPharmacy

CREATE TABLE EmployeeInformation(
	EmployeeID CHAR(5) PRIMARY KEY CHECK(EmployeeID LIKE 'EM[0-9][0-9][0-9]'),
	EmployeeName VARCHAR(50) NOT NULL,
	EmployeeEmail VARCHAR(50) CHECK(EmployeeEmail LIKE'%@hallo.com') NOT NULL,
	EmployeePhoneNumber VARCHAR(50) NOT NULL,
	EmployeeAddress VARCHAR(50) NOT NULL,
	EmployeeDateofBirth DATE NOT NULL,
	EmployeeGender VARCHAR(7) CHECK(EmployeeGender IN ('Male','Female')) NOT NULL,
	EmployeeSalary INT NOT NULL
)

CREATE TABLE CustomerInformation(
	CustomerID CHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50) NOT NULL,
	CustomerPhoneNumber VARCHAR(50) NOT NULL,
	CustomerAddress VARCHAR(50) NOT NULL,
	CustomerGender VARCHAR(6) CHECK(CustomerGender IN ('Male','Female')) NOT NULL,
	CustomerEmail VARCHAR(50) CHECK(CustomerEmail LIKE'%hallo.com') NOT NULL,
	CustomerPassword VARCHAR(50) NOT NULL,
	CustomerDateofBirth DATE NOT NULL
)

CREATE TABLE VendorInformation(
	VendorID CHAR(5) PRIMARY KEY CHECK(VendorID LIKE 'VN[0-9][0-9][0-9]'),
	VendorName VARCHAR(50) CHECK(LEN(VendorName)>3) NOT NULL,
	VendorPhone VARCHAR(50) NOT NULL,
	VendorAddress VARCHAR(50) NOT NULL,
	VendorEmail VARCHAR(50) CHECK(VendorEmail LIKE'%hallo.com') NOT NULL,
	VendorEstablishedYear INT NOT NULL
)

CREATE TABLE MedicineCategory(
	MedicineCategoryID CHAR(5) PRIMARY KEY CHECK(MedicineCategoryID LIKE'CT[0-9][0-9][0-9]'),
	MedicineCategoryName VARCHAR(50) CHECK(MedicineCategoryName IN('Amidopyrine','Phenacetin','Methaqualone')) NOT NULL
)

CREATE TABLE MedicineInformation(
	MedicineID CHAR(5) PRIMARY KEY CHECK(MedicineID LIKE'MD[0-9][0-9][0-9]'),
	MedicineName VARCHAR(50) NOT NULL,
	MedicinePrice INT CHECK(MedicinePrice BETWEEN 5000 AND 100000)NOT NULL,
	MedicineDescription VARCHAR(100) NOT NULL,
	MedicineStock INT NOT NULL,
	MedicineCategoryID CHAR(5) FOREIGN KEY REFERENCES MedicineCategory(MedicineCategoryID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
)

CREATE TABLE PurchaseTransactionHeader(
	PurchaseTransactionID CHAR(5) PRIMARY KEY CHECK(PurchaseTransactionID LIKE'PC[0-9][0-9][0-9]'),
	EmployeeID CHAR(5) FOREIGN KEY REFERENCES EmployeeInformation(EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	VendorID CHAR(5) FOREIGN KEY REFERENCES VendorInformation(VendorID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TransactionDate DATE NOT NULL
)

CREATE TABLE PurchaseTransactionDetail(
	PurchaseTransactionID CHAR (5) FOREIGN KEY REFERENCES PurchaseTransactionHeader(PurchaseTransactionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	MedicineID CHAR(5) FOREIGN KEY REFERENCES MedicineInformation(MedicineID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	MedicineQuantity INT NOT NULL,
	PRIMARY KEY(PurchaseTransactionID, MedicineID)
)

CREATE TABLE SalesTransactionHeader(
	SalesTransactionID CHAR(5) PRIMARY KEY CHECK(SalesTransactionID LIKE 'SL[0-9][0-9][0-9]'),
	EmployeeID CHAR(5) FOREIGN KEY REFERENCES EmployeeInformation(EmployeeID) NOT NULL,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES CustomerInformation(CustomerID) NOT NULL,
	PurchaseTransactionDate DATE NOT NULL
)

CREATE TABLE SalesTransactionDetail(
	SalesTransactionID CHAR(5) FOREIGN KEY REFERENCES SalesTransactionHeader(SalesTransactionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	MedicineID CHAR(5) FOREIGN KEY REFERENCES MedicineInformation(MedicineID) NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(SalesTransactionID, MedicineID)
)
