USE [master]
GO
/****** Object:  Database [otp_parking]    Script Date: 14-04-2021 19:51:31 ******/
CREATE DATABASE [otp_parking]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'otp_parking', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\otp_parking.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'otp_parking_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\otp_parking_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [otp_parking] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [otp_parking].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [otp_parking] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [otp_parking] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [otp_parking] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [otp_parking] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [otp_parking] SET ARITHABORT OFF 
GO
ALTER DATABASE [otp_parking] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [otp_parking] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [otp_parking] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [otp_parking] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [otp_parking] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [otp_parking] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [otp_parking] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [otp_parking] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [otp_parking] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [otp_parking] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [otp_parking] SET  DISABLE_BROKER 
GO
ALTER DATABASE [otp_parking] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [otp_parking] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [otp_parking] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [otp_parking] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [otp_parking] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [otp_parking] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [otp_parking] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [otp_parking] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [otp_parking] SET  MULTI_USER 
GO
ALTER DATABASE [otp_parking] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [otp_parking] SET DB_CHAINING OFF 
GO
ALTER DATABASE [otp_parking] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [otp_parking] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [otp_parking]
GO
/****** Object:  StoredProcedure [dbo].[Ad_login]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Ad_login]
@username varchar(50),
@password varchar(50)


AS
BEGIN

	SET NOCOUNT ON;
select * from Admin_master where username=@username and password=@password

END


GO
/****** Object:  StoredProcedure [dbo].[allocateSlot]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		sy
-- =============================================
CREATE PROCEDURE [dbo].[allocateSlot] 
	-- Add the parameters for the stored procedure here
@bookingid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
update Booking_master set Status='2',dt2=getdate() where Booking_id=@bookingid

END


GO
/****** Object:  StoredProcedure [dbo].[Book_slot]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Book_slot]
	@slot_id int,
	@cust_id int
AS
BEGIN

	SET NOCOUNT ON;
declare @area_id int,@booking_id int,@otp int;
set @area_id=(select top(1)Area_id from dbo.ParkingSlot_master where Slot_id=@slot_id )

Insert into dbo.Booking_master(Area_id, Slot_id,Cust_id, Status, dt) values (@area_id,@slot_id,@cust_id,1,getdate())

set @booking_id = (select Booking_id from dbo.Booking_master where Cust_id=@cust_id and Slot_id=@slot_id and Status=1)


set @otp = (select substring(convert(varchar(114),(rand() * 9 + 1) * 1000,128),1,4))

insert into otp_master values (@cust_id,@booking_id,@otp)

select o_otp from otp_master where booking_id = @booking_id

update ParkingSlot_master set Flag='1' where Area_id=@area_id and Slot_id=@slot_id

END


GO
/****** Object:  StoredProcedure [dbo].[Insert_area]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Insert_area]
	
@area_name varchar(50),
@total_slots int,
@mail varchar(50),
@pass varchar(50),
@lat varchar(50),
@lon varchar(50)
	
AS
BEGIN
	
	SET NOCOUNT ON;
insert into dbo.Area_master( Area_name, total_slot,email_ID,Password,lat,lon) values(@area_name,@total_slots,@mail,@pass,@lat,@lon)

declare @id int;
set @id=(select top(1)Area_id from  dbo.Area_master as am where am.Area_name=@area_name)

declare @loop int
declare @flag int
set @loop=1
set @flag=0
while @loop<=@total_slots
begin
insert into dbo.ParkingSlot_master(Area_id, Slot_no,Flag) values(@id,@loop,@flag)
set @loop=@loop+1
end

END


GO
/****** Object:  StoredProcedure [dbo].[Select_parkslot]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Select_parkslot]
@slot_id int

AS
BEGIN

	SET NOCOUNT ON;


select * from dbo.Booking_master where Slot_id=@slot_id and dt=cast(getdate() as date) and Status=1 or Status=2 
END


GO
/****** Object:  StoredProcedure [dbo].[Slot_details]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		sy
-- =============================================
CREATE PROCEDURE [dbo].[Slot_details] 
	@slot_id int
AS
BEGIN

	SET NOCOUNT ON;
select a.Area_name,Slot_no from ParkingSlot_master as p left join Area_master as a on p.Area_id=a.Area_id
where Slot_id=@slot_id
END


GO
/****** Object:  StoredProcedure [dbo].[updateRating]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		sy
-- =============================================
CREATE PROCEDURE [dbo].[updateRating]

	@userid int,
	@areaid int,
	@rate numeric(5,2)
AS
BEGIN

	SET NOCOUNT ON;

   if exists(select * from Rate_Master where userid=@userid and areaid=(select Area_id from Booking_master where Booking_id=@areaid))
	begin
		select * from rate_master where userid=@userid and areaid=(select Area_id from Booking_master where Booking_id=@areaid)
	end
	else
	begin
		insert into Rate_Master(rating, userid, areaid, dtme) values(@rate,@userid,(select Area_id from Booking_master where Booking_id=@areaid),getdate())
	end
   
END


GO
/****** Object:  StoredProcedure [dbo].[View_slots]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[View_slots]
	@area_name varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @id int;
		set @id=(select top(1)Area_id from  dbo.Area_master as am where am.Area_name=@area_name)
	select Slot_id,Slot_no,slot_url from ParkingSlot_master where Area_id=@id and Flag='0'
	
END


GO
/****** Object:  Table [dbo].[Admin_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Admin_master](
	[Ad_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Admin_master] PRIMARY KEY CLUSTERED 
(
	[Ad_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Area_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Area_master](
	[Area_id] [int] IDENTITY(200,1) NOT NULL,
	[Area_name] [varchar](50) NOT NULL,
	[total_slot] [int] NULL,
	[email_ID] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[lat] [varchar](50) NULL,
	[lon] [varchar](50) NULL,
 CONSTRAINT [PK_Area_master] PRIMARY KEY CLUSTERED 
(
	[Area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Booking_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Booking_master](
	[Booking_id] [int] IDENTITY(300,1) NOT NULL,
	[Area_id] [int] NOT NULL,
	[Slot_id] [int] NOT NULL,
	[Status] [varchar](50) NULL,
	[dt] [datetime] NOT NULL,
	[Cust_id] [int] NOT NULL,
	[dt2] [datetime] NULL,
	[cost] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer_master](
	[C_id] [int] IDENTITY(1,1) NOT NULL,
	[C_fname] [varchar](50) NOT NULL,
	[C_lname] [varchar](50) NOT NULL,
	[C_Address] [varchar](50) NULL,
	[C_ph] [varchar](50) NOT NULL,
	[C_email] [varchar](50) NOT NULL,
	[C_password] [varchar](50) NOT NULL,
	[C_balance] [float] NULL,
	[OTP] [varchar](50) NULL,
	[acc_status] [int] NULL,
 CONSTRAINT [PK_Customer_master] PRIMARY KEY CLUSTERED 
(
	[C_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[feedback_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[feedback_master](
	[feed_id] [int] IDENTITY(1,1) NOT NULL,
	[feedback] [varchar](max) NULL,
	[userId] [int] NULL,
	[date1] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[otp_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[otp_master](
	[o_id] [int] IDENTITY(1,1) NOT NULL,
	[cust_id] [int] NULL,
	[booking_id] [int] NULL,
	[o_otp] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ParkingSlot_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ParkingSlot_master](
	[Slot_id] [int] IDENTITY(500,1) NOT NULL,
	[Area_id] [int] NOT NULL,
	[Slot_no] [varchar](50) NOT NULL,
	[slot_url] [varchar](max) NULL,
	[Flag] [varchar](10) NULL,
 CONSTRAINT [PK_ParkingSlot_master] PRIMARY KEY CLUSTERED 
(
	[Slot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rate_Master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Master](
	[rate_id] [int] IDENTITY(1,1) NOT NULL,
	[rating] [numeric](5, 2) NULL,
	[userid] [int] NULL,
	[areaid] [int] NULL,
	[dtme] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Status_master]    Script Date: 14-04-2021 19:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Status_master](
	[Status_id] [int] IDENTITY(1,1) NOT NULL,
	[Status_name] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Admin_master] ON 

INSERT [dbo].[Admin_master] ([Ad_id], [username], [password]) VALUES (1, N'admin', N'admin')
SET IDENTITY_INSERT [dbo].[Admin_master] OFF
SET IDENTITY_INSERT [dbo].[Area_master] ON 

INSERT [dbo].[Area_master] ([Area_id], [Area_name], [total_slot], [email_ID], [Password], [lat], [lon]) VALUES (200, N'Borivali Station', 5, N'borivalistation@gmail.com', N'123456', N'19.2291', N'72.8574')
INSERT [dbo].[Area_master] ([Area_id], [Area_name], [total_slot], [email_ID], [Password], [lat], [lon]) VALUES (201, N'Infiniti Mall ', 5, N'infinitimall@gmail.com', N'123456', N'19.1849', N'72.8344')
SET IDENTITY_INSERT [dbo].[Area_master] OFF
SET IDENTITY_INSERT [dbo].[Booking_master] ON 

INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (300, 203, 560, N'3', CAST(0x0000AA3C00847DB4 AS DateTime), 2, NULL, NULL)
INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (301, 202, 535, N'3', CAST(0x0000AA3C00B52915 AS DateTime), 1, CAST(0x0000AA3C00B5506F AS DateTime), N'20')
INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (302, 202, 535, N'3', CAST(0x0000AA3C00B5AFC6 AS DateTime), 1, CAST(0x0000AA3C00B5EEC3 AS DateTime), N'20')
INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (303, 203, 561, N'3', CAST(0x0000AA3C00E57B3F AS DateTime), 1, CAST(0x0000AA3C00E5B87A AS DateTime), N'20')
INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (305, 205, 605, N'3', CAST(0x0000AA9300D09A23 AS DateTime), 4, NULL, NULL)
INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (306, 200, 502, N'3', CAST(0x0000ACF300DAD8E4 AS DateTime), 1, CAST(0x0000ACF300FAEAD6 AS DateTime), NULL)
INSERT [dbo].[Booking_master] ([Booking_id], [Area_id], [Slot_id], [Status], [dt], [Cust_id], [dt2], [cost]) VALUES (313, 200, 503, N'1', CAST(0x0000ACF301076594 AS DateTime), 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Booking_master] OFF
SET IDENTITY_INSERT [dbo].[Customer_master] ON 

INSERT [dbo].[Customer_master] ([C_id], [C_fname], [C_lname], [C_Address], [C_ph], [C_email], [C_password], [C_balance], [OTP], [acc_status]) VALUES (1, N'charan', N'singh', N'malad', N'9854003347', N'charan@gmail.com', N'123456', 0, N'1021', 1)
SET IDENTITY_INSERT [dbo].[Customer_master] OFF
SET IDENTITY_INSERT [dbo].[feedback_master] ON 

INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (2, N'qwettu', 1, CAST(0x0000AA0F00F5EA1A AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (3, N'Easy to use', 9, CAST(0x0000AA1400FD018B AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (4, N'nice', 13, CAST(0x0000AA1B00CF17E9 AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (5, N'best parking area near infinity mall', 16, CAST(0x0000AA200156A3F1 AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (6, N'nice', 13, CAST(0x0000AA2C00BD7C1A AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (7, N'good', 23, CAST(0x0000AA3400CFA750 AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (1009, N'good', 1, CAST(0x0000AA3C00DCFA01 AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (8, N'Excellent', 23, CAST(0x0000AA3400D03144 AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (9, N'??', 23, CAST(0x0000AA3600BA848B AS DateTime))
INSERT [dbo].[feedback_master] ([feed_id], [feedback], [userId], [date1]) VALUES (10, N'hiii abcd', 32, CAST(0x0000AA3700100623 AS DateTime))
SET IDENTITY_INSERT [dbo].[feedback_master] OFF
SET IDENTITY_INSERT [dbo].[otp_master] ON 

INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (1, 1, 306, 5826)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (2, 1, 307, 7838)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (3, 1, 308, 3288)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (4, 1, 309, 9136)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (5, 1, 310, 2007)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (6, 1, 311, 9683)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (7, 1, 312, 6546)
INSERT [dbo].[otp_master] ([o_id], [cust_id], [booking_id], [o_otp]) VALUES (8, 1, 313, 3678)
SET IDENTITY_INSERT [dbo].[otp_master] OFF
SET IDENTITY_INSERT [dbo].[ParkingSlot_master] ON 

INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (500, 200, N'1', NULL, N'1')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (501, 200, N'2', NULL, N'1')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (502, 200, N'3', NULL, N'1')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (503, 200, N'4', NULL, N'1')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (504, 200, N'5', NULL, N'1')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (505, 200, N'6', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (506, 200, N'7', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (507, 201, N'1', NULL, N'1')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (508, 201, N'2', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (509, 201, N'3', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (510, 201, N'4', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (511, 201, N'5', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (512, 201, N'6', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (513, 201, N'7', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (514, 200, N'8', NULL, N'0')
INSERT [dbo].[ParkingSlot_master] ([Slot_id], [Area_id], [Slot_no], [slot_url], [Flag]) VALUES (515, 200, N'9', NULL, N'0')
SET IDENTITY_INSERT [dbo].[ParkingSlot_master] OFF
SET IDENTITY_INSERT [dbo].[Status_master] ON 

INSERT [dbo].[Status_master] ([Status_id], [Status_name]) VALUES (1, N'Booked')
INSERT [dbo].[Status_master] ([Status_id], [Status_name]) VALUES (2, N'Alloted')
INSERT [dbo].[Status_master] ([Status_id], [Status_name]) VALUES (3, N'Empty')
SET IDENTITY_INSERT [dbo].[Status_master] OFF
USE [master]
GO
ALTER DATABASE [otp_parking] SET  READ_WRITE 
GO
