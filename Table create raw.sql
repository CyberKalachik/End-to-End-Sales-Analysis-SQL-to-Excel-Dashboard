USE [Customer segmentation];
GO

CREATE TABLE dbo.raw_sales_stage (
    [Date] nvarchar(30),
    [Day] nvarchar(20),
    [Month] nvarchar(30),
    [Year] nvarchar(20),
    Customer_Age nvarchar(20),
    Age_Group nvarchar(50),
    Customer_Gender nvarchar(10),
    Country nvarchar(100),
    State nvarchar(100),
    Product_Category nvarchar(100),
    Sub_Category nvarchar(100),
    Product nvarchar(200),
    Order_Quantity nvarchar(30),
    Unit_Cost nvarchar(30),
    Unit_Price nvarchar(30),
    Profit nvarchar(30),
    Cost nvarchar(30),
    Revenue nvarchar(30)
);
GO