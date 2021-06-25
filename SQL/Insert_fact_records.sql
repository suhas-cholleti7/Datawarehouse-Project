insert into `dw-2205-team3_salesorders`.financial_control_analysis_fact (
select customer_sk, products_sk, supplier_sk, checkout_detials_sk as checkout_details_sk, order_date_sk, sales_date_sk, 
cost_price, amt as amount, gross_profit, qty as quantity, shipping_time, null as shipping_cost, discounted, 'TPCW' as sale_type, invoiceid as invoice_id_DD from 
`dw-2205-team3_salesorders`.tpcinvoicetemporary as TPCiT, 
`dw-2205-team3_salesorders`.customer_dim as c, `dw-2205-team3_salesorders`.products_dim as p, 
`dw-2205-team3_salesorders`.supplier_dim as s, `dw-2205-team3_salesorders`.sales_date_dim as sales,
`dw-2205-team3_salesorders`.order_date_dim as ordr, `dw-2205-team3_salesorders`.checkout_details_dim_junk as junk
where c.customer_id = TPCiT.custID and c.customer_sourceflag = "TPCW" and 
p.product_id = TPCiT.productID and p.Product_sourceflag = "TPCW" and
s.supplier_name = TPCiT.supplierName and s.supplier_Address1 = TPCiT.supplierAttn and s.supplier_address2 = TPCiT.supplierAddress and 
s.supplier_city = TPCiT.supplierCity and s.supplier_state = TPCiT.supplierState and s.supplier_zip = TPCiT.supplierZipcode and
sales.sales_date_fiscal_year = TPCiT.fiscal_year and sales.sales_date_fiscal_quarter = TPCiT.fiscal_quarter and 
sales.sales_date_calendar_year = TPCiT.cal_year and sales.sales_date_calendar_quarter = TPCiT.cal_quarter and 
sales.sales_date_calendar_month = TPCiT.cal_month and sales.sales_date_day = TPCiT.cal_day and 
ordr.order_date_fiscal_year is null and ordr.order_date_fiscal_quarter is null and 
ordr.order_date_calendar_year is null and ordr.order_date_calendar_quarter is null and 
ordr.order_date_calendar_month is null and ordr.order_date_day is null and 
junk.order_method is null and junk.payment_method is null and junk.shipping_method is null
);




insert into `dw-2205-team3_salesorders`.financial_control_analysis_fact (
select customer_sk, products_sk, supplier_sk, checkout_detials_sk as checkout_details_sk, order_date_sk, sales_date_sk, 
cost_price, amt as amount, gross_profit, qty as quantity, shipping_time, shipCost as shipping_cost, discounted, 'PEC' as sale_type, invoice as invoice_id_DD from 
`dw-2205-team3_salesorders`.pecinvoicetemporary as PECiT, 
`dw-2205-team3_salesorders`.customer_dim as c, `dw-2205-team3_salesorders`.products_dim as p, 
`dw-2205-team3_salesorders`.supplier_dim as s, `dw-2205-team3_salesorders`.sales_date_dim as sales,
`dw-2205-team3_salesorders`.order_date_dim as ordr, `dw-2205-team3_salesorders`.checkout_details_dim_junk as junk
where c.customer_id = PECiT.custID and c.customer_sourceflag = "PEC" and 
p.product_id = PECiT.prodid and p.Product_sourceflag = "PEC" and
s.supplier_name = PECiT.supplierName and s.supplier_Address1 is null and s.supplier_address2 is null and 
s.supplier_city is null and s.supplier_state is null and s.supplier_zip is null and
sales.sales_date_fiscal_year = PECiT.salesDate_fiscal_year and sales.sales_date_fiscal_quarter = PECiT.salesDate_fiscal_quarter and 
sales.sales_date_calendar_year = PECiT.cal_salesDate_year and sales.sales_date_calendar_quarter = PECiT.cal_salesDate_quarter and 
sales.sales_date_calendar_month = PECiT.cal_salesDate_month and sales.sales_date_day = PECiT.cal_salesDate_day and 
ordr.order_date_fiscal_year = PECiT.orderDate_fiscal_year and ordr.order_date_fiscal_quarter = PECiT.orderDate_fiscal_quarter and 
ordr.order_date_calendar_year  = PECiT.cal_orderDate_year and ordr.order_date_calendar_quarter  = PECiT.cal_orderDate_quarter and 
ordr.order_date_calendar_month  = PECiT.cal_orderDate_month and ordr.order_date_day = PECiT.cal_orderDate_day and 
junk.order_method = PECiT.orderMethod and junk.payment_method = PECiT.paymentMethod and junk.shipping_method = PECiT.shipMethod
);