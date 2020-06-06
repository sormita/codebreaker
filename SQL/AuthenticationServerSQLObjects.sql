/****** Object:  Table [dbo].[HungerLocation]    Script Date: 06-06-2020 16:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HungerLocation](
	[County] [nvarchar](50) NOT NULL,
	[Neighbourhood] [nvarchar](50) NOT NULL,
	[Postcode] [nvarchar](50) NULL,
	[Road] [nvarchar](50) NOT NULL,
	[HungerCallID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_HungerLocation] PRIMARY KEY CLUSTERED 
(
	[HungerCallID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogin]    Script Date: 06-06-2020 16:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogin](
	[UserID] [numeric](18, 0) NOT NULL,
	[UserName] [nchar](50) NOT NULL,
	[Password] [nchar](50) NOT NULL,
 CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRegistration]    Script Date: 06-06-2020 16:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRegistration](
	[Username] [nchar](50) NOT NULL,
	[Password] [nchar](50) NOT NULL,
	[EntityType] [nchar](50) NULL,
	[foodEntityType] [nchar](50) NULL,
	[wardnumber] [numeric](18, 0) NULL,
	[address] [nvarchar](max) NULL,
	[pincode] [nchar](10) NOT NULL,
	[UserId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_UserRegistration] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_AddHungerLocation]    Script Date: 06-06-2020 16:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_AddHungerLocation]
(
    @County nvarchar(50)
           ,@Neighbourhood nvarchar(50)
           ,@Postcode nvarchar(50)
           ,@Road nvarchar(50)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

INSERT INTO [dbo].[HungerLocation]
           ([County]
           ,[Neighbourhood]
           ,[Postcode]
           ,[Road])
     VALUES
           (@County
           ,@Neighbourhood
           ,@Postcode
           ,@Road)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AddUserRegistration]    Script Date: 06-06-2020 16:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      sormita
-- Description: Will be used for user login
-- =============================================
CREATE PROCEDURE [dbo].[usp_AddUserRegistration]
(
    @Username nchar(50),
	@Password nchar(50),
	@EntityType nchar(50),
    @foodEntityType nchar(50),
    @wardnumber int,
     @address nvarchar(200),
     @pincode nchar(10)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    INSERT INTO [dbo].[UserRegistration]
           ([Username]
           ,[Password]
           ,[EntityType]
           ,[foodEntityType]
           ,[wardnumber]
           ,[address]
           ,[pincode]
           )
     VALUES
           (@Username
           ,@Password
           ,@EntityType
           ,@foodEntityType
           ,@wardnumber
           ,@address
           ,@pincode
           )
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UserLoginProcedure]    Script Date: 06-06-2020 16:38:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      sormita
-- Description: Will be used for user login
-- =============================================
CREATE PROCEDURE [dbo].[usp_UserLoginProcedure]
(
    @Username nchar(50),
	@Password nchar(50)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    select UserID,Username from [dbo].[UserLogin] where username=@Username and password=@Password;
END
GO
