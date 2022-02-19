--CREATING VIEWS--

CREATE VIEW vMovies
AS
SELECT [MovieName],
		[ReleaseDate],
		[RunningTime],
		[MovieDescription],
		[Genre]jj
FROM Movies
GO

--CREATE STORED PROCEDURE--

CREATE PROCEDURE [dbo].[uspGetActorInfo]

@MovieID int.
@WriterID int = NULL

AS
	SELECT m.MovieName,
	m.Release,
