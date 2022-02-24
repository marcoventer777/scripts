USE DonoraDB;
GO

INSERT INTO Transfusion(personID, amountReceivedML)
<<<<<<< HEAD:scripts/Data/Data.sql
VALUES  
		(5, 400),
		(5, 250),
		(4, 350),
		(4, 220),
		(4, 600),
		(5, 700),
		(4, 620),
		(5, 600)
=======
VALUES  (4, 400),
	(5, 470)
>>>>>>> 05b8efaf6a6be614582529ebaf36ca9fc75ef2e2:Data/Data.sql
GO

INSERT INTO PreTest(
	hemoglobin, 
	temperature, 
	bloodPressure,
	heartPulseBPM
)

VALUES  (12.9, 36.4, '120/200', 77),
<<<<<<< HEAD:scripts/Data/Data.sql
		(14.2,35.3, '90/60', 82),
		(13.8,37.0, '100/80', 70),
		(13.5,36.0, '108/90', 65),
		(15.1,37.1, '110/96', 68),
		(17.1,36.2, '105/69', 79),
		(14.1,35.8, '120/100', 80),
		(13.7,37.3, '145/160', 73),
		(14.0,36.8, '100/180', 84),
		(12.9, 36.4, '120/200', 77),
		(14.2,35.3, '90/60', 82),
		(13.8,37.0, '100/80', 70),
		(13.5,36.0, '108/90', 65),
		(15.1,37.1, '110/96', 68),
		(17.1,36.2, '105/69', 79),
		(14.1,35.8, '120/100', 80),
		(13.7,37.3, '145/160', 73),
		(14.0,36.8, '100/180', 84)
=======
	(14.2,35.3, '90/60', 82),
	(13.8,37.0, '100/80', 70),
	(13.5,36.0, '108/90', 65),
	(15.1,37.1, '110/96', 68),
	(17.1,36.2, '105/69', 79),
	(14.1,35.8, '120/100', 80),
	(13.7,37.3, '145/160', 73),
	(14.0,36.8, '100/180', 84)
>>>>>>> 05b8efaf6a6be614582529ebaf36ca9fc75ef2e2:Data/Data.sql
GO



INSERT INTO Donation(
	personID , 
	preTestID, 
	donationType, 
	amountDonatedML 
)

VALUES  (3,45,'Blood', 300),
<<<<<<< HEAD:scripts/Data/Data.sql
		(5,46,'Platelets', 200),
		(7,47,'Plasma', 350)
		(7,50,'Plasma', 400),
		(7,51,'Plasma', 470)
=======
	(5,46,'Platelets', 200),
	(7,47,'Plasma', 350)
>>>>>>> 05b8efaf6a6be614582529ebaf36ca9fc75ef2e2:Data/Data.sql
GO


INSERT INTO DonationTypes(
	donationType, 
	donationInterval
)

VALUES  ('Blood', 56),
<<<<<<< HEAD:scripts/Data/Data.sql
		('Platelets', 7),
		('Plasma', 28)
GO

=======
	('Platelets', 7),
	('Plasma', 28)
GO
>>>>>>> 05b8efaf6a6be614582529ebaf36ca9fc75ef2e2:Data/Data.sql
