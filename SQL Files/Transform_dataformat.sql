USE [Customer segmentation];
GO

IF OBJECT_ID('dbo.raw_sales','U') IS NOT NULL DROP TABLE dbo.raw_sales;
GO

CREATE TABLE dbo.raw_sales (
    SaleDate date,
    [Day] int,
    [Month] nvarchar(20),
    [Year] int,
    Customer_Age int,
    Age_Group nvarchar(50),
    Customer_Gender char(1),
    Country nvarchar(100),
    State nvarchar(100),
    Product_Category nvarchar(100),
    Sub_Category nvarchar(100),
    Product nvarchar(200),
    Order_Quantity int,
    Unit_Cost decimal(10,2),
    Unit_Price decimal(10,2),
    Profit decimal(12,2),
    Cost decimal(12,2),
    Revenue decimal(12,2)
);
GO