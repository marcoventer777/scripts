USE [master]
GO
/****** Object:  Database [DonoraDB]    Script Date: 2022/02/24 23:51:30 ******/
CREATE DATABASE [DonoraDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DonoraDB', FILENAME = N'D:\rdsdbdata\DATA\DonoraDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DonoraDB_log', FILENAME = N'D:\rdsdbdata\DATA\DonoraDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [DonoraDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DonoraDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DonoraDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DonoraDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DonoraDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DonoraDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DonoraDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [DonoraDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DonoraDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DonoraDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DonoraDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DonoraDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DonoraDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DonoraDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DonoraDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DonoraDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DonoraDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DonoraDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DonoraDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DonoraDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DonoraDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DonoraDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DonoraDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DonoraDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DonoraDB] SET RECOVERY FULL 
GO
ALTER DATABASE [DonoraDB] SET  MULTI_USER 
GO
ALTER DATABASE [DonoraDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DonoraDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DonoraDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DonoraDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DonoraDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DonoraDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [DonoraDB] SET QUERY_STORE = OFF
GO
USE [DonoraDB]
GO
/****** Object:  User [primaryuser]    Script Date: 2022/02/24 23:51:31 ******/
CREATE USER [primaryuser] FOR LOGIN [primaryuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [primaryuser]
GO
/****** Object:  UserDefinedFunction [dbo].[Perc_TransfusedOfDonation]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Perc_TransfusedOfDonation] (
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
/****** Object:  Table [dbo].[Persons]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persons](
	[personID] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](120) NOT NULL,
	[lastName] [varchar](120) NOT NULL,
	[weightKGS] [int] NOT NULL,
	[idNum] [varchar](13) NOT NULL,
	[bloodType] [varchar](3) NOT NULL,
	[gender] [varchar](6) NOT NULL,
	[mobileNum] [char](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Persons_CorrectWeight]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Persons_CorrectWeight] as

select * from Persons where weightKGS >= 50;
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[personID] [int] NOT NULL,
	[needStatus] [varchar](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Donor]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donor](
	[personID] [int] NOT NULL,
	[schemeCode] [varchar](50) NULL,
	[nextSafeDonationDate] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Persons_DueForDonation]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from INFORMATION_SCHEMA.VIEWS;

--[view all persons with correct weight]
--create view Persons_CorrectWeight as
--select * from Persons where weightKGS >= 50;

--drop view DROP VIEW Persons_DueForDonation;
--[view that sees who is due for donation]

create view [dbo].[Persons_DueForDonation] as
select nextSafeDonationDate, needStatus from Donor, Patient where nextSafeDonationDate >= GETDATE() AND needStatus='low';
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory](
	[bloodBagID] [int] NOT NULL,
	[locationID] [int] NOT NULL,
	[available] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[bloodBagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BloodBag]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BloodBag](
	[bloodBagID] [int] IDENTITY(1,1) NOT NULL,
	[amountML] [int] NOT NULL,
	[bloodType] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[bloodBagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[locationID] [int] IDENTITY(1,1) NOT NULL,
	[locationName] [varchar](128) NOT NULL,
	[codeID] [varchar](8) NOT NULL,
	[city] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[locationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vCheckAmountAvailable]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCheckAmountAvailable]
AS

SELECT  l.locationName, b.bloodType, b.amountML AS Amount_Left
FROM Locations l 
INNER JOIN Inventory i
ON l.locationID = i.locationID
INNER JOIN BloodBag b
ON i.bloodBagID = b.bloodBagID;
GO
/****** Object:  Table [dbo].[Transfusions]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transfusions](
	[transfusionID] [int] NOT NULL,
	[locationID] [int] NOT NULL,
	[bloodBagID] [int] NOT NULL,
	[transfusionDate] [date] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Donations]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donations](
	[donationID] [int] NOT NULL,
	[locationID] [int] NOT NULL,
	[bloodBagID] [int] NOT NULL,
	[donationDate] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[donationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vCheckBloodGroup_Amount_Expired]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCheckBloodGroup_Amount_Expired]
AS

SELECT  b.bloodBagID, b.bloodType, b.amountML AS ExpiredBlood
FROM  BloodBag b
RIGHT JOIN Donations d
ON b.bloodBagID = d.bloodBagID
RIGHT JOIN Transfusions t
ON b.bloodBagID = t.bloodBagID
WHERE DATEDIFF(day, d.donationDate, GETDATE()) < 42

GO
/****** Object:  Table [dbo].[Request]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Request](
	[requestID] [int] IDENTITY(1,1) NOT NULL,
	[locationID] [int] NOT NULL,
	[bloodTypeRequested] [varchar](3) NOT NULL,
	[dateReceived] [date] NULL,
	[amountRequestedML] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[requestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vGetBloodRequested]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vGetBloodRequested]
AS

SELECT l.locationID, l.locationName, r.bloodTypeRequested, SUM(r.amountRequestedML) AS Total_Amount
FROM Locations l 
INNER JOIN Request r
ON l.locationID = r.locationID
GROUP BY l.locationID, l.locationName, r.bloodTypeRequested;

GO
/****** Object:  Table [dbo].[Donation]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donation](
	[donationID] [int] IDENTITY(1,1) NOT NULL,
	[personID] [int] NOT NULL,
	[preTestID] [int] NOT NULL,
	[donationType] [varchar](20) NOT NULL,
	[amountDonatedML] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[donationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DonationTypes]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DonationTypes](
	[donationType] [varchar](20) NOT NULL,
	[donationInterval] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[donationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocationCodes]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationCodes](
	[codeID] [varchar](8) NOT NULL,
	[description] [varchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[codeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalAid]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalAid](
	[schemeCode] [varchar](50) NOT NULL,
	[medName] [varchar](120) NULL,
	[rewardPerDonation] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[schemeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PreTest]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreTest](
	[preTestID] [int] IDENTITY(1,1) NOT NULL,
	[hemoglobin] [float] NOT NULL,
	[temperature] [float] NOT NULL,
	[bloodPressure] [varchar](7) NULL,
	[heartPulseBPM] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[preTestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transfusion]    Script Date: 2022/02/24 23:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transfusion](
	[transfusionID] [int] IDENTITY(1,1) NOT NULL,
	[personID] [int] NOT NULL,
	[amountReceivedML] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[transfusionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BloodBag] ON 

INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (1, 0, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (2, 70, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (3, 470, N'AB-')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (4, 120, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (5, 470, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (6, 250, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (7, 470, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (8, 470, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (9, 470, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (10, 470, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (11, 0, N'B-')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (12, 470, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (13, 470, N'B+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (14, 0, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (15, 0, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (16, 0, N'A+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (17, 70, N'O-')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (18, 70, N'A-')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (19, 470, N'O+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (20, 170, N'AB+')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (21, 470, N'B-')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (22, 470, N'B-')
INSERT [dbo].[BloodBag] ([bloodBagID], [amountML], [bloodType]) VALUES (24, 470, N'A+')
SET IDENTITY_INSERT [dbo].[BloodBag] OFF
GO
SET IDENTITY_INSERT [dbo].[Donation] ON 

INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (12, 3, 45, N'Blood', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (13, 5, 46, N'Platelets', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (14, 7, 47, N'Plasma', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (15, 3, 45, N'Blood', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (16, 3, 45, N'Plasma', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (17, 5, 47, N'Platelets', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (18, 5, 45, N'Plasma', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (19, 7, 50, N'Plasma', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (20, 7, 51, N'Plasma', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (22, 3, 57, N'Blood', 470)
INSERT [dbo].[Donation] ([donationID], [personID], [preTestID], [donationType], [amountDonatedML]) VALUES (23, 7, 58, N'Blood', 470)
SET IDENTITY_INSERT [dbo].[Donation] OFF
GO
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (12, 3, 1, CAST(N'2022-02-05' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (13, 4, 2, CAST(N'2022-02-06' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (14, 5, 3, CAST(N'2022-02-07' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (15, 6, 4, CAST(N'2022-02-08' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (16, 7, 5, CAST(N'2022-02-09' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (17, 3, 6, CAST(N'2022-02-10' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (18, 4, 7, CAST(N'2022-02-11' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (19, 5, 8, CAST(N'2022-02-12' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (20, 6, 9, CAST(N'2022-02-13' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (22, 3, 21, CAST(N'2022-02-24' AS Date))
INSERT [dbo].[Donations] ([donationID], [locationID], [bloodBagID], [donationDate]) VALUES (23, 3, 22, CAST(N'2022-02-24' AS Date))
GO
INSERT [dbo].[DonationTypes] ([donationType], [donationInterval]) VALUES (N'Blood', 56)
INSERT [dbo].[DonationTypes] ([donationType], [donationInterval]) VALUES (N'Plasma', 28)
INSERT [dbo].[DonationTypes] ([donationType], [donationInterval]) VALUES (N'Platelets', 7)
GO
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (3, N'DISC', CAST(N'2022-03-20' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (5, N'DISC', CAST(N'2022-03-01' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (7, N'MOM', CAST(N'2022-05-02' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (13, N'DISC', CAST(N'2022-03-08' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (14, N'DISC', CAST(N'2022-03-09' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (15, N'BMF', CAST(N'2022-03-10' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (16, N'GEMS', CAST(N'2022-03-11' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (17, N'MED', CAST(N'2022-03-12' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (18, N'GEMS', CAST(N'2022-03-13' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (19, N'MOM', CAST(N'2022-03-14' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (20, N'DISC', CAST(N'2022-03-15' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (21, N'DISC', CAST(N'2022-03-16' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (22, N'MOM', CAST(N'2022-03-17' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (23, N'GEMS', CAST(N'2022-03-18' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (24, N'MED', CAST(N'2022-03-19' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (25, N'BMF', CAST(N'2022-03-20' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (26, N'MOM', CAST(N'2022-03-21' AS Date))
INSERT [dbo].[Donor] ([personID], [schemeCode], [nextSafeDonationDate]) VALUES (27, N'MED', CAST(N'2022-03-22' AS Date))
GO
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (1, 3, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (2, 9, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (3, 11, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (4, 5, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (5, 5, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (6, 5, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (7, 10, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (8, 4, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (9, 6, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (10, 6, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (11, 12, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (12, 3, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (13, 11, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (14, 10, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (15, 12, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (16, 8, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (17, 12, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (18, 7, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (19, 12, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (20, 9, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (21, 3, 1)
INSERT [dbo].[Inventory] ([bloodBagID], [locationID], [available]) VALUES (22, 3, 1)
GO
INSERT [dbo].[LocationCodes] ([codeID], [description]) VALUES (N'BDRIVE', N'A Rare Popup Blood Drive Location')
INSERT [dbo].[LocationCodes] ([codeID], [description]) VALUES (N'CLINIC', N'A Private/Public Clinic That Accepts Donations')
INSERT [dbo].[LocationCodes] ([codeID], [description]) VALUES (N'DONORA', N'A Fixed Blood Donora Donor Location')
INSERT [dbo].[LocationCodes] ([codeID], [description]) VALUES (N'HOSPITAL', N'A Private/Public Hospital That Accepts Donations')
INSERT [dbo].[LocationCodes] ([codeID], [description]) VALUES (N'ORG', N'A School/Office With Regular Blood Drives')
GO
SET IDENTITY_INSERT [dbo].[Locations] ON 

INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (3, N'BBD JHB Office', N'ORG', N'Killarney')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (4, N'Nelson Mandela Square', N'BDRIVE', N'Sandton')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (5, N'Chris Hani Baragwanath Academic Hospital', N'HOSPITAL', N'Soweto')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (6, N'Musgrave Donor Centre', N'DONORA', N'Durban')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (7, N'Claremont Clinic', N'CLINIC', N'Claremont')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (8, N'Booth Memorial Hospital', N'HOSPITAL', N'Oranjezicht')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (9, N'Levai Mbatha Community Health Center', N'CLINIC', N'Evaton')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (10, N'Zola Clinic', N'CLINIC', N'Soweto')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (11, N'Netcare Christiaan Barnard Memorial Hospital', N'HOSPITAL', N'Foreshore')
INSERT [dbo].[Locations] ([locationID], [locationName], [codeID], [city]) VALUES (12, N'Sebokeng Hospital', N'HOSPITAL', N'Sebokeng')
SET IDENTITY_INSERT [dbo].[Locations] OFF
GO
INSERT [dbo].[MedicalAid] ([schemeCode], [medName], [rewardPerDonation]) VALUES (N'BMF', N'Bonitas Medical Fund', 150)
INSERT [dbo].[MedicalAid] ([schemeCode], [medName], [rewardPerDonation]) VALUES (N'DISC', N'Discovery Health', 1000)
INSERT [dbo].[MedicalAid] ([schemeCode], [medName], [rewardPerDonation]) VALUES (N'GEMS', N'Government Employees Medical Scheme', 250)
INSERT [dbo].[MedicalAid] ([schemeCode], [medName], [rewardPerDonation]) VALUES (N'MED', N'Medshield', 400)
INSERT [dbo].[MedicalAid] ([schemeCode], [medName], [rewardPerDonation]) VALUES (N'MOM', N'Momentum Health', 350)
GO
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (3, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (4, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (5, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (6, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (7, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (8, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (9, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (10, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (11, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (12, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (13, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (14, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (15, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (16, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (17, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (18, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (19, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (20, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (21, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (22, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (23, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (24, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (25, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (26, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (27, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (28, N'high')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (29, N'low')
INSERT [dbo].[Patient] ([personID], [needStatus]) VALUES (30, N'high')
GO
SET IDENTITY_INSERT [dbo].[Persons] ON 

INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (3, N'Sipho', N'Kasi', 54, N'120125658987', N'B-', N'female', N'0849068722')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (4, N'Blessing', N'Ndlovu', 88, N'7405095655897', N'A-', N'male', N'0711958784')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (5, N'Rameriz', N'Rodriguez', 63, N'6905112505589', N'O+', N'male', N'0711958785')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (6, N'Adam', N'Small', 53, N'9812074544147', N'O-', N'male', N'0611958748')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (7, N'Jessica', N'Parker', 120, N'6910108577489', N'B-', N'female', N'0621958785')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (8, N'Gail', N'Buck', 69, N'2001014800086', N'O+', N'female', N'0611954785')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (9, N'Jolene', N'Lane', 79, N'6303295548186', N'A+', N'female', N'0611958489')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (10, N'Drew', N'Boyle', 93, N'6506274973080', N'AB-', N'male', N'0611951241')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (11, N'Newton', N'Hakeem L.', 86, N'3609034226188', N'A+', N'male', N'0611777748')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (12, N'Kim', N'Collier', 93, N'4006254151080', N'A+', N'female', N'0611958799')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (13, N'Grant', N'Mayo', 95, N'9908224150180', N'O+', N'male', N'0611958111')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (14, N'Kyra', N'Wiggins', 98, N'3902144801085', N'A+', N'female', N'0611958780')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (15, N'Xandra', N'Ratliff', 80, N'2710185378082', N'O+', N'female', N'0611958748')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (16, N'Fiona', N'Franco', 85, N'6808295709182', N'A+', N'female', N'0211958785')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (17, N'Melvin', N'Mcmillan', 83, N'3704064895083', N'O+', N'male', N'0921958785')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (18, N'Pollard', N'Cody V', 84, N'9612314605182', N'B-', N'male', N'0881954785')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (19, N'Evangeline', N'Shepard', 73, N'6709144308087', N'A+', N'female', N'0641958489')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (20, N'Olivia', N'Wilkinson', 75, N'9809164921087', N'B+', N'female', N'0211951241')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (21, N'Margaret', N'Fletcher', 79, N'5403104419180', N'O+', N'female', N'0111777748')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (22, N'Reece', N'Herring', 94, N'4106244396082', N'O+', N'male', N'0611958799')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (23, N'Rivas', N'Brianna T.', 91, N'5008305591180', N'A+', N'female', N'0311258111')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (24, N'Fritz', N'Valdez', 84, N'3412064766185', N'O-', N'female', N'0697758780')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (25, N'August', N'Baldwin', 98, N'4103275009189', N'A-', N'male', N'0611444718')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (26, N'Dalton', N'Bright', 79, N'6902245451084', N'O+', N'male', N'0211444458')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (27, N'Olivia', N'Baldwin', 78, N'3312165115086', N'AB+', N'female', N'0921957747')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (28, N'Pollard', N'Hanae O.', 95, N'3802135936181', N'A+', N'male', N'0881954444')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (29, N'Kyra', N'Hakeem L.', 92, N'6601074379081', N'O-', N'female', N'0991958489')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (30, N'Xandra', N'Ratliff', 80, N'7508215348181', N'A-', N'female', N'0214448484')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (31, N'Angelica', N'Short', 88, N'7111155181082', N'O+', N'female', N'0111222263')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (32, N'Kermit', N'Mays', 89, N'8901134550087', N'AB+', N'male', N'0611957490')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (33, N'Kennedy', N'Cunningham', 82, N'5812215256184', N'B-', N'male', N'0311258000')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (34, N'Hasad', N'Wade', 80, N'7602155998186', N'O+', N'male', N'0697751141')
INSERT [dbo].[Persons] ([personID], [firstName], [lastName], [weightKGS], [idNum], [bloodType], [gender], [mobileNum]) VALUES (35, N'Delilah', N'Buck', 78, N'5301104538084', N'A+', N'female', N'0697766669')
SET IDENTITY_INSERT [dbo].[Persons] OFF
GO
SET IDENTITY_INSERT [dbo].[PreTest] ON 

INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (45, 12.9, 36.4, N'120/200', 77)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (46, 14.2, 35.3, N'90/60', 82)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (47, 13.8, 37, N'100/80', 70)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (48, 13.5, 36, N'108/90', 65)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (49, 15.1, 37.1, N'110/96', 68)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (50, 17.1, 36.2, N'105/69', 79)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (51, 14.1, 35.8, N'120/100', 80)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (52, 13.7, 37.3, N'145/160', 73)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (53, 14, 36.8, N'100/180', 84)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (56, 12.5, 36, N'100/80', 61)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (57, 13, 35.9, N'120/100', 65)
INSERT [dbo].[PreTest] ([preTestID], [hemoglobin], [temperature], [bloodPressure], [heartPulseBPM]) VALUES (58, 13, 35.9, N'120/100', 65)
SET IDENTITY_INSERT [dbo].[PreTest] OFF
GO
SET IDENTITY_INSERT [dbo].[Request] ON 

INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (2, 6, N'A+', CAST(N'2022-02-23' AS Date), 470)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (3, 3, N'O+', CAST(N'2022-02-23' AS Date), 400)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (4, 7, N'AB+', CAST(N'2022-02-23' AS Date), 10000)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (5, 5, N'B+', CAST(N'2022-02-23' AS Date), 2000)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (6, 4, N'A-', CAST(N'2022-02-23' AS Date), 3090)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (7, 3, N'O-', CAST(N'2022-02-23' AS Date), 500)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (8, 5, N'B-', CAST(N'2022-02-23' AS Date), 5050)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (9, 6, N'AB-', CAST(N'2022-02-23' AS Date), 3090)
INSERT [dbo].[Request] ([requestID], [locationID], [bloodTypeRequested], [dateReceived], [amountRequestedML]) VALUES (11, 4, N'A-', CAST(N'2021-01-19' AS Date), 7000)
SET IDENTITY_INSERT [dbo].[Request] OFF
GO
SET IDENTITY_INSERT [dbo].[Transfusion] ON 

INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (4, 4, 400)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (5, 4, 400)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (6, 5, 470)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (7, 5, 200)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (8, 5, 270)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (9, 4, 350)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (10, 4, 220)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (11, 4, 200)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (12, 5, 470)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (13, 4, 470)
INSERT [dbo].[Transfusion] ([transfusionID], [personID], [amountReceivedML]) VALUES (14, 5, 470)
SET IDENTITY_INSERT [dbo].[Transfusion] OFF
GO
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (4, 5, 17, CAST(N'2202-03-01' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (5, 7, 18, CAST(N'2202-03-02' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (6, 7, 1, CAST(N'2202-03-03' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (7, 5, 2, CAST(N'2202-03-04' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (8, 9, 14, CAST(N'2202-03-05' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (9, 8, 4, CAST(N'2202-03-06' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (10, 12, 6, CAST(N'2202-03-07' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (11, 11, 20, CAST(N'2202-03-08' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (12, 10, 11, CAST(N'2202-03-09' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (13, 9, 15, CAST(N'2202-03-10' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (14, 12, 16, CAST(N'2202-03-11' AS Date))
INSERT [dbo].[Transfusions] ([transfusionID], [locationID], [bloodBagID], [transfusionDate]) VALUES (7, 5, 14, CAST(N'2022-03-04' AS Date))
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__MedicalA__D9A976D19DF0674E]    Script Date: 2022/02/24 23:51:34 ******/
ALTER TABLE [dbo].[MedicalAid] ADD UNIQUE NONCLUSTERED 
(
	[medName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Persons__3FF147F238D40900]    Script Date: 2022/02/24 23:51:34 ******/
ALTER TABLE [dbo].[Persons] ADD UNIQUE NONCLUSTERED 
(
	[idNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inventory] ADD  DEFAULT ((1)) FOR [available]
GO
ALTER TABLE [dbo].[Persons] ADD  DEFAULT ('0849068722') FOR [mobileNum]
GO
ALTER TABLE [dbo].[Request] ADD  DEFAULT (getdate()) FOR [dateReceived]
GO
ALTER TABLE [dbo].[Donation]  WITH CHECK ADD  CONSTRAINT [FK__Donation__donati__5CD6CB2B] FOREIGN KEY([donationType])
REFERENCES [dbo].[DonationTypes] ([donationType])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donation] CHECK CONSTRAINT [FK__Donation__donati__5CD6CB2B]
GO
ALTER TABLE [dbo].[Donation]  WITH CHECK ADD  CONSTRAINT [FK__Donation__person__5AEE82B9] FOREIGN KEY([personID])
REFERENCES [dbo].[Donor] ([personID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donation] CHECK CONSTRAINT [FK__Donation__person__5AEE82B9]
GO
ALTER TABLE [dbo].[Donation]  WITH CHECK ADD  CONSTRAINT [FK__Donation__pretes__5BE2A6F2] FOREIGN KEY([preTestID])
REFERENCES [dbo].[PreTest] ([preTestID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donation] CHECK CONSTRAINT [FK__Donation__pretes__5BE2A6F2]
GO
ALTER TABLE [dbo].[Donations]  WITH CHECK ADD  CONSTRAINT [FK__Donations__blood__787EE5A0] FOREIGN KEY([bloodBagID])
REFERENCES [dbo].[BloodBag] ([bloodBagID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donations] CHECK CONSTRAINT [FK__Donations__blood__787EE5A0]
GO
ALTER TABLE [dbo].[Donations]  WITH CHECK ADD  CONSTRAINT [FK__Donations__donat__76969D2E] FOREIGN KEY([donationID])
REFERENCES [dbo].[Donation] ([donationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donations] CHECK CONSTRAINT [FK__Donations__donat__76969D2E]
GO
ALTER TABLE [dbo].[Donations]  WITH CHECK ADD FOREIGN KEY([locationID])
REFERENCES [dbo].[Locations] ([locationID])
GO
ALTER TABLE [dbo].[Donor]  WITH CHECK ADD  CONSTRAINT [FK__Donor__personID__44FF419A] FOREIGN KEY([personID])
REFERENCES [dbo].[Persons] ([personID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donor] CHECK CONSTRAINT [FK__Donor__personID__44FF419A]
GO
ALTER TABLE [dbo].[Donor]  WITH CHECK ADD  CONSTRAINT [FK__Donor__schemeCod__45F365D3] FOREIGN KEY([schemeCode])
REFERENCES [dbo].[MedicalAid] ([schemeCode])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Donor] CHECK CONSTRAINT [FK__Donor__schemeCod__45F365D3]
GO
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD FOREIGN KEY([bloodBagID])
REFERENCES [dbo].[BloodBag] ([bloodBagID])
GO
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD FOREIGN KEY([locationID])
REFERENCES [dbo].[Locations] ([locationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD FOREIGN KEY([codeID])
REFERENCES [dbo].[LocationCodes] ([codeID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK__Patient__personI__3E52440B] FOREIGN KEY([personID])
REFERENCES [dbo].[Persons] ([personID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK__Patient__personI__3E52440B]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD FOREIGN KEY([locationID])
REFERENCES [dbo].[Locations] ([locationID])
GO
ALTER TABLE [dbo].[Transfusion]  WITH CHECK ADD  CONSTRAINT [FK__Transfusi__perso__5535A963] FOREIGN KEY([personID])
REFERENCES [dbo].[Patient] ([personID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Transfusion] CHECK CONSTRAINT [FK__Transfusi__perso__5535A963]
GO
ALTER TABLE [dbo].[Transfusions]  WITH CHECK ADD  CONSTRAINT [FK__Transfusi__blood__73BA3083] FOREIGN KEY([bloodBagID])
REFERENCES [dbo].[BloodBag] ([bloodBagID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Transfusions] CHECK CONSTRAINT [FK__Transfusi__blood__73BA3083]
GO
ALTER TABLE [dbo].[Transfusions]  WITH CHECK ADD FOREIGN KEY([locationID])
REFERENCES [dbo].[Locations] ([locationID])
GO
ALTER TABLE [dbo].[Transfusions]  WITH NOCHECK ADD  CONSTRAINT [FK__Transfusi__trans__71D1E811] FOREIGN KEY([transfusionID])
REFERENCES [dbo].[Transfusion] ([transfusionID])
ON UPDATE CASCADE
ON DELETE CASCADE
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Transfusions] CHECK CONSTRAINT [FK__Transfusi__trans__71D1E811]
GO
ALTER TABLE [dbo].[BloodBag]  WITH CHECK ADD  CONSTRAINT [CHK_BloodBag_bloodType] CHECK  (([bloodType]='A+' OR [bloodType]='A-' OR [bloodType]='B+' OR [bloodType]='B-' OR [bloodType]='AB+' OR [bloodType]='AB-' OR [bloodType]='O+' OR [bloodType]='O-'))
GO
ALTER TABLE [dbo].[BloodBag] CHECK CONSTRAINT [CHK_BloodBag_bloodType]
GO
ALTER TABLE [dbo].[BloodBag]  WITH CHECK ADD  CONSTRAINT [CK_BloodBag] CHECK  (([amountML]<=(470) AND [amountML]>=(0)))
GO
ALTER TABLE [dbo].[BloodBag] CHECK CONSTRAINT [CK_BloodBag]
GO
ALTER TABLE [dbo].[Donor]  WITH CHECK ADD  CONSTRAINT [CHK_dateCorrect] CHECK  (([nextSafeDonationDate]>=getdate()))
GO
ALTER TABLE [dbo].[Donor] CHECK CONSTRAINT [CHK_dateCorrect]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CHK_needStatus] CHECK  (([needStatus]='low' OR [needStatus]='high'))
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CHK_needStatus]
GO
ALTER TABLE [dbo].[Persons]  WITH CHECK ADD  CONSTRAINT [CHK_bloodType] CHECK  (([bloodType]='A+' OR [bloodType]='A-' OR [bloodType]='B+' OR [bloodType]='B-' OR [bloodType]='AB+' OR [bloodType]='AB-' OR [bloodType]='O+' OR [bloodType]='O-'))
GO
ALTER TABLE [dbo].[Persons] CHECK CONSTRAINT [CHK_bloodType]
GO
ALTER TABLE [dbo].[Persons]  WITH CHECK ADD  CONSTRAINT [CHK_gender] CHECK  (([gender]='male' OR [gender]='female'))
GO
ALTER TABLE [dbo].[Persons] CHECK CONSTRAINT [CHK_gender]
GO
ALTER TABLE [dbo].[Persons]  WITH CHECK ADD  CONSTRAINT [CHK_mobileNUm] CHECK  ((NOT [mobileNum] like '%[^0-9]%' AND [mobileNum] like '0%'))
GO
ALTER TABLE [dbo].[Persons] CHECK CONSTRAINT [CHK_mobileNUm]
GO
ALTER TABLE [dbo].[Persons]  WITH CHECK ADD  CONSTRAINT [CHK_weight] CHECK  (([weightKGS]>=(5)))
GO
ALTER TABLE [dbo].[Persons] CHECK CONSTRAINT [CHK_weight]
GO
ALTER TABLE [dbo].[PreTest]  WITH CHECK ADD  CONSTRAINT [CHK_Pretest_heartPulseBPM] CHECK  (([heartPulseBPM]>(60) AND [heartPulseBPM]<(100)))
GO
ALTER TABLE [dbo].[PreTest] CHECK CONSTRAINT [CHK_Pretest_heartPulseBPM]
GO
ALTER TABLE [dbo].[PreTest]  WITH CHECK ADD  CONSTRAINT [CHK_Pretest_hemoglobin] CHECK  (([hemoglobin]>=(12.5)))
GO
ALTER TABLE [dbo].[PreTest] CHECK CONSTRAINT [CHK_Pretest_hemoglobin]
GO
ALTER TABLE [dbo].[PreTest]  WITH CHECK ADD  CONSTRAINT [CHK_Pretest_temperature] CHECK  (([temperature]>=(35) AND [temperature]<=(37.9)))
GO
ALTER TABLE [dbo].[PreTest] CHECK CONSTRAINT [CHK_Pretest_temperature]
GO
/****** Object:  StoredProcedure [dbo].[addDonation]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE   PROCEDURE [dbo].[addDonation]
    @hemoglobin FLOAT,
    @temperature FLOAT,
    @bloodPressure VARCHAR(7),
    @heartPulseBPM INT,
    @personID INT,
    @amountDonatedML INT,
    @donationType VARCHAR(20),
    @locationID INT
AS
BEGIN TRY
	 --update donor next safe donation date based on donation type
     DECLARE @interval INT;
     SELECT @interval = donationInterval FROM DonationTypes WHERE donationType=@donationType;
     DECLARE @curDate DATE;
     SELECT @curDate = nextSafeDonationDate FROM Donor WHERE personID=@personID;
     UPDATE Donor SET nextSafeDonationDate=CAST(DATEADD(day, @interval, @curDate) AS DATE) WHERE personID=@personID
     INSERT INTO PreTest(
         hemoglobin,
         temperature,
         bloodPressure,
         heartPulseBPM
     )
     VALUES (
        @hemoglobin,
        @temperature ,
        @bloodPressure,
        @heartPulseBPM 
     )
    EXEC enterDonation @personID=@personID, @amountDonatedML=@amountDonatedML, @donationType=@donationType, @locationID=@locationID
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[DonorMedPoints]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[DonorMedPoints] @schemeCode VARCHAR(50)
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
GO
/****** Object:  StoredProcedure [dbo].[enterDonation]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[enterDonation] 
   @personID INT,
   @amountDonatedML INT,
   @donationType VARCHAR(20),
   @locationID INT
AS
BEGIN TRY
    DECLARE @preTestID AS INT;
    DECLARE @bloodBagID AS INT;
    DECLARE @donationID AS INT;
    DECLARE @bloodType VARCHAR(3);
    SELECT @preTestID = preTestID FROM PreTest;
    SELECT @bloodType = bloodType FROM Persons WHERE personID = @personID
    INSERT INTO Donation(
        personID,
        preTestID,
        donationType,
        amountDonatedML
    )
    VALUES (
        @personID,
        @preTestID,
        @donationType,
        @amountDonatedML
    )
    INSERT INTO BloodBag(
        amountML,
        bloodType
    )
    VALUES (
        @amountDonatedML,
        @bloodType
    )
    SELECT @bloodBagID = bloodBagID FROM BloodBag;
    SELECT @donationID = donationID FROM Donation;
    INSERT INTO Donations(
        donationID,
        locationID,
        bloodBagID,
        donationDate
    )
    VALUES (
       @donationID,
       @locationID,
       @bloodBagID,
       CAST(GETDATE() AS DATE)
    )
    INSERT INTO Inventory(
        bloodBagID,
        locationID,
        available
    )
    VALUES(
        @bloodBagID,
        @locationID,
        1
    )

END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[enterPretestData]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[enterPretestData] 
    @hemoglobin FLOAT,
    @temperature FLOAT,
    @bloodPressure VARCHAR(7),
    @heartPulseBPM INT
AS
BEGIN TRY
     INSERT INTO PreTest(
         hemoglobin,
         temperature,
         bloodPressure,
         heartPulseBPM
     )
     VALUES (
        @hemoglobin,
        @temperature ,
        @bloodPressure,
        @heartPulseBPM 
     )
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Get_HighRiskPatients]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_HighRiskPatients]
@needStatus nvarchar(4)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT p.firstName, p.lastName, p.gender, p.bloodType, pa.needStatus
	FROM Persons p
	RIGHT JOIN Patient pa
	ON p.personID = pa.personID
	WHERE pa.needStatus LIKE '%'+@needStatus+'%' 

END
GO
/****** Object:  StoredProcedure [dbo].[Get_Patients_Per_Location]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_Patients_Per_Location]

	-- Add the parameters for the stored procedure here
@LocationName nvarchar(128)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM LOCATIONS
	WHERE locationName LIKE '%'+@locationName+'%' 
END
GO
/****** Object:  StoredProcedure [dbo].[getBloodAvailablePerLocation]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getBloodAvailablePerLocation]
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
/****** Object:  StoredProcedure [dbo].[SelectAllFromPersons]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[SelectAllFromPersons] 
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
/****** Object:  StoredProcedure [dbo].[SelectPatientsWithStatus]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

--*desired
--view locations with blood bags in desc order
--view locations donations in desc order
--view locations transfusions in desc order
--view medical aid with most donations
--view requestd blood type in desc order

--PROCS
-- execute proc: EXEC SelectAllCustomers;

-- create: 
create procedure [dbo].[SelectPatientsWithStatus] @Status varchar(4) 
as
select * from Patient where needStatus = @Status;
GO
/****** Object:  StoredProcedure [dbo].[ShowTransfusionsForDonor]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[ShowTransfusionsForDonor] @donorID int 
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
GO
/****** Object:  StoredProcedure [dbo].[udpNewPatient]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[udpNewPatient]
@personID int,
@needState varchar(4),
@newID int OUTPUT
AS BEGIN
	INSERT INTO Patient(personID, needStatus) VALUES(@personID, @needState)

	SELECT @newID = MAX(personID) FROM Patient
	PRINT 'New patient created. Patient ID: ' + @newID
	END
GO
/****** Object:  StoredProcedure [dbo].[udpSingleTransfusion]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[udpSingleTransfusion]
(
	@bloodTransfused int,
	@bloodLeft int,
	@bloodBagID int,
	@personID int,
	@locationID int
)
AS BEGIN
	UPDATE BloodBag SET amountML=@bloodLeft WHERE bloodBagID=@bloodBagID 
	INSERT INTO Transfusion(personID, amountReceivedML) VALUES(@personID, @bloodTransfused)

	-- Get the latest transfusion and create a link to the location + bloodBag
	DECLARE @nextTransfusionID int 
	SELECT @nextTransfusionID = MAX(transfusionID) FROM Transfusion
	INSERT INTO Transfusions(transfusionID, locationID, bloodBagID, transfusionDate) 
		VALUES(@nextTransfusionID, @locationID, @bloodBagID, GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[udpUseUpBag]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[udpUseUpBag]
@personID int,
@bloodAmount int,
@userCity varchar(128),
@bloodType varchar(3)
AS BEGIN
	-- transaction
		-- Go find a blood bag that has the correct blood type
		IF @bloodAmount > 0
			BEGIN
			DECLARE @bloodBagID int
			DECLARE @oldAmount int
			DECLARE @locationID int

			-- find a blood bag with enough blood
			SELECT @bloodBagID=BloodBag.bloodBagID, @oldAmount = amountML, @locationID=Locations.locationID
			FROM BloodBag
			INNER JOIN Inventory
			ON Inventory.bloodBagID = BloodBag.bloodBagID
			AND Inventory.available=1
			AND BloodBag.amountML>=@bloodAmount
			AND BloodBag.bloodType=@bloodType
			INNER JOIN Locations
			ON Locations.city = @userCity
			AND Inventory.locationID = Locations.locationID

			-- blood bag found
			IF @bloodBagID IS NOT NULL	
				BEGIN
				-- run the transfusion
				DECLARE @left int = @oldAmount-@bloodAmount
				EXEC udpSingleTransfusion @bloodAmount,@left,@bloodBagID,@personID,@locationID
				RETURN
				END
			ELSE
				BEGIN
				-- not found, try smaller bags
				DECLARE @iterator CURSOR
				DECLARE @currentBagAmount int

				SET @iterator = CURSOR FOR 
				SELECT BloodBag.bloodBagID, BloodBag.amountML
				FROM BloodBag
				INNER JOIN Inventory
				ON Inventory.bloodBagID = BloodBag.bloodBagID
				AND Inventory.available=1
				AND BloodBag.amountML>0
				AND BloodBag.bloodType=@bloodType
				INNER JOIN Locations
				ON Locations.city = @userCity
				AND Inventory.locationID = Locations.locationID

				OPEN @iterator FETCH NEXT 
					FROM @iterator INTO @bloodBagID, @currentBagAmount
					WHILE @@FETCH_STATUS = 0
					BEGIN
						DECLARE @transfused int
						SELECT @locationID=locationID FROM Inventory WHERE bloodBagID=@bloodBagID

						IF @currentBagAmount > @bloodAmount
						BEGIN
							SET @transfused = @bloodAmount
							SET @left = @currentBagAmount-@bloodAmount
							SET @bloodAmount = 0
						END
						ELSE
							SET @transfused = @currentBagAmount
							SET @left=0
							SET @bloodAmount = @bloodAmount-@currentBagAmount
						EXEC udpSingleTransfusion @transfused,@left,@bloodBagID,@personID,@locationID

						FETCH NEXT FROM @iterator INTO @bloodBagID, @currentBagAmount
					END
				END
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePersonWeight]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UpdatePersonWeight] (
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
/****** Object:  StoredProcedure [dbo].[ViewDonorHistory]    Script Date: 2022/02/24 23:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ViewDonorHistory] @DonorID int
as
select *
from Donor as p 
inner join Donation as d 
on p.personID = d.personID
inner join MedicalAid as m 
on p.schemeCode = m.schemeCode
where p.personID = @DonorID;
--count num donations - get rewards * count = points.
GO
USE [master]
GO
ALTER DATABASE [DonoraDB] SET  READ_WRITE 
GO


CREATE PROCEDURE [dbo].[udpInitiateTransfusion]
(
	@patientIDNumber varchar(13),
	@bloodRequired int,
	@selectedLocation varchar(128)
)
	AS 
	BEGIN
		-- Checking if the ID number is a person in the DB
		 DECLARE @personID int
		 SELECT @personID = personID FROM Persons where idNum=@patientIDNumber
		 IF @personID IS NULL
			RETURN -1

		-- Get the person's blood type
		DECLARE @bloodType varchar(3)
		SELECT @bloodType = bloodType FROM Persons WHERE personID=@personID

		-- Checking if the location exists, take the first one
		DECLARE @locationID int
		SELECT @locationID = locationID FROM Locations where city=@selectedLocation
		IF @locationID IS NULL
			RETURN -1

		 --Checking that this person is a patient, if not, create one
		 DECLARE @patientID int
		 SELECT @patientID=personID FROM Patient WHERE personID=@personID
		 IF @patientID IS NULL
			EXEC dbo.udpNewPatient @patientID,'HIGH',@newID=@patientID OUTPUT

		-- Use up a bag
		EXEC dbo.udpUseUpBag @personID=@personId, @bloodAmount=@bloodRequired, @userCity=@selectedLocation, @bloodType=@bloodType

		-- Return the last transfusion ID
		DECLARE @transfusion int
		SELECT @transfusion=MAX(transfusionID) FROM Transfusion
		RETURN @transfusion			
	END
GO