USE DonoraDB
GO

 CREATE TABLE Persons (
 personID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
 firstName VARCHAR (120) NOT NULL,
 lastName VARCHAR (120) NOT NULL,
 weightKGS int NOT NULL,
 idNum CHAR (13) NOT NULL,
 bloodType VARCHAR (3) NOT NULL,
 gender VARCHAR (6) NOT NULL,
 mobileNum CHAR (10) NOT NULL,
 emailAddress VARCHAR (120) NOT NULL,
  --validation
 UNIQUE (idNum),
 CONSTRAINT CHK_bloodType CHECK (bloodType='A+' OR
 bloodType='A-' OR
 bloodType='B+' OR
 bloodType='B-' OR
 bloodType='AB+' OR
 bloodType='AB-' OR
 bloodType='O+' OR
 bloodType='O-'),
 CONSTRAINT CHK_weight CHECK (weightKGS >= 5), --lightest recorded adult (2.1 kg) at the age of 17.
 CONSTRAINT CHK_gender CHECK (gender = 'male' or gender = 'female'),
 CONSTRAINT CHK_emailRegex CHECK (emailAddress LIKE '%___@___%'), --email regex
 CONSTRAINT CHK_mobileNUm CHECK (mobileNum NOT LIKE '%[^0-9]%' AND mobileNum LIKE '0%')
 );
 GO

 CREATE TABLE Patient (
 personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID) 
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 needStatus [varchar] (4) NOT NULL,
 CONSTRAINT CHK_needStatus CHECK (needStatus='low' OR needStatus='high'),
 );
 GO

 CREATE TABLE MedicalAid (
 schemeCode varchar(50) NOT NULL PRIMARY KEY,
 medName [varchar] (120) NULL,
 rewardPerDonation [int] NOT NULL,
 UNIQUE (medName),
 );
 GO

 CREATE TABLE Donor (
 personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 schemeCode varchar(50) NULL FOREIGN KEY REFERENCES MedicalAid(schemeCode)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 nextSafeDonationDate DATE NOT NULL,
 FOREIGN KEY (schemeCode) REFERENCES MedicalAid(schemeCode),
    CONSTRAINT CHK_dateCorrect CHECK (nextSafeDonationDate >= GETDATE())
 );
 GO

 CREATE TABLE Pretest(
 preTestID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 hemoglobin FLOAT NOT NULL,
 temperature FLOAT NOT NULL,
 bloodPressure FLOAT NOT NULL,
 heartPulseBPM INT NOT NULL,
 CONSTRAINT CHK_Pretest_hemoglobin CHECK(hemoglobin >= 12.5),
 CONSTRAINT CHK_Pretest_temperature CHECK(temperature >= 35 AND temperature <= 37.9),
 CONSTRAINT CHK_Pretest_bloodPressure CHECK(bloodPressure > 180/200 AND bloodPressure < 100/60),
 CONSTRAINT CHK_Pretest_heartPulseBPM CHECK(heartPulseBPM > 60 AND heartPulseBPM < 100)
 );
 GO

 CREATE TABLE DonationTypes (
 donationType varchar(20) NOT NULL PRIMARY KEY,
 donationInterval int NOT NULL,
 );
 GO

 CREATE TABLE Donation(
 donationID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
 personID INT NOT NULL FOREIGN KEY REFERENCES Donor(personID)    
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 pretestID INT NOT NULL FOREIGN KEY REFERENCES PreTest(preTestID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 donationType VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES DonationTypes(donationType)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 amountDonatedML INT NOT NULL
 );
 GO

 CREATE TABLE Transfusion(
 transfusionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 personID INT NOT NULL FOREIGN KEY REFERENCES Patient(personID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
 amountReceivedML INT NOT NULL
 );
 GO

 CREATE TABLE BloodBag(
     bloodBagID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
     amountML INT NOT NULL,
     bloodType VARCHAR (3)
     CONSTRAINT CHK_BloodBag_bloodType CHECK (
         bloodType='A+' OR
         bloodType='A-' OR
         bloodType='B+' OR
         bloodType='B-' OR
         bloodType='AB+' OR
         bloodType='AB-' OR
         bloodType='O+' OR
         bloodType='O-'
     )
 );
 GO

 CREATE TABLE LocationCodes(
     codeID VARCHAR(8) NOT NULL PRIMARY KEY, 
     [description] VARCHAR(256) NULL
 )
 GO

 CREATE TABLE Locations(
     locationID INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
     locationName VARCHAR(128) NOT NULL, 
     codeID VARCHAR(8) NOT NULL FOREIGN KEY references LocationCodes(codeID) 
		ON UPDATE CASCADE 
        ON DELETE NO ACTION, 
     city VARCHAR(128) NOT NULL,  
 )

 CREATE TABLE Request(
     requestID INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID)
   ON DELETE CASCADE
   ON UPDATE CASCADE, 
     bloodTypeRequested VARCHAR(3) NOT NULL,
     dateReceived DATE DEFAULT(GETDATE()), 
     amountRequestedML INT NOT NULL
 )
 GO

 CREATE TABLE Inventory(
     bloodBagID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES BloodBag(bloodBagID)
   ON DELETE CASCADE
   ON UPDATE CASCADE, 
     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID) 
	ON DELETE CASCADE 
    ON UPDATE CASCADE, 
     available BIT DEFAULT(1)
 )
 GO

 CREATE TABLE Transfusions(
     transfusionID INT NOT NUll PRIMARY KEY FOREIGN KEY REFERENCES Transfusion(transfusionID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
     bloodBagID INT NOT NULL FOREIGN KEY REFERENCES BloodBag(bloodBagID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
     transfusionDate DATE NOT NULL
 );
 GO

 CREATE TABLE Donations(
     donationID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Donation(donationID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
     locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
     bloodBagID INT NOT NULL FOREIGN KEY REFERENCES BloodBag(bloodBagID)
   ON DELETE CASCADE
   ON UPDATE CASCADE, 
     donationDate DATE NOT NULL
 );   
 GO
