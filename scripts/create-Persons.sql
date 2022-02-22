CREATE TABLE Persons (
			personID [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
			firstName [varchar] (120) NOT NULL,
			lastName [varchar] (120) NOT NULL,
			weightKGS [int] NOT NULL,
			idNum [varchar] (13) NOT NULL,
			bloodType [varchar] (3) NOT NULL,
);
GO