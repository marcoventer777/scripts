USE DonoraDB;
GO

INSERT INTO Transfusion(personID, amountReceivedML)
VALUES  (4, 400),
	(5, 470)
GO

INSERT INTO PreTest(
	hemoglobin, 
	temperature, 
	bloodPressure,
	heartPulseBPM
)

VALUES  (12.9, 36.4, '120/200', 77),
		(14.2,35.3, '90/60', 82),
		(13.8,37.0, '100/80', 70),
		(13.5,36.0, '108/90', 65),
		(15.1,37.1, '110/96', 68),
		(17.1,36.2, '105/69', 79),
		(14.1,35.8, '120/100', 80),
		(13.7,37.3, '145/160', 73),
		(14.0,36.8, '100/180', 84)
GO



INSERT INTO Donation(
	personID , 
	preTestID, 
	donationType, 
	amountDonatedML 
)

VALUES  (3,45,'Blood', 300),
		(5,46,'Platelets', 200),
		(7,47,'Plasma', 350)
GO

INSERT INTO DonationTypes(
	donationType, 
	donationInterval
)

VALUES  ('Blood', 56),
		('Platelets', 7),
		('Plasma', 28)
GO
