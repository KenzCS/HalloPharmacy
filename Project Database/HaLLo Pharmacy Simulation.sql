-- Albert Sanjaya (customerID CU001) datang ke HaLLo Pharmacy untuk membeli:
-- Golden Apple (MD003) 5 buah
-- Melatanin (MD004) 6 buah
-- Dia dilayani oleh Luther Jenkins (employeeID = EM001) pada tanggal 2021-12-17

INSERT INTO SalesTransactionHeader VALUES
('SL027', 'EM001', 'CU001','2021-12-17')

INSERT INTO SalesTransactionDetail VALUES
('SL027','MD003',5),
('SL027','MD004',6)