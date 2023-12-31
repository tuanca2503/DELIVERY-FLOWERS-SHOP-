USE [master]
GO
/****** Object:  Database [Flowers]    Script Date: 5/22/2023 11:44:27 AM ******/

DECLARE @databaseName NVARCHAR(128) = 'Flowers';
DECLARE @dataFilePath NVARCHAR(260) = N'';

-- Get the full path of the current directory
SELECT @dataFilePath = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(260));

-- Create the MDF file in the current directory
EXEC('CREATE DATABASE ' + @databaseName + ' ON PRIMARY 
(NAME = ' + @databaseName + ', FILENAME = ''' + @dataFilePath + @databaseName + '.mdf'',
SIZE = 8192KB, MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB)
LOG ON 
(NAME = ' + @databaseName + '_log, FILENAME = ''' + @dataFilePath + @databaseName + '_log.ldf'',
SIZE = 8192KB, MAXSIZE = 2048GB, FILEGROWTH = 65536KB)
WITH CATALOG_COLLATION = DATABASE_DEFAULT');

GO
ALTER DATABASE [Flowers] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Flowers].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Flowers] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Flowers] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Flowers] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Flowers] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Flowers] SET ARITHABORT OFF 
GO
ALTER DATABASE [Flowers] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Flowers] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Flowers] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Flowers] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Flowers] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Flowers] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Flowers] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Flowers] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Flowers] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Flowers] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Flowers] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Flowers] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Flowers] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Flowers] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Flowers] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Flowers] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Flowers] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Flowers] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Flowers] SET  MULTI_USER 
GO
ALTER DATABASE [Flowers] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Flowers] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Flowers] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Flowers] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Flowers] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Flowers] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Flowers] SET QUERY_STORE = OFF
GO
USE [Flowers]
GO
/****** Object:  Table [dbo].[Admin]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin](
	[AdminID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Role] [tinyint] NULL,
	[Email] [varchar](50) NOT NULL,
	[ResetPasswordCode] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AdminID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bouquets]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bouquets](
	[BouquetID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[ImagePath] [varchar](max) NOT NULL,
	[Brand] [varchar](50) NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[OccasionID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BouquetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[CartID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[IsCheckedOut] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartItems]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartItems](
	[CartItemID] [int] IDENTITY(1,1) NOT NULL,
	[BouquetID] [int] NOT NULL,
	[CartID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CartItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gallery]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gallery](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ImagePath] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Occasions]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Occasions](
	[OccasionID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ImagePath] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OccasionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderID] [int] NOT NULL,
	[BouquetID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK__OrderDet__7E7F74C058CDC912] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[BouquetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[PaymentID] [int] NOT NULL,
	[TotalPrice] [decimal](10, 2) NOT NULL,
	[PhonenNumber] [varchar](20) NOT NULL,
	[DeliveryDate] [date] NOT NULL,
	[DeliveryAddress] [varchar](100) NOT NULL,
	[Status] [varchar](50) NULL,
 CONSTRAINT [PK__Orders__C3905BAF11FA169A] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
	[CreditCardNumber] [varchar](50) NULL,
	[PaymentStatus] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 5/22/2023 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Fullname] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[ImagePath] [varchar](max) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Address] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Admin] ON 

INSERT [dbo].[Admin] ([AdminID], [Username], [Password], [Role], [Email], [ResetPasswordCode]) VALUES (1, N'namdepham', N'81dc9bdb52d04dc20036dbd8313ed055', 1, N'hoainampham2k@gmail.com', N'')
INSERT [dbo].[Admin] ([AdminID], [Username], [Password], [Role], [Email], [ResetPasswordCode]) VALUES (3, N'Trang Nga', N'202cb962ac59075b964b07152d234b70', 2, N'mietagg@gmail.com', N'null')
SET IDENTITY_INSERT [dbo].[Admin] OFF
GO
SET IDENTITY_INSERT [dbo].[Bouquets] ON 

INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (3, N'Romantic Elegance', N'A stunning arrangement of red roses and delicate white lilies, symbolizing love and purity. This bouquet is elegantly wrapped in a satin ribbon, making it the perfect gift for celebrating a special anniversary', N'~/Uploads/wedding-2.jpg', N'Blossom Delights', CAST(49.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (4, N'Enchanting Garden', N'An enchanting blend of fragrant lavender, baby''s breath, and lush green foliage, creating a dreamy garden-inspired arrangement. This bouquet adds a touch of romance and elegance to any wedding celebration.', N'~/Uploads/wedding-1.jpg', N'Evergreen Blooms', CAST(79.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (5, N'Vintage Romance', N' A romantic blend of pastel-colored roses, peonies, and delicate baby''s breath, reminiscent of vintage charm and timeless beauty. This bouquet adds a touch of nostalgia to a bride''s special day', N'~/Uploads/wedding-3.jpg', N' Enchanting Blooms', CAST(149.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (8, N'Garden Whispers', N'A whimsical mix of wildflowers, lavender, and greenery, creating a garden-inspired bouquet that exudes natural beauty and rustic charm. This bouquet is perfect for a boho or outdoor wedding.', N'~/Uploads/wedding-4.jpg', N'Meadow Mist Florals', CAST(129.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (9, N'Modern Glamour', N'A glamorous combination of exotic blooms like proteas, anthuriums, and tropical foliage, creating a striking and contemporary bouquet. This bouquet is perfect for a modern and chic wedding.', N'~/Uploads/wedding-5.jpg', N' Glamorous Blooms', CAST(169.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (10, N'Peaceful Remembrance', N'A serene arrangement of white lilies, roses, and carnations, symbolizing purity and remembrance. This bouquet offers comfort and solace during a time of loss. Brand: Tranquil Tributes', N'~/Uploads/funeral-1.jpg', N'Eternal Serenity', CAST(79.99 AS Decimal(10, 2)), 4)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (11, N'Garden of Memories', N' A heartfelt mix of soft-colored roses, daisies, and chrysanthemums, reminiscent of a peaceful garden sanctuary. This bouquet is a beautiful tribute to celebrate a life well-lived', N'~/Uploads/funeral-2.jpg', N'Loving Memories', CAST(89.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (12, N'Comforting Embrace', N' A comforting arrangement of lavender roses, hydrangeas, and delicate baby''s breath, expressing sympathy and support. This bouquet offers solace during a time of grief.', N'~/Uploads/funeral-3.jpg', N' Serene Blooms', CAST(69.99 AS Decimal(10, 2)), 2)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (13, N'Birthday Bliss', N'A vibrant mix of colorful gerbera daisies, carnations, and bright sunflowers, radiating joy and happiness. This bouquet is a perfect way to celebrate someone''s special day.', N'~/Uploads/birthday-1.jpg', N'Blooming Wishes', CAST(39.99 AS Decimal(10, 2)), 3)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (14, N'Cheerful Surprise', N' A delightful mix of bright daisies, sunflowers, and vibrant wildflowers, spreading cheer and positivity. This bouquet is a wonderful surprise for someone on their birthday.', N'~/Uploads/birthday-2.jpg', N'Sunshine Blooms', CAST(44.99 AS Decimal(10, 2)), 3)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (15, N'Birthday Bonanza', N'A lavish arrangement of mixed roses, orchids, and exotic foliage, creating a luxurious and unforgettable gift. This bouquet is perfect for making a grand statement on someone''s birthday.', N'~/Uploads/birthday-3.jpg', N' Luxe Floral Designs', CAST(69.99 AS Decimal(10, 2)), 3)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (16, N'Burst of Joy', N'An exuberant combination of vibrant tulips, lilies, and irises, symbolizing energy and enthusiasm. This bouquet brings a burst of joy and excitement to birthday celebrations.', N'~/Uploads/birthday-4.jpg', N'Joy''s Bloom', CAST(59.99 AS Decimal(10, 2)), 3)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (17, N'Sweet Celebrations', N'A charming arrangement of pastel-colored roses, daisies, and delicate baby''s breath, capturing the sweetness of the occasion. This bouquet is a delightful gift for birthdays.', N'~/Uploads/birthday-5.jpg', N'Sweet Petals', CAST(49.99 AS Decimal(10, 2)), 3)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (18, N'Bundle of Joy"', N' A sweet arrangement of pastel-colored roses, daisies, and delicate baby''s breath, celebrating the arrival of a precious little one. This bouquet is a perfect gift to congratulate new parents.', N'~/Uploads/new-baby-1.jpg', N'Little Blossoms', CAST(49.99 AS Decimal(10, 2)), 5)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (19, N'Baby Bliss', N'A whimsical mix of soft pink and blue blooms, such as roses, carnations, and hydrangeas, embodying the joy and happiness of a new baby. This bouquet is a delightful way to welcome the little bundle of joy.', N'~/Uploads/new-baby-2.jpg', N'Cuddly Delights', CAST(59.99 AS Decimal(10, 2)), 5)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (20, N'Cuddly Delights', N'An adorable arrangement of teddy bears, balloons, and baby-friendly flowers, creating a cute and cuddly gift for the newborn. This bouquet brings smiles and warmth to the new parents.', N'~/Uploads/new-baby-3.jpg', N' Snuggle Up Florals', CAST(69.99 AS Decimal(10, 2)), 5)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (21, N'Sweet Arrival', N' A charming combination of fragrant flowers like lavender, chamomile, and baby''s breath, welcoming the new baby with a touch of sweetness and serenity. This bouquet is a gentle celebration of the precious arrival.', N'~/Uploads/new-baby-4.jpg', N'Sweet Beginnings', CAST(79.99 AS Decimal(10, 2)), 5)
INSERT [dbo].[Bouquets] ([BouquetID], [Name], [Description], [ImagePath], [Brand], [Price], [OccasionID]) VALUES (23, N'Little Dreamers', N'A dreamy arrangement of soft blue and pink roses, lisianthus, and delicate greenery, capturing the enchantment and wonder of a new baby. This bouquet is a beautiful gift to congratulate the growing family.', N'~/Uploads/new-baby-5.jpg', N'Dreamy Meadows', CAST(89.99 AS Decimal(10, 2)), 5)
SET IDENTITY_INSERT [dbo].[Bouquets] OFF
GO
SET IDENTITY_INSERT [dbo].[Cart] ON 

INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (4, 1, 2130.0000, 1, CAST(N'2023-05-03T00:12:10.780' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (6, 1, 252.0000, 1, CAST(N'2023-05-04T09:26:38.303' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (7, 1, 24.0000, 1, CAST(N'2023-05-04T09:32:55.110' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (8, 1, 12.0000, 1, CAST(N'2023-05-04T09:34:58.230' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (9, 1, 213.0000, 1, CAST(N'2023-05-04T09:44:42.240' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (10, 1, 357.0000, 1, CAST(N'2023-05-04T10:16:33.283' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (11, 1, 12.0000, 1, CAST(N'2023-05-04T10:31:28.610' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (12, 1, 84.0000, 1, CAST(N'2023-05-04T10:57:21.067' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (13, 1, 213.0000, 1, CAST(N'2023-05-04T11:05:19.877' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (14, 1, 12.0000, 1, CAST(N'2023-05-04T11:11:11.973' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (15, 1, 2556.0000, 1, CAST(N'2023-05-04T11:28:29.950' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (16, 1, 213.0000, 1, CAST(N'2023-05-04T11:39:52.230' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (17, 1, 12.0000, 1, CAST(N'2023-05-04T11:42:27.243' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1006, 1, 213.0000, 1, CAST(N'2023-05-04T13:15:39.293' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1007, 1, 426.0000, 1, CAST(N'2023-05-04T13:21:31.023' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1008, 1, 24.0000, 1, CAST(N'2023-05-04T13:30:47.407' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1009, 1, 120.0000, 1, CAST(N'2023-05-04T13:38:34.680' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1010, 1, 12.0000, 1, CAST(N'2023-05-04T13:40:53.110' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1011, 1, 24.0000, 1, CAST(N'2023-05-04T13:43:17.557' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1012, 1, 426.0000, 1, CAST(N'2023-05-04T13:47:34.133' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1013, 1, 132.0000, 1, CAST(N'2023-05-04T13:51:14.100' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1014, 1, 120.0000, 1, CAST(N'2023-05-04T15:39:21.423' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1015, 1, 225.0000, 1, CAST(N'2023-05-04T15:48:46.540' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1016, 1, 438.0000, 1, CAST(N'2023-05-04T16:03:17.643' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1017, 1, 21300.0000, 1, CAST(N'2023-05-04T16:07:07.710' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1018, 1, 213.0000, 1, CAST(N'2023-05-04T16:10:58.913' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1019, 1, 12.0000, 1, CAST(N'2023-05-04T16:12:36.417' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1020, 1, 2142.0000, 1, CAST(N'2023-05-04T18:29:25.087' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1021, 1, 426.0000, 1, CAST(N'2023-05-04T18:33:00.063' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1022, 1, 12.0000, 1, CAST(N'2023-05-04T21:25:54.830' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1023, 1, 438.0000, 1, CAST(N'2023-05-05T17:43:30.547' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1024, 1, 120.0000, 1, CAST(N'2023-05-06T12:59:19.497' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1025, 1, 438.0000, 1, CAST(N'2023-05-06T13:11:17.487' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1026, 1, 72.0000, 1, CAST(N'2023-05-06T13:24:38.117' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1027, 1, 450.0000, 1, CAST(N'2023-05-06T19:00:14.040' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1028, 1, 426.0000, 1, CAST(N'2023-05-06T19:13:01.493' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1029, 1, 1278.0000, 1, CAST(N'2023-05-07T01:59:43.967' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1030, 1, 213.0000, 1, CAST(N'2023-05-07T08:12:05.180' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1031, 1, 438.0000, 1, CAST(N'2023-05-07T08:26:06.590' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1032, 1, 26343.0000, 1, CAST(N'2023-05-07T13:24:20.167' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1033, 1, 5325.0000, 1, CAST(N'2023-05-07T13:31:46.877' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1034, 1, 213.0000, 1, CAST(N'2023-05-07T13:35:14.050' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1035, 1, 237.0000, 1, CAST(N'2023-05-07T15:14:25.290' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1036, 1, 12.0000, 1, CAST(N'2023-05-07T15:18:55.597' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1037, 1, 213.0000, 1, CAST(N'2023-05-07T15:29:43.127' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1038, 1, 213.0000, 1, CAST(N'2023-05-07T15:31:41.270' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1039, 1, 225.0000, 1, CAST(N'2023-05-07T15:40:00.797' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1040, 1, 225.0000, 1, CAST(N'2023-05-07T15:49:18.837' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1041, 1, 225.0000, 1, CAST(N'2023-05-07T15:53:26.060' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1042, 1, 24.0000, 1, CAST(N'2023-05-07T16:33:53.963' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1043, 1, 36.0000, 1, CAST(N'2023-05-07T16:34:27.210' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1044, 1, 225.0000, 1, CAST(N'2023-05-07T19:45:10.523' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1045, 1, 24.0000, 1, CAST(N'2023-05-07T20:05:31.797' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1046, 1, 1488.0000, 1, CAST(N'2023-05-08T13:38:47.783' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1047, 1, 2994.0000, 1, CAST(N'2023-05-08T14:20:59.270' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1048, 1, 213.0000, 1, CAST(N'2023-05-08T14:56:14.990' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1049, 2, 24.0000, 1, CAST(N'2023-05-08T15:00:47.527' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1050, 1, 462.0000, 1, CAST(N'2023-05-08T16:54:30.733' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1051, 1, 24.0000, 1, CAST(N'2023-05-09T09:27:14.993' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1052, 1, 237.0000, 1, CAST(N'2023-05-09T11:47:31.317' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1053, 1, 213.0000, 1, CAST(N'2023-05-09T11:48:57.630' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1054, 1, 213.0000, 1, CAST(N'2023-05-09T18:59:16.037' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1055, 1, 213.0000, 1, CAST(N'2023-05-09T19:11:47.103' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1056, 1, 213.0000, 1, CAST(N'2023-05-10T16:47:39.863' AS DateTime))
INSERT [dbo].[Cart] ([CartID], [UserID], [TotalPrice], [IsCheckedOut], [DateCreated]) VALUES (1057, 1, 159.9800, 1, CAST(N'2023-05-11T10:40:40.217' AS DateTime))
SET IDENTITY_INSERT [dbo].[Cart] OFF
GO
SET IDENTITY_INSERT [dbo].[CartItems] ON 

INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1, 4, 4, 10)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (3, 3, 6, 21)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (4, 3, 7, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (5, 5, 8, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (6, 4, 9, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (7, 3, 10, 12)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (8, 4, 10, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (9, 3, 11, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (10, 3, 12, 7)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (11, 4, 13, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (12, 3, 14, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (13, 4, 15, 12)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (14, 4, 16, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (15, 5, 17, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1003, 4, 1006, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1004, 4, 1007, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1008, 5, 1011, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1009, 4, 1012, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1010, 5, 1013, 10)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1011, 3, 1013, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1012, 3, 1014, 10)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1013, 4, 1015, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1014, 3, 1015, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1015, 4, 1016, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1016, 5, 1016, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1017, 4, 1017, 100)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1018, 4, 1018, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1019, 5, 1019, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1021, 3, 1020, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1022, 4, 1020, 10)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1023, 4, 1021, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1024, 3, 1022, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1025, 4, 1023, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1026, 3, 1023, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1027, 3, 1024, 10)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1028, 4, 1025, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1029, 5, 1025, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1030, 3, 1026, 3)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1031, 5, 1026, 3)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1032, 4, 1027, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1033, 3, 1027, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1034, 4, 1028, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1035, 4, 1029, 6)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1036, 4, 1030, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1037, 3, 1031, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1038, 4, 1031, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1039, 4, 1032, 123)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1040, 5, 1032, 12)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1042, 4, 1033, 23)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1043, 4, 1034, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1044, 3, 1035, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1045, 4, 1035, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1046, 3, 1036, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1047, 4, 1037, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1048, 4, 1038, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1049, 3, 1039, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1050, 4, 1039, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1051, 4, 1040, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1052, 5, 1040, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1053, 4, 1041, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1054, 3, 1041, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1055, 3, 1042, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1056, 3, 1043, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1057, 5, 1043, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1058, 3, 1044, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1059, 4, 1044, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1060, 3, 1045, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1061, 3, 1046, 124)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1062, 4, 1047, 14)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1063, 3, 1047, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1064, 4, 1048, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1065, 3, 1049, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1066, 4, 1050, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (1067, 3, 1050, 3)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2067, 3, 1051, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2068, 4, 1052, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2069, 5, 1052, 2)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2070, 4, 1053, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2071, 4, 1054, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2072, 4, 1055, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2073, 4, 1056, 1)
INSERT [dbo].[CartItems] ([CartItemID], [BouquetID], [CartID], [Quantity]) VALUES (2074, 10, 1057, 2)
SET IDENTITY_INSERT [dbo].[CartItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Gallery] ON 

INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (1, N'~/Uploads/lantana.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (3, N'~/Uploads/Galleries/false-indigo.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (4, N'~/Uploads/Galleries/fan-flower.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (5, N'~/Uploads/Galleries/forsythia.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (6, N'~/Uploads/Galleries/four-o''clocks.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (7, N'~/Uploads/Galleries/fuchsia.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (8, N'~/Uploads/Galleries/hydrangea.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (9, N'~/Uploads/Galleries/ice-plant.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (10, N'~/Uploads/Galleries/impatiens.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (11, N'~/Uploads/Galleries/lantana.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (12, N'~/Uploads/Galleries/lavender.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (13, N'~/Uploads/Galleries/lilac.jpg')
INSERT [dbo].[Gallery] ([id], [ImagePath]) VALUES (14, N'~/Uploads/Galleries/lobelia.jpg')
SET IDENTITY_INSERT [dbo].[Gallery] OFF
GO
SET IDENTITY_INSERT [dbo].[Occasions] ON 

INSERT [dbo].[Occasions] ([OccasionID], [Name], [ImagePath]) VALUES (2, N'wedding-day', N'~/Uploads/wedding.jpg')
INSERT [dbo].[Occasions] ([OccasionID], [Name], [ImagePath]) VALUES (3, N'birthday', N'~/Uploads/birthday.jpg')
INSERT [dbo].[Occasions] ([OccasionID], [Name], [ImagePath]) VALUES (4, N'funeral', N'~/Uploads/furneral.jpg')
INSERT [dbo].[Occasions] ([OccasionID], [Name], [ImagePath]) VALUES (5, N'new baby ', N'~/Uploads/new-baby.jpg')
SET IDENTITY_INSERT [dbo].[Occasions] OFF
GO
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023117, 3, 124)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023149, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023164, 3, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023164, 5, 2)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023171, 3, 3)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023171, 4, 2)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023421, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023514, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023552, 3, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023552, 4, 14)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023594, 3, 2)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023670, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023670, 5, 2)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023680, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023724, 3, 2)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023784, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023906, 10, 2)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023920, 3, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023920, 4, 1)
INSERT [dbo].[OrderDetails] ([OrderID], [BouquetID], [Quantity]) VALUES (2023979, 3, 2)
GO
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023117, 1, 1, CAST(1488.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-10' AS Date), N'48 NKT', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023149, 1, 1, CAST(213.00 AS Decimal(10, 2)), N'0912452523', CAST(N'2023-05-16' AS Date), N'123 DC', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023164, 1, 1, CAST(36.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-10' AS Date), N'48 NKT', N'Canceled')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023171, 1, 1, CAST(462.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-11' AS Date), N'285 Doi Can', N'Completed')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023421, 1, 1, CAST(213.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-24' AS Date), N'48 NKT', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023514, 1, 1, CAST(213.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-23' AS Date), N'asd', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023552, 1, 1, CAST(2994.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-23' AS Date), N'285 Doi Can', N'Completed')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023594, 1, 1, CAST(24.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-09' AS Date), N'48 NKT', N'In Progress')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023670, 1, 2, CAST(237.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-11' AS Date), N'as', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023680, 1, 2, CAST(213.00 AS Decimal(10, 2)), N'0337925386', CAST(N'2023-05-09' AS Date), N'CT2  Nghia Do, Cau Giay', N'Completed')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023724, 1, 2, CAST(24.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-11' AS Date), N'48 NKT', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023784, 1, 1, CAST(213.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-24' AS Date), N'as', N'Completed')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023906, 1, 2, CAST(159.98 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-24' AS Date), N'48 NKT', N'Pending')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023920, 1, 2, CAST(225.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-09' AS Date), N'48 NKT', N'In Progress')
INSERT [dbo].[Orders] ([OrderID], [UserID], [PaymentID], [TotalPrice], [PhonenNumber], [DeliveryDate], [DeliveryAddress], [Status]) VALUES (2023979, 2, 1, CAST(24.00 AS Decimal(10, 2)), N'0904525881', CAST(N'2023-05-09' AS Date), N'285 Doi Can', N'Pending')
GO
SET IDENTITY_INSERT [dbo].[Payments] ON 

INSERT [dbo].[Payments] ([PaymentID], [PaymentMethod], [CreditCardNumber], [PaymentStatus]) VALUES (1, N'PayLater', NULL, NULL)
INSERT [dbo].[Payments] ([PaymentID], [PaymentMethod], [CreditCardNumber], [PaymentStatus]) VALUES (2, N'CreditCard', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Payments] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [Fullname], [Password], [Email], [ImagePath], [PhoneNumber], [Address]) VALUES (1, N'Nam Pham', N'202cb962ac59075b964b07152d234b70', N'hoainampham2k@gmail.com', N'~/Uploads/lavender.jpg', N'0904525881', N'196 Cau Giay Hanoi')
INSERT [dbo].[Users] ([UserID], [Fullname], [Password], [Email], [ImagePath], [PhoneNumber], [Address]) VALUES (2, N'Truong Van Bac', N'e10adc3949ba59abbe56e057f20f883e', N'truongbac2109@gmail.com', N'~/Uploads/new-baby.jpg', N'0912452523', N'Thanh Son, Nghe An')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[Admin] ADD  DEFAULT ((2)) FOR [Role]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT ((0)) FOR [IsCheckedOut]
GO
ALTER TABLE [dbo].[Bouquets]  WITH CHECK ADD FOREIGN KEY([OccasionID])
REFERENCES [dbo].[Occasions] ([OccasionID])
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD FOREIGN KEY([BouquetID])
REFERENCES [dbo].[Bouquets] ([BouquetID])
GO
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD FOREIGN KEY([CartID])
REFERENCES [dbo].[Cart] ([CartID])
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK__OrderDeta__Bouqu__31EC6D26] FOREIGN KEY([BouquetID])
REFERENCES [dbo].[Bouquets] ([BouquetID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK__OrderDeta__Bouqu__31EC6D26]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK__OrderDeta__Order__30F848ED] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK__OrderDeta__Order__30F848ED]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK__Orders__PaymentI__2E1BDC42] FOREIGN KEY([PaymentID])
REFERENCES [dbo].[Payments] ([PaymentID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK__Orders__PaymentI__2E1BDC42]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK__Orders__UserID__2D27B809] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK__Orders__UserID__2D27B809]
GO
USE [master]
GO
ALTER DATABASE [Flowers] SET  READ_WRITE 
GO
