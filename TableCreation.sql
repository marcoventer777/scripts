USE DonoraDB
GO

-- CREATE TABLE Persons (
-- personID [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
-- firstName [varchar] (120) NOT NULL,
-- lastName [varchar] (120) NOT NULL,
-- weightKGS [int] NOT NULL,
-- idNum [varchar] (13) NOT NULL,
-- bloodType [varchar] (3) NOT NULL,
-- gender VARCHAR (6) NOT NULL,
-- --validation
-- UNIQUE (idNum),
-- CONSTRAINT CHK_bloodType CHECK (bloodType='A+' OR
-- bloodType='A-' OR
-- bloodType='B+' OR
-- bloodType='B-' OR
-- bloodType='AB+' OR
-- bloodType='AB-' OR
-- bloodType='O+' OR
-- bloodType='O-'),
-- CONSTRAINT CHK_weight CHECK (weightKGS >= 5), --lightest recorded adult (2.1 kg) at the age of 17.
-- CONSTRAINT CHK_gender CHECK (gender = 'male' or gender = 'female')
-- );
-- GO

-- CREATE TABLE Patient (
-- personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
-- needStatus [varchar] (4) NOT NULL,
-- --validation
-- CONSTRAINT CHK_needStatus CHECK (needStatus='low' OR needStatus='high'),
-- );
-- GO

-- CREATE TABLE MedicalAid (
-- schemeCode varchar(50) NOT NULL PRIMARY KEY,
-- medName [varchar] (120) NULL,
-- rewardPerDonation [int] NOT NULL,
-- --validation
-- UNIQUE (medName),
-- );
-- GO

-- CREATE TABLE Donor (
-- personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
-- schemeCode varchar(50) NULL,
-- nextSafeDonationDate DATE NOT NULL,
-- FOREIGN KEY (schemeCode) REFERENCES MedicalAid(schemeCode),
-- );
-- GO

-- CREATE TABLE Pretest(
-- preTestID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
-- hemoglobin FLOAT NOT NULL,
-- temperature FLOAT NOT NULL,
-- bloodPressure FLOAT NOT NULL,
-- heartPulseBPM INT NOT NULL,
-- CONSTRAINT CHK_Pretest_hemoglobin CHECK(hemoglobin >= 12.5),
-- CONSTRAINT CHK_Pretest_temperature CHECK(temperature >= 35 AND temperature <= 37.9),
-- CONSTRAINT CHK_Pretest_bloodPressure CHECK(bloodPressure > 180/200 AND bloodPressure < 100/60),
-- CONSTRAINT CHK_Pretest_heartPulseBPM CHECK(heartPulseBPM > 60 AND heartPulseBPM < 100)
-- );
-- GO

-- CREATE TABLE DonationTypes (
-- donationType varchar(20) NOT NULL PRIMARY KEY,
-- donationInterval int NOT NULL,
-- );
-- GO

-- CREATE TABLE Donation(
-- donationID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
-- personID INT NOT NULL FOREIGN KEY REFERENCES Donor(personID),
-- pretestID INT NOT NULL FOREIGN KEY REFERENCES PreTest(preTestID),
-- donationType VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES DonationTypes(donationType),
-- amountDonatedML INT NOT NULL
-- );
-- GO

-- CREATE TABLE Transfusion(
-- transfusionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
-- personID INT NOT NULL FOREIGN KEY REFERENCES Patient(personID),
-- amountReceivedML INT NOT NULL
-- );
-- GO

-- CREATE TABLE BloodBag(
--     bloodBagID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--     amountML INT NOT NULL,
--     bloodType VARCHAR (3)
--     CONSTRAINT CHK_BloodBag_bloodType CHECK (
--         bloodType='A+' OR
--         bloodType='A-' OR
--         bloodType='B+' OR
--         bloodType='B-' OR
--         bloodType='AB+' OR
--         bloodType='AB-' OR
--         bloodType='O+' OR
--         bloodType='O-'
--     )
-- );
-- GO

-- CREATE TABLE LocationCodes(
--     codeID VARCHAR(8) NOT NULL PRIMARY KEY, 
--     [description] VARCHAR(256) NULL
-- )
-- GO

-- CREATE TABLE Locations(
--     locationID INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
--     locationName VARCHAR(128) NOT NULL, 
--     codeID VARCHAR(8) NOT NULL FOREIGN KEY references LocationCodes(codeID) ON UPDATE CASCADE ON DELETE NO ACTION, 
--     city VARCHAR(128) NOT NULL,  
-- )

-- CREATE TABLE Request(
--     requestID INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
--     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID), 
--     bloodTypeRequested VARCHAR(3) NOT NULL,
--     dateReceived DATE DEFAULT(GETDATE()), 
--     amountRequestedML INT NOT NULL
-- )
-- GO

-- CREATE TABLE Inventory(
--     bloodBagID INT NOT NULL PRIMARY KEY IDENTITY(1, 1) FOREIGN KEY REFERENCES BloodBag(bloodBagID), 
--     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID) ON DELETE CASCADE ON UPDATE CASCADE, 
--     available BIT DEFAULT(1)
-- )
-- GO

-- CREATE TABLE Transfusions(
--     transfusionID INT NOT NUll PRIMARY KEY FOREIGN KEY REFERENCES Transfusion(transfusionID),
--     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID),
--     bloodBagID INT NOT NULL FOREIGN KEY REFERENCES BloodBag(bloodBagID),
--     transfusionDate DATE NOT NULL
-- );
-- GO

-- CREATE TABLE Donations(
--     donationID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Donation(donationID),
--     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID),
--     bloodBagID INT NOT NULL FOREIGN KEY REFERENCES BloodBag(bloodBagID), 
--     donationDate DATE NOT NULL
-- );   
-- GO
