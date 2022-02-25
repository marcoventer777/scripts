CREATE FUNCTION udfBloodTypeTest
(
	@bloodType varchar(3)
)
RETURNS int 
	AS 
	BEGIN
		IF @bloodType='A+' OR @bloodType='A-' OR @bloodType='B+' OR @bloodType='B-' OR
			@bloodType='AB+' OR @bloodType='AB-' OR @bloodType='O+' OR @bloodType='O-'
			RETURN 1
		RETURN 0
	END
GO