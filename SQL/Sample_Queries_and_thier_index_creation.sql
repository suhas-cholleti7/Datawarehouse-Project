CREATE INDEX sales_date_quarter_index
ON `dw-2205-team3_salesorders`.sales_date_dim (Sales_Date_Fiscal_Year, Sales_Date_Fiscal_Quarter);

SELECT fact.Customer_SK, Customer_Name, Sales_Date_Fiscal_Year, Sales_Date_Fiscal_Quarter, 
sum(amount) as 'Total sales', sum(cost_price) as 'Total costs' 
FROM financial_control_analysis_fact as fact, customer_dim as c, sales_date_dim as sales
where fact.Customer_SK = c.Customer_SK and sales.sales_date_sk = fact.sales_date_sk 
group by Customer_SK, Sales_Date_Fiscal_Year, Sales_Date_Fiscal_Quarter;



CREATE INDEX sales_date_calendar_month
ON `dw-2205-team3_salesorders`.sales_date_dim (Sales_Date_Calendar_Year, Sales_Date_Calendar_Month);

SELECT Product_SK, Sales_Date_Calendar_Year, Sales_Date_Calendar_Month, sum(amount) as 'Total sales', sum(cost_price) as 'Total costs' 
FROM financial_control_analysis_fact as fact, products_dim as p, sales_date_dim as sales
where fact.Product_SK = p.Products_SK and sales.sales_date_sk = fact.sales_date_sk 
group by Product_SK, Sales_Date_Calendar_Year, Sales_Date_Calendar_Month;


CREATE INDEX invoice_id_index
ON `dw-2205-team3_salesorders`.financial_control_analysis_fact (invoice_id_DD);

SELECT count(distinct(Shipping_Method)), invoice_id_DD FROM financial_control_analysis_fact as fact, 
checkout_details_dim_junk as junk
where fact.Checkout_detials_SK = junk.Checkout_detials_SK and sale_type = "PEC"
group by invoice_id_DD;