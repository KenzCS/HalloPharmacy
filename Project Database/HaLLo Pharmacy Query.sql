-- 1.
SELECT [Customer ID]=ci.CustomerID, [Customer Name]=CustomerName, [Transaction Date]=PurchaseTransactionDate,
[Medicine Bought]=SUM(Quantity)
FROM CustomerInformation ci
JOIN SalesTransactionHeader sth ON sth.CustomerID = ci.CustomerID
JOIN SalesTransactionDetail std ON std.SalesTransactionID = sth.SalesTransactionID
WHERE DAY(PurchaseTransactionDate) >= 20 AND DAY(PurchaseTransactionDate) <= 30 AND CustomerGender = 'Female'
GROUP BY ci.CustomerID, CustomerName, PurchaseTransactionDate

-- 2.
SELECT [Employee Number]=SUBSTRING(ei.EmployeeID,3,3), [Employee Name]=EmployeeName, 
[Customer Served] = CONCAT(COUNT(SalesTransactionID),' customer(s)')
FROM EmployeeInformation ei
JOIN SalesTransactionHeader sth ON sth.EmployeeID = ei.EmployeeID
WHERE (EmployeeName LIKE '%b%' OR EmployeeName LIKE '%B%' OR EmployeeName LIKE 'B%' OR EmployeeName LIKE '%b') AND EmployeeGender = 'Female'
GROUP BY SUBSTRING(ei.EmployeeID,3,3), EmployeeName 

--3.
SELECT [Customer ID]=ci.CustomerID, [Customer Name]=CustomerName, [Date of Birth] = CONVERT(VARCHAR, PurchaseTransactionDate, 106),
[Transaction Count] = COUNT(DISTINCT(sth.SalesTransactionID)), [Total Purchase] = SUM(MedicinePrice * Quantity)
FROM CustomerInformation ci
JOIN SalesTransactionHeader sth ON sth.CustomerID = ci.CustomerID
JOIN SalesTransactionDetail std ON std.SalesTransactionID = sth.SalesTransactionID
JOIN MedicineInformation mi ON mi.MedicineID = std.MedicineID
WHERE MONTH(PurchaseTransactionDate) >= 1 AND MONTH(PurchaseTransactionDate) <= 6 
AND (EmployeeID LIKE 'EM004' OR EmployeeID LIKE 'EM006' OR EmployeeID LIKE 'EM008')
GROUP BY ci.CustomerID, CustomerName, convert(varchar, PurchaseTransactionDate, 106)

-- 4.
SELECT [Employee ID]=ei.EmployeeID, [Employee Name]=EmployeeName, [Local Phone Number]=CONCAT('62',SUBSTRING(EmployeePhoneNumber,3,10)),
[Transaction Done] = COUNT(pth.PurchaseTransactionID), [Total Medicine Bought] = CONCAT(SUM(MedicineQuantity),' item(s)')
FROM EmployeeInformation ei
JOIN PurchaseTransactionHeader pth ON pth.EmployeeID = ei.EmployeeID
JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseTransactionID  = pth.PurchaseTransactionID
JOIN VendorInformation vi ON vi.VendorID = pth.VendorID
WHERE DAY(pth.TransactionDate) >= 10 AND DAY(pth.TransactionDate) <= 20 AND vi.VendorEstablishedYear > 2000
GROUP BY ei.EmployeeID, EmployeeName, CONCAT('62',SUBSTRING(EmployeePhoneNumber,3,10))
-- replace 08 jadi 62

-- 5
SELECT [Numeric Medicine ID]=SUBSTRING(mi.MedicineID,3,3), [MedicineName]=MedicineName, [Category Name] = MedicineCategoryName,
[Price] = CONCAT('Rp. ', MedicinePrice), [Medicine Stock]=MedicineStock
FROM MedicineInformation mi
JOIN MedicineCategory mc ON mc.MedicineCategoryID=mi.MedicineCategoryID
WHERE MedicinePrice > 50000  AND MedicineStock < (
	SELECT AVG(Quantity) FROM SalesTransactionHeader sth
	JOIN SalesTransactionDetail std ON std.SalesTransactionID = sth.SalesTransactionID
)

-- 6
SELECT [Employee Code]=CONCAT('Employee',SUBSTRING(ei.EmployeeID,3,3)), [Employee Name] = EmployeeName,
[Transaction Date] = CONVERT(VARCHAR, PurchaseTransactionDate, 1), [Medicine Name] = MedicineName,
[Medicine Price] = MedicinePrice, Quantity, EmployeeSalary
FROM EmployeeInformation ei
JOIN SalesTransactionHeader sth ON ei.EmployeeID = sth.EmployeeID
JOIN SalesTransactionDetail std ON sth.SalesTransactionID = std.SalesTransactionID
JOIN MedicineInformation mi ON mi.MedicineID = std.MedicineID
WHERE DAY(PurchaseTransactionDate) = 2 AND ei.EmployeeSalary < (
	SELECT AVG(EmployeeSalary) FROM EmployeeInformation
)

-- 7
SELECT [Customer ID]=ci.CustomerID, [Customer Name]=CustomerName, 
[Local Customer Number]=CONCAT('62',SUBSTRING(CustomerPhoneNumber,3,10)),
[Date of Birth] = CONVERT(VARCHAR, CustomerDateofBirth, 107), [Medicine Bought] = CONCAT(SUM(Quantity),' item(s)')
FROM CustomerInformation ci
JOIN SalesTransactionHeader sth ON sth.CustomerID = ci.CustomerID
JOIN SalesTransactionDetail std ON std.SalesTransactionID = sth.SalesTransactionID
WHERE CustomerGender NOT IN('Male')
GROUP BY ci.CustomerID, CustomerName, CONCAT('62',SUBSTRING(CustomerPhoneNumber,3,10)), CONVERT(VARCHAR, CustomerDateofBirth, 107)
HAVING SUM(Quantity) > (
	SELECT AVG(Quantity2)  
	FROM (
		SELECT SUM(Quantity) as Quantity2 FROM CustomerInformation ci
		JOIN SalesTransactionHeader sth ON sth.CustomerID = ci.CustomerID
		JOIN SalesTransactionDetail std ON std.SalesTransactionID = sth.SalesTransactionID
		GROUP BY ci.CustomerID
	)sub1
)
 

-- 8
SELECT [Employee ID] = ei.EmployeeID, [Employee Name] = LEFT(EmployeeName, charindex(' ', EmployeeName) - 1), 
[Salary] = CONCAT('Rp. ',EmployeeSalary), [Date of Birth] = CONVERT(VARCHAR, EmployeeDateofBirth, 107), 
[Transaction Served] = COUNT(SalesTransactionID)
FROM EmployeeInformation ei
JOIN SalesTransactionHeader sth ON sth.EmployeeID = ei.EmployeeID
WHERE EmployeeName LIKE '% %'
GROUP BY ei.EmployeeID,LEFT(EmployeeName, charindex(' ', EmployeeName) - 1),
CONCAT('Rp. ',EmployeeSalary),CONVERT(VARCHAR, EmployeeDateofBirth, 107)
HAVING COUNT(SalesTransactionID) > (
	SELECT AVG(AverageSales) FROM (
		SELECT COUNT(SalesTransactionID) AS AverageSales FROM SalesTransactionHeader
		GROUP BY EmployeeID
	) sub1
)

-- 9
CREATE VIEW VendorMaximumAverageQuantityViewer AS
SELECT [Vendor ID]=vi.VendorID, [Vendor Name]=VendorName, [Average Supplied Quantity]=CONCAT(AVG(ptd.MedicineQuantity), ' item(s)'),
[Maximum Supplied Quantity]=CONCAT(MAX(ptd.MedicineQuantity),' item(s)')
FROM VendorInformation vi
JOIN PurchaseTransactionHeader pth ON pth.VendorID = vi.VendorID
JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseTransactionID = pth.PurchaseTransactionID
WHERE (VendorName LIKE '%a%' OR VendorName LIKE '%A%' OR VendorName LIKE 'A%' OR VendorName LIKE '%a')
GROUP BY vi.VendorID, VendorName
HAVING MAX(ptd.MedicineQuantity) > 5

SELECT * FROM VendorMaximumAverageQuantityViewer


-- 10
CREATE VIEW VendorSupplyViewer AS
SELECT [Vendor Number]=SUBSTRING(vi.VendorID,3,3), [Vendor Name]=VendorName, [Vendor Address]=VendorAddress,
[Total Supplied Value] = CONCAT('Rp. ',SUM(MedicinePrice * MedicineQuantity)), 
[Medicine Type Supplied] = CONCAT(COUNT(mc.MedicineCategoryName), ' medicine(s)')
FROM VendorInformation vi
JOIN PurchaseTransactionHeader pth ON pth.VendorID = vi.VendorID
JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseTransactionID = pth.PurchaseTransactionID
JOIN MedicineInformation mi ON mi.MedicineID = ptd.MedicineID
JOIN MedicineCategory mc ON mc.MedicineCategoryID = mi.MedicineCategoryID
GROUP BY SUBSTRING(vi.VendorID,3,3), VendorName, VendorAddress
HAVING SUM(MedicinePrice * MedicineQuantity) > 150000 AND COUNT(mc.MedicineCategoryName) > 2

SELECT * FROM VendorMaximumAverageQuantityViewer