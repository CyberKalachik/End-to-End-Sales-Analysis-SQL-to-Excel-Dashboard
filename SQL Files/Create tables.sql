-- 1. Create DIM: products

IF OBJECT_ID('dbo.dim_products','U') IS NOT NULL DROP TABLE dbo.dim_products;
GO

CREATE TABLE dbo.dim_products (
  ProductKey int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  Product_Category nvarchar(100) NOT NULL,
  Sub_Category nvarchar(100) NOT NULL,
  Product nvarchar(200) NOT NULL,
  CONSTRAINT UQ_dim_products UNIQUE (Product_Category, Sub_Category, Product)
);
GO

INSERT INTO dbo.dim_products (Product_Category, Sub_Category, Product)
SELECT DISTINCT
  Product_Category,
  Sub_Category,
  Product
FROM dbo.raw_sales
WHERE Product IS NOT NULL;
GO

-- 2. DIM: customers 
-- We don't have a CustomerID, so we create a "pseudo-customer" as a combination of demographics and geography. 

IF OBJECT_ID('dbo.dim_customers','U') IS NOT NULL DROP TABLE dbo.dim_customers;
GO

CREATE TABLE dbo.dim_customers (
  CustomerKey int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  Customer_Age int NULL,
  Age_Group nvarchar(50) NULL,
  Customer_Gender char(1) NULL,
  Country nvarchar(100) NULL,
  State nvarchar(100) NULL,
  CONSTRAINT UQ_dim_customers UNIQUE (Customer_Age, Age_Group, Customer_Gender, Country, State)
);
GO

INSERT INTO dbo.dim_customers (Customer_Age, Age_Group, Customer_Gender, Country, State)
SELECT DISTINCT
  Customer_Age,
  Age_Group,
  Customer_Gender,
  Country,
  State
FROM dbo.raw_sales;
GO

-- 3.FACT: Sales. Fact = transaction

IF OBJECT_ID('dbo.fact_sales','U') IS NOT NULL DROP TABLE dbo.fact_sales;
GO

CREATE TABLE dbo.fact_sales (
  SalesKey bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
  SaleDate date NOT NULL,
  [Year] int NOT NULL,
  [Month] nvarchar(20) NOT NULL,
  [Day] int NOT NULL,

  CustomerKey int NOT NULL,
  ProductKey int NOT NULL,

  Order_Quantity int NOT NULL,
  Unit_Cost decimal(10,2) NOT NULL,
  Unit_Price decimal(10,2) NOT NULL,
  Cost decimal(12,2) NOT NULL,
  Revenue decimal(12,2) NOT NULL,
  Profit decimal(12,2) NOT NULL,

  CONSTRAINT FK_fact_sales_customers FOREIGN KEY (CustomerKey) REFERENCES dbo.dim_customers(CustomerKey),
  CONSTRAINT FK_fact_sales_products  FOREIGN KEY (ProductKey)  REFERENCES dbo.dim_products(ProductKey)
);
GO

INSERT INTO dbo.fact_sales (
  SaleDate, [Year], [Month], [Day],
  CustomerKey, ProductKey,
  Order_Quantity, Unit_Cost, Unit_Price, Cost, Revenue, Profit
)
SELECT
  r.SaleDate, r.[Year], r.[Month], r.[Day],
  c.CustomerKey,
  p.ProductKey,
  r.Order_Quantity, r.Unit_Cost, r.Unit_Price, r.Cost, r.Revenue, r.Profit
FROM dbo.raw_sales r
JOIN dbo.dim_customers c
  ON ISNULL(r.Customer_Age,-1) = ISNULL(c.Customer_Age,-1)
 AND ISNULL(r.Age_Group,'') = ISNULL(c.Age_Group,'')
 AND ISNULL(r.Customer_Gender,'') = ISNULL(c.Customer_Gender,'')
 AND ISNULL(r.Country,'') = ISNULL(c.Country,'')
 AND ISNULL(r.State,'') = ISNULL(c.State,'')
JOIN dbo.dim_products p
  ON ISNULL(r.Product_Category,'') = ISNULL(p.Product_Category,'')
 AND ISNULL(r.Sub_Category,'') = ISNULL(p.Sub_Category,'')
 AND ISNULL(r.Product,'') = ISNULL(p.Product,'');
GO

-- 4. Индексы (for faster work at Excel)

CREATE INDEX IX_fact_sales_SaleDate ON dbo.fact_sales(SaleDate);
CREATE INDEX IX_fact_sales_CustomerKey ON dbo.fact_sales(CustomerKey);
CREATE INDEX IX_fact_sales_ProductKey  ON dbo.fact_sales(ProductKey);
GO

-- 5. VIEW для Excel

---5.1. Monthly performance

CREATE OR ALTER VIEW dbo.vw_monthly_kpis AS
SELECT
  [Year],
  [Month],
  COUNT(*) AS transactions,
  SUM(Order_Quantity) AS units,
  SUM(Revenue) AS revenue,
  SUM(Cost) AS cost,
  SUM(Profit) AS profit
FROM dbo.fact_sales
GROUP BY [Year], [Month];
GO

---5.2. Category performance

CREATE OR ALTER VIEW dbo.vw_category_kpis AS
SELECT
  p.Product_Category,
  p.Sub_Category,
  SUM(f.Order_Quantity) AS units,
  SUM(f.Revenue) AS revenue,
  SUM(f.Profit) AS profit
FROM dbo.fact_sales f
JOIN dbo.dim_products p ON p.ProductKey = f.ProductKey
GROUP BY p.Product_Category, p.Sub_Category;
GO

---5.3. Customer segment (Age_Group + Gender)

CREATE OR ALTER VIEW dbo.vw_customer_segments AS
SELECT
  c.Country,
  c.Age_Group,
  c.Customer_Gender,
  COUNT(*) AS transactions,
  SUM(f.Revenue) AS revenue,
  SUM(f.Profit) AS profit
FROM dbo.fact_sales f
JOIN dbo.dim_customers c ON c.CustomerKey = f.CustomerKey
GROUP BY c.Country, c.Age_Group, c.Customer_Gender;
GO
