USE master
IF db_id ('ShoeGarden2017') is not null
	drop database ShoeGarden2017

GO

CREATE DATABASE ShoeGarden2017

GO

USE ShoeGarden2017

GO

-- TABLE "ROLES" -- 
CREATE TABLE roles (
	roleID				INT				PRIMARY KEY		IDENTITY(1,1),
	roleName			NVARCHAR(30)	NOT NULL,
)

GO

-- TABLE "USERS" -- 
CREATE TABLE users (
	userID				INT				PRIMARY KEY		IDENTITY(1,1),
	roleID				INT				FOREIGN KEY		REFERENCES roles(roleID),
	email				NVARCHAR(50)	UNIQUE			NOT NULL,
	[password]			NVARCHAR(500)	NOT NULL,
	firstName			NVARCHAR(50)	NOT NULL,
	lastName			NVARCHAR(50)	NOT NULL,
	[address]			NVARCHAR(255)	NOT NULL,
	phoneNumber			NVARCHAR(20)	NOT NULL,
	gender				TINYINT,						--1: MALE; 0: FEMALE
	birthday			DATE			NOT NULL,
	registrationDate	DATE			DEFAULT getDate(),
	[status]			TINYINT			DEFAULT 1		--1: WORKING, 0: BANNED 
)

GO

CREATE TABLE userAddresses (
	addressID		INT					PRIMARY KEY		IDENTITY(1,1),
	userID			INT					FOREIGN KEY		REFERENCES users(userID),
	[address]		NVARCHAR(255)		NOT NULL,
	phoneNumber		NVARCHAR(20)		NOT NULL
)

GO

--Them--
create table functions(
	functionID int  identity(1,1) primary key not null,
	functionGroup varchar(50) not null,
	functionName varchar(50) not null
)

create table permission(
	roleID				INT				FOREIGN KEY		REFERENCES roles(roleID),
	functionID			Int				FOREIGN KEY		REFERENCES functions(functionID)
)
--Them

-- TABLE "BRANCHES" --
CREATE TABLE brands (
	braID				INT				PRIMARY KEY		IDENTITY(1,1),
	braName				NVARCHAR(255)	NOT NULL		UNIQUE,
	[status]			TINYINT			DEFAULT 1		--1: WORKING, 0: NOT WORKING 
)

GO

-- TABLE "CATEGORIES" --
CREATE TABLE categories (
	catID				INT				PRIMARY KEY		IDENTITY(1,1),
	braID				INT				FOREIGN KEY		REFERENCES brands(braID),
	catName				NVARCHAR(255)	NOT NULL,
	[status]			TINYINT			DEFAULT 1		--1: WORKING, 0: NOT WORKING 
)

GO

-- TABLE "DISCOUNTS" --
CREATE TABLE discounts(
	discID				INT				PRIMARY KEY		IDENTITY(1,1),
	discTitle			NVARCHAR(255)	NOT NULL,
	discContent			NVARCHAR(255)	NOT NULL,
	dateBegin			DATE			NOT NULL,
	dateEnd				DATE			NOT NULL,
	discount			TINYINT			NOT NULL
)

GO

-- TABLE "PRODUCTS" --
CREATE TABLE products (
	productID			INT				PRIMARY KEY		IDENTITY(1,1),
	braID				INT				FOREIGN KEY		REFERENCES brands(braID),
	catID				INT				FOREIGN KEY		REFERENCES categories(catID),
	productName			NVARCHAR(255)	NOT NULL,
	price				FLOAT			NOT NULL,
	urlImg				NVARCHAR(255)	NOT NULL,
	productDes			TEXT,
	postedDate			DATE			DEFAULT getDate(),	
	productViews		INT				DEFAULT 0,
	[status]			TINYINT			DEFAULT 1		--1: WORKING, 0: NOT WORKING 
)

GO

-- TABLE "DISCOUNT DETAILS" --
CREATE TABLE discountDetails (
	discDetailID		INT				PRIMARY KEY		IDENTITY(1,1),
	discID				INT				FOREIGN KEY		REFERENCES discounts(discID),
	productID			INT				FOREIGN KEY		REFERENCES products(productID)	
)

GO

-- TABLE "PRODUCT COLOR" --
CREATE TABLE productColors (
	colorID				INT				PRIMARY KEY		IDENTITY(1,1),
	productID			INT				FOREIGN KEY		REFERENCES products(productID),
	color				NVARCHAR(255)	NOT NULL,
	urlColorImg			NVARCHAR(255)	NOT NULL,
	[status]			TINYINT			DEFAULT 1
)

GO

-- TABLE "SIZES BY COLOR" --
CREATE TABLE sizesByColor (
	sizeID				INT				PRIMARY KEY		IDENTITY(1,1),
	colorID				INT				FOREIGN KEY		REFERENCES productColors(colorID),
	size				NVARCHAR(255)	NOT NULL,
	quantity			INT				NOT NULL,
	[status]			TINYINT			DEFAULT 1
)

GO

-- TABLE "SUBIMAGES OF PRODUCTS" --
CREATE TABLE productSubImgs (
	subImgID			INT				PRIMARY KEY		IDENTITY(1,1),
	colorID				INT				FOREIGN KEY		REFERENCES productColors(colorID),
	urlImg				NVARCHAR(255)	NOT NULL
)

GO

-- TABLE "RATING" --
CREATE TABLE rating (
	ratingID	INT				PRIMARY KEY		IDENTITY(1,1),
	productID	INT				FOREIGN KEY		REFERENCES products(productID),
	userID		INT				FOREIGN KEY		REFERENCES users(userID),
	rating		INT				NOT NULL,
	ratingDate	DATE			DEFAULT getDate(),
	review		TEXT,
	[status]	TINYINT			DEFAULT 0 -- 0: NOT VERIFIED, 1: VERIFIED 
)

GO

-- Table "ORDERS" -- 
CREATE TABLE orders (
	ordersID			INT				PRIMARY KEY		IDENTITY(1,1),
	userID				INT				FOREIGN KEY		REFERENCES users(userID),
	ordersDate			DATETIME		DEFAULT getDate(),
	receiverFirstName	NVARCHAR(100)	NOT NULL,
	receiverLastName	NVARCHAR(100)	NOT NULL,
	phoneNumber			NVARCHAR(20)	NOT NULL,
	deliveryAddress		NVARCHAR(255)	NOT NULL,
	note				TEXT,
	[status]			TINYINT							-- 1: Completed; 2: Pending; 0: Cancelled
)

GO

-- Table "ORDERS DETAILS" -- 
CREATE TABLE ordersDetail (
	ordersDetailID		INT				PRIMARY KEY		IDENTITY(1,1),
	ordersID			INT				FOREIGN KEY		REFERENCES orders(ordersID),
	productID			INT				FOREIGN KEY		REFERENCES products(productID),
	sizeID				INT				FOREIGN KEY		REFERENCES sizesByColor(sizeID),
	productDiscount		TINYINT			NOT NULL,		--Base on discountDetails
	quantity			INT				NOT NULL,
	price				FLOAT			NOT NULL,
	[status]			TINYINT							--0: not change; 1: old; 2: new
)

GO
-- TABLE "WISHLIST"--
CREATE TABLE wishList(
	wishID		INT		PRIMARY KEY		IDENTITY(1,1),
	userID		INT		FOREIGN KEY		REFERENCES users(userID),
	productID	INT		FOREIGN KEY		REFERENCES products(productID),
	createDate	DATE					DEFAULT getDate()
)

GO




INSERT [dbo].[roles] ([roleName]) VALUES (N'Admin')
GO
INSERT [dbo].[roles] ([roleName]) VALUES (N'Moderator')
GO
INSERT [dbo].[roles] ([roleName]) VALUES (N'User')
GO




INSERT [dbo].[users] ([roleID], [email], [password], [firstName], [lastName],[address],[phoneNumber],[gender], [birthday], [registrationDate], [status]) VALUES (1, N'admin@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Nguyen Minh', N'Tri',N'Ho Chi Minh City',N'0988000111', 1, CAST(N'1990-12-31' AS Date), CAST(N'2017-06-06' AS Date), 1)
GO
INSERT [dbo].[users] ([roleID], [email], [password], [firstName], [lastName],[address],[phoneNumber],[gender], [birthday], [registrationDate], [status]) VALUES (2, N'mod01@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Truong Tuan', N'Son',N'Ho Chi Minh City',N'0988000222',1, CAST(N'1992-12-19' AS Date), CAST(N'2017-06-06' AS Date), 1)
GO
INSERT [dbo].[users] ([roleID], [email], [password], [firstName], [lastName],[address],[phoneNumber],[gender], [birthday], [registrationDate], [status]) VALUES (2, N'mod02@gmail.com', N'1', N'Nguyen Lam', N'Thuyen',N'Ho Chi Minh City',N'0988000333',1, CAST(N'1992-12-19' AS Date), CAST(N'2017-06-06' AS Date), 1)

GO


INSERT [dbo].brands (braName) VALUES (N'Nike')
GO
INSERT [dbo].brands (braName) VALUES (N'Adidas')
GO
INSERT [dbo].brands (braName) VALUES (N'Vans')
GO
INSERT [dbo].brands (braName) VALUES (N'Converse')
GO


--Categories--

INSERT categories(braID,catName) VALUES (1,'Running')
INSERT categories(braID,catName) VALUES (1,'Basketball')
INSERT categories(braID,catName) VALUES (1,'Soccer')
INSERT categories(braID,catName) VALUES (1,'Tennis')


INSERT categories(braID,catName) VALUES (2,'Originals')
INSERT categories(braID,catName) VALUES (2,'NEO')
INSERT categories(braID,catName) VALUES (2,'Stella McCartney')
INSERT categories(braID,catName) VALUES (2,'Athletics')


INSERT categories(braID,catName) VALUES (3,'SK8-HI')
INSERT categories(braID,catName) VALUES (3,'Old Skool')
INSERT categories(braID,catName) VALUES (3,'Authentics')
INSERT categories(braID,catName) VALUES (3,'Slip On')

INSERT categories(braID,catName) VALUES (4,'Chuck II')
INSERT categories(braID,catName) VALUES (4,'All Star')
INSERT categories(braID,catName) VALUES (4,'Jack Purcell')
INSERT categories(braID,catName) VALUES (4,'Andy Warhol')



SET IDENTITY_INSERT [dbo].[products] ON 

INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (1, 1, 1, N'NIKE AIR ZOOM ALL OUT FLYKNIT', 80, N'20170619_16_24_15air-zoom-all-out-flyknit-running-shoe-(6).jpg', N'<h2>MEN&#39;S RUNNING SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (2, 1, 1, N'NIKE AIR ZOOM PEGASUS 34', 75, N'20170619_16_42_27air-zoom-pegasus-34-running-shoe.jpg', N'<h2>MEN&#39;S RUNNING SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (3, 1, 1, N'Nike Free RN', 60, N'20170619_16_50_37freern21703_2_v1-(1).png', N'<p>MEN&#39;S RUNNING SHOE</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (4, 1, 1, N'NIKE FREE RN FLYKNIT 2017', 80, N'20170619_16_55_14free-rn-flyknit-2017-older-running-shoe.jpg', N'<h2>MEN&#39;S RUNNING SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (5, 1, 1, N'Nike Free RN FlyKnit ID', 75, N'20170619_17_04_21freern2fk1703_v1-(1).png', N'<h2>MEN&#39;S RUNNING SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (6, 1, 1, N'NIKE FREE RN MOTION FLYKNIT', 85, N'20170619_17_09_10free-rn-motion-flyknit-2017-running-shoe-(6).jpg', N'<h2>MEN&#39;S RUNNING SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (7, 1, 1, N'Nike Zoom Elite 9', 65, N'20170619_17_14_38air-zoom-elite-9-running-shoe-(6).jpg', N'<h2>MEN&#39;S RUNNING SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (8, 1, 2, N'JORDAN CP3.X', 450, N'20170619_17_22_26main1.png', N'<h1>AIR JORDAN XIII/XIV DMP</h1>

<h2>MEN&#39;S BASKETBALL SHOE PACK</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (9, 1, 2, N'JORDAN ULTRA FLY 2', 500, N'20170619_17_26_41jordan-ultrafly-2-basketball-shoe.jpg', N'<h1>MEN&#39;S BASKETBALL SHOE PACK</h1>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (10, 1, 2, N'KD ZOOM KDX', 470, N'20170619_17_34_45zoom-kdx-mens-basketball-shoe.jpg', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (11, 1, 2, N'KOBE A.D', 520, N'20170619_17_43_25kobe12master_v1.png', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (12, 1, 2, N'KOBE MAMBA INSTINCT', 520, N'20170619_17_57_23kobe-mamba-instinct-basketball-shoe.jpg', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (13, 1, 2, N'MEN''S BASKETBALL SHOE', 460, N'20170619_18_00_45main.jpg', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (14, 1, 2, N'LEBRON XIV ''AGIMAT''', 430, N'20170619_18_04_44main.jpg', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (15, 1, 2, N'NIKE LEBRON WITNESS', 650, N'20170619_18_11_00lebron-witness-basketball-shoe.jpg', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (16, 1, 2, N'NIKE ZOOM KD 9 ELITE', 490, N'20170619_18_14_32zoom-kd-9-elite-basketball-shoe-(6).jpg', N'<h2>MEN&#39;S BASKETBALL SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (17, 1, 3, N'Nike Hypervenom Phantom 3 Tech Craft DF iD', 180, N'20170619_19_46_47hypphaniii1702_v1.png', N'<h2>MEN&#39;S FOOTBALL CLEAT</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (18, 1, 3, N'NIKE HYPERVENOMX PHADE 3 IC', 200, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe.jpg', N'<h2>MEN&#39;S FOOTBALL CLEAT</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (19, 1, 3, N'Nike Magista Obra II Tech Craft iD', 220, N'20170619_19_53_09obraii1611_v1-(1).png', N'<h2>MEN&#39;S FOOTBALL CLEAT</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (20, 1, 3, N'Nike Mercurial Superfly V FG iD', 180, N'20170619_20_15_24mersuperflyii1608_v1.png', N'<h2>MEN&#39;S FOOTBALL CLEAT</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (21, 1, 3, N'NIKE MERCURIAL VORTEX III IC', 210, N'20170619_20_19_24mercurial-vortex-iii-indoor-court-football-shoe.jpg', N'<h2>MEN&#39;S FOOTBALL CLEAT</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (22, 1, 3, N'NIKE TIEMPO GENIO II LEATHER IC', 170, N'20170619_20_23_44tiempo-genio-ii-leather-football-boot.jpg', N'<h2>MEN&#39;S FOOTBALL CLEAT</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (23, 1, 4, N'NIKECOURT AIR ZOOM ULTRA', 180, N'20170619_20_29_43nikecourt-air-zoom-ultra-tennis-shoe.jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (24, 1, 4, N'NIKECOURT AIR ZOOM ULTRA REACT HARD COURT', 200, N'20170619_20_32_15nikecourt-air-zoom-ultra-react-hard-court-mens-tennis-shoe.jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (25, 1, 4, N'NIKECOURT LITE', 165, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(6).jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (26, 1, 4, N'NIKECOURT LUNAR BALLISTEC 1.5', 240, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(6).jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (27, 1, 4, N'NIKECOURT ZOOM VAPOR 9.5 TOUR I', 210, N'20170619_20_40_35nikecourt-zoom-vapor-9-5-tour-tennis-shoe.jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (28, 1, 4, N'NIKECOURT ZOOM VAPOR 9.5 TOUR QS', 140, N'20170619_20_42_55nikecourt-zoom-vapor-9-5-tour-qs-tennis-shoe.jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (29, 1, 4, N'NIKECOURT ZOOM VAPOR FLYKNIT HARD COURT', 230, N'20170619_20_45_25nikecourt-zoom-vapor-flyknit-hard-court-tennis-shoe.jpg', N'<h2>MEN&#39;S TENNIS SHOE</h2>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (30, 2, 5, N'FALCON ELITE 5 SHOES', 90, N'20170619_20_51_05aq2230_01_standard.jpg', N'<p>MEN RUNNING</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (31, 2, 5, N'PURE BOOST CLIMA SHOES', 65, N'20170619_21_15_03ba9058_01_standard.jpg', N'<p>MEN RUNNING</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (32, 2, 5, N'PURE BOOST SHOES', 85, N'20170619_21_17_48ba8895_01_standard.jpg', N'<p>MEN RUNNING</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (33, 2, 5, N'QUESTAR BOOST SHOES', 80, N'20170619_21_20_28ba9305_01_standard.jpg', N'<p>MEN RUNNING</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (34, 2, 5, N'RESPONSE 3 SHOES', 85, N'20170619_21_23_03aq2500_01_standard.jpg', N'<p>MEN RUNNING</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (35, 2, 5, N'ULTRA BOOST X SHOES', 100, N'20170619_21_25_14bb1696_01_standard.jpg', N'<p>MEN RUNNING</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (36, 2, 8, N'COURT FURY', 450, N'20170619_21_57_53main1.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (37, 2, 8, N'CRAZY FIRE SHOES', 430, N'20170619_21_59_55main1.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (38, 2, 8, N'CRAZYLIGHT BOOST LOW I', 500, N'20170619_22_01_55main1.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (39, 2, 8, N'CRAZYLIGHT BOOST LOW II', 520, N'20170619_22_05_07main1.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (40, 2, 8, N'D ROSE 7 PRIMEKNIT SHOES', 530, N'20170619_22_07_07b72720_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (41, 2, 8, N'D ROSE 7 SHOES', 520, N'20170619_22_08_36b54133_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (42, 2, 8, N'D ROSE 773 V MID SHOES', 470, N'20170619_22_10_36aq7222_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (43, 2, 7, N'ACE 16.3 PRIMEMESH TURF SHOES', 200, N'20170619_22_16_48aq3432_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (44, 2, 7, N'ACE 16.4 FLEXIBLE GROUND BOOTS', 180, N'20170619_22_19_56bb3894_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (45, 2, 7, N'GLORO 16.2 TURF SHOES', 150, N'20170619_22_22_51ba8390_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (46, 2, 7, N'GLORO BOOTS', 130, N'20170619_22_25_31ba9881_01_standard.jpg', N'<p>MEN</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (47, 2, 6, N'CLOUDFOAM QT RACER SHOES', 65, N'20170619_22_54_34aw4326_01_standard.jpg', N'<p>MEN&#39;S ADIDAS NEO</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (48, 2, 6, N'CLOUDFOAM RACE SHOES', 80, N'20170619_22_57_47b74728_01_standard.jpg', N'<p>MEN&#39;S ADIDAS NEO</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (49, 2, 6, N'CLOUDFOAM REVIVAL MID SHOES', 70, N'20170619_23_00_45aw3951_01_standard.jpg', N'<p>MEN&#39;S ADIDAS NEO</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (50, 2, 6, N'CLOUDFOAM SUPER DAILY SHOES', 75, N'20170619_23_04_45aw3907_01_standard.jpg', N'<p>MEN&#39;S ADIDAS NEO</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (51, 2, 6, N'MEN''S ADIDAS NEO', 90, N'20170619_23_08_33aw4164_01_standard.jpg', N'<p>MEN&#39;S ADIDAS NEO</p>
', CAST(0xF23C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (52, 4, 13, N'Chuck Taylor All Star Americana Print', 44, N'20170620_14_41_12155383_shot1.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (53, 4, 13, N'Chuck Taylor All Star Classic Colours', 55, N'20170620_15_36_50m9621c_shot1.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (54, 4, 13, N'Chuck Taylor All Star Fresh Colors', 55, N'20170620_15_42_23155740_shot1.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (55, 4, 13, N'Chuck Taylor All Star Fresh Colours Yth.Jr', 60, N'20170620_16_59_24355572_shot1.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (56, 4, 13, N'Chuck Taylor All Star Leather', 70, N'20170620_17_02_24136823c_shot1.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (57, 4, 15, N'CONVERSE JACK PURCELL CLASSIC LOW TOP', 75, N'20170620_17_06_24converse-jack-purcell-classic-low-top-unisex-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (58, 4, 15, N'CONVERSE JACK PURCELL LOW PROFILE SLIP-ON', 55, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(6).jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (59, 4, 15, N'CONVERSE JACK PURCELL S SERIES', 50, N'20170620_17_14_44converse-jack-purcell-s-series-mens-boot.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (60, 4, 15, N'CONVERSE JACK PURCELL SIGNATURE LOW TOP', 45, N'20170620_17_18_14converse-jack-purcell-signature-low-top-unisex-shoe-(6).jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (61, 4, 15, N'CONVERSE JACK PURCELL OPEN TEXTILE LOW TOP', 45, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (62, 4, 15, N'CONVERSE JACK PURCELL TUMBLED LEATHER LOW TOP', 90, N'20170620_17_25_29converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(5).jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (63, 4, 15, N'JACK PURCELL SIGNATURE CVO LOW TOP', 100, N'20170620_17_28_38jack-purcell-signature-cvo-low-top-unisex-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (64, 4, 14, N'CONVERSE CONS ONE STAR PRO LOW TOP', 60, N'20170620_17_31_35converse-cons-one-star-pro-low-top-unisex-skateboarding-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (65, 4, 14, N'CONVERSE CONS ONE STAR PRO SPECKLED SUEDE LOW TOP', 55, N'20170620_17_34_43converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(5).jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (66, 4, 14, N'CONVERSE CONS ONE STAR PRO SPECKLED SUEDE MID TOP', 70, N'20170620_17_40_04converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (67, 4, 16, N'CONVERSE CONS ONE STAR PRO SUEDE BACKED CANVAS LOW TOP', 75, N'20170620_17_44_10converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (68, 4, 16, N'CONVERSE ONE STAR CC PRO', 65, N'20170620_17_47_08converse-one-star-cc-pro-sage-elsesser-mens-skateboarding-shoe.jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (69, 4, 16, N'CONVERSE ONE STAR CC PRO LOW TOP', 70, N'20170620_17_49_33converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(4).jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (70, 4, 16, N'CONVERSE ONE STAR PREMIUM SUEDE LOW TOP', 55, N'20170620_17_52_36converse-one-star-premium-suede-low-top-unisex-shoe-(5).jpg', N'<p>It provides a comfort that will keep your mind on the important stuff.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (71, 3, 11, N'Vans AUTHENTIC', 60, N'20170620_18_10_02download-(6).png', N'<p>Vans Check out our Authentics&nbsp;for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (72, 3, 11, N'Vans CANVAS AUTHENTIC LITE', 70, N'20170620_18_13_38download-(2).png', N'<p>Vans Check out our Authentics&nbsp;for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (73, 3, 11, N'Vans RATA VULC SF', 80, N'20170620_18_24_46download-(6).png', N'<p>Vans Check out our Authentics&nbsp;for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (74, 3, 11, N'Vans SNAKE HALF CAB', 85, N'20170620_18_37_57download-(6).png', N'<p>Vans Check out our Authentics&nbsp;for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (75, 3, 12, N'Vans BALI SF', 55, N'20170620_18_46_04download-(6).png', N'<p>Vans Check out our Slip On for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (76, 3, 12, N'Vans CANVAS COURT MID', 70, N'20170620_18_49_00download-(6).png', N'<p>Vans Check out our Old Skool Pro for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (77, 3, 12, N'Vans FLAME SLIP-ON', 60, N'20170620_18_51_55download-(2).png', N'<p>Vans Check out our Slip On for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (78, 3, 12, N'Vans PRIMARY CHECK SLIP-ON', 55, N'20170620_18_54_57download-(7).png', N'<p>Vans Check out our Slip On&nbsp;for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (79, 3, 9, N'Vans CHIMA FERGUSON PRO', 70, N'20170620_18_59_48download-(6).png', N'<p>Vans Check out our SK8-HI for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (80, 3, 9, N'Vans CROCKETT PRO 2', 65, N'20170620_19_03_31download-(6).png', N'<p>Vans Check out our SK8-HIo for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (81, 3, 9, N'Vans SK8-HI PRO', 90, N'20170620_19_06_40download-(6).png', N'<p>Vans Check out our SK8-HI for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (82, 3, 12, N'Vans SLIP-ON PRO', 55, N'20170620_19_50_36download-(6).png', N'<p>Vans Check out our Slip On&nbsp;for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (83, 3, 9, N'Vans ULTRARANGE PRO', 90, N'20170620_23_02_20download-(5).png', N'<p>Vans Check out our SK8-HI&nbsp;for upgraded cushioning and durability.</p>
', CAST(0xF33C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (84, 3, 10, N'Vans HALF CAB', 75, N'20170621_00_29_59download-(6).png', N'<p>Vans Check out our Old Skool Pro for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF43C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (85, 3, 10, N'Vans LEATHER COURT MID DX', 100, N'20170621_00_34_10download-(6).png', N'<p>Vans Check out our Old Skool Pro for upgraded cushioning and durability.</p>
', CAST(0xF43C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (86, 3, 10, N'Vans OLD SKOOL', 85, N'20170621_00_37_26download-(6).png', N'<p>Vans Check out our Old Skool Pro for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF43C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (87, 3, 10, N'Vans PRIMARY CHECK OLD SKOOL', 85, N'20170621_00_41_20download-(6).png', N'<p>Vans Check out our Old Skool Pro for upgraded cushioning and durability.</p>
', CAST(0xF43C0B00 AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [braID], [catID], [productName], [price], [urlImg], [productDes], [postedDate], [productViews], [status]) VALUES (88, 3, 10, N'Vans VANS X PEANUTS OLD SKOOL', 95, N'20170621_00_56_08download-(3).png', N'<p>Vans Check out our Old Skool Pro for upgraded cushioning and durability.&nbsp;</p>
', CAST(0xF43C0B00 AS Date), 0, 1)
SET IDENTITY_INSERT [dbo].[products] OFF


SET IDENTITY_INSERT [dbo].[productColors] ON 

INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (1, 1, N'Black', N'20170619_16_32_03capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (2, 1, N'Grey', N'20170619_16_31_48capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (3, 2, N'Black', N'20170619_16_42_27capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (4, 2, N'Green', N'20170619_16_42_27capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (5, 3, N'Red', N'20170619_16_50_37capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (6, 3, N'Blue', N'20170619_16_50_37capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (7, 4, N'Red', N'20170619_16_55_14capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (8, 4, N'Blue', N'20170619_16_55_14capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (9, 5, N'Red', N'20170619_17_04_21capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (10, 5, N'Black', N'20170619_17_04_21capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (11, 6, N'Black', N'20170619_17_08_37capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (12, 6, N'Green', N'20170619_17_08_37capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (13, 7, N'Dark Blue', N'20170619_17_14_38capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (14, 7, N'Light Blue', N'20170619_17_14_38capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (15, 8, N'Green', N'20170619_17_22_26capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (16, 8, N'Blue', N'20170619_17_22_26capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (17, 9, N'White', N'20170619_17_26_41capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (18, 9, N'Red', N'20170619_17_26_41capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (19, 10, N'White', N'20170619_17_34_45capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (20, 11, N'Red', N'20170619_17_43_25capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (21, 11, N'Blue', N'20170619_17_43_25capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (22, 12, N'Black', N'20170619_17_57_23capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (23, 12, N'Red', N'20170619_17_57_23capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (24, 13, N'Grey', N'20170619_18_00_45capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (25, 13, N'Black', N'20170619_18_00_45capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (26, 14, N'Black', N'20170619_18_04_44capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (27, 14, N'Blue', N'20170619_18_04_44capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (28, 15, N'Black', N'20170619_18_11_00capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (29, 15, N'Red', N'20170619_18_11_00capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (30, 16, N'Red', N'20170619_18_14_16capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (31, 16, N'Black', N'20170619_18_14_16capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (32, 17, N'Black', N'20170619_19_46_27capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (33, 17, N'Red', N'20170619_19_46_27capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (34, 18, N'Black', N'20170619_19_49_36capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (35, 18, N'Green', N'20170619_19_49_36capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (36, 19, N'Red', N'20170619_19_53_09capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (37, 19, N'Green', N'20170619_19_53_09capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (38, 20, N'Red', N'20170619_20_15_24capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (39, 20, N'Green', N'20170619_20_15_24capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (40, 21, N'Green', N'20170619_20_19_24capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (41, 21, N'Blue', N'20170619_20_19_24capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (42, 22, N'White', N'20170619_20_23_44capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (43, 22, N'Blue', N'20170619_20_23_44capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (44, 23, N'Blue', N'20170619_20_29_43capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (45, 24, N'Black and Green', N'20170619_20_32_15capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (46, 25, N'Grey', N'20170619_20_35_15capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (47, 25, N'White', N'20170619_20_35_15capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (48, 26, N'Grey', N'20170619_20_38_14capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (49, 26, N'Orange', N'20170619_20_38_14capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (50, 27, N'White', N'20170619_20_40_35capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (51, 27, N'Blue', N'20170619_20_40_35capture1.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (52, 28, N'Black and Green', N'20170619_20_42_55capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (53, 29, N'Black and Orange', N'20170619_20_45_25capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (54, 30, N'Grey', N'20170619_20_51_04capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (55, 30, N'Dark Blue', N'20170619_20_51_05capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (56, 31, N'Blue', N'20170619_21_15_03capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (57, 31, N'White', N'20170619_21_15_03capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (58, 32, N'Grey', N'20170619_21_17_48capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (59, 32, N'Red', N'20170619_21_17_48capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (60, 33, N'Red', N'20170619_21_20_28capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (61, 33, N'Black', N'20170619_21_20_28capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (62, 34, N'Blue and Red', N'20170619_21_23_03capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (63, 34, N'Black', N'20170619_21_23_03capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (64, 35, N'Grey', N'20170619_21_25_14capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (65, 35, N'Black', N'20170619_21_25_14capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (66, 36, N'White', N'20170619_21_57_53capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (67, 37, N'Black', N'20170619_21_59_55capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (68, 38, N'Black', N'20170619_22_01_55capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (69, 39, N'White', N'20170619_22_04_35capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (70, 40, N'White', N'20170619_22_07_07capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (71, 41, N'Black', N'20170619_22_08_36capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (72, 42, N'Black and Red', N'20170619_22_10_36capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (73, 43, N'Yellow', N'20170619_22_16_48capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (74, 43, N'White', N'20170619_22_16_48capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (75, 44, N'Yellow', N'20170619_22_19_56capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (76, 44, N'Black', N'20170619_22_19_56capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (77, 45, N'Grey and Black', N'20170619_22_22_51capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (78, 45, N'Brown and Black', N'20170619_22_22_51capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (79, 46, N'Black', N'20170619_22_25_31capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (80, 46, N'White', N'20170619_22_25_31capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (81, 47, N'Black', N'20170619_22_54_34capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (82, 48, N'Black', N'20170619_22_57_47capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (83, 48, N'White', N'20170619_22_57_47capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (84, 49, N'Black', N'20170619_23_00_45capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (85, 50, N'Dark Blue', N'20170619_23_04_45capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (86, 50, N'Black', N'20170619_23_04_45capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (87, 51, N'Black', N'20170619_23_08_33capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (88, 51, N'White', N'20170619_23_08_33capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (89, 52, N'Orange', N'20170620_14_41_12capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (90, 52, N'Black', N'20170620_14_41_12capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (91, 53, N'White', N'20170620_15_36_50capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (92, 53, N'Pink', N'20170620_15_36_50capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (93, 54, N'Yellow', N'20170620_15_42_23capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (94, 54, N'Mint', N'20170620_15_42_23capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (95, 55, N'Orange', N'20170620_16_59_24capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (96, 55, N'Blue', N'20170620_16_59_24capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (97, 56, N'White', N'20170620_17_02_24capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (98, 57, N'Black', N'20170620_17_06_24capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (99, 57, N'White', N'20170620_17_06_24capture.png', 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (100, 58, N'White', N'20170620_17_10_33capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (101, 58, N'Grey', N'20170620_17_10_33capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (102, 59, N'Brown', N'20170620_17_14_44capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (103, 59, N'Black', N'20170620_17_14_44capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (104, 60, N'Blue', N'20170620_17_18_14capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (105, 60, N'Grey', N'20170620_17_18_14capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (106, 61, N'Blue', N'20170620_17_22_37capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (107, 61, N'Orange', N'20170620_17_22_37capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (108, 62, N'White', N'20170620_17_25_29capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (109, 62, N'Black', N'20170620_17_25_29capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (110, 63, N'Black', N'20170620_17_28_38capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (111, 64, N'Black', N'20170620_17_31_35capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (112, 65, N'White', N'20170620_17_34_43capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (113, 65, N'Black', N'20170620_17_34_43capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (114, 66, N'Blue', N'20170620_17_40_04capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (115, 66, N'Grey', N'20170620_17_40_04capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (116, 67, N'Blue', N'20170620_17_44_10capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (117, 67, N'Grey', N'20170620_17_44_10capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (118, 68, N'Black', N'20170620_17_47_08capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (119, 69, N'Black', N'20170620_17_49_33capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (120, 69, N'Grey', N'20170620_17_49_33capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (121, 70, N'Blue', N'20170620_17_52_36capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (122, 70, N'Red', N'20170620_17_52_36capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (123, 71, N'White', N'20170620_18_10_02capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (124, 71, N'Black', N'20170620_18_10_02capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (125, 72, N'Blue', N'20170620_18_13_38capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (126, 72, N'Green', N'20170620_18_13_38capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (127, 73, N'Brown', N'20170620_18_24_46capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (128, 73, N'Dark Blue', N'20170620_18_24_46capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (129, 74, N'Black', N'20170620_18_37_57capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (130, 74, N'White', N'20170620_18_37_57capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (131, 75, N'Grey', N'20170620_18_43_55capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (132, 75, N'Black', N'20170620_18_43_45capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (133, 76, N'Black', N'20170620_18_49_00capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (134, 76, N'Brown', N'20170620_18_49_00capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (135, 77, N'Black and Red', N'20170620_18_51_55capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (136, 78, N'Blue', N'20170620_18_54_57capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (137, 78, N'Red', N'20170620_18_54_57capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (138, 79, N'White', N'20170620_18_59_48capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (139, 79, N'Bue', N'20170620_18_59_48capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (140, 80, N'Blue', N'20170620_19_03_31capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (141, 80, N'Grey', N'20170620_19_03_31capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (142, 81, N'Blue', N'20170620_19_06_40capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (143, 81, N'Red', N'20170620_19_06_40capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (144, 82, N'Black', N'20170620_19_50_36capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (145, 82, N'White', N'20170620_19_50_36capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (146, 83, N'White', N'20170620_23_02_20capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (147, 83, N'Black', N'20170620_23_02_20capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (148, 84, N'Brown', N'20170621_00_29_59capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (149, 84, N'Black', N'20170621_00_29_59capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (150, 85, N'White', N'20170621_00_34_10capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (151, 85, N'Black', N'20170621_00_34_10capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (152, 86, N'Red', N'20170621_00_37_26capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (153, 86, N'Black', N'20170621_00_37_26capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (154, 87, N'Blue', N'20170621_00_41_20capture.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (155, 87, N'Red', N'20170621_00_41_20capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (156, 88, N'Pink', N'20170621_00_56_08capture2.png', 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [urlColorImg], [status]) VALUES (157, 88, N'Yellow', N'20170621_00_56_08capture.png', 1)
SET IDENTITY_INSERT [dbo].[productColors] OFF





SET IDENTITY_INSERT [dbo].[productSubImgs] ON 

INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (2, 1, N'20170619_16_24_15air-zoom-all-out-flyknit-running-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (4, 1, N'20170619_16_24_15air-zoom-all-out-flyknit-running-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (5, 2, N'20170619_16_30_34air-zoom-all-out-flyknit-running-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (6, 1, N'20170619_16_24_15air-zoom-all-out-flyknit-running-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (7, 1, N'20170619_16_24_15air-zoom-all-out-flyknit-running-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (8, 2, N'20170619_16_30_46air-zoom-all-out-flyknit-running-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (9, 2, N'20170619_16_30_56air-zoom-all-out-flyknit-running-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (10, 2, N'20170619_16_31_07air-zoom-all-out-flyknit-running-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (11, 3, N'20170619_16_42_27air-zoom-pegasus-34-running-shoe-(11).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (12, 4, N'20170619_16_45_57air-zoom-pegasus-34-running-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (13, 3, N'20170619_16_42_27air-zoom-pegasus-34-running-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (14, 4, N'20170619_16_45_36air-zoom-pegasus-34-running-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (15, 4, N'20170619_16_42_27air-zoom-pegasus-34-running-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (16, 4, N'20170619_16_45_47air-zoom-pegasus-34-running-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (17, 3, N'20170619_16_42_27air-zoom-pegasus-34-running-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (18, 3, N'20170619_16_42_27air-zoom-pegasus-34-running-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (19, 5, N'20170619_16_51_27freern21703_2_v1-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (20, 5, N'20170619_16_51_34freern21703_2_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (21, 5, N'20170619_16_50_37freern21703_2_v4-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (22, 6, N'20170619_16_50_37freern21703_2_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (23, 6, N'20170619_16_52_05freern21703_2_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (24, 6, N'20170619_16_50_37freern21703_2_v6.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (25, 5, N'20170619_16_51_47freern21703_2_v6-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (26, 6, N'20170619_16_52_12freern21703_2_v5.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (27, 8, N'20170619_16_57_02free-rn-flyknit-2017-older-running-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (28, 8, N'20170619_16_57_13free-rn-flyknit-2017-older-running-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (29, 8, N'20170619_16_56_44free-rn-flyknit-2017-older-running-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (30, 8, N'20170619_16_55_14free-rn-flyknit-2017-older-running-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (31, 7, N'20170619_16_55_14free-rn-flyknit-2017-older-running-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (32, 7, N'20170619_16_55_14free-rn-flyknit-2017-older-running-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (33, 7, N'20170619_16_55_14free-rn-flyknit-2017-older-running-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (34, 7, N'20170619_16_55_14free-rn-flyknit-2017-older-running-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (35, 9, N'20170619_17_04_21freern2fk1703_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (36, 10, N'20170619_17_04_21freern2fk1703_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (37, 10, N'20170619_17_04_21freern2fk1703_v4-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (38, 10, N'20170619_17_04_21freern2fk1703_v6-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (39, 9, N'20170619_17_04_21freern2fk1703_v6.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (40, 9, N'20170619_17_04_21freern2fk1703_v4.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (41, 9, N'20170619_17_04_21freern2fk1703_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (42, 10, N'20170619_17_04_21freern2fk1703_v1-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (43, 11, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (44, 12, N'20170619_17_10_09free-rn-motion-flyknit-2017-running-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (45, 12, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (46, 12, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (47, 11, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (48, 12, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (49, 11, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (50, 11, N'20170619_17_08_37free-rn-motion-flyknit-2017-running-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (51, 14, N'20170619_17_15_32air-zoom-elite-9-running-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (52, 14, N'20170619_17_14_38air-zoom-elite-9-running-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (53, 13, N'20170619_17_16_10air-zoom-elite-9-running-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (54, 13, N'20170619_17_16_30air-zoom-elite-9-running-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (55, 14, N'20170619_17_15_24air-zoom-elite-9-running-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (56, 14, N'20170619_17_15_17air-zoom-elite-9-running-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (57, 13, N'20170619_17_16_22air-zoom-elite-9-running-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (58, 13, N'20170619_17_14_38air-zoom-elite-9-running-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (59, 15, N'20170619_17_22_26jorcp3x1610_pe_2_v6-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (60, 15, N'20170619_17_22_26jorcp3x1610_pe_2_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (61, 16, N'20170619_17_23_22jorcp3x1610_pe_2_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (62, 16, N'20170619_17_22_26jorcp3x1610_pe_2_v6.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (63, 15, N'20170619_17_22_26jorcp3x1610_pe_2_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (64, 16, N'20170619_17_23_44jorcp3x1610_pe_2_v5.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (65, 15, N'20170619_17_22_26jorcp3x1610_pe_2_v4-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (66, 16, N'20170619_17_23_10main1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (67, 18, N'20170619_17_28_26jordan-ultrafly-2-basketball-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (68, 18, N'20170619_17_28_19jordan-ultrafly-2-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (69, 17, N'20170619_17_26_41jordan-ultrafly-2-basketball-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (70, 17, N'20170619_17_26_41jordan-ultrafly-2-basketball-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (71, 18, N'20170619_17_28_11jordan-ultrafly-2-basketball-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (72, 17, N'20170619_17_26_41jordan-ultrafly-2-basketball-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (73, 17, N'20170619_17_26_41jordan-ultrafly-2-basketball-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (74, 18, N'20170619_17_26_41jordan-ultrafly-2-basketball-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (75, 19, N'20170619_17_35_47zoom-kdx-mens-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (76, 19, N'20170619_17_35_29zoom-kdx-mens-basketball-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (77, 19, N'20170619_17_34_45zoom-kdx-mens-basketball-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (78, 19, N'20170619_17_35_20zoom-kdx-mens-basketball-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (79, 21, N'20170619_17_43_25kobe12master_v6.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (80, 20, N'20170619_17_43_25kobe12master_v6-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (81, 21, N'20170619_18_08_57kobe12master_v4.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (82, 20, N'20170619_17_43_25kobe12master_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (83, 21, N'20170619_18_08_50kobe12master_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (84, 21, N'20170619_17_44_09main1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (85, 20, N'20170619_17_43_25kobe12master_v5-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (86, 20, N'20170619_17_43_25kobe12master_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (87, 22, N'20170619_17_58_04kobe-mamba-instinct-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (88, 23, N'20170619_17_57_23kobe-mamba-instinct-basketball-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (89, 22, N'20170619_17_58_14kobe-mamba-instinct-basketball-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (90, 23, N'20170619_17_57_23kobe-mamba-instinct-basketball-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (91, 23, N'20170619_17_57_23kobe-mamba-instinct-basketball-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (92, 22, N'20170619_17_58_24kobe-mamba-instinct-basketball-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (93, 22, N'20170619_17_57_23kobe-mamba-instinct-basketball-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (94, 23, N'20170619_17_57_23kobe-mamba-instinct-basketball-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (95, 25, N'20170619_18_01_33main.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (96, 25, N'20170619_18_01_53kyrie-3-basketball-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (97, 25, N'20170619_18_01_47kyrie-3-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (98, 24, N'20170619_18_00_45kyrie-3-basketball-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (99, 25, N'20170619_18_01_39kyrie-3-basketball-shoe3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (100, 24, N'20170619_18_00_45kyrie-3-basketball-shoe-(7).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (101, 24, N'20170619_18_00_45kyrie-3-basketball-shoe-(5).jpg')
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (102, 24, N'20170619_18_00_45kyrie-3-basketball-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (103, 26, N'20170619_18_07_44lebron-xiv-lmtd-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (104, 27, N'20170619_18_05_19main.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (105, 26, N'20170619_18_07_36lebron-xiv-lmtd-basketball-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (106, 27, N'20170619_18_07_13lebron-xiv-agimat-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (107, 27, N'20170619_18_07_21lebron-xiv-agimat-basketball-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (108, 26, N'20170619_18_07_55lebron-xiv-lmtd-basketball-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (109, 27, N'20170619_18_06_42lebron-xiv-agimat-basketball-shoe1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (110, 26, N'20170619_18_04_44lebron-xiv-lmtd-basketball-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (111, 28, N'20170619_18_11_00lebron-witness-basketball-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (112, 29, N'20170619_18_11_00lebron-witness-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (113, 29, N'20170619_18_11_00lebron-witness-basketball-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (114, 28, N'20170619_18_11_00lebron-witness-basketball-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (115, 28, N'20170619_18_11_00lebron-witness-basketball-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (116, 29, N'20170619_18_11_45lebron-witness-basketball-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (117, 28, N'20170619_18_11_00lebron-witness-basketball-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (118, 29, N'20170619_18_11_50lebron-witness-basketball-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (119, 31, N'20170619_18_14_16zoom-kd-9-elite-basketball-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (120, 31, N'20170619_18_14_16zoom-kd-9-elite-basketball-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (121, 30, N'20170619_18_15_08zoom-kd-9-elite-basketball-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (122, 31, N'20170619_18_14_16zoom-kd-9-elite-basketball-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (123, 30, N'20170619_18_14_16zoom-kd-9-elite-basketball-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (124, 30, N'20170619_18_15_14zoom-kd-9-elite-basketball-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (125, 31, N'20170619_18_14_16zoom-kd-9-elite-basketball-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (126, 30, N'20170619_18_15_02zoom-kd-9-elite-basketball-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (127, 33, N'20170619_19_46_27hypphaniii1702_v1-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (128, 32, N'20170619_19_46_27hypphaniii1702_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (129, 33, N'20170619_19_46_27hypphaniii1702_v6-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (130, 33, N'20170619_19_46_27hypphaniii1702_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (131, 33, N'20170619_19_46_27hypphaniii1702_v4-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (132, 32, N'20170619_19_46_27hypphaniii1702_v4.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (133, 32, N'20170619_19_46_27hypphaniii1702_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (134, 32, N'20170619_19_46_27hypphaniii1702_v6.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (135, 35, N'20170619_19_50_18hypervenomx-phade-3-indoor-court-football-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (136, 34, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (137, 34, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (138, 35, N'20170619_19_50_10hypervenomx-phade-3-indoor-court-football-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (139, 34, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (140, 34, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (141, 35, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (142, 35, N'20170619_19_49_36hypervenomx-phade-3-indoor-court-football-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (143, 36, N'20170619_19_53_09obraii1611_v5-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (144, 37, N'20170619_19_53_09obraii1611_v5.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (145, 36, N'20170619_19_53_09obraii1611_v1-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (146, 37, N'20170619_19_53_09obraii1611_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (147, 37, N'20170619_19_53_09obraii1611_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (148, 36, N'20170619_19_53_09obraii1611_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (149, 36, N'20170619_19_53_09obraii1611_v4-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (150, 37, N'20170619_19_53_09obraii1611_v4.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (151, 39, N'20170619_20_15_24mersuperflyii1608_v3.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (152, 39, N'20170619_20_15_24mersuperflyii1608_v1.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (153, 38, N'20170619_20_15_24mersuperflyii1608_v4-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (154, 39, N'20170619_20_15_24mersuperflyii1608_v4.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (155, 39, N'20170619_20_15_24mersuperflyii1608_v6.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (156, 38, N'20170619_20_15_24mersuperflyii1608_v1-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (157, 38, N'20170619_20_15_24mersuperflyii1608_v6-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (158, 38, N'20170619_20_15_24mersuperflyii1608_v3-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (159, 40, N'20170619_20_19_24mercurial-vortex-iii-indoor-court-football-shoe-(11).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (160, 40, N'20170619_20_19_24mercurial-vortex-iii-indoor-court-football-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (161, 41, N'20170619_20_20_43mercurial-vortex-iii-indoor-court-football-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (162, 41, N'20170619_20_20_54mercurial-vortex-iii-indoor-court-football-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (163, 40, N'20170619_20_19_24mercurial-vortex-iii-indoor-court-football-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (164, 41, N'20170619_20_19_24mercurial-vortex-iii-indoor-court-football-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (165, 40, N'20170619_20_19_24mercurial-vortex-iii-indoor-court-football-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (166, 41, N'20170619_20_21_04mercurial-vortex-iii-indoor-court-football-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (167, 43, N'20170619_20_24_57tiempo-genio-ii-leather-indoor-court-football-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (168, 42, N'20170619_20_24_29tiempo-genio-ii-leather-football-boot.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (169, 42, N'20170619_20_24_45tiempo-genio-ii-leather-football-boot-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (170, 43, N'20170619_20_25_11tiempo-genio-ii-leather-indoor-court-football-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (171, 42, N'20170619_20_24_37tiempo-genio-ii-leather-football-boot-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (172, 42, N'20170619_20_23_44tiempo-genio-ii-leather-football-boot-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (173, 43, N'20170619_20_23_44tiempo-genio-ii-leather-indoor-court-football-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (174, 43, N'20170619_20_25_04tiempo-genio-ii-leather-indoor-court-football-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (175, 44, N'20170619_20_30_26nikecourt-air-zoom-ultra-tennis-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (176, 44, N'20170619_20_29_43nikecourt-air-zoom-ultra-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (177, 44, N'20170619_20_30_12nikecourt-air-zoom-ultra-tennis-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (178, 44, N'20170619_20_30_20nikecourt-air-zoom-ultra-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (179, 45, N'20170619_20_32_15nikecourt-air-zoom-ultra-react-hard-court-mens-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (180, 45, N'20170619_20_32_15nikecourt-air-zoom-ultra-react-hard-court-mens-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (181, 45, N'20170619_20_32_15nikecourt-air-zoom-ultra-react-hard-court-mens-tennis-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (182, 45, N'20170619_20_32_15nikecourt-air-zoom-ultra-react-hard-court-mens-tennis-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (183, 46, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(11).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (184, 47, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (185, 47, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (186, 46, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (187, 46, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (188, 47, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (189, 46, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (190, 47, N'20170619_20_35_15nikecourt-lite-mens-tennis-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (191, 49, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (192, 48, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (193, 49, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (194, 49, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (195, 49, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (196, 48, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (197, 48, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (198, 48, N'20170619_20_38_14nikecourt-lunar-ballistec-15-mens-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (199, 51, N'20170619_20_41_29nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (200, 51, N'20170619_20_41_18nikecourt-zoom-vapor-9-5-tour-tennis-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (201, 50, N'20170619_20_40_35nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(9).jpg')
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (202, 50, N'20170619_20_40_35nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (203, 50, N'20170619_20_40_35nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (204, 50, N'20170619_20_40_35nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(11).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (205, 51, N'20170619_20_41_38nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (206, 51, N'20170619_20_40_35nikecourt-zoom-vapor-9-5-tour-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (207, 52, N'20170619_20_43_42nikecourt-zoom-vapor-9-5-tour-qs-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (208, 52, N'20170619_20_42_55nikecourt-zoom-vapor-9-5-tour-qs-tennis-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (209, 52, N'20170619_20_43_34nikecourt-zoom-vapor-9-5-tour-qs-tennis-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (210, 52, N'20170619_20_43_59nikecourt-zoom-vapor-9-5-tour-qs-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (211, 53, N'20170619_20_46_00nikecourt-zoom-vapor-flyknit-hard-court-tennis-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (212, 53, N'20170619_20_45_55nikecourt-zoom-vapor-flyknit-hard-court-tennis-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (213, 53, N'20170619_20_46_09nikecourt-zoom-vapor-flyknit-hard-court-tennis-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (214, 53, N'20170619_20_45_25nikecourt-zoom-vapor-flyknit-hard-court-tennis-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (216, 55, N'20170619_20_51_05aq2229_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (217, 54, N'20170619_20_51_04aq2230_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (218, 55, N'20170619_20_51_05aq2229_02_standard-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (219, 54, N'20170619_20_51_04aq2230_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (220, 54, N'20170619_20_51_05aq2230_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (221, 54, N'20170619_20_51_04aq2230_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (222, 55, N'20170619_20_51_05aq2229_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (223, 57, N'20170619_21_15_03ba9058_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (224, 56, N'20170619_21_15_03ba9056_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (225, 57, N'20170619_21_15_03ba9058_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (226, 57, N'20170619_21_15_03ba9058_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (227, 56, N'20170619_21_15_03ba9056_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (228, 56, N'20170619_21_15_03ba9056_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (229, 56, N'20170619_21_15_03ba9056_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (230, 57, N'20170619_21_15_56ba9058_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (231, 58, N'20170619_21_17_48ba8903_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (232, 58, N'20170619_21_17_48ba8903_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (233, 58, N'20170619_21_17_48ba8903_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (234, 58, N'20170619_21_17_48ba8903_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (235, 59, N'20170619_21_17_48ba8895_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (236, 59, N'20170619_21_17_48ba8895_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (237, 59, N'20170619_21_17_48ba8895_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (238, 59, N'20170619_21_17_48ba8895_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (239, 60, N'20170619_21_20_28ba9307_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (240, 61, N'20170619_21_20_28ba9305_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (241, 61, N'20170619_21_20_28ba9305_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (242, 60, N'20170619_21_20_28ba9307_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (243, 61, N'20170619_21_20_28ba9305_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (244, 60, N'20170619_21_20_28ba9307_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (245, 60, N'20170619_21_20_28ba9307_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (246, 61, N'20170619_21_20_28ba9305_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (247, 63, N'20170619_21_23_03aq2500_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (248, 63, N'20170619_21_23_03aq2500_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (249, 63, N'20170619_21_23_03aq2500_03_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (250, 62, N'20170619_21_23_03aq2497_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (251, 63, N'20170619_21_23_03aq2500_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (252, 62, N'20170619_21_23_03aq2497_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (253, 62, N'20170619_21_23_03aq2497_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (254, 62, N'20170619_21_23_03aq2497_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (255, 65, N'20170619_21_25_14bb1696_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (256, 65, N'20170619_21_25_14bb1696_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (257, 64, N'20170619_21_25_14bb1695_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (258, 64, N'20170619_21_25_14bb1695_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (259, 64, N'20170619_21_25_14bb1695_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (260, 65, N'20170619_21_25_14bb1696_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (261, 64, N'20170619_21_25_14bb1695_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (262, 65, N'20170619_21_25_14bb1696_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (263, 66, N'20170619_21_57_53aq7298_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (264, 66, N'20170619_21_57_53aq7298_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (265, 66, N'20170619_21_58_33aq7298_03_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (266, 66, N'20170619_21_58_27main1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (267, 67, N'20170619_22_00_26main1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (268, 67, N'20170619_22_00_34b72746_03_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (269, 67, N'20170619_21_59_55b72746_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (270, 67, N'20170619_21_59_55b72746_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (271, 68, N'20170619_22_02_28main1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (272, 68, N'20170619_22_01_55b49756_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (273, 68, N'20170619_22_02_36b49756_03_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (274, 68, N'20170619_22_01_55b49756_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (275, 69, N'20170619_22_04_35aq7320_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (276, 69, N'20170619_22_05_29main1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (277, 69, N'20170619_22_04_35aq7320_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (278, 69, N'20170619_22_05_35aq7320_03_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (279, 70, N'20170619_22_07_07b72720_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (280, 70, N'20170619_22_07_07b72720_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (281, 70, N'20170619_22_07_07b72720_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (282, 70, N'20170619_22_07_07b72720_03_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (283, 71, N'20170619_22_08_36b54133_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (284, 71, N'20170619_22_08_36b54133_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (285, 71, N'20170619_22_08_36b54133_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (286, 71, N'20170619_22_08_36b54133_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (287, 72, N'20170619_22_10_36aq7222_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (288, 72, N'20170619_22_10_36aq7222_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (289, 72, N'20170619_22_10_36aq7222_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (290, 72, N'20170619_22_10_36aq7222_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (291, 74, N'20170619_22_16_48aq3432_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (292, 73, N'20170619_22_16_48aq3429_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (293, 73, N'20170619_22_16_48aq3429_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (294, 74, N'20170619_22_16_48aq3432_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (295, 74, N'20170619_22_16_48aq3432_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (296, 73, N'20170619_22_16_48aq3429_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (297, 74, N'20170619_22_16_48aq3432_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (298, 73, N'20170619_22_16_48aq3429_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (299, 75, N'20170619_22_19_56s42144_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (300, 76, N'20170619_22_19_56bb3894_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (301, 75, N'20170619_22_19_56s42144_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (302, 75, N'20170619_22_19_56s42144_02_standard.jpg')
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (303, 76, N'20170619_22_19_56bb3894_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (304, 76, N'20170619_22_19_56bb3894_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (305, 76, N'20170619_22_19_56bb3894_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (306, 75, N'20170619_22_19_56s42144_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (307, 77, N'20170619_22_22_51s42173_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (308, 78, N'20170619_22_22_51ba8390_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (309, 78, N'20170619_22_22_51ba8390_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (310, 77, N'20170619_22_22_51s42173_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (311, 77, N'20170619_22_22_51s42173_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (312, 77, N'20170619_22_22_51s42173_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (313, 78, N'20170619_22_22_51ba8390_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (314, 78, N'20170619_22_22_51ba8390_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (315, 79, N'20170619_22_25_31ba9881_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (316, 80, N'20170619_22_25_31ba9880_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (317, 80, N'20170619_22_25_31ba9880_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (318, 80, N'20170619_22_25_31ba9880_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (319, 79, N'20170619_22_25_31ba9881_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (320, 79, N'20170619_22_25_31ba9881_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (321, 80, N'20170619_22_25_31ba9880_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (322, 79, N'20170619_22_25_31ba9881_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (323, 81, N'20170619_22_54_34aw4326_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (324, 81, N'20170619_22_54_34aw4326_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (325, 81, N'20170619_22_54_34aw4326_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (326, 81, N'20170619_22_54_34aw4326_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (327, 83, N'20170619_22_57_47b74728_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (328, 83, N'20170619_22_57_47b74728_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (329, 83, N'20170619_22_57_47b74728_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (330, 83, N'20170619_22_57_47b74728_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (331, 82, N'20170619_22_57_47aw5327_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (332, 82, N'20170619_22_57_47aw5327_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (333, 82, N'20170619_22_57_47aw5327_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (334, 82, N'20170619_22_57_47aw5327_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (335, 84, N'20170619_23_00_45aw3951_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (336, 84, N'20170619_23_00_45aw3951_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (337, 84, N'20170619_23_00_45aw3951_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (338, 84, N'20170619_23_00_45aw3951_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (339, 86, N'20170619_23_04_45aw3906_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (340, 86, N'20170619_23_04_45aw3906_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (341, 86, N'20170619_23_04_45aw3906_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (342, 85, N'20170619_23_04_45aw3907_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (343, 86, N'20170619_23_04_45aw3906_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (344, 85, N'20170619_23_04_45aw3907_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (345, 85, N'20170619_23_04_45aw3907_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (346, 85, N'20170619_23_04_45aw3907_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (347, 87, N'20170619_23_08_33aw4163_05_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (348, 88, N'20170619_23_08_33aw4164_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (349, 87, N'20170619_23_08_33aw4163_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (350, 88, N'20170619_23_08_33aw4164_01_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (351, 87, N'20170619_23_08_33aw4163_04_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (353, 87, N'20170619_23_08_33aw4163_02_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (354, 88, N'20170619_23_08_33aw4164_04_standard-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (355, 89, N'20170620_15_37_35155382_shot2-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (356, 90, N'20170620_14_44_24155383_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (357, 89, N'20170620_15_37_29155382_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (358, 90, N'20170620_14_48_27155383_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (359, 89, N'20170620_14_45_36155382_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (360, 90, N'20170620_14_48_19155383_shot2.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (361, 90, N'20170620_14_41_12155383_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (362, 89, N'20170620_14_41_12155382_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (363, 92, N'20170620_15_38_42m9621c_shot2.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (364, 92, N'20170620_15_39_13m9621c_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (365, 91, N'20170620_15_39_26m7650c_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (366, 91, N'20170620_15_39_47m7650c_shot4.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (367, 92, N'20170620_15_36_50m9621c_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (368, 91, N'20170620_15_39_41m7650c_shot2.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (369, 92, N'20170620_15_38_18m9621c_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (370, 91, N'20170620_15_36_50m7650c_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (371, 94, N'20170620_15_42_23155740_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (372, 93, N'20170620_15_43_40155738_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (373, 94, N'20170620_15_43_05155740_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (374, 93, N'20170620_15_43_52155738_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (375, 94, N'20170620_15_43_31155740_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (376, 93, N'20170620_15_43_46155738_shot2.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (377, 94, N'20170620_15_43_14155740_shot2.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (378, 93, N'20170620_15_42_23155738_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (379, 96, N'20170620_17_00_10355572_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (380, 95, N'20170620_17_00_33355736_shot4.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (381, 96, N'20170620_17_00_04355572_shot2.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (382, 96, N'20170620_16_59_56355572_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (383, 95, N'20170620_16_59_24355736_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (384, 95, N'20170620_17_00_24355736_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (385, 96, N'20170620_16_59_24355572_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (386, 95, N'20170620_17_00_39355736_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (387, 97, N'20170620_17_03_10136823c_standard.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (388, 97, N'20170620_17_02_24136823c_shot1.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (389, 97, N'20170620_17_02_24136823c_shot4.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (390, 97, N'20170620_17_03_16136823c_shot3.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (392, 99, N'20170620_17_06_24converse-jack-purcell-classic-low-top-unisex-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (393, 99, N'20170620_17_07_59converse-jack-purcell-classic-low-top-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (394, 98, N'20170620_17_06_24converse-jack-purcell-classic-low-top-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (396, 98, N'20170620_17_06_58converse-jack-purcell-classic-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (398, 98, N'20170620_17_06_24converse-jack-purcell-classic-low-top-unisex-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (399, 98, N'20170620_17_07_20converse-jack-purcell-classic-low-top-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (400, 99, N'20170620_17_08_19converse-jack-purcell-classic-low-top-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (401, 100, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (402, 101, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (403, 100, N'20170620_17_11_08converse-jack-purcell-low-profile-slip-on-unisex-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (404, 101, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (405, 101, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (406, 101, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(8).jpg')
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (407, 100, N'20170620_17_10_33converse-jack-purcell-low-profile-slip-on-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (408, 100, N'20170620_17_11_17converse-jack-purcell-low-profile-slip-on-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (409, 102, N'20170620_17_15_35converse-jack-purcell-s-series-mens-boot-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (410, 102, N'20170620_17_15_19converse-jack-purcell-s-series-mens-boot.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (411, 103, N'20170620_17_14_44converse-jack-purcell-s-series-mens-boot-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (412, 103, N'20170620_17_14_44converse-jack-purcell-s-series-mens-boot-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (413, 103, N'20170620_17_14_44converse-jack-purcell-s-series-mens-boot-(7).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (414, 102, N'20170620_17_14_44converse-jack-purcell-s-series-mens-boot-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (415, 103, N'20170620_17_14_44converse-jack-purcell-s-series-mens-boot-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (417, 102, N'20170620_17_15_45converse-jack-purcell-s-series-mens-boot-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (418, 104, N'20170620_17_18_47converse-jack-purcell-signature-low-top-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (419, 105, N'20170620_17_19_20converse-jack-purcell-signature-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (422, 104, N'20170620_17_18_14converse-jack-purcell-signature-low-top-unisex-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (423, 105, N'20170620_17_18_14converse-jack-purcell-signature-low-top-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (424, 105, N'20170620_17_18_14converse-jack-purcell-signature-low-top-unisex-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (425, 104, N'20170620_17_18_14converse-jack-purcell-signature-low-top-unisex-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (426, 104, N'20170620_17_19_09converse-jack-purcell-signature-low-top-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (427, 105, N'20170620_17_19_46converse-jack-purcell-signature-low-top-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (428, 107, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (429, 106, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (430, 106, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (431, 107, N'20170620_17_23_19converse-jack-purcell-open-textile-low-top-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (432, 107, N'20170620_17_23_13converse-jack-purcell-open-textile-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (433, 106, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe-(7).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (434, 106, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (435, 107, N'20170620_17_22_37converse-jack-purcell-open-textile-low-top-unisex-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (436, 108, N'20170620_17_25_29converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (437, 108, N'20170620_17_26_39converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (438, 108, N'20170620_17_25_29converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (440, 109, N'20170620_17_25_29converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (441, 109, N'20170620_17_25_29converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (443, 109, N'20170620_17_26_01converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (444, 109, N'20170620_17_26_22converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (445, 108, N'20170620_17_26_54converse-jack-purcell-tumbled-leather-low-top-unisex-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (446, 110, N'20170620_17_29_24jack-purcell-signature-cvo-low-top-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (447, 110, N'20170620_17_29_16jack-purcell-signature-cvo-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (448, 110, N'20170620_17_28_38jack-purcell-signature-cvo-low-top-unisex-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (449, 110, N'20170620_17_29_05jack-purcell-signature-cvo-low-top-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (450, 111, N'20170620_17_32_10converse-cons-one-star-pro-low-top-unisex-skateboarding-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (451, 111, N'20170620_17_32_17converse-cons-one-star-pro-low-top-unisex-skateboarding-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (452, 111, N'20170620_17_32_24converse-cons-one-star-pro-low-top-unisex-skateboarding-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (453, 111, N'20170620_17_31_35converse-cons-one-star-pro-low-top-unisex-skateboarding-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (454, 113, N'20170620_17_36_00converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (455, 113, N'20170620_17_34_43converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (456, 113, N'20170620_17_35_14converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (457, 112, N'20170620_17_34_43converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (458, 113, N'20170620_17_35_40converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(7).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (459, 112, N'20170620_17_36_14converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (460, 112, N'20170620_17_34_43converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (461, 112, N'20170620_17_36_26converse-cons-one-star-pro-speckled-suede-low-top-unisex-skateboarding-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (464, 114, N'20170620_17_41_47converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (465, 115, N'20170620_17_40_04converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (466, 114, N'20170620_17_42_00converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (467, 115, N'20170620_17_40_32converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (468, 114, N'20170620_17_40_04converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (469, 114, N'20170620_17_41_23converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (470, 115, N'20170620_17_41_08converse-cons-one-star-pro-speckled-suede-mid-top-unisex-skateboarding-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (471, 116, N'20170620_17_44_51converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (472, 116, N'20170620_17_44_43converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (473, 117, N'20170620_17_44_10converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (474, 116, N'20170620_17_45_00converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (475, 117, N'20170620_17_45_25converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (477, 117, N'20170620_17_45_42converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (478, 116, N'20170620_17_44_10converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (479, 117, N'20170620_17_45_50converse-cons-one-star-pro-suede-backed-canvas-low-top-unisex-skateboarding-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (480, 118, N'20170620_17_47_36converse-one-star-cc-pro-sage-elsesser-mens-skateboarding-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (481, 118, N'20170620_17_47_41converse-one-star-cc-pro-sage-elsesser-mens-skateboarding-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (482, 118, N'20170620_17_47_08converse-one-star-cc-pro-sage-elsesser-mens-skateboarding-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (484, 119, N'20170620_17_50_31converse-one-star-cc-pro-low-top-mens-skateboarding-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (485, 120, N'20170620_17_49_33converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(7).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (486, 119, N'20170620_17_50_37converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (487, 120, N'20170620_17_49_33converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (488, 120, N'20170620_17_50_01converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(6).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (489, 119, N'20170620_17_50_49converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (490, 119, N'20170620_17_50_43converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (491, 120, N'20170620_17_50_19converse-one-star-cc-pro-low-top-mens-skateboarding-shoe-(1).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (492, 122, N'20170620_17_52_36converse-one-star-premium-suede-low-top-unisex-shoe-(8).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (493, 122, N'20170620_17_52_36converse-one-star-premium-suede-low-top-unisex-shoe-(5).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (494, 121, N'20170620_17_52_36converse-one-star-premium-suede-low-top-unisex-shoe-(4).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (495, 121, N'20170620_17_53_09converse-one-star-premium-suede-low-top-unisex-shoe-(2).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (496, 122, N'20170620_17_52_36converse-one-star-premium-suede-low-top-unisex-shoe-(10).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (497, 121, N'20170620_17_53_39converse-one-star-premium-suede-low-top-unisex-shoe-(3).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (498, 122, N'20170620_17_52_36converse-one-star-premium-suede-low-top-unisex-shoe-(9).jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (499, 121, N'20170620_17_53_20converse-one-star-premium-suede-low-top-unisex-shoe.jpg')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (500, 123, N'20170620_18_11_19download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (501, 124, N'20170620_18_11_05download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (502, 123, N'20170620_18_10_02download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (503, 124, N'20170620_18_10_55download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (504, 124, N'20170620_18_10_02download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (505, 123, N'20170620_18_11_28download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (506, 123, N'20170620_18_10_34download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (507, 124, N'20170620_18_10_02download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (508, 126, N'20170620_18_15_07download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (509, 125, N'20170620_18_14_33download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (510, 126, N'20170620_18_15_26download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (511, 125, N'20170620_18_14_40download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (512, 125, N'20170620_18_14_47download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (513, 125, N'20170620_18_14_19download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (514, 126, N'20170620_18_15_21download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (515, 126, N'20170620_18_15_15download-(5).png')
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (516, 127, N'20170620_18_25_20download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (517, 128, N'20170620_18_26_08download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (518, 127, N'20170620_18_25_26download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (519, 128, N'20170620_18_26_16download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (520, 127, N'20170620_18_25_32download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (521, 127, N'20170620_18_25_46download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (522, 128, N'20170620_18_25_57download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (523, 128, N'20170620_18_26_04download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (524, 129, N'20170620_18_38_33download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (525, 130, N'20170620_18_37_57download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (526, 129, N'20170620_18_38_43download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (527, 130, N'20170620_18_39_19download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (528, 130, N'20170620_18_37_57download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (529, 130, N'20170620_18_39_24download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (530, 129, N'20170620_18_38_57download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (531, 129, N'20170620_18_39_04download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (532, 132, N'20170620_18_44_29download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (533, 131, N'20170620_18_45_21download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (534, 131, N'20170620_18_45_27download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (535, 132, N'20170620_18_44_24download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (536, 131, N'20170620_18_45_41download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (537, 132, N'20170620_18_44_33download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (538, 131, N'20170620_18_44_47download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (539, 132, N'20170620_18_44_18download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (540, 133, N'20170620_18_49_00download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (541, 134, N'20170620_18_49_41download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (542, 134, N'20170620_18_49_30download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (543, 133, N'20170620_18_50_17download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (544, 133, N'20170620_18_49_00download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (545, 134, N'20170620_18_49_50download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (546, 133, N'20170620_18_50_07download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (547, 134, N'20170620_18_49_36download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (548, 135, N'20170620_18_52_58download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (549, 135, N'20170620_18_52_53download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (550, 135, N'20170620_18_52_29download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (551, 135, N'20170620_18_52_48download-(9).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (552, 137, N'20170620_18_54_57download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (553, 137, N'20170620_18_54_57download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (554, 136, N'20170620_18_56_10download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (555, 136, N'20170620_18_56_00download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (556, 136, N'20170620_18_56_04download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (557, 137, N'20170620_18_56_28download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (558, 136, N'20170620_18_56_16download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (559, 137, N'20170620_18_56_33download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (560, 138, N'20170620_19_01_18download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (561, 139, N'20170620_19_00_52download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (562, 139, N'20170620_19_00_47download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (563, 139, N'20170620_19_00_33download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (564, 138, N'20170620_19_01_29download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (565, 139, N'20170620_19_00_58download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (566, 138, N'20170620_19_01_12download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (567, 138, N'20170620_19_01_07download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (568, 140, N'20170620_19_04_13download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (569, 141, N'20170620_19_03_31download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (570, 140, N'20170620_19_03_57download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (571, 141, N'20170620_19_04_22download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (572, 141, N'20170620_19_03_31download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (573, 140, N'20170620_19_04_07download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (574, 141, N'20170620_19_04_31download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (575, 140, N'20170620_19_04_02download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (576, 143, N'20170620_19_07_35download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (577, 143, N'20170620_19_07_46download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (578, 142, N'20170620_19_07_56download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (579, 142, N'20170620_19_09_06download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (580, 142, N'20170620_19_09_19download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (581, 143, N'20170620_19_07_40download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (582, 142, N'20170620_19_08_57download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (583, 143, N'20170620_19_07_26download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (584, 145, N'20170620_19_52_03download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (585, 144, N'20170620_19_59_44download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (586, 144, N'20170620_20_00_16download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (587, 145, N'20170620_19_51_45download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (588, 144, N'20170620_19_59_52download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (589, 145, N'20170620_19_54_27download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (590, 145, N'20170620_19_51_56download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (591, 144, N'20170620_20_00_02download-(7).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (592, 147, N'20170620_23_02_20download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (593, 146, N'20170620_23_02_20download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (594, 146, N'20170620_23_03_03download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (595, 146, N'20170620_23_02_52download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (596, 147, N'20170620_23_02_20download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (597, 146, N'20170620_23_02_20download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (598, 147, N'20170620_23_02_20download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (599, 147, N'20170620_23_02_20download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (600, 148, N'20170621_00_30_38download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (601, 148, N'20170621_00_30_45download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (602, 149, N'20170621_00_29_59download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (603, 149, N'20170621_00_31_48download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (604, 149, N'20170621_00_31_57download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (605, 149, N'20170621_00_31_38download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (606, 148, N'20170621_00_30_52download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (607, 148, N'20170621_00_31_23download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (608, 151, N'20170621_00_34_45download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (611, 151, N'20170621_00_34_51download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (612, 150, N'20170621_00_34_10download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (613, 150, N'20170621_00_35_24download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (614, 151, N'20170621_00_35_07download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (615, 150, N'20170621_00_35_18download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (616, 153, N'20170621_00_38_26download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (617, 153, N'20170621_00_38_33download-(8).png')
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (618, 152, N'20170621_00_37_56download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (619, 152, N'20170621_00_38_10download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (620, 153, N'20170621_00_38_45download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (621, 153, N'20170621_00_37_26download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (622, 152, N'20170621_00_38_01download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (623, 152, N'20170621_00_38_17download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (624, 155, N'20170621_00_42_33download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (625, 154, N'20170621_00_41_47download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (626, 155, N'20170621_00_42_26download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (627, 155, N'20170621_00_42_16download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (628, 154, N'20170621_00_41_57download-(4).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (629, 154, N'20170621_00_42_04download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (630, 154, N'20170621_00_41_52download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (631, 155, N'20170621_00_42_21download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (632, 157, N'20170621_00_56_08download.png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (633, 157, N'20170621_00_58_42download-(3).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (634, 156, N'20170621_00_59_22download-(8).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (635, 157, N'20170621_00_58_48download-(1).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (636, 156, N'20170621_00_59_42download-(6).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (637, 157, N'20170621_00_56_08download-(2).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (638, 156, N'20170621_00_59_33download-(5).png')
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg]) VALUES (639, 156, N'20170621_00_59_28download-(4).png')
SET IDENTITY_INSERT [dbo].[productSubImgs] OFF

SET IDENTITY_INSERT [dbo].[sizesByColor] ON 

INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (1, 2, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (2, 2, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (3, 1, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (4, 1, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (5, 4, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (6, 4, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (7, 3, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (8, 3, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (9, 5, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (10, 6, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (11, 5, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (12, 6, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (13, 7, N'40', 14, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (14, 7, N'39', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (15, 8, N'39', 13, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (16, 8, N'40', 14, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (17, 10, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (18, 10, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (19, 9, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (20, 9, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (21, 11, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (22, 12, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (23, 12, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (24, 11, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (25, 14, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (26, 13, N'40', 14, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (27, 13, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (28, 14, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (29, 16, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (30, 15, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (31, 15, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (32, 16, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (33, 18, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (34, 17, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (35, 18, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (36, 17, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (37, 19, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (38, 19, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (39, 21, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (40, 20, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (41, 21, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (42, 20, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (43, 23, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (44, 22, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (45, 23, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (46, 22, N'39', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (47, 24, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (48, 24, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (49, 25, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (50, 25, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (51, 27, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (52, 26, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (53, 26, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (54, 27, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (55, 28, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (56, 28, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (57, 29, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (58, 29, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (59, 30, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (60, 31, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (61, 31, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (62, 30, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (63, 32, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (64, 32, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (65, 33, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (66, 33, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (67, 34, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (68, 35, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (69, 35, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (70, 34, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (71, 36, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (72, 36, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (73, 37, N'40', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (74, 37, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (75, 38, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (76, 39, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (77, 38, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (78, 39, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (79, 40, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (80, 41, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (81, 41, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (82, 40, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (83, 43, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (84, 43, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (85, 42, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (86, 42, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (87, 44, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (88, 44, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (89, 45, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (90, 45, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (91, 46, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (92, 46, N'39', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (93, 47, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (94, 47, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (95, 49, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (96, 48, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (97, 48, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (98, 49, N'40', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (99, 51, N'39', 17, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (100, 50, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (101, 51, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (102, 50, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (103, 52, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (104, 52, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (105, 53, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (106, 53, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (107, 54, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (108, 55, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (109, 55, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (110, 54, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (111, 57, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (112, 57, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (113, 56, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (114, 56, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (115, 58, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (116, 59, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (117, 59, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (118, 58, N'39', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (119, 61, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (120, 60, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (121, 60, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (122, 61, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (123, 62, N'39', 14, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (124, 63, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (125, 62, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (126, 63, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (127, 64, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (128, 65, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (129, 65, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (130, 64, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (131, 66, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (132, 66, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (133, 67, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (134, 67, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (135, 68, N'39', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (136, 68, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (137, 69, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (138, 69, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (139, 70, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (140, 70, N'40', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (141, 71, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (142, 71, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (143, 72, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (144, 72, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (145, 74, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (146, 74, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (147, 73, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (148, 73, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (149, 76, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (150, 75, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (151, 76, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (152, 75, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (153, 77, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (154, 77, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (155, 78, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (156, 78, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (157, 80, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (158, 79, N'39', 14, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (159, 79, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (160, 80, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (161, 81, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (162, 81, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (163, 82, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (164, 83, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (165, 83, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (166, 82, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (167, 84, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (168, 84, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (169, 86, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (170, 85, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (171, 86, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (172, 85, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (173, 87, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (174, 87, N'40', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (175, 88, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (176, 88, N'39', 27, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (177, 89, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (178, 89, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (179, 90, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (180, 90, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (181, 92, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (182, 92, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (183, 91, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (184, 91, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (185, 93, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (186, 93, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (187, 94, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (188, 94, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (189, 96, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (190, 95, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (191, 96, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (192, 95, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (193, 97, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (194, 97, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (195, 98, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (196, 99, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (197, 98, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (198, 99, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (199, 101, N'40', 19, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (200, 100, N'40', 14, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (201, 100, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (202, 101, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (203, 102, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (204, 103, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (205, 102, N'39', 27, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (206, 103, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (207, 104, N'40', 27, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (208, 104, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (209, 105, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (210, 105, N'39', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (211, 106, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (212, 107, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (213, 106, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (214, 107, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (215, 108, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (216, 108, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (217, 109, N'39', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (218, 109, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (219, 110, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (220, 110, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (221, 111, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (222, 111, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (223, 112, N'39', 29, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (224, 113, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (225, 112, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (226, 113, N'40', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (227, 115, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (228, 114, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (229, 115, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (230, 114, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (231, 117, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (232, 117, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (233, 116, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (234, 116, N'39', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (235, 118, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (236, 118, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (237, 120, N'39', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (238, 120, N'40', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (239, 119, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (240, 119, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (241, 122, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (242, 121, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (243, 122, N'40', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (244, 121, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (245, 123, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (246, 124, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (247, 124, N'40', 27, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (248, 123, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (249, 126, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (250, 125, N'39', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (251, 125, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (252, 126, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (253, 128, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (254, 128, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (255, 127, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (256, 127, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (257, 130, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (258, 130, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (259, 129, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (260, 129, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (261, 132, N'39', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (262, 132, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (263, 131, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (264, 131, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (265, 133, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (266, 133, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (267, 134, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (268, 134, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (269, 135, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (270, 135, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (271, 136, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (272, 136, N'39', 29, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (273, 137, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (274, 137, N'40', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (275, 138, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (276, 139, N'39', 26, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (277, 139, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (278, 138, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (279, 141, N'39', 29, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (280, 140, N'40', 27, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (281, 140, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (282, 141, N'40', 16, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (283, 143, N'39', 17, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (284, 142, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (285, 143, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (286, 142, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (287, 145, N'39', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (288, 144, N'40', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (289, 145, N'40', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (290, 144, N'39', 27, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (291, 146, N'39', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (292, 147, N'40', 19, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (293, 147, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (294, 146, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (295, 148, N'40', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (296, 149, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (297, 148, N'39', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (298, 149, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (299, 150, N'39', 23, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (300, 150, N'40', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (301, 151, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (302, 151, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (303, 152, N'40', 25, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (304, 152, N'39', 28, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (305, 153, N'40', 29, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (306, 153, N'39', 24, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (307, 155, N'39', 21, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (308, 154, N'39', 20, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (309, 155, N'40', 30, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (310, 154, N'40', 15, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (311, 157, N'40', 18, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (312, 156, N'39', 22, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (313, 156, N'40', 23, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [status]) VALUES (314, 157, N'39', 20, 1)
SET IDENTITY_INSERT [dbo].[sizesByColor] OFF


