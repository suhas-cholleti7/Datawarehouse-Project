* Setup the library;
libname MyLab3 '/folders/myfolders';

* Reading the input file and setting the size for the character fields;
data MyLab3.PECProduct;
	infile '/folders/myfolders/Lab3/PECproduct.csv' dsd delimiter=';' firstobs=2;
	informat product $150.;
	informat prodDescription $90.;
	informat supplierName $40.;
	input product $;
	run;
	
* Removing quotes;
data MyLab3.PECProduct;
	set MyLab3.PECProduct;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
run;

* Cleaning Columns;
data MyLab3.PECProduct;
	set MyLab3.PECProduct;
	prodid = scan(product, 1, ";");
	prodDescription = scan(product, 2, ";");
	price1 = scan(product, 3, ";");
	price2 = scan(product, 4, ";");
	unitCost = scan(product, 5, ";");
	supplierName = scan(product, 6, ";");
	productTypeID = scan(product, 7, ";");
	if find(unitCost, ".") le 1 then 
		do;
			productTypeID = unitCost;
			unitCost = "%sysfunc(byte(0))";
		end;
	if productTypeID = "33" then productTypeID = "3";
	if missing(supplierName) then supplierName = "PEC";
	drop product;
	prodDescription=tranwrd(prodDescription, 'Equipment', 'Equip');
	prodDescription=tranwrd(prodDescription, 'Equip', 'Equipment');
	run;
	

* Print list of PECProduct;
proc print data=MyLab3.PECProduct;
	title 'List of PECProduct';
	run;
	
* Export the clean data to a .csv file - PECProduct;
proc export data=MyLab3.PECProduct outfile='/folders/myfolders/Lab3/PECproduct_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;