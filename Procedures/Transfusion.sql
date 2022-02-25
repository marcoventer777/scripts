USE DonoraDB
GO


CREATE PROCEDURE udpNewPatient
@personID int,
@needState varchar(4),
@newID int OUTPUT
AS BEGIN
	INSERT INTO Patient(personID, needStatus) VALUES(@personID, @needState)

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
@userCity varchar(128),
@bloodType varchar(3)
AS BEGIN
	-- transaction
		-- Go find a blood bag that has the correct blood type
		IF @bloodAmount > 0
			BEGIN
			DECLARE @bloodBagID int
			DECLARE @oldAmount int
			DECLARE @locationID int

			-- find a blood bag with enough blood
			SELECT @bloodBagID=BloodBag.bloodBagID, @oldAmount = amountML, @locationID=Locations.locationID
			FROM BloodBag
			INNER JOIN Inventory
			ON Inventory.bloodBagID = BloodBag.bloodBagID
			AND Inventory.available=1
			AND BloodBag.amountML>=@bloodAmount
			AND BloodBag.bloodType=@bloodType
			INNER JOIN Locations
			ON Locations.city = @userCity
			AND Inventory.locationID = Locations.locationID

			-- blood bag found
			IF @bloodBagID IS NOT NULL	
				BEGIN
				-- run the transfusion
				DECLARE @left int = @oldAmount-@bloodAmount
				EXEC udpSingleTransfusion @bloodAmount,@left,@bloodBagID,@personID,@locationID
				RETURN
				END
			ELSE
				BEGIN
				-- not found, try smaller bags
				DECLARE @iterator CURSOR
				DECLARE @currentBagAmount int

				SET @iterator = CURSOR FOR 
				SELECT BloodBag.bloodBagID, BloodBag.amountML
				FROM BloodBag
				INNER JOIN Inventory
				ON Inventory.bloodBagID = BloodBag.bloodBagID
				AND Inventory.available=1
				AND BloodBag.amountML>0
				AND BloodBag.bloodType=@bloodType
				INNER JOIN Locations
				ON Locations.city = @userCity
				AND Inventory.locationID = Locations.locationID

				OPEN @iterator FETCH NEXT 
					FROM @iterator INTO @bloodBagID, @currentBagAmount
					WHILE @@FETCH_STATUS = 0
					BEGIN
						DECLARE @transfused int
						SELECT @locationID=locationID FROM Inventory WHERE bloodBagID=@bloodBagID

						IF @currentBagAmount > @bloodAmount
						BEGIN
							SET @transfused = @bloodAmount
							SET @left = @currentBagAmount-@bloodAmount
							SET @bloodAmount = 0
						END
						ELSE
							SET @transfused = @currentBagAmount
							SET @left=0
							SET @bloodAmount = @bloodAmount-@currentBagAmount
						EXEC udpSingleTransfusion @transfused,@left,@bloodBagID,@personID,@locationID

						FETCH NEXT FROM @iterator INTO @bloodBagID, @currentBagAmount
					END
				END
			END
	END
GO

CREATE PROCEDURE udpInitiateTransfusion
(
	@patientIDNumber varchar(13),
	@bloodRequired int,
	@selectedLocation varchar(128)
)
	AS 
	BEGIN
		-- Checking if the ID number is a person in the DB
		 DECLARE @personID int
		 SELECT @personID = personID FROM Persons where idNum=@patientIDNumber
		 IF @personID IS NULL
			RETURN -1

		-- Get the person's blood type
		DECLARE @bloodType varchar(3)
		SELECT @bloodType = bloodType FROM Persons WHERE personID=@personID

		-- Checking if the location exists, take the first one
		DECLARE @locationID int
		SELECT @locationID = locationID FROM Locations where city=@selectedLocation
		IF @locationID IS NULL
			RETURN -1

		 --Checking that this person is a patient, if not, create one
		 DECLARE @patientID int
		 SELECT @patientID=personID FROM Patient WHERE personID=@personID
		 IF @patientID IS NULL
			EXEC dbo.udpNewPatient @patientID,'HIGH',@newID=@patientID OUTPUT

		-- Use up a bag
		EXEC dbo.udpUseUpBag @personID=@personId, @bloodAmount=@bloodRequired, @userCity=@selectedLocation, @bloodType=@bloodType

		-- Return the last transfusion ID
		DECLARE @transfusion int
		SELECT @transfusion=MAX(transfusionID) FROM Transfusion
		RETURN @transfusion			
	END
GO