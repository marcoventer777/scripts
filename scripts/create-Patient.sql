CREATE TABLE Patient (
	    personID int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Persons(personID),
	    needStatus [varchar] (4) NOT NULL,
);
GO