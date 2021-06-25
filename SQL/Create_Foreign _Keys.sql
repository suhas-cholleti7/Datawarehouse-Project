ALTER TABLE `dw-2205-team3_salesorders`.financial_control_analysis_fact
ADD FOREIGN KEY (Customer_SK) REFERENCES `dw-2205-team3_salesorders`.customer_dim(Customer_SK);

ALTER TABLE `dw-2205-team3_salesorders`.financial_control_analysis_fact
ADD FOREIGN KEY (Product_SK) REFERENCES `dw-2205-team3_salesorders`.products_dim(Products_SK);

ALTER TABLE `dw-2205-team3_salesorders`.financial_control_analysis_fact
ADD FOREIGN KEY (supplier_SK) REFERENCES `dw-2205-team3_salesorders`.supplier_dim(supplier_SK);

ALTER TABLE `dw-2205-team3_salesorders`.financial_control_analysis_fact
ADD FOREIGN KEY (checkout_detials_sk) REFERENCES `dw-2205-team3_salesorders`.checkout_details_dim_junk(checkout_detials_sk);

ALTER TABLE `dw-2205-team3_salesorders`.financial_control_analysis_fact
ADD FOREIGN KEY (order_date_sk) REFERENCES `dw-2205-team3_salesorders`.order_date_dim(order_date_sk);

ALTER TABLE `dw-2205-team3_salesorders`.financial_control_analysis_fact
ADD FOREIGN KEY (sales_date_sk) REFERENCES `dw-2205-team3_salesorders`.sales_date_dim(sales_date_sk);