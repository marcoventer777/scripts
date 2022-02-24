--select * from INFORMATION_SCHEMA.VIEWS;

--[view all persons with correct weight]
--create view Persons_CorrectWeight as
--select * from Persons where weightKGS >= 50;

--VIEWS
--drop view DROP VIEW Persons_DueForDonation;
--[view that sees who is due for donation]

--create view Persons_DueForDonation as
--select nextSafeDonationDate, needStatus from Donor, Patient where nextSafeDonationDate >= GETDATE() AND needStatus='low';
--GO

--select * from Persons_DueForDonation;

--PROCS
-- execute proc: EXEC SelectAllCustomers;

-- create: 
--create procedure SelectPatientsWithStatus @Status varchar(4) 
--as
--select * from Patient where needStatus = @Status;
--GO

--EXEC SelectPatientsWithStatus @Status = 'high';

--FUNCTIONS
-- execute: select dbo.scalar_overallWeight(1,100);
--drop: DROP FUNCTION IF EXISTS dbo.scalar_overallWeight;
--create function scalar_overallWeight (
--	@lower AS INT,
--	@upper AS INT
--)
--RETURNS INT
--AS
--BEGIN
--	RETURN @lower +  @upper;
--END;

--see what medical aid's have been used by donors
--select distinct d.schemeCode
--from Donor as d
--inner join MedicalAid as m
--on d.schemeCode = m.schemeCode

select * from MedicalAid;
select * from donor;

select * from donor;
select * from donation;
select * from donations;
select * from bloodbag;
select * from transfusions;
select * from transfusion;


drop proc DonorMedPoints;
--PROC - show all donor total med aid points for specific med aid.
create procedure DonorMedPoints @schemeCode VARCHAR(50)
as
select p.personID as DonorID, COUNT(p.personID) as NumDonations, SUM(m.rewardPerDonation) as TotalPoints
from Donor p 
inner join Donation d 
on p.personID = d.personID
inner join MedicalAid m 
on p.schemeCode = m.schemeCode
where p.schemeCode = @schemeCode
GROUP BY p.personID
ORDER BY TotalPoints DESC;

EXEC DonorMedPoints @schemeCode='DISC';	--enter personID

--FUNC - get % used in transfusions if blood donated is given.
create function Perc_TransfusedOfDonation (
	@donated AS INT,
	@transfused AS INT
)
RETURNS FLOAT
AS
BEGIN
	RETURN (@donated - @transfused) / @donated * 100;
END;

--PROC - show total blood donated and total blood transfused for donor.

--drop proc ShowTransfusionsForDonor;

create procedure ShowTransfusionsForDonor @donorID int 
as
select  p.personID, SUM(d.amountDonatedML) as TotalDonated, 
	    SUM(t.amountReceivedML) as TotalUsed, 
		dbo.Perc_TransfusedOfDonation(SUM(d.amountDonatedML), SUM(t.amountReceivedML)) as PercUsed
from Donor p
inner join Donation d on p.personID = d.personID
inner join Donations ds on d.donationID = ds.donationID 
inner join BloodBag b on b.bloodBagID = ds.bloodBagID
inner join Transfusions ts on ts.bloodBagID = b.bloodBagID
inner join Transfusion t on ts.transfusionID=t.transfusionID
where p.personID = @donorID
group by p.personID;


EXEC ShowTransfusionsForDonor @donorID = 3;







