

CREATE PROCEDURE getBloodAvailablePerLocation
@locationName nvarchar(128)

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT  l.locationName, b.bloodType, b.amountML AS Amount_Left , i.available AS Still_Available
	FROM Locations l 
	INNER JOIN Inventory i
	ON l.locationID = i.locationID
	INNER JOIN BloodBag b
	ON i.bloodBagID = b.bloodBagID
	WHERE l.locationName LIKE '%'+@locationName+'%' ;

END
GO
