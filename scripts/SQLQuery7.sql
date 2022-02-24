CREATE TABLE Persons (
			personID [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
			firstName [varchar] (120) NOT NULL,
			lastName [varchar] (120) NOT NULL,
			weightKGS [int] NOT NULL,
			idNum [varchar] (13) NOT NULL,   
			bloodType [varchar] (3) NOT NULL,
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
);
GO

CREATE TABLE Patient (
	    personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
	    needStatus [varchar] (4) NOT NULL,
	    --validation
	    CONSTRAINT CHK_bloodType CHECK (needStatus='low' OR needStatus='high'),
);
GO


CREATE TABLE MedicalAid (
	    schemeCode varchar(50) NOT NULL PRIMARY KEY,
	    medName [varchar] (120) NULL,
	    rewardPerDonation [int] NOT NULL,
	    --validation
	    UNIQUE (medName),
);
GO

CREATE TABLE Donor (
	    personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
	    schemeCode varchar(50) NULL,
            nextSafeDonationDate DATE NOT NULL, 
	    FOREIGN KEY (schemeCode) REFERENCES MedicalAid(schemeCode),
);
GO