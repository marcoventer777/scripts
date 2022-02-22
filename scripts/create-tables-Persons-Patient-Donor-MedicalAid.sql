CREATE TABLE Persons (
			personID [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
			firstName [varchar] (120) NOT NULL,
			lastName [varchar] (120) NOT NULL,
			weightKGS [int] NOT NULL,
			idNum [varchar] (13) NOT NULL,
			bloodType [varchar] (3) NOT NULL,
);
GO

CREATE TABLE Patient (
	    personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
	    needStatus [varchar] (4) NOT NULL,
);
GO

CREATE TABLE MedicalAid (
	    schemeCode varchar(50) NOT NULL PRIMARY KEY,
		medName [varchar] (120) NULL,
		rewardPerDonation [int] NOT NULL,
);
GO

CREATE TABLE Donor (
	    personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
	    schemeCode varchar(50) NULL,
            nextSafeDonationDate DATE NOT NULL, FOREIGN KEY (schemeCode) REFERENCES MedicalAid(schemeCode),
);
GO