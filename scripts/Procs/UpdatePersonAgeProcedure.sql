USE DonoraDB
GO

CREATE OR ALTER PROCEDURE UpdatePersonWeight (
    @personID INT,
    @weightKGS INT
)
AS
BEGIN TRY
    UPDATE Persons
    SET weightKGS=@weightKGS
    WHERE personID=@personID 
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH
GO

CREATE OR ALTER PROCEDURE SelectAllFromPersons 
 @personID INT
AS
BEGIN TRY
    SELECT 
        personID, 
        firstName, 
        lastName, 
        weightKGS,
        idNum 
    FROM Persons
    WHERE personID=@personID
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH
GO
