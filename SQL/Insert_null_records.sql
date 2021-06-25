insert into `dw-2205-team3_salesorders`.supplier_dim(supplier_name, supplier_address1, supplier_address2, supplier_city, supplier_state,
supplier_zip) values(null, null, null, null, null, null);

insert into `dw-2205-team3_salesorders`.customer_dim(Customer_id, Customer_Name, Customer_Address1, Customer_Address2, Customer_City,
Customer_State, Customer_Zip, Customer_Type_Name, customer_sourceflag) values(null, null, null, null, null, null, null, null, null);

insert into `dw-2205-team3_salesorders`.products_dim(Product_ID, Product_Description, Product_Price1, Product_Price2, Product_Unitcost,
Product_TypeDescription, Product_BusinessUnit_Name, Product_Abbrev, Product_sourceflag) values(null, null, null, null, null, null, null, null, null);

insert into `dw-2205-team3_salesorders`.checkout_details_dim_junk(Order_Method, Payment_Method, Shipping_Method) values(null, null, null);

insert into `dw-2205-team3_salesorders`.order_date_dim(Order_Date_Fiscal_Year, Order_Date_Fiscal_Quarter, Order_Date_Calendar_Year, 
Order_Date_Calendar_Quarter, Order_Date_Calendar_Month, Order_Date_Day) values(null, null, null, null, null, null);
 
insert into `dw-2205-team3_salesorders`.sales_date_dim(Sales_Date_Fiscal_Year, Sales_Date_Fiscal_Quarter, Sales_Date_Calendar_Year, 
Sales_Date_Calendar_Quarter, Sales_Date_Calendar_Month, Sales_Date_Day) values(null, null, null, null, null, null);