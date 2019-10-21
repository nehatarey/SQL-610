USE [AdventureWorks2016CTP3]
GO

/****** Object:  Table [dbo].[Hours]    Script Date: 4/15/2019 11:18:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Hours](
	[Last Name] [nvarchar](255) NULL,
	[First Name] [nvarchar](255) NULL,
	[Job title] [nvarchar](255) NULL,
	[Week 1] [float] NULL,
	[Week 2] [float] NULL,
	[Week 3] [float] NULL,
	[Week 4] [float] NULL
) ON [PRIMARY]
GO

