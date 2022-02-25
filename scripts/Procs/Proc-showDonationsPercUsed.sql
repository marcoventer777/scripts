--PROC - show % of blood donated that is used in transfusions for donor.
CREATE OR ALTER PROCEDURE ShowTransfusionsForDonor @donorID INT 
AS
SELECT  p.personID, SUM(d.amountDonatedML) AS TotalDonated, 
	    SUM(t.amountReceivedML) AS TotalUsed, 
		[dbo].Perc_TransfusedOfDonation(SUM(d.amountDonatedML), SUM(t.amountReceivedML)) AS PercUsed
FROM Donor p
LEFT JOIN Donation d ON p.personID = d.personID
LEFT JOIN Donations ds ON d.donationID = ds.donationID 
LEFT JOIN BloodBag b ON b.bloodBagID = ds.bloodBagID
LEFT JOIN Transfusions ts ON ts.bloodBagID = b.bloodBagID
LEFT JOIN Transfusion t on ts.transfusionID=t.transfusionID
WHERE p.personID = @donorID
GROUP BY p.personID;
GO

--FUNC - get % used in transfusions if blood donated is given. Test: select [dbo].Perc_TransfusedOfDonation(1880, 820) as PercUsed;
CREATE OR ALTER FUNCTION [dbo].Perc_TransfusedOfDonation (
	@donated real,
	@transfused real
)
RETURNS real
AS
BEGIN
	--get %, and keep 2 decimal places.
	RETURN CONVERT(DECIMAL(10,2), (@donated - @transfused) / @donated * 100);
END;
GO

EXEC ShowTransfusionsForDonor @donorID = 3;
GO
