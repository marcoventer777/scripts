--PROC - show % of blood donated that is used in transfusions for donor.
create or alter procedure ShowTransfusionsForDonor @donorID int 
as
select  p.personID, SUM(d.amountDonatedML) as TotalDonated, 
	    SUM(t.amountReceivedML) as TotalUsed, 
		[dbo].Perc_TransfusedOfDonation(SUM(d.amountDonatedML), SUM(t.amountReceivedML)) as PercUsed
from Donor p
left join Donation d on p.personID = d.personID
left join Donations ds on d.donationID = ds.donationID 
left join BloodBag b on b.bloodBagID = ds.bloodBagID
left join Transfusions ts on ts.bloodBagID = b.bloodBagID
left join Transfusion t on ts.transfusionID=t.transfusionID
where p.personID = @donorID
group by p.personID;

--FUNC - get % used in transfusions if blood donated is given. Test: select [dbo].Perc_TransfusedOfDonation(1880, 820) as PercUsed;
create or alter function [dbo].Perc_TransfusedOfDonation (
	@donated real,
	@transfused real
)
RETURNS real
AS
BEGIN
	--get %, and keep 2 decimal places.
	RETURN CONVERT(DECIMAL(10,2), (@donated - @transfused) / @donated * 100);
END;

EXEC ShowTransfusionsForDonor @donorID = 3;