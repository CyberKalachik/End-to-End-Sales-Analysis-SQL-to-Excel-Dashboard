INSERT INTO dbo.raw_sales
SELECT
    TRY_CONVERT(date, [Date], 103) AS SaleDate,
    TRY_CAST([Day] AS int),
    [Month],
    TRY_CAST([Year] AS int),
    TRY_CAST(Customer_Age AS int),
    Age_Group,
    LEFT(Customer_Gender, 1),
    Country,
    State,
    Product_Category,
    Sub_Category,
    REPLACE(Product, '"', '') AS Product,
    TRY_CAST(Order_Quantity AS int),
    TRY_CAST(Unit_Cost AS decimal(10,2)),
    TRY_CAST(Unit_Price AS decimal(10,2)),
    TRY_CAST(Profit AS decimal(12,2)),
    TRY_CAST(Cost AS decimal(12,2)),
    TRY_CAST(Revenue AS decimal(12,2))
FROM dbo.raw_sales_stage;
GO