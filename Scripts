USE DonorTestingDB
GO

CREATE TABLE LocationCodes([codeID] varchar(16) PRIMARY KEY, [description] varchar(256))
GO

CREATE TABLE Locations([locationID] int PRIMARY KEY IDENTITY(1, 1), [name] varchar(256) NOT NULL, [codeID] varchar(16) NOT NULL,
						[address] varchar(256) NOT NULL,
						constraint locationCode FOREIGN KEY(codeID) references LocationCodes(codeID)
						ON UPDATE CASCADE
						ON DELETE NO ACTION)
GO

CREATE TABLE Request([requestID] int PRIMARY KEY IDENTITY(1, 1), [locationID] int NOT NULL, [bloodTypeRequested] varchar(8) NOT NULL,
						[dateReceived] date DEFAULT(GETDATE()), [amountRequestedML] int NOT NULL,
						constraint [requestLocation] FOREIGN KEY(locationID) references Locations(locationID)
						ON UPDATE CASCADE
						ON DELETE NO ACTION
						)
GO