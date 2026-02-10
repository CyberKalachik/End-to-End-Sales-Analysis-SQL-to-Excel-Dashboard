BULK INSERT dbo.raw_sales_stage
FROM 'C:\data\sales.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDQUOTE = '"',
    TABLOCK
);
GO