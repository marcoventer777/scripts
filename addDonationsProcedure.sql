USE DonoraDB
GO

CREATE OR ALTER PROCEDURE addDonation
    @hemoglobin FLOAT,
    @temperature FLOAT,
    @bloodPressure VARCHAR(7),
    @heartPulseBPM INT,
    @personID INT,
    @amountDonatedML INT,
    @donationType VARCHAR(20),
    @locationID INT
AS
BEGIN TRY
     INSERT INTO PreTest(
         hemoglobin,
         temperature,
         bloodPressure,
         heartPulseBPM
     )
     VALUES (
        @hemoglobin,
        @temperature ,
        @bloodPressure,
        @heartPulseBPM 
     )
    EXEC enterDonation @personID=@personID, @amountDonatedML=@amountDonatedML, @donationType=@donationType, @locationID=@locationID
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH
GO

CREATE OR ALTER PROCEDURE enterDonation 
   @personID INT,
   @amountDonatedML INT,
   @donationType VARCHAR(20),
   @locationID INT
AS
BEGIN TRY
    DECLARE @preTestID AS INT;
    DECLARE @bloodBagID AS INT;
    DECLARE @donationID AS INT;
    DECLARE @bloodType VARCHAR(3);
    SELECT @preTestID = preTestID FROM PreTest;
    SELECT @bloodType = bloodType FROM Persons WHERE personID = @personID
    INSERT INTO Donation(
        personID,
        preTestID,
        donationType,
        amountDonatedML
    )
    VALUES (
        @personID,
        @preTestID,
        @donationType,
        @amountDonatedML
    )
    INSERT INTO BloodBag(
        amountML,
        bloodType
    )
    VALUES (
        @amountDonatedML,
        @bloodType
    )
    SELECT @bloodBagID = bloodBagID FROM BloodBag;
    SELECT @donationID = donationID FROM Donation;
    INSERT INTO Donations(
        donationID,
        locationID,
        bloodBagID,
        donationDate
    )
    VALUES (
       @donationID,
       @locationID,
       @bloodBagID,
       CAST(GETDATE() AS DATE)
    )
    INSERT INTO Inventory(
        bloodBagID,
        locationID,
        available
    )
    VALUES(
        @bloodBagID,
        @locationID,
        1
    )

END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH
GO


-- EXEC addDonation @hemoglobin=13, @temperature=35.9, @bloodPressure='120/100', @heartPulseBPM=65, @personID=3,@amountDonatedML=350,@donationType='Blood',@locationID=3;