USE DonoraDB
GO

CREATE PROCEDURE udpNewPatient
@personID int,
@needState varchar(4),
@newID int OUTPUT
AS BEGIN
	-- error handling
	INSERT INTO Patient(personID, needStatus) VALUES(@personID, @needState)
	-- error handling

	SELECT @newID = MAX(personID) FROM Patient
	PRINT 'New patient created. Patient ID: ' + @newID
	END
GO


CREATE PROCEDURE udpSingleTransfusion
(
	@bloodTransfused int,
	@bloodLeft int,
	@bloodBagID int,
	@personID int,
	@locationID int
)
AS BEGIN
	UPDATE BloodBag SET amountML=@bloodLeft WHERE bloodBagID=@bloodBagID 
	INSERT INTO Transfusion(personID, amountReceivedML) VALUES(@personID, @bloodTransfused)

	-- Get the latest transfusion and create a link to the location + bloodBag
	DECLARE @nextTransfusionID int 
	SELECT @nextTransfusionID = MAX(transfusionID) FROM Transfusion
	INSERT INTO Transfusions(transfusionID, locationID, bloodBagID, transfusionDate) 
		VALUES(@nextTransfusionID, @locationID, @bloodBagID, GETDATE())
END
GO


CREATE PROCEDURE udpUseUpBag
@personID int,
@bloodAmount int,
@locationID int,
@bloodType varchar(3)
AS BEGIN
	-- transaction
		-- Go find a blood bag that has the correct blood type
		IF @bloodAmount > 0
			DECLARE @bloodBagID int
			DECLARE @oldAmount int

			-- find a blood bag with enough blood
			SELECT @bloodBagID = bloodBagID, @oldAmount = amountML FROM BloodBag WHERE amountML>=@bloodAmount

			-- blood bag found
			IF @bloodBagID IS NOT NULL	
				-- run the transfusion
				DECLARE @left int = @oldAmount-@bloodAmount
				EXEC udpSingleTransfusion @bloodAmount,@left,@bloodBagID,@personID,@locationID
			
			IF @bloodBagID IS NULL
				-- not found, try smaller bags
				DECLARE @iterator CURSOR
				DECLARE @currentBagAmount int

				SET @iterator = CURSOR FOR 
				SELECT Inventory.bloodBagID, BloodBag.amountML FROM Inventory
					INNER JOIN BloodBag
					ON Inventory.bloodBagID = BloodBag.bloodBagID
					AND Inventory.available=1
					AND Inventory.locationID=@locationID
					AND BloodBag.amountML>0
					AND BloodBag.bloodType=@bloodType

				OPEN @iterator FETCH NEXT 
					FROM @iterator INTO @bloodBagID, @currentBagAmount
					WHILE @@FETCH_STATUS = 0
					BEGIN
						DECLARE @transfused int = @bloodAmount-@currentBagAmount
						EXEC udpSingleTransfusion @currentBagAmount,0,@bloodBagID,@personID,@locationID
						SET @bloodAmount = @transfused
					END
	END
GO

CREATE FUNCTION udfInitiateTransfusion
(
	@patientIDNumber varchar(13),
	@bloodRequired int,
	@selectedLocation varchar(128)
)
RETURNS int 
	AS 
	BEGIN
		-- Checking if the ID number is a person in the DB
		 DECLARE @personID int
		 SELECT @personID = personID FROM Persons where idNum=@patientIDNumber
		 IF ISNULL(@personID, -1) = -1
			PRINT 'Invalid ID Number'
			RETURN -1

		-- Get the person's blood type
		DECLARE @bloodType varchar(3)
		SELECT @bloodType = bloodType FROM Persons WHERE personID=@personID

		-- Checking if the location exists, take the first one
		DECLARE @locationID int
		SELECT @locationID = locationID FROM Locations where locationName=@selectedLocation
		IF @locationID IS NULL
			PRINT 'Invalid Location'
			RETURN -1

		 --Checking that this person is a patient, if not, create one
		 DECLARE @patientID int
		 SELECT @patientID=personID FROM Patient WHERE personID=@personID
		 IF @patientID IS NULL
			EXEC dbo.udpNewPatient @patientID,'HIGH',@newID=@patientID OUTPUT

		-- Use up a bag
		EXEC udpUseUpBag @personID,@bloodRequired,@locationID,@bloodType

		-- Return the last transfusion ID
		DECLARE @transfusion int
		SELECT @transfusion=MAX(transfusionID) FROM Transfusion
		RETURN @transfusion			
	END
GO
