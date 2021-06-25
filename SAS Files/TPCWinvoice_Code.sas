* Setup the library;
libname MyLab3 '/folders/myfolders';

* Reading the input file and setting the size for the character fields;
data MyLab3.TPCWinvoice;
	infile '/folders/myfolders/Lab3/TPCWinvoice.csv' dsd delimiter=',' firstobs=2;
	informat salesDate $50.;
	input invoiceid $ custID $ prodID $ salesDate $ amt $ qty $ discounted $;
	run;
	
	
* Modifying and cleaning - Sale Date Formatting;
data MyLab3.TPCWinvoice;
	set MyLab3.TPCWinvoice;
	if find(salesDate, "-") ge 1 and length(salesDate) > 10 then
		do;
			temp = scan(salesDate, 3, '-');
			qty = substr(temp, 3, 3);
			cal_month = scan(salesDate, 2, "-");
			cal_day = scan(salesDate, 1, "-");
			cal_year = put(input(substr(scan(salesDate, 3, "-"), 1, 2), best12.), 2.);
		end;
	else if find(salesDate, "/") ge 1 then
		do;
			cal_month = scan(salesDate, 1, "/");
			cal_day = scan(salesDate, 2, "/");
			cal_year = put(input(scan(salesDate, 3, "/"), best12.), 2.);
		end;
	else if find(salesDate, "-") ge 1 and length(salesDate) < 10 then
		do;
			cal_day = scan(salesDate, 1, "-");
			cal_month = scan(salesDate, 2, "-");
			cal_year = put(input(scan(salesDate, 3, "-"), best12.), 2.);
		end;
	
	if strip(cal_month) in ("1", "2", "3", "01", "02", "03") then cal_quarter = "1";
	if strip(cal_month) in ("4", "5", "6", "04", "05", "06") then cal_quarter = "2";
	if strip(cal_month) in ("7", "8", "9", "07", "08", "09") then cal_quarter = "3";
	if strip(cal_month) in ("10", "11", "12") then cal_quarter = "4";
	
	if strip(cal_month) in ("5", "6", "7", "05", "06", "07") then fiscal_quarter = "1";
	if strip(cal_month) in ("8", "9", "10", "08", "09") then fiscal_quarter = "2";
	if strip(cal_month) in ("11", "12", "1", "01") then fiscal_quarter = "3";
	if strip(cal_month) in ("2", "3", "4", "02", "03", "04") then fiscal_quarter = "4";
	
	if strip(cal_month) in ("1", "2", "3", "4", "01", "02", "03", "04") then 
		do;
			fiscal_year = input(cal_year, best12.) - 1;
			format fiscal_year z2.;
		end;
		
	else fiscal_year = cal_year;

	visit = cats(strip(cal_month), "/", strip(cal_day), "/", strip(cal_year));
	if custID = "custID" then delete;
	drop temp;
	drop salesDate;
	drop visit;
	run;
	
* Modifying and cleaning - Customer_ID;
data MyLab3.TPCWinvoice;
	set MyLab3.TPCWinvoice;
	firstChar = substr(custID, 1, 1);
	if firstChar = '-' then custID = substr(custID, 2, length(custID)-1);
	drop firstChar;
	run;
	
data MyLab3.TPCWinvoice;
	set MyLab3.TPCWinvoice;
	previous_invoiceid=lag1(invoiceid);
	previous_discounted = lag1(discounted);
	if missing(discounted) and invoiceid = previous_invoiceid then
		do;
			discounted = previous_discounted;
		end;
	drop previous_invoiceid;
	drop previous_discounted;
	run;
	
* Print list of TPCWinvoice;
proc print data=MyLab3.TPCWinvoice (obs=40);
	title 'List of TPCWinvoice';
	run;
	
* Export the clean data to a .csv file;
proc export data=MyLab3.TPCWInvoice outfile='/folders/myfolders/Lab3/TPCWinvoice_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;