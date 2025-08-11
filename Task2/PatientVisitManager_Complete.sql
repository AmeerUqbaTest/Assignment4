-- USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PatientVisitManager')
BEGIN
    ALTER DATABASE PatientVisitManager SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PatientVisitManager;
END
GO

CREATE DATABASE PatientVisitManager;
GO

USE PatientVisitManager;
GO

CREATE TABLE UserRoles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    IsActive BIT DEFAULT 1
);

CREATE TABLE VisitTypes (
    VisitTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL UNIQUE,
    BaseRate DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE FeeSchedules (
    FeeScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceCode NVARCHAR(20) NOT NULL UNIQUE,
    ServiceName NVARCHAR(100) NOT NULL,
    BaseRate DECIMAL(10,2) NOT NULL,
    PerMinuteRate DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Specialization NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100) UNIQUE,
    IsActive BIT DEFAULT 1
);

CREATE TABLE Patients (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(200),
    IsActive BIT DEFAULT 1
);

CREATE TABLE Visits (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT,
    VisitTypeID INT NOT NULL,
    VisitDate DATE NOT NULL,
    Duration INT DEFAULT 0,
    Reason NVARCHAR(500) NOT NULL,
    TotalCost DECIMAL(10,2) DEFAULT 0.00,
    Status NVARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (VisitTypeID) REFERENCES VisitTypes(VisitTypeID)
);

CREATE TABLE ActivityLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50) NOT NULL,
    RecordID INT NOT NULL,
    Action NVARCHAR(20) NOT NULL,
    UserName NVARCHAR(100),
    LogDate DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE SystemUsers (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    RoleID INT NOT NULL,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (RoleID) REFERENCES UserRoles(RoleID)
);

INSERT INTO UserRoles (RoleName) VALUES
('Administrator'),
('Doctor'),
('Nurse'),
('Receptionist');

INSERT INTO VisitTypes (TypeName, BaseRate) VALUES
('Emergency', 200.00),
('Routine Check-up', 150.00),
('Follow-up', 100.00),
('Consultation', 175.00);

INSERT INTO FeeSchedules (ServiceCode, ServiceName, BaseRate, PerMinuteRate) VALUES
('EMRG001', 'Emergency Consultation', 200.00, 5.00),
('ROUT001', 'Routine Examination', 150.00, 2.50),
('FOLL001', 'Follow-up Visit', 100.00, 2.00),
('CONS001', 'Specialist Consultation', 175.00, 3.50);

INSERT INTO Doctors (FirstName, LastName, Specialization, Phone, Email) VALUES
('Sarah', 'Davis', 'General Medicine', '555-0101', 'sarah.davis@hospital.com'),
('Michael', 'Taylor', 'Internal Medicine', '555-0102', 'michael.taylor@hospital.com'),
('Jennifer', 'Williams', 'Emergency Medicine', '555-0103', 'jennifer.williams@hospital.com'),
('Robert', 'Brown', 'Cardiology', '555-0104', 'robert.brown@hospital.com'),
('Lisa', 'Anderson', 'Pediatrics', '555-0105', 'lisa.anderson@hospital.com'),
('David', 'Moore', 'Orthopedics', '555-0106', 'david.moore@hospital.com'),
('Jessica', 'Johnson', 'General Medicine', '555-0107', 'jessica.johnson@hospital.com'),
('Thomas', 'Smith', 'Internal Medicine', '555-0108', 'thomas.smith@hospital.com'),
('Amanda', 'Wilson', 'Emergency Medicine', '555-0109', 'amanda.wilson@hospital.com'),
('Christopher', 'Miller', 'General Medicine', '555-0110', 'christopher.miller@hospital.com');

INSERT INTO Patients (FirstName, LastName, DateOfBirth, Phone, Email, Address) VALUES
('Daniel', 'Moore', '1985-03-15', '555-1001', 'daniel.moore@email.com', '123 Main St'),
('Jennifer', 'Lee', '1990-07-22', '555-1003', 'jennifer.lee@email.com', '456 Oak Ave'),
('Daniel', 'Rodriguez', '1978-11-08', '555-1005', 'daniel.rodriguez@email.com', '789 Pine St'),
('Nancy', 'Garcia', '1965-02-14', '555-1007', 'nancy.garcia@email.com', '321 Elm Dr'),
('Joseph', 'Sanchez', '1982-09-30', '555-1009', 'joseph.sanchez@email.com', '654 Maple Ln'),
('Thomas', 'Thomas', '1975-12-05', '555-1011', 'thomas.thomas@email.com', '987 Cedar St'),
('Patricia', 'Perez', '1988-04-18', '555-1013', 'patricia.perez@email.com', '147 Birch Ave'),
('Susan', 'Garcia', '1992-01-25', '555-1015', 'susan.garcia@email.com', '258 Willow Dr'),
('Elizabeth', 'Jackson', '1987-06-12', '555-1017', 'elizabeth.jackson@email.com', '369 Spruce St'),
('Robert', 'Garcia', '1980-08-03', '555-1019', 'robert.garcia@email.com', '741 Aspen Ln'),
('James', 'Rodriguez', '1973-10-27', '555-1021', 'james.rodriguez@email.com', '852 Poplar Ave'),
('James', 'Perez', '1985-05-16', '555-1023', 'james.perez@email.com', '963 Hickory Dr'),
('Thomas', 'Harris', '1991-03-09', '555-1025', 'thomas.harris@email.com', '159 Walnut St'),
('Mark', 'Jones', '1984-12-20', '555-1027', 'mark.jones@email.com', '357 Chestnut Ave'),
('Linda', 'Davis', '1976-07-14', '555-1029', 'linda.davis@email.com', '468 Beech Ln'),
('Joseph', 'Williams', '1989-02-28', '555-1031', 'joseph.williams@email.com', '579 Sycamore Dr'),
('Joseph', 'Ramirez', '1983-11-11', '555-1033', 'joseph.ramirez@email.com', '680 Magnolia St'),
('Emma', 'Gonzalez', '1986-09-07', '555-1035', 'emma.gonzalez@email.com', '791 Dogwood Ave'),
('David', 'Taylor', '1979-04-23', '555-1037', 'david.taylor@email.com', '802 Redwood Ln'),
('Jessica', 'Miller', '1993-08-15', '555-1039', 'jessica.miller@email.com', '913 Sequoia Dr');

INSERT INTO Visits (PatientID, DoctorID, VisitTypeID, VisitDate, Duration, Reason, TotalCost, Status) VALUES
(1, 1, 1, '2025-04-21', 98, 'Regular checkup', 1633.33, 'Completed'),
(2, 2, 3, '2025-05-16', 116, 'Annual physical exam', 580.00, 'Completed'),
(3, 3, 1, '2025-05-04', 49, 'Regular checkup', 816.67, 'Completed'),
(4, 4, 3, '2025-02-06', 43, 'Medical evaluation', 215.00, 'Completed'),
(5, 5, 1, '2025-03-06', 50, 'Follow-up appointment', 833.33, 'Completed'),
(6, 5, 2, '2025-01-09', 65, 'Preventive care visit', 433.33, 'Completed'),
(7, 2, 4, '2025-02-26', 81, 'Health screening', 675.00, 'Completed'),
(8, 6, 3, '2025-06-15', 108, 'Medical evaluation', 540.00, 'Completed'),
(9, 7, 1, '2024-10-25', 39, 'Preventive care visit', 650.00, 'Completed'),
(10, NULL, 1, '2025-02-23', 23, 'Health screening', 383.33, 'Completed'),
(8, 8, 2, '2024-11-10', 63, 'Follow-up appointment', 420.00, 'Completed'),
(7, 7, 1, '2024-11-25', 23, 'Medical evaluation', 383.33, 'Completed'),
(11, 9, 4, '2025-01-21', 34, 'Urgent medical attention needed', 283.33, 'Completed'),
(12, 5, 1, '2024-11-14', 99, 'Medical evaluation', 1650.00, 'Completed'),
(13, 9, 1, '2025-06-22', 34, 'Consultation for symptoms', 566.67, 'Completed'),
(14, 1, 2, '2024-10-09', 61, 'Consultation for symptoms', 406.67, 'Completed'),
(15, 5, 1, '2024-09-18', 53, 'Annual physical exam', 883.33, 'Completed'),
(16, NULL, 1, '2024-10-03', 17, 'Follow-up appointment', 283.33, 'Completed'),
(17, 8, 1, '2024-12-08', 120, 'Routine examination', 2000.00, 'Completed'),
(18, NULL, 3, '2024-08-03', 81, 'Preventive care visit', 405.00, 'Completed');

INSERT INTO SystemUsers (Username, Email, FirstName, LastName, RoleID) VALUES
('admin', 'admin@hospital.com', 'System', 'Administrator', 1),
('sdavis', 'sarah.davis@hospital.com', 'Sarah', 'Davis', 2),
('mtaylor', 'michael.taylor@hospital.com', 'Michael', 'Taylor', 2),
('jwilliams', 'jennifer.williams@hospital.com', 'Jennifer', 'Williams', 2),
('reception1', 'reception@hospital.com', 'Mary', 'Johnson', 4);

INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName) VALUES
('Patients', 1, 'INSERT', 'admin'),
('Patients', 2, 'INSERT', 'admin'),
('Visits', 1, 'INSERT', 'sdavis'),
('Visits', 2, 'INSERT', 'mtaylor'),
('Patients', 1, 'UPDATE', 'reception1');

GO
CREATE PROCEDURE stp_AddPatient
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Address NVARCHAR(200) = NULL
AS
BEGIN
    BEGIN TRY
        IF @FirstName IS NULL OR @LastName IS NULL
        BEGIN
            RAISERROR('First name and last name are required.', 16, 1);
            RETURN;
        END
        
        INSERT INTO Patients (FirstName, LastName, DateOfBirth, Phone, Email, Address)
        VALUES (@FirstName, @LastName, @DateOfBirth, @Phone, @Email, @Address);
        
        DECLARE @PatientID INT = SCOPE_IDENTITY();
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Patients', @PatientID, 'INSERT', SYSTEM_USER);
        
        SELECT @PatientID as PatientID, 'Patient added successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_GetPatientById
    @PatientID INT
AS
BEGIN
    SELECT PatientID, FirstName, LastName, DateOfBirth, Phone, Email, Address, IsActive
    FROM Patients 
    WHERE PatientID = @PatientID AND IsActive = 1;
END
GO

CREATE PROCEDURE stp_UpdatePatient
    @PatientID INT,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @DateOfBirth DATE = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Address NVARCHAR(200) = NULL
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Patients WHERE PatientID = @PatientID AND IsActive = 1)
        BEGIN
            RAISERROR('Patient not found.', 16, 1);
            RETURN;
        END
        
        UPDATE Patients 
        SET 
            FirstName = ISNULL(@FirstName, FirstName),
            LastName = ISNULL(@LastName, LastName),
            DateOfBirth = ISNULL(@DateOfBirth, DateOfBirth),
            Phone = ISNULL(@Phone, Phone),
            Email = ISNULL(@Email, Email),
            Address = ISNULL(@Address, Address)
        WHERE PatientID = @PatientID;
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Patients', @PatientID, 'UPDATE', SYSTEM_USER);
        
        SELECT 'Patient updated successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_DeletePatient
    @PatientID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Patients WHERE PatientID = @PatientID AND IsActive = 1)
        BEGIN
            RAISERROR('Patient not found.', 16, 1);
            RETURN;
        END
        
        UPDATE Patients 
        SET IsActive = 0
        WHERE PatientID = @PatientID;
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Patients', @PatientID, 'DELETE', SYSTEM_USER);
        
        SELECT 'Patient deleted successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_AddDoctor
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Specialization NVARCHAR(100) = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        IF @FirstName IS NULL OR @LastName IS NULL
        BEGIN
            RAISERROR('First name and last name are required.', 16, 1);
            RETURN;
        END
        
        INSERT INTO Doctors (FirstName, LastName, Specialization, Phone, Email)
        VALUES (@FirstName, @LastName, @Specialization, @Phone, @Email);
        
        DECLARE @DoctorID INT = SCOPE_IDENTITY();
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Doctors', @DoctorID, 'INSERT', SYSTEM_USER);
        
        SELECT @DoctorID as DoctorID, 'Doctor added successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_GetDoctorById
    @DoctorID INT
AS
BEGIN
    SELECT DoctorID, FirstName, LastName, Specialization, Phone, Email, IsActive
    FROM Doctors 
    WHERE DoctorID = @DoctorID AND IsActive = 1;
END
GO

CREATE PROCEDURE stp_UpdateDoctor
    @DoctorID INT,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @Specialization NVARCHAR(100) = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Doctors WHERE DoctorID = @DoctorID AND IsActive = 1)
        BEGIN
            RAISERROR('Doctor not found.', 16, 1);
            RETURN;
        END
        
        UPDATE Doctors 
        SET 
            FirstName = ISNULL(@FirstName, FirstName),
            LastName = ISNULL(@LastName, LastName),
            Specialization = ISNULL(@Specialization, Specialization),
            Phone = ISNULL(@Phone, Phone),
            Email = ISNULL(@Email, Email)
        WHERE DoctorID = @DoctorID;
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Doctors', @DoctorID, 'UPDATE', SYSTEM_USER);
        
        SELECT 'Doctor updated successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_DeleteDoctor
    @DoctorID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Doctors WHERE DoctorID = @DoctorID AND IsActive = 1)
        BEGIN
            RAISERROR('Doctor not found.', 16, 1);
            RETURN;
        END
        
        UPDATE Doctors 
        SET IsActive = 0
        WHERE DoctorID = @DoctorID;
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Doctors', @DoctorID, 'DELETE', SYSTEM_USER);
        
        SELECT 'Doctor deleted successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_AddVisit
    @PatientID INT,
    @DoctorID INT = NULL,
    @VisitTypeID INT,
    @VisitDate DATE,
    @Duration INT = 0,
    @Reason NVARCHAR(500),
    @TotalCost DECIMAL(10,2) = 0.00
AS
BEGIN
    BEGIN TRY
        IF @PatientID IS NULL OR @VisitTypeID IS NULL OR @VisitDate IS NULL OR @Reason IS NULL
        BEGIN
            RAISERROR('Patient ID, Visit Type ID, Visit Date, and Reason are required.', 16, 1);
            RETURN;
        END
        
        INSERT INTO Visits (PatientID, DoctorID, VisitTypeID, VisitDate, Duration, Reason, TotalCost)
        VALUES (@PatientID, @DoctorID, @VisitTypeID, @VisitDate, @Duration, @Reason, @TotalCost);
        
        DECLARE @VisitID INT = SCOPE_IDENTITY();
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Visits', @VisitID, 'INSERT', SYSTEM_USER);
        
        SELECT @VisitID as VisitID, 'Visit added successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_GetVisitById
    @VisitID INT
AS
BEGIN
    SELECT 
        v.VisitID, v.PatientID, v.DoctorID, v.VisitTypeID,
        v.VisitDate, v.Duration, v.Reason, v.TotalCost, v.Status,
        p.FirstName + ' ' + p.LastName as PatientName,
        ISNULL(d.FirstName + ' ' + d.LastName, 'Unassigned') as DoctorName,
        vt.TypeName as VisitType
    FROM Visits v
    INNER JOIN Patients p ON v.PatientID = p.PatientID
    LEFT JOIN Doctors d ON v.DoctorID = d.DoctorID
    INNER JOIN VisitTypes vt ON v.VisitTypeID = vt.VisitTypeID
    WHERE v.VisitID = @VisitID;
END
GO

CREATE PROCEDURE stp_UpdateVisit
    @VisitID INT,
    @DoctorID INT = NULL,
    @VisitDate DATE = NULL,
    @Duration INT = NULL,
    @Reason NVARCHAR(500) = NULL,
    @TotalCost DECIMAL(10,2) = NULL,
    @Status NVARCHAR(20) = NULL
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Visits WHERE VisitID = @VisitID)
        BEGIN
            RAISERROR('Visit not found.', 16, 1);
            RETURN;
        END
        
        UPDATE Visits 
        SET 
            DoctorID = ISNULL(@DoctorID, DoctorID),
            VisitDate = ISNULL(@VisitDate, VisitDate),
            Duration = ISNULL(@Duration, Duration),
            Reason = ISNULL(@Reason, Reason),
            TotalCost = ISNULL(@TotalCost, TotalCost),
            Status = ISNULL(@Status, Status)
        WHERE VisitID = @VisitID;
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Visits', @VisitID, 'UPDATE', SYSTEM_USER);
        
        SELECT 'Visit updated successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_DeleteVisit
    @VisitID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Visits WHERE VisitID = @VisitID)
        BEGIN
            RAISERROR('Visit not found.', 16, 1);
            RETURN;
        END
        
        DELETE FROM Visits WHERE VisitID = @VisitID;
        
        INSERT INTO ActivityLogs (TableName, RecordID, Action, UserName)
        VALUES ('Visits', @VisitID, 'DELETE', SYSTEM_USER);
        
        SELECT 'Visit deleted successfully.' as Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE stp_GetAllPatients
AS
BEGIN
    SELECT PatientID, FirstName, LastName, DateOfBirth, Phone, Email, Address
    FROM Patients 
    WHERE IsActive = 1
    ORDER BY LastName, FirstName;
END
GO

CREATE PROCEDURE stp_GetAllDoctors
AS
BEGIN
    SELECT DoctorID, FirstName, LastName, Specialization, Phone, Email
    FROM Doctors 
    WHERE IsActive = 1
    ORDER BY LastName, FirstName;
END
GO

CREATE PROCEDURE stp_GetVisitsByPatient
    @PatientID INT
AS
BEGIN
    SELECT 
        v.VisitID, v.VisitDate, v.Duration, v.Reason, v.TotalCost, v.Status,
        ISNULL(d.FirstName + ' ' + d.LastName, 'Unassigned') as DoctorName,
        vt.TypeName as VisitType
    FROM Visits v
    LEFT JOIN Doctors d ON v.DoctorID = d.DoctorID
    INNER JOIN VisitTypes vt ON v.VisitTypeID = vt.VisitTypeID
    WHERE v.PatientID = @PatientID
    ORDER BY v.VisitDate DESC;
END
GO

PRINT 'Database creation completed successfully!';
