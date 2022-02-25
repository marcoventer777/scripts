Use DonoraDB
GO

--VIEW/DISPLAY EXPIRED BLOOD FROM STORED/COLLECTED BLOOD BAGS
--Blood is considered outdated after 42 days

CREATE VIEW vCheckBloodGroup_Amount_Expired
AS

SELECT  b.bloodBagID, b.bloodType, b.amountML AS ExpiredBlood
FROM  BloodBag b
RIGHT JOIN Donations d
ON b.bloodBagID = d.bloodBagID
RIGHT JOIN Transfusions t
ON b.bloodBagID = t.bloodBagID
WHERE DATEDIFF(day, d.donationDate, GETDATE()) < 42

GO

