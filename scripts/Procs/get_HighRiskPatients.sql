
--PROC 
CREATE PROCEDURE Get_HighRiskPatients
@needStatus nvarchar(4)

AS
BEGIN
	-- SET NOCOUNT prevents extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT p.firstName, p.lastName, p.gender, p.bloodType, pa.needStatus
	FROM Persons p
	RIGHT JOIN Patient pa
	ON p.personID = pa.personID
	WHERE pa.needStatus LIKE '%'+@needStatus+'%' 

END
GO

 
