--PROC - show all donor total med aid points for specific med aid.
create or alter procedure DonorMedPoints @schemeCode VARCHAR(50)
as
select p.personID as DonorID, COUNT(p.personID) as NumDonations, SUM(m.rewardPerDonation) as TotalPoints
from Donor p 
left join Donation d 
on p.personID = d.personID
left join MedicalAid m 
on p.schemeCode = m.schemeCode
where p.schemeCode = @schemeCode
GROUP BY p.personID	
ORDER BY TotalPoints DESC;

EXEC DonorMedPoints @schemeCode='DISC';	--enter personID

