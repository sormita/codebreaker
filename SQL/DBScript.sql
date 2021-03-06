USE [CB_FoodCrisisManagement]
GO
/****** Object:  StoredProcedure [dbo].[ForecastAnalysis1]    Script Date: 06-06-2020 16:55:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from Forecastdata1
-- exec  ForecastAnalysis1
CREATE procedure [dbo].[ForecastAnalysis1]
as
truncate table Forecastdata1
--select row_number() over (order by ctype),* from Forecastdata 
--select row_number() over (order by ctype) id ,* into Forecastdata2 from Forecastdata
declare @id int
declare @ctype varchar(20)
declare @cnt int
declare @cnt1 int = 0
declare @week varchar(20) 
declare @date varchar(20)
declare @population int

DECLARE  CURSOR1 cursor
    FOR select * from Forecastdata2;
	OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @id,@ctype,@cnt,@week,@date,@population;
	WHILE @@FETCH_STATUS = 0  
    BEGIN
	select @cnt = cnt from Forecastdata1 where id = @id - 1
	set @cnt1 = @cnt+@population 

	
	insert into Forecastdata1 values(@id,@ctype,@cnt1,@week,@date,@population)
	
	--set @cnt1 = @cnt
	--set @cnt1 = @cnt1 + @population
	
	
	
	--insert into Forecastdata1 values(@id,@ctype,@cnt1,@week,@date,@population)
        FETCH NEXT FROM CURSOR1 into @id,@ctype,@cnt,@week,@date,@population;  

    END;
	set @cnt = @cnt1
	CLOSE CURSOR1;
	DEALLOCATE CURSOR1;

	



 

GO
/****** Object:  Table [dbo].[CB_Date]    Script Date: 06-06-2020 16:55:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CB_Date](
	[Date_ID] [int] IDENTITY(1,1) NOT NULL,
	[Week] [nchar](15) NOT NULL,
	[Date] [datetime] NOT NULL
)

GO
/****** Object:  Table [dbo].[CB_Fact_Food_Demands]    Script Date: 06-06-2020 16:55:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CB_Fact_Food_Demands](
	[Usage_ID] [int] NOT NULL,
	[Govt_CID] [int] NOT NULL,
	[Vendor_ID] [int] NOT NULL,
	[No_Of_Meal_Demands_W1] [int] NOT NULL,
	[No_Of_Meal_Demands_W2] [int] NOT NULL,
	[No_Of_Meal_Demands_W3] [int] NOT NULL
)

GO
/****** Object:  Table [dbo].[CB_Fact_Food_Usage]    Script Date: 06-06-2020 16:55:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CB_Fact_Food_Usage](
	[Usage_ID] [int] NOT NULL,
	[Govt_CID] [int] NOT NULL,
	[Date_ID] [int] NOT NULL,
	[No_Of_Meals_Usage] [int] NOT NULL,
	[No_Of_Meals_Wastage] [int] NOT NULL,
	[No_Of_Meals_Shortage] [int] NOT NULL,
	[CenterType] [nchar](100) NOT NULL
)

GO
/****** Object:  Table [dbo].[CB_Fact_Food_Usage_Raw]    Script Date: 06-06-2020 16:55:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_Fact_Food_Usage_Raw](
	[CenterName] [varchar](250) NULL,
	[Date] [datetime] NULL,
	[No_Of_Meals_Supply] [int] NULL,
	[No_Of_Meals_Wastage] [int] NULL,
	[No_Of_Meals_Shortage] [int] NULL,
	[CenterType] [nchar](100) NULL,
	[WeekNo] [nchar](12) NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CB_Govt_Centers]    Script Date: 06-06-2020 16:55:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CB_Govt_Centers](
	[Govt_CID] [int] NOT NULL,
	[Center_ID] [int] NOT NULL,
	[District_ID] [int] NOT NULL,
	[CenterType] [nchar](15) NULL
)

GO
/****** Object:  Table [dbo].[CB_Govt_Hospital]    Script Date: 06-06-2020 16:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_Govt_Hospital](
	[HID] [int] NOT NULL,
	[HospitalName] [varchar](250) NOT NULL,
	[District_ID] [int] NOT NULL,
	[Address] [varchar](500) NOT NULL,
	[PinCode] [int] NOT NULL,
	[ContactNo] [int] NULL,
	[TotalBeds] [int] NULL,
	[TotalPateint_Curr] [int] NULL,
	[Pateint_W1] [int] NULL,
	[Pateint_W2] [int] NULL,
	[Pateint_W3] [int] NULL,
	[Discharged_W1] [int] NULL,
	[Discharged_W2] [int] NULL,
	[Discharged_W3] [int] NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CB_Govt_Hospital_Raw]    Script Date: 06-06-2020 16:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_Govt_Hospital_Raw](
	[SlNo] [int] NULL,
	[District] [varchar](250) NULL,
	[HospitalName] [varchar](250) NULL,
	[Address] [varchar](500) NULL,
	[PinCode] [varchar](50) NULL,
	[ContactNo] [varchar](50) NULL,
	[TotalBeds] [varchar](50) NULL,
	[TotalPateint_Curr] [varchar](50) NULL,
	[Pateint_W1] [varchar](50) NULL,
	[Pateint_W2] [varchar](50) NULL,
	[Pateint_W3] [varchar](50) NULL,
	[Discharged_W1] [varchar](50) NULL,
	[Discharged_W2] [varchar](50) NULL,
	[Discharged_W3] [varchar](50) NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CB_Govt_QuarantineCenters]    Script Date: 06-06-2020 16:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_Govt_QuarantineCenters](
	[QID] [int] NOT NULL,
	[District_ID] [int] NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[Pincode] [int] NULL,
	[Address] [varchar](500) NOT NULL,
	[Block] [varchar](250) NOT NULL,
	[Panchayat] [varchar](250) NOT NULL,
	[Village] [varchar](250) NOT NULL,
	[Town/Zone] [varchar](250) NOT NULL,
	[ClinicType] [varchar](250) NOT NULL,
	[TotalBeds] [int] NULL,
	[TotalQuarantine_Curr] [int] NULL,
	[Count_W1] [int] NULL,
	[Count_W2] [int] NULL,
	[Count_W3] [int] NULL,
	[Discharged_W1] [int] NULL,
	[Discharged_W2] [int] NULL,
	[Discharged_W3] [int] NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CB_Govt_QuarantineCenters_Raw]    Script Date: 06-06-2020 16:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_Govt_QuarantineCenters_Raw](
	[Sl No] [int] NULL,
	[Districts] [varchar](250) NULL,
	[Name] [varchar](250) NULL,
	[Pincode] [varchar](250) NULL,
	[Address] [varchar](500) NULL,
	[Block] [varchar](250) NULL,
	[Panchayat] [varchar](250) NULL,
	[Village] [varchar](250) NULL,
	[Town / Zone] [varchar](250) NULL,
	[Clinic Type] [varchar](250) NULL,
	[TotalBeds] [int] NULL,
	[TotalQuarantine_Curr] [varchar](250) NULL,
	[Count_W1] [varchar](250) NULL,
	[Count_W2] [varchar](250) NULL,
	[Count_W3] [varchar](250) NULL,
	[Discharged_W1] [varchar](250) NULL,
	[Discharged_W2] [varchar](250) NULL,
	[Discharged_W3] [varchar](250) NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CB_Govt_Vendor]    Script Date: 06-06-2020 16:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CB_Govt_Vendor](
	[V_ID] [int] NOT NULL,
	[District_ID] [int] NOT NULL,
	[Supply_Center_ID] [int] NOT NULL,
	[Date_ID] [int] NOT NULL,
	[No_Of_Meals] [int] NOT NULL,
	[Supply_Status] [nchar](4) NOT NULL
)

GO
/****** Object:  Table [dbo].[CB_SlumArea/Village]    Script Date: 06-06-2020 16:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_SlumArea/Village](
	[Sl_ID] [int] NOT NULL,
	[District_ID] [int] NOT NULL,
	[VillageName] [varchar](250) NOT NULL,
	[Population_Curr] [int] NULL,
	[Pincode] [int] NULL,
	[Address] [varchar](250) NOT NULL,
	[Block] [varchar](250) NOT NULL,
	[Panchayat] [varchar](250) NOT NULL,
	[Zone] [int] NULL,
	[Migrant_W1] [int] NULL,
	[Migrant_W2] [int] NULL,
	[Migrant_W3] [int] NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CB_SlumArea/Village_Raw]    Script Date: 06-06-2020 16:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CB_SlumArea/Village_Raw](
	[SlNo] [int] NOT NULL,
	[District] [varchar](250) NULL,
	[VillageName] [varchar](250) NULL,
	[Population_Curr] [varchar](250) NULL,
	[Pincode] [varchar](250) NULL,
	[Address] [varchar](250) NULL,
	[Block] [varchar](250) NULL,
	[Panchayat] [varchar](250) NULL,
	[Zone] [varchar](250) NULL,
	[Migrant_W1] [varchar](250) NULL,
	[Migrant_W2] [varchar](250) NULL,
	[Migrant_W3] [varchar](250) NULL
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[WastageVsDemand]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[WastageVsDemand]
as

  with  WastageVsDemand_CTE
  as
  (
select CType, [date],[No_Of_Meals_Supply] supply
,case when ([No_Of_Meals_Supply] > [TotalPateint_Curr] )
then ([No_Of_Meals_Supply] - [TotalPateint_Curr] )
when ( [No_Of_Meals_Supply] < [TotalPateint_Curr] )
then 0 end Westage

,case when ([No_Of_Meals_Supply] < [TotalPateint_Curr]) 
then (  [TotalPateint_Curr] -[No_Of_Meals_Supply])
when ([No_Of_Meals_Supply] > [TotalPateint_Curr] )
then 0 end Demand
 from (select distinct SlNo,District,[TotalPateint_Curr],'Hospital' CType from [CB_Govt_Hospital_Raw]
union 
select distinct [Sl No] SlNo,Districts District,[TotalQuarantine_Curr][TotalPateint_Curr],'QCenter' CType from [dbo].[CB_Govt_QuarantineCenters_Raw]
union
select distinct SlNo,District,[Population_Curr] [TotalPateint_Curr],'Village' CType from [dbo].[CB_SlumArea/Village_Raw]
) GCR
join [dbo].[CB_Fact_Food_Usage_Raw] FR on GCR.SlNo = FR.CenterName and GCR.CType = FR.CenterType
)

SELECT CType,[Date]
      ,sum([supply]) Supply
      ,sum([Westage]) Wastage
      ,sum([Demand]) Shortage
  FROM WastageVsDemand_CTE group by [date],CType

--group by District,[Date]GO




GO
/****** Object:  View [dbo].[WastageVsDemand_Hospital]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[WastageVsDemand_Hospital]
as
SELECT *
  FROM [dbo].[WastageVsDemand]  where CType = 'Hospital'

GO
/****** Object:  View [dbo].[WastageVsDemand_Village]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[WastageVsDemand_Village]
as
SELECT *
  FROM [dbo].[WastageVsDemand]  where CType = 'Village'

GO
/****** Object:  View [dbo].[WastageVsDemand_QCenter]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[WastageVsDemand_QCenter]
as
SELECT *
  FROM [dbo].[WastageVsDemand]  where CType = 'QCenter'

GO
/****** Object:  View [dbo].[ForecastAnalysis]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[ForecastAnalysis]
as
select District,CType,sum([No_Of_Meals_Supply]) NoOfMeals

,sum([CountW1])*2 W1Demand,sum([CountW2])*7 W2Demand,sum([CountW3] ) *7 W3Demand
from (
select distinct SlNo,District,'Hospital' CType
 ,(convert(int,[TotalPateint_Curr]) + convert(int,[Pateint_W1]) - convert(int,[Discharged_W1])) [CountW1]
 ,(convert(int,[TotalPateint_Curr]) + convert(int,[Pateint_W2]) - convert(int,[Discharged_W2])) [CountW2]
,(convert(int,[TotalPateint_Curr]) + convert(int,[Pateint_W3]) - convert(int,[Discharged_W3])) [CountW3]
from [CB_Govt_Hospital_Raw]
union 
select distinct [Sl No] SlNo,Districts District,'QCenter' CType 
 ,(convert(int,[TotalQuarantine_Curr]) + convert(int,[Count_W1]) - convert(int,[Discharged_W1])) [CountW1]
 ,(convert(int,[TotalQuarantine_Curr]) + convert(int,[Count_W2]) - convert(int,[Discharged_W2])) [CountW2]
,(convert(int,[TotalQuarantine_Curr]) + convert(int,[Count_W3]) - convert(int,[Discharged_W3])) [CountW3]

from [dbo].[CB_Govt_QuarantineCenters_Raw]
union
select distinct SlNo,District,'Village' CType 
 ,(convert(int,[Population_Curr]) + convert(int,[Migrant_W1])) [CountW1]
 ,(convert(int,[Population_Curr]) + convert(int,[Migrant_W2])) [CountW2]
,(convert(int,[Population_Curr]) + convert(int,[Migrant_W3])) [CountW3]

from [dbo].[CB_SlumArea/Village_Raw]
) GCR
join [dbo].[CB_Fact_Food_Usage_Raw] FR on GCR.SlNo = FR.CenterName and GCR.CType = FR.CenterType
group by District,CType 

GO
/****** Object:  View [dbo].[Demand_W1]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view  [dbo].[Demand_W1]
as
SELECT sum(W1Demand) demands,sum(NoOfMeals) lastweek,30000000 HighDemand, 35000000 MaxRequired  ,sum(convert(decimal(10,2),NoOfMeals))/(sum(convert(decimal(10,2),W1Demand))) Fulllfillment
from ForecastAnalysis

GO
/****** Object:  View [dbo].[SupplyPerWeek]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[SupplyPerWeek]
as
select District,[Date],CType,sum([No_Of_Meals_Supply]) NoOfMeals 
from (
select distinct SlNo,District,'Hospital' CType from [CB_Govt_Hospital_Raw]
union 
select distinct [Sl No] SlNo,Districts District,'QCenter' CType from [dbo].[CB_Govt_QuarantineCenters_Raw]
union
select distinct SlNo,District,'Village' CType from [dbo].[CB_SlumArea/Village_Raw]
) GCR
join [dbo].[CB_Fact_Food_Usage_Raw] FR on GCR.SlNo = FR.CenterName and GCR.CType = FR.CenterType
group by District,[Date],CType



GO
/****** Object:  View [dbo].[wastage_Districtwise]    Script Date: 06-06-2020 16:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from wastage_Districtwise


CREATE view [dbo].[wastage_Districtwise]
as
with  WastageVsDemand_CTE
  as
  (
select District,[Date],GCR.CenterName CenterName, CType,[No_Of_Meals_Supply] supply
,case when ([No_Of_Meals_Supply] > [TotalPateint_Curr] )
then ([No_Of_Meals_Supply] - [TotalPateint_Curr] )
when ( [No_Of_Meals_Supply] < [TotalPateint_Curr] )
then 0 end Westage

,case when ([No_Of_Meals_Supply] < [TotalPateint_Curr]) 
then (  [TotalPateint_Curr] -[No_Of_Meals_Supply])
when ([No_Of_Meals_Supply] > [TotalPateint_Curr] )
then 0 end shortage
 from (select distinct SlNo,District,[TotalPateint_Curr],'Hospital' CType , HospitalName CenterName from [CB_Govt_Hospital_Raw]
union 
select distinct [Sl No] SlNo,Districts District,[TotalQuarantine_Curr][TotalPateint_Curr],'QCenter' CType,Name CenterName from [dbo].[CB_Govt_QuarantineCenters_Raw]
union
select distinct SlNo,District,[Population_Curr] [TotalPateint_Curr],'Village' CType,Villagename CenterName from [dbo].[CB_SlumArea/Village_Raw]
) GCR
join [dbo].[CB_Fact_Food_Usage_Raw] FR on GCR.SlNo = FR.CenterName and GCR.CType = FR.CenterType
)

SELECT *
     
  FROM WastageVsDemand_CTE

--group by District,[Date]GO



GO
