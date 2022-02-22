CREATE TABLE Donor (
	    personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
	    schemeCode varchar(50) NULL,
            nextSafeDonationDate DATE NOT NULL, FOREIGN KEY (schemeCode) REFERENCES MedicalAid(schemeCode),
);
GO