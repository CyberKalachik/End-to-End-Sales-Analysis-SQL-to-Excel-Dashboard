# 🧠 Key insights

## Product performance
- Road Bikes and Mountain Bikes are the primary revenue and profit drivers, significantly outperforming all other sub-categories.
- Accessories contribute moderate revenue but show relatively strong profit margins in selected sub-categories (e.g. Helmets, Tires & Tubes).
- Clothing sub-categories generate lower revenue overall, indicating a supporting rather than core revenue role.
- The overall sales portfolio is heavily driven by high-value bike products, while accessories and clothing complement total performance.
Geographic performance.
- The United States is the clear market leader, generating the highest revenue, profit, and unit sales, significantly outperforming all other countries.
- Australia and the United Kingdom form a strong second tier, with solid profitability despite lower total volumes compared to the US.
- Germany and France show moderate performance, while Canada contributes the smallest share of total profit and revenue.
Gender split insights.
- Revenue and profit contributions from male and female customers are broadly balanced across countries.
- In high-performing markets (notably the United States), both genders contribute substantially, suggesting a diversified customer base rather than reliance on a single segment.
- No country shows extreme gender dependency, reducing concentration risk.

## Time-series trends

- Unit sales increased sharply after 2013, peaking in 2014 and 2016, indicating periods of strong demand expansion.
- Revenue and profit exhibit noticeable structural breaks, suggesting shifts in pricing, product mix, or market conditions.
- Profit margin trends reveal that higher unit volumes do not always translate proportionally into profit, highlighting differences in margin structures over time.
________________________________________

# 🛠 SQL Server data preparation

Raw sales data was ingested and transformed in SQL Server before analysis in Excel.

## Key steps included:

1. Loading raw CSV data into a staging table (raw_sales_stage)
2. Handling quoted text fields and locale-specific date formats
3. Converting string-based numeric fields into proper numeric data types
4. Standardizing and cleaning categorical fields (e.g. gender, product names)
5. Validating data integrity post-load before exporting to Excel

### 🧩 Example transformation logic (SQL Server)

This query represents the transformation step of the ETL pipeline.
Raw CSV data is loaded into a staging table and then cleaned, typed,
and inserted into the final `raw_sales` table.

```sql
INSERT INTO dbo.raw_sales
SELECT
    TRY_CONVERT(date, [Date], 103) AS SaleDate,
    TRY_CAST([Day] AS int) AS Day,
    [Month],
    TRY_CAST([Year] AS int) AS Year,
    TRY_CAST(Customer_Age AS int) AS Customer_Age,
    Age_Group,
    LEFT(Customer_Gender, 1) AS Gender,
    Country,
    State,
    Product_Category,
    Sub_Category,
    REPLACE(Product, '"', '') AS Product,
    TRY_CAST(Order_Quantity AS int) AS Order_Quantity,
    TRY_CAST(Unit_Cost AS decimal(10,2)) AS Unit_Cost,
    TRY_CAST(Unit_Price AS decimal(10,2)) AS Unit_Price,
    TRY_CAST(Profit AS decimal(12,2)) AS Profit,
    TRY_CAST(Cost AS decimal(12,2)) AS Cost,
    TRY_CAST(Revenue AS decimal(12,2)) AS Revenue
FROM dbo.raw_sales_stage
```

________________________________________
### This approach ensures:

- Clean, analysis-ready data
- Reproducible transformations
- A clear separation between raw ingestion and analytical datasets
________________________________________

## 🧩 Analytical approach

- SQL Server used for data ingestion, cleaning, and type enforcement
- Excel PivotTables used for aggregation and slicing
- PivotCharts and slicers used to create interactive, business-focused dashboards
- Visual design inspired by Power BI–style clarity and minimalism
- Insights framed from a decision-making perspective, not just descriptive statistics
________________________________________

# 📂 Files

1. Excel_Project.xlsx — full Excel workbook with data model and dashboards
2. Screenshots/ — dashboard previews for quick review
3. SQL files:
- Create tables.sql
- Insert_table.sql
- Transform_dataformat.sql
- raw table creation.sql
- ETL_pipeline_part.sql
________________________________________

## 📊 Key dashboards

### Revenue and Profit by Product Category
![Revenue_and_Profit_by_Product_Category](Screenshots/Revenue_and_Profit_by_Product_Category.jpg)

### Revenue and Profit Over Time
![ Revenue_and_Profit_Over_Time](Screenshots/Revenue_and_Profit_Over_Time.jpg)

### Revenue by Age Group and Gender
![ Revenue_by_Age_Group_and_Gender](Screenshots/Revenue_by_Age_Group_and_Gender.jpg)

### Units Sold by Year and Profit by country and gender
![ UnitsSold_by_Year_and_Profit_by_country](Screenshots/UnitsSold_by_Year_and_Profit_by_country.jpg)
