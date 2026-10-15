# AI Practice Modeling — Power BI Project Guide

## 1. Purpose and audience

This is an import-mode Power BI sales analytics project built as a practice model. It brings together sales transactions and lookup data, models customers, products, sales representatives, and dates, and exposes sales and time-intelligence metrics through a report and semantic model.

This guide is for developers maintaining the PBIP project and managers or analysts who need to understand the report's scope, measures, data flow, and important assumptions. The report and model are named **AI_Practice_modeling**.

## 2. Project at a glance

| Area | Current implementation |
|---|---|
| Project format | Power BI Project (PBIP), with separate report and semantic-model folders |
| Storage mode | Import |
| Model culture | `en-US`; Power Query source culture is `en-IN` |
| Model compatibility level | 1606 |
| Main fact | `fact_sale` |
| Main dimensions | `dim_customer`, `dim_product`, `dim_sale_rep`, `dim_date` |
| Supporting objects | `_Measures`, `fact_bridge_salerep`, `Time Intel calc`, hidden auto-date tables |
| Report pages | `Page 1`, `Page 3`, `Sale Performance Analysis`, and `Product performance analysis` |
| Security role | `Region_RLS` (currently filters to one named representative) |

Open `AI_Practice_modeling.pbip` in Power BI Desktop to work with the report and semantic model. The PBIP file points to the report folder; the report definition in turn references the semantic model.

## 3. Repository layout

```text
AI_Practice_modeling.pbip
AI_Practice_modeling.Report/
  definition/
    report.json
    pages/
      pages.json
      <page-id>/
        page.json
        visuals/<visual-id>/visual.json
AI_Practice_modeling.SemanticModel/
  definition/
    database.tmdl
    model.tmdl
    relationships.tmdl
    expressions.tmdl
    roles/
    tables/
```

- **Report definition** stores page order, visual definitions, formatting, and visual-to-model bindings.
- **Semantic-model definition** stores tables, columns, measures, relationships, Power Query expressions, calculation items, and row-level security.
- **TMDL files** are the editable text representation of model metadata. Make coordinated edits to the semantic model and report when changing fields or measures used by visuals.
- Local `.pbi` settings and cache files are Power BI Desktop support data, not the authoritative documentation or source data.

## 4. Report experience

The report currently contains four pages, all configured to fit the page:

### Page 1 — sales overview

The page includes KPI cards, a representative slicer, and visuals for sales by region and product category, revenue trends by month, top-product information, order volume, and return rate. These visuals use fields from `dim_sale_rep`, `dim_product`, and `dim_date`, together with measures from `_Measures`.

### Page 3 — time analysis

This page compares sales-related measures across the date hierarchy. It includes a date-oriented table/matrix with revenue and time metrics, plus a clustered column chart using year/month and month-over-month sales.

### Sale Performance Analysis

This page contains sales KPI cards and visuals for revenue by product category, sales trends, and sales performance breakdowns.

### Product performance analysis

This page is an interactive product dashboard. Revenue, net revenue, order count, and top-product KPI cards sit above category, subcategory, and monthly revenue visuals. Category, subcategory, and year slicers filter the page, and a product matrix compares revenue, orders, and each product's share of all revenue. The product-share measure removes product filters from its denominator, while preserving other report filters.

## 5. Semantic model

### 5.1 Business tables

| Table | Role | Important columns |
|---|---|---|
| `fact_sale` | Transaction-level sales fact; carries order, customer, product, representative, date, quantity, price, discount, currency, shipping mode, and return reason | `Order_id`, `Customer_id`, `Product_id`, `Rep_id`, `Order_date`, `Quantity`, `Unit_price`, `Discount`, `Currency`, `Ship_mode`, `Return_reason` |
| `dim_customer` | Customer lookup | `Customer_id`, `Full_name`, `First_name`, `Last_name`, `Email`, `Domain`, `City`, `Country`, `Channel` |
| `dim_product` | Product lookup | `Product_key`, `Product_id`, `Product_name`, `Category`, `SubCategory`, `UnitPrice` |
| `dim_sale_rep` | Sales-representative lookup | `Rep_id`, `Rep_name`, `Region` |
| `dim_date` | Calendar dimension used by date-based measures and report visuals | `Date`, `Year`, `Quarter`, `Month No`, `Month Name` |

### 5.2 Supporting and hidden tables

- **`_Measures`** is a measure home table. Its hidden calculated placeholder column is not a business attribute.
- **`fact_bridge_salerep`** contains distinct `Customer_id`/`Rep_id` pairs derived from the staged sales data. It is related to the customer and representative dimensions. Both relationships are single-direction, so do not assume this table propagates a filter from one dimension through to the other.
- **`Time Intel calc`** is a calculation group with `Current`, `PY`, `QTD`, `YTD`, and `YOY %` items. It applies the selected time transformation to the selected measure.
- `DateTableTemplate_*` and `LocalDateTable_*` are hidden Power BI-generated date support tables; they are not intended as reporting dimensions. `dim_date` is the project calendar used by the model's explicit date measures.

### 5.3 Relationships

All seven current relationships are active and single-direction:

| Many-side table/column | One-side table/column | Purpose |
|---|---|---|
| `fact_sale[Customer_id]` | `dim_customer[Customer_id]` | Filter sales by customer |
| `fact_sale[Product_id]` | `dim_product[Product_id]` | Filter sales by product |
| `fact_sale[Rep_id]` | `dim_sale_rep[Rep_id]` | Filter sales by representative |
| `fact_sale[Order_date]` | `dim_date[Date]` | Filter sales by date |
| `fact_bridge_salerep[Customer_id]` | `dim_customer[Customer_id]` | Relate bridge rows to customers |
| `fact_bridge_salerep[Rep_id]` | `dim_sale_rep[Rep_id]` | Relate bridge rows to representatives |
| `dim_date[Date]` | hidden `LocalDateTable_…[Date]` | Power BI date hierarchy support |

The `fact_sale` relationships to the four business dimensions provide the primary star-schema filtering behavior.

## 6. Data sources and refresh flow

Power Query uses local files outside this repository, currently under a `Practice\Modeling_practice\files` directory on the original author's machine. The queries reference:

- `Lookup_Tables.xlsx` for Customers, Products, Returns, and SalesReps lookup sheets.
- `Sales_Mar2025.xlsx` for the `Sales` sheet.
- `Sales_Jan2025.csv` and `Sales_Feb2025.csv` for the two monthly sales inputs.
- `fact_sale_2026_sample.csv` for appended sample transactions.

The query groups in the model separate staged queries, dimensions, facts, and support data. The main transformation path is:

1. **Stage monthly sales.** `sales1` combines January and February 2025 sales and adds `Currency = "INR"`. `sales2` combines `Sales` with `sales1`, standardizes the appended data, and prepares a product identifier.
2. **Build dimensions.** The customer query promotes headers, splits the email domain and first/last names, renames fields, and keeps one row per customer ID. The product and representative queries rename source fields to the model's naming convention.
3. **Build the fact.** `fact_sale` joins staged sales to Returns on order ID, expands the return reason, replaces missing return reasons with `"n/a"`, replaces blank customer IDs with `"n/a"`, removes a preparation column, and appends the 2026 sample CSV.
4. **Build the bridge.** `fact_bridge_salerep` derives distinct customer/representative pairs from `sales2`.
5. **Build the calendar.** `dim_date` is a calculated calendar using `CALENDARAUTO()` and derives year, quarter, month number, and month name.

### Refresh and portability

Because the source files are local-file inputs, another developer or a deployment machine must update the Power Query file paths and confirm that the expected workbooks/CSVs are available before refreshing. A successful Desktop refresh on the original machine does not guarantee those paths exist elsewhere. Keep source data in an approved shared location or parameterize the paths as part of deployment preparation.

The model is Import mode; report results reflect data loaded into the model and are updated by refresh. `dim_customer[Channel]` is a calculated column using `RANDBETWEEN` and `SWITCH`, choosing among `Online`, `Retail`, `Mobile App`, `Social Media`, and `Wholesale`. This is sample/randomized data rather than a source-system attribute, and recalculation can change customer assignments. The calculation does not guarantee every category will be represented in a given refresh.

## 7. Measures

Measures live in `_Measures`, grouped into the `sale` and `Time Measures` display folders. The current inventory is:

### `sale` folder

| Measure | Definition / interpretation |
|---|---|
| `Total_Revenue` | `SUMX(fact_sale, Unit_price * Quantity * (1 - Discount))`; discounted line revenue before excluding returned sales |
| `Net_Revenue` | `Total_Revenue` filtered to rows whose `Return_reason` is `"n/a"` |
| `Total_orders` | Distinct count of `fact_sale[Order_id]` |
| `Average of Sales` | Average of `[Total_Revenue]` over distinct `fact_sale[Order_id]` values; average revenue per order |
| `Return_rate %` | Count of non-`"n/a"` return-reason rows divided by distinct orders |
| `Average_Discount %` | Total discount amount divided by gross line revenue before discount |
| `% Contribution_to_Total` | Current-context revenue divided by revenue with the product-category filter removed |
| `Top_region_by_sale` | Revenue evaluated over the top 10 regions by revenue |
| `top_product_by_revenue` | Product name with the highest revenue in the current context |
| `Product Revenue Share %` | Product revenue divided by total revenue with product filters removed |
| `Running Sale` | Cumulative `[Total_Revenue]` through the maximum date in the current context |

### `Time Measures` folder

| Measure | Definition / interpretation |
|---|---|
| `previous_month_sale` | `[Total_Revenue]` for the previous month |
| `MOM` | Current `[Total_Revenue]` minus `[previous_month_sale]` |
| `MOM %` | Month-over-month change divided by previous-month sales |
| `Previous_year_revenue` | `[Total_Revenue]` for the same period in the previous year |
| `YearOYear %` | Year-over-year revenue change divided by prior-year revenue |
| `YTD` | Year-to-date `[Total_Revenue]` |
| `Total_revenue_YearTD` | Another year-to-date `[Total_Revenue]` calculation |
| `QTD` | Quarter-to-date `[Total_Revenue]` |
| `MTD` | Month-to-date `[Total_Revenue]` |
| `Rolling_3_Month` | `[Total_Revenue]` over the three-month period ending on the maximum date in context |

The `Time Intel calc` calculation group offers `Current`, prior-year (`PY`), quarter-to-date (`QTD`), year-to-date (`YTD`), and year-over-year percentage (`YOY %`) transformations for selected measures.

## 8. Security

The model contains a role named **`Region_RLS`** with read permission and this table filter:

```DAX
dim_sale_rep[Rep_name] = "Anita George"
```

This is a hard-coded representative filter, not dynamic user-to-region mapping. Before publishing, verify that the role is intended, test it with **View as**, and confirm that it restricts the required data as expected. Assign users/groups to the role in the service after publishing; model metadata alone does not assign consumers.

## 9. Business interpretation and validation notes

The model is useful for sales exploration, but validate these definitions before treating results as financial or operational reporting:

1. **Revenue and returns:** `Total_Revenue` includes transaction rows regardless of return status. `Net_Revenue` excludes any row with a return reason other than `"n/a"`; its behavior depends on return reasons being correctly populated and on the business definition of net sales.
2. **Return-rate grain:** The numerator counts fact rows with a return reason, while the denominator counts distinct orders. If an order has multiple returned line items, the measure can exceed 100%. Confirm the intended return grain and denominator.
3. **Currency:** January and February staging assigns INR, while the March sales source and appended sample carry a currency field. Revenue measures sum numeric values without currency conversion. Do not aggregate across currencies unless the inputs are confirmed to use a common currency or a conversion process is added.
4. **Random channel:** `Channel` is generated for demonstration and should not be interpreted as observed customer behavior or a reliable segmentation attribute.
5. **Order key assumptions:** Order-based measures assume `Order_id` identifies orders consistently across all appended source files.
6. **Date coverage:** `CALENDARAUTO()` infers the calendar from date values in the model. Recheck date coverage and time-intelligence results when adding source data or changing the model's date columns.
7. **Region naming:** `Top_region_by_sale` uses `TOPN(10, …)` although the name is singular; confirm whether users expect top one or top ten region behavior.

## 10. Developer workflow

1. Open `AI_Practice_modeling.pbip` in Power BI Desktop.
2. In Power Query, update file locations as needed and inspect source schemas before refreshing.
3. Refresh the model and resolve any data type, missing-column, or relationship errors before editing visuals.
4. Keep DAX measures in `_Measures` and use the existing `sale` or `Time Measures` display folders where appropriate.
5. When changing a field or measure referenced by a visual, verify all report pages still bind to the intended model object.
6. Test date filters, representative filters, the calculation group, and `Region_RLS` using representative model data.
7. Save the PBIP changes, review the report/model definitions in source control, and test the project from a clean checkout or another machine to catch machine-specific file-path dependencies.

## 11. Glossary

- **Fact table:** Table of measurable business events; here, sales transactions in `fact_sale`.
- **Dimension:** Descriptive lookup used to group/filter facts, such as customer, product, representative, or date.
- **Measure:** DAX calculation evaluated in the current filter context.
- **Calculation group:** Reusable DAX transformations applied to selected measures.
- **RLS:** Row-level security; restricts rows visible to users assigned to a role.
- **PBIP/TMDL:** Text-based Power BI project and semantic-model formats used for Desktop authoring and source control.
