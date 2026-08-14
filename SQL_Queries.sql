CREATE DATABASE MaintenancePrediction;
GO
USE MaintenancePrediction;
GO
CREATE TABLE MachineData(
Product_ID VARCHAR(20) PRIMARY KEY,
Type CHAR(1),
Machine_Failure BIT
);

CREATE TABLE Sensors(
Product_ID VARCHAR(20) PRIMARY KEY,
Air_Temperature_K FLOAT,
Process_Temperature_K FLOAT,
Rotational_Speed_RPM INT,
Torque_Nm FLOAT,
Tool_Wear_min INT,
FOREIGN KEY (Product_ID) REFERENCES MachineData(Product_ID)
);

CREATE TABLE Maintenance (
MaintenanceID INT PRIMARY KEY IDENTITY(1,1),
Product_ID VARCHAR (20),
Maintenance_Date DATE,
Maintenance_Cost FLOAT,
Technician VARCHAR(10),
FOREIGN KEY (Product_ID) REFERENCES MachineData (Product_ID)
);

CREATE TABLE Operators(
OperatorID INT PRIMARY KEY IDENTITY(1,1),
Product_ID VARCHAR(20),
Operator_Name VARCHAR(50),
Shift CHAR(1),
FOREIGN KEY (Product_ID) REFERENCES MachineData (Product_ID)
);

Select * from MachineData_temp; -- ignore red line

INSERT INTO MachineData(Product_ID, Type, Machine_Failure)
Select Product_ID, Type, Machine_Failure
from MachineData_temp;

Select COUNT(*) from MachineData;

INSERT INTO Sensors(Product_ID, Air_Temperature_K, Process_Temperature_K,Rotational_Speed_RPM,Torque_Nm,Tool_Wear_min)
Select Product_ID, Air_Temperature_K, Process_Temperature_K,Rotational_Speed_RPM,Torque_Nm,Tool_Wear_min
from Sensors_temp;

-- creating data for maintenance table
INSERT INTO Maintenance(Product_ID,Maintenance_Date, Maintenance_Cost,Technician)
SELECT Product_ID, DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, '2025-01-01'),
500 + (ABS(CHECKSUM(NEWID())) % 4501),
CONCAT('Tech_', ABS(CHECKSUM(NEWID())) %20 +1)
FROM MachineData;  

SELECT TOP 5 * FROM Maintenance;

-- creating data for Operators table
INSERT INTO Operators(Product_ID, Operator_Name, Shift)
Select Product_ID, CONCAT('Operartor_', ABS(CHECKSUM(NEWID()))%100+1),
CASE 
	WHEN ABS(CHECKSUM(NEWID())) % 3 =0 THEN 'A'
	WHEN ABS(CHECKSUM(NEWID())) % 3 =1 THEN 'B'
	ELSE 'C'
END
FROM MachineData;

SELECT TOP 5 * FROM Operators;

-- Total machines failed
SELECT COUNT(*) AS Failed_Machines FROM MachineData WHERE Machine_Failure = 1;

-- Failure %
SELECT COUNT(*) AS Total_Machines, SUM( CASE WHEN Machine_failure = 1 THEN 1 ELSE 0 END) AS Failed, ROUND( 100.0* SUM( CASE WHEN Machine_failure = 1 THEN 1 ELSE 0 END)/COUNT(*),2) AS Failure_Percentage
FROM MachineData;

-- Failure count by machine type
SELECT Type, COUNT(*) AS Total_Machine, SUM(CASE WHEN Machine_failure = 1 THEN 1 ELSE 0 END) AS Failed_Machines FROM MachineData GROUP BY Type;

-- Avgerage torque of failed vs non-failed machines
SELECT m.Machine_Failure, AVG(s.Torque_Nm) AS Avg_Torque 
From MachineData m 
INNER JOIN Sensors s ON m.Product_ID = s.Product_ID 
GROUP BY m.Machine_Failure;

-- average tool wear of failed vs non failed machine
SELECT m.Machine_Failure, AVG(s.Tool_Wear_min) As Avg_ToolWear 
FROM MachineData m
INNER JOIN Sensors S ON m.Product_ID=s.Product_ID
GROUP BY m.Machine_Failure;

-- Machine with torque greater than avg torque
SELECT m.Product_ID, m.Type, s.Torque_Nm
FROM MachineData m
INNER JOIN Sensors s ON m.Product_ID=s.Product_ID
WHERE s.Torque_Nm>( SELECT AVG( Torque_Nm) FROM Sensors);

-- Top 10 Machines with Highest Torque
SELECT TOP 10 m.Product_ID, m.Type, s.Torque_Nm
FROM MachineData m 
INNER JOIN Sensors s ON m.Product_ID=s.Product_ID
ORDER BY Torque_Nm DESC;

-- Machines with tool wear greater than 200 mins
SELECT m.Product_ID, m.Type, s.Torque_Nm
FROM MachineData m
INNER JOIN Sensors s ON m.Product_ID=s.Product_ID
WHERE s.Tool_Wear_min>200;

-- Complete Dataset For PowerBI Dashboard
SELECT
    m.Product_ID,
    m.Type,
    m.Machine_Failure,

    s.Air_Temperature_K,
    s.Process_Temperature_K,
    s.Rotational_Speed_RPM,
    s.Torque_Nm,
    s.Tool_Wear_Min,

    o.Operator_Name,
    o.Shift,

    mt.Maintenance_Cost,
    mt.Technician

FROM MachineData m
INNER JOIN Sensors s
ON m.Product_ID = s.Product_ID
INNER JOIN Operators o
ON m.Product_ID = o.Product_ID
INNER JOIN Maintenance mt
ON m.Product_ID = mt.Product_ID;

