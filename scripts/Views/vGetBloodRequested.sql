
--DISPLAY DIFFERENT BLOODTYPES REQUESTED FROM EACH LOCATION 

CREATE VIEW vGetBloodRequested
AS

SELECT l.locationID, l.locationName, r.bloodTypeRequested, SUM(r.amountRequestedML) AS Total_Amount
FROM Locations l 
INNER JOIN Request r
ON l.locationID = r.locationID
GROUP BY l.locationID, l.locationName, r.bloodTypeRequested;

GO
