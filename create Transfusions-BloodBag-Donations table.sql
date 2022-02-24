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

CREATE TABLE Transfusions(
    transfusionID INT NOT NUll PRIMARY KEY FOREIGN KEY REFERENCES Transfusion(transfusionID),
    locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID),
    bloodBagID INT NOT NULL FOREIGN KEY REFERENCES BloodBag(bloodBagID),
    transfusionDate DATE NOT NULL
);
GO

CREATE TABLE Donations(
    donationID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Donation(donationID),
    locationID INT NOT NULL FOREIGN KEY REFERENCES Locations(locationID),
    bloodBagID INT NOT NULL FOREIGN KEY REFERENCES BloodBag(bloodBagID), 
    donationDate DATE NOT NULL
);   
GO
