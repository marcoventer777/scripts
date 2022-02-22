Use DonorTestingDB;
GO

CREATE TABLE [dbo].[Transfusion](
	[transfusionID] [int] IDENTITY (1,1) NOT NULL,
	[personID] [int] NULL, --FK
	[pretestID] [int] NULL, --FK
	[amountReceivedML] [int] NULL,
	CONSTRAINT [PK_Transfusion] PRIMARY KEY CLUSTERED ([transfusionID] ASC)
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
);
GO

CREATE TABLE [dbo].[Donation](
	[donationID] [int] IDENTITY (1,1) NOT NULL,
	[personID] [int] NULL, --FK
	[pretestID] [int] NULL, --FK
	[donationType] [varchar](130) NULL, --FK
	[amountDonatedML] [int] NULL,
	CONSTRAINT [PK_Donation] PRIMARY KEY CLUSTERED ([donationID] ASC)
);
GO

--FOREIGN KEYS
ALTER TABLE dbo.Donation WITH NOCHECK ADD
	CONSTRAINT FK_Donation_Persons_personID FOREIGN KEY(personID) REFERENCES Persons(personID),
	CONSTRAINT FK_Donation_PreTest_preTestID FOREIGN KEY(preTestID) REFERENCES PreTest(preTestID),
	CONSTRAINT FK_Donation_DonationTypes_donationType FOREIGN KEY(donationType) REFERENCES DonationTypes(donationType)
GO

CREATE TABLE [dbo].[DonationTypes](
	[donationType] [varchar](130) UNIQUE NOT NULL,
	[donationInterval] [int] NULL,
	CONSTRAINT [PK_DonationTypes] PRIMARY KEY NONCLUSTERED ([donationType] ASC)
  --CONSTRAINT unq_DonationTypes_donationType UNIQUE(donationType) 
);
GO

--DonationType is classified as a string primary key on the ERD hence it became a unique value for the DonationType table
--Having varchar as a primary key slows down operations when querying the db so its debatable whether we keep it as a primary key or just make it a unique constraint
--Check here for ref https://dba.stackexchange.com/questions/80806/varchar-primary-key-mysql
