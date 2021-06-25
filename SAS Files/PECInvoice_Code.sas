* Setup the library;
libname MyLab3 '/folders/myfolders';

* Reading the input file and setting the size for the character fields;
data MyLab3.PECinvoice;
	infile '/folders/myfolders/Lab3/PECinvoice.csv' dsd delimiter=',' firstobs=2;
	informat Invoice $45.;
	informat custID $45.;
	informat salesDate $40.;
	informat orderDate $40.;
	input Invoice $ custID $ salesDate $ prodid $ amt $ qty $ shipMethod $ shipCost $ paymentMethod $ orderMethod $ orderDate $ discounted $;
	run;
	
data MyLab3.PECinvoice;
	set MyLab3.PECinvoice;
	if length(scan(Invoice, 2, '"')) > 1 then
		do;
			temp = scan(Invoice, 2,'"');
			Invoice = scan(Invoice, 1, '"');
			orderDate = orderMethod;
			orderMethod = paymentMethod;
			paymentMethod = shipCost;
			shipCost = shipMethod;
			shipMethod = qty;
			qty = amt;
			amt = prodid;
			prodid = salesDate;
			salesDate = custID;
			custID = temp;
		end;
	if length(scan(custID, 2, ',')) > 1 then
		do;
			temp = scan(custID, 2,',');
			custID = scan(custID, 1, ',');
			orderDate = orderMethod;
			orderMethod = paymentMethod;
			paymentMethod = shipCost;
			shipCost = shipMethod;
			shipMethod = qty;
			qty = amt;
			amt = prodid;
			prodid = salesDate;
			salesDate = temp;
		end;
	drop temp;
	run;
	
data MyLab3.PECinvoice;
	set MyLab3.PECinvoice;
	if find(salesDate, "-") ge 1 and length(salesDate) < 10 then
		do;
			cal_salesDate_year = substr(salesDate, 3, 2);
			cal_salesDate_month = substr(salesDate, 5, 2);
			cal_salesDate_day = substr(salesDate, 8, 2);
			salesDate = strip(cal_salesDate_month) || "/" || strip(cal_salesDate_day) || "/" || strip(cal_salesDate_year);
		end;
	else if find(salesDate, "-") ge 1 and length(salesDate) > 10 then
		do;
			cal_salesDate_year = substr(salesDate, 3, 2);
			cal_salesDate_month = substr(salesDate, 6, 2);
			cal_salesDate_day = substr(salesDate, 9, 2);
			salesDate = strip(cal_salesDate_month) || "/" || strip(cal_salesDate_day) || "/" || strip(cal_salesDate_year);
		end;
	
	* Sales Date formatting;
	cal_salesDate_month = scan(salesDate, 1, "/");
	cal_salesDate_day = scan(salesDate, 2, "/");
	cal_salesDate_year = scan(salesDate, 3, "/");
	
	if strip(cal_salesDate_month) in ("1", "2", "3", "01", "02", "03") then cal_salesDate_quarter = "1";
	if strip(cal_salesDate_month) in ("4", "5", "6", "04", "05", "06") then cal_salesDate_quarter = "2";
	if strip(cal_salesDate_month) in ("7", "8", "9", "07", "08", "09") then cal_salesDate_quarter = "3";
	if strip(cal_salesDate_month) in ("10", "11", "12") then cal_salesDate_quarter = "4";
	
	if strip(cal_salesDate_month) in ("5", "6", "7", "05", "06", "07") then salesDate_fiscal_quarter = "1";
	if strip(cal_salesDate_month) in ("8", "9", "10", "08", "09") then salesDate_fiscal_quarter = "2";
	if strip(cal_salesDate_month) in ("11", "12", "1", "01") then salesDate_fiscal_quarter = "3";
	if strip(cal_salesDate_month) in ("2", "3", "4", "02", "03", "04") then salesDate_fiscal_quarter = "4";
	
	if strip(cal_salesDate_month) in ("1", "2", "3", "4", "01", "02", "03", "04") then 
		do;
			salesDate_fiscal_year = input(cal_salesDate_year, best12.) - 1;
			format salesDate_fiscal_year z2.;
		end;
		
	else salesDate_fiscal_year = cal_salesDate_year;
	
	* Order date formatting;
	cal_orderDate_month = scan(orderDate, 1, "/");
	cal_orderDate_day = scan(orderDate, 2, "/");
	cal_orderDate_year = scan(orderDate, 3, "/");
	
	if strip(cal_orderDate_month) in ("1", "2", "3", "01", "02", "03") then cal_orderDate_quarter = "1";
	if strip(cal_orderDate_month) in ("4", "5", "6", "04", "05", "06") then cal_orderDate_quarter = "2";
	if strip(cal_orderDate_month) in ("7", "8", "9", "07", "08", "09") then cal_orderDate_quarter = "3";
	if strip(cal_orderDate_month) in ("10", "11", "12") then cal_orderDate_quarter = "4";
	
	if strip(cal_orderDate_month) in ("5", "6", "7", "05", "06", "07") then orderDate_fiscal_quarter = "1";
	if strip(cal_orderDate_month) in ("8", "9", "10", "08", "09") then orderDate_fiscal_quarter = "2";
	if strip(cal_orderDate_month) in ("11", "12", "1", "01") then orderDate_fiscal_quarter = "3";
	if strip(cal_orderDate_month) in ("2", "3", "4", "02", "03", "04") then orderDate_fiscal_quarter = "4";
	
	if strip(cal_orderDate_month) in ("1", "2", "3", "4", "01", "02", "03", "04") then 
		do;
			orderDate_fiscal_year = input(cal_orderDate_year, best12.) - 1;
			format orderDate_fiscal_year z2.;
		end;
		
	else orderDate_fiscal_year = cal_orderDate_year;
	
	drop salesDate;
	drop orderDate;
	run;
	
* Fixing the wrong entries in shipMethod;
data MyLab3.PECinvoice;
	modify MyLab3.PECinvoice;
	if shipMethod in ('aiir', 'air') then shipMethod = 'air';
	if shipMethod in ('trainn', 'trrain', 'trran', 'train') then shipMethod = 'train';
	if shipMethod in ('truck', 'truckk', 'trick', 'tuck') then shipMethod = 'truck';
	run;
	
* Print list of PECinvoice;
proc print data=MyLab3.PECinvoice (obs=10);
	title 'List of PECinvoice';
	run;
	
* Export the clean data to a .csv file;
proc export data=MyLab3.PECinvoice outfile='/folders/myfolders/Lab3/PECinvoice_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;