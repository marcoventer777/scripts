Use DonorTestingDB;
GO

CREATE TABLE Transfusion(
	[transfusionID] INT IDENTITY (1,1) NOT NULL,
	[personID] INT NULL, --FK
	[pretestID] INT NULL, --FK
	[amountReceivedML] INT NULL,
	CONSTRAINT [PK_Transfusion] PRIMARY KEY  ([transfusionID] ASC)
);
GO

--FOREIGN KEYS
ALTER TABLE dbo.Transfusion WITH NOCHECK ADD
	CONSTRAINT FK_Transfusion_Persons_personID FOREIGN KEY(personID) REFERENCES Persons(personID),
	CONSTRAINT FK_Transfusion_PreTest_preTestID FOREIGN KEY(preTestID) REFERENCES PreTest(preTestID)
GO

CREATE TABLE [dbo].[Pretest](
	[preTestID] [int] IDENTITY (1,1) NOT NULL,
	[hemoglobin] [float] NULL,
	[temperature] [float] NULL,
	[bloodPressure] [float] NULL,
	[heartPulseBPM] [int] NULL,
	CONSTRAINT [PK_Pretest] PRIMARY KEY CLUSTERED ([pretestID] ASC)
	CONSTRAINT CHK_Pretest_temperature CHECK(temperature <= 37.9)
	CONSTRAINT CHK_Pretest_personID CHECK(
);
GO

CREATE TABLE Donation(
	donationID INT IDENTITY (1,1) NOT NULL,
	personID INT NULL,
	pretestID INT NULL,
	donationType VARCHAR(130) NULL, 
	amountDonatedML INT NULL,
	CONSTRAINT [PK_Donation] PRIMARY KEY ([donationID] ASC)
);
GO

--FOREIGN KEYS
ALTER TABLE dbo.Donation WITH NOCHECK ADD
	CONSTRAINT FK_Donation_Persons_personID FOREIGN KEY(personID) REFERENCES Persons(personID),
	CONSTRAINT FK_Donation_PreTest_preTestID FOREIGN KEY(preTestID) REFERENCES PreTest(preTestID),
	CONSTRAINT FK_Donation_DonationTypes_donationType FOREIGN KEY(donationType) REFERENCES DonationTypes(donationType)
GO

CREATE TABLE DonationTypes (
	donationType varchar(130) UNIQUE NOT NULL,
	donationInterval int NULL,
	CONSTRAINT [PK_DonationTypes] PRIMARY KEY NONCLUSTERED ([donationType] ASC)
  
);
GO
--CONSTRAINT unq_DonationTypes_donationType UNIQUE(donationType) 
--DonationType is classified as a string primary key on the ERD hence it became a unique value for the DonationType table
--Having varchar as a primary key slows down operations when querying the db so its debatable whether we keep it as a primary key or just make it a unique constraint
--Check here for ref https://dba.stackexchange.com/questions/80806/varchar-primary-key-mysql
