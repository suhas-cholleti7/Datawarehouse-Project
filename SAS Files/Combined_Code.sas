* Setup the library;
libname MyLab3 '/folders/myfolders';

/* Cleaning TPCWProductType */
* Reading the input file and setting the size for the character fields;
data MyLab3.TPCWProductType;
	infile '/folders/myfolders/Lab3/TPCWproduct_type.csv' dsd delimiter=';' firstobs=2;
	informat productTypeID $70.;
	informat prodTypeID $30.;
	informat typeDescription $70.;
	informat BUID $30.;
	input productTypeID $;
	run;

* Removing quotes;
data MyLab3.TPCWProductType;
	set MyLab3.TPCWProductType;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
run;

* Cleaning Columns;
data MyLab3.TPCWProductType;
	set MyLab3.TPCWProductType;
	prodTypeID = scan(productTypeID, 1, ";");
	typeDescription = scan(productTypeID, 2, ";");
	BUID = scan(productTypeID, 3, ";");
	drop productTypeID;
	typeDescription=tranwrd(typeDescription, 'Equipment', 'Equip');
	typeDescription=tranwrd(typeDescription, 'Equip', 'Equipment');
	run;
	
* Print list of TPCWProductType;
proc print data=MyLab3.TPCWProductType;
	title 'List of TPCWProductType';
	run;

/* Cleaning TPCWBusiness_Unit: */
* Reading the input file and setting the size for the character fields;
data MyLab3.TPCWBusiness_Unit;
	infile '/folders/myfolders/Lab3/TPCWbusiness_unit.csv' dsd delimiter=';' firstobs=2;
	informat name $30.;
	informat abbrev $10.;
	input buid $ name $ abbrev $;
	run;

/* data MyLab3.TPCWBusiness_Unit; */
data MyLab3.TPCWBusiness_Unit;
	set mylab3.tpcwbusiness_unit;
	if name="Miscellaneous" then abbrev = "Misc.";
	run;
	
* Print list of TPCWBusiness_Unit;
proc print data=MyLab3.TPCWBusiness_Unit;
	title 'List of TPCWBusiness_Unit';
	run;
	
/* Cleaning PECBusiness_Unit: */
* Reading the input file and setting the size for the character fields;
data MyLab3.PECBusiness_Unit;
	infile '/folders/myfolders/Lab3/PECbusiness_unit.csv' dsd delimiter=';' firstobs=2;
	informat name $50.;
	informat abbrev $100.;
	informat buid $100.;
	informat name_original $100.;
	input name_original $;
	run;
	
* Removing quotes;
data MyLab3.PECBusiness_Unit;
	set MyLab3.PECBusiness_Unit;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
run;

* Cleaning Columns;
data MyLab3.PECBusiness_Unit;
	set MyLab3.PECBusiness_Unit;
	BUID = scan(name_original, 1, ";");
	name = scan(name_original, 2, ";");
	name = strip(name);
	abbrev = scan(name_original, 3, ";");
	if name = "Miscellaneous" then abbrev = "Misc.";
	drop name_original;
	run;
	
* Print list of PECBusiness_Unit;
proc print data=MyLab3.PECBusiness_Unit;
	title 'List of PECBusiness_Unit';
	run;
	
/* Cleaning TPCWCustomer_Type: */
* Reading the input file and setting the size for the character fields;
data MyLab3.TPCWCustomer_Type;
	infile '/folders/myfolders/Lab3/TPCWcustomer_type.csv' dsd delimiter=';' firstobs=2;
	informat typename $40.;
	input custtypeid $ typename $;
	run;
	
data MyLab3.TPCWCustomer_Type;
	modify MyLab3.TPCWCustomer_Type;
	typename=tranwrd(typename, 'Govt', 'Gov');
	typename=tranwrd(typename, 'Gov', 'Govt');
	run;
	
* Print list of TPCWCustomer_Type;
proc print data=MyLab3.TPCWCustomer_Type;
	title 'List of TPCWCustomer_Type';
	run;
	
/* Cleaning PECCustomer_Type: */
* Reading the input file and setting the size for the character fields;
data MyLab3.PECCustomer_Type;
	infile '/folders/myfolders/Lab3/PECcustomer_type.csv' dsd delimiter=';' firstobs=2;
	informat typename_original $60.;
	input typename_original $;
	run;
	
* Removing quotes;
data MyLab3.PECCustomer_Type;
	set MyLab3.PECCustomer_Type;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
run;

	
data MyLab3.PECCustomer_Type;
	modify MyLab3.PECCustomer_Type;
	typename_original=tranwrd(typename_original, 'Govt', 'Gov');
	typename_original=tranwrd(typename_original, 'Gov', 'Govt');
	run;
	
data MyLab3.PECCustomer_Type;
	set MyLab3.PECCustomer_Type;
	custtypeid = scan(typename_original, 1, ";");
	typename = scan(typename_original, 2, ";");
	drop typename_original;
	run;
	
* Print list of PECCustomer_Type;
proc print data=MyLab3.PECCustomer_Type;
	title 'List of PECCustomer_Type';
	run;
	
/* Cleaning PECManufacturingCosts: */
* Reading the input file and setting the size for the character fields;
data MyLab3.PECManufacturingCosts;
	infile '/folders/myfolders/Lab3/PECmanufacturingCosts.csv' dsd delimiter='|' firstobs=2;
	input year $ month $ prodID $ manufacturingCost $;
	run;
	
data MyLab3.PECManufacturingCosts;
	set MyLab3.PECManufacturingCosts;
	if length(strip(year)) = 1 then year = "0" || strip(year);
	run;
	
* Print list of PECManufacturingCosts;
proc print data=MyLab3.PECManufacturingCosts;
	title 'List of PECManufacturingCosts';
	run;

/* Cleaning PECProductType */
* Reading the input file and setting the size for the character fields;
data MyLab3.PECProductType;
	infile '/folders/myfolders/Lab3/PECproduct_type.csv' dsd delimiter=';' firstobs=2;
	informat productTypeID $70.;
	informat prodTypeID $30.;
	informat typeDescription $70.;
	informat BUID $30.;
	input productTypeID $;
	run;

* Removing quotes;
data MyLab3.PECProductType;
	set MyLab3.PECProductType;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
run;
	
* Cleaning Columns;
data MyLab3.PECProductType;
	set MyLab3.PECProductType;
	prodTypeID = scan(productTypeID, 1, ";");
	typeDescription = scan(productTypeID, 2, ";");
	BUID = scan(productTypeID, 3, ";");
	drop productTypeID;
	typeDescription=tranwrd(typeDescription, 'Equipment', 'Equip');
	typeDescription=tranwrd(typeDescription, 'Equip', 'Equipment');
	run;
	
* Print list of PECProductType;
proc print data=MyLab3.PECProductType;
	title 'List of PECProductType';
	run;

/* Exporting to clean .csv files: */
* Export the clean data to a .csv file - TPCWBusiness_Unit;
proc export data=MyLab3.TPCWBusiness_Unit outfile='/folders/myfolders/Lab3/TPCWbusiness_unit_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;

* Export the clean data to a .csv file - TPCWCustomer_Type;
proc export data=MyLab3.TPCWCustomer_Type outfile='/folders/myfolders/Lab3/TPCWcustomer_type_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;
	
* Export the clean data to a .csv file - PECCustomer_Type;
proc export data=MyLab3.PECCustomer_Type outfile='/folders/myfolders/Lab3/PECcustomer_type_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;
	
* Export the clean data to a .csv file - PECManufacturingCosts;
proc export data=MyLab3.PECManufacturingCosts outfile='/folders/myfolders/Lab3/PECmanufacturingCosts_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;
	
* Export the clean data to a .csv file - TPCWProductType;
proc export data=MyLab3.TPCWProductType outfile='/folders/myfolders/Lab3/TPCWproduct_type_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;
	
* Export the clean data to a .csv file - PECProductType;
proc export data=MyLab3.PECProductType outfile='/folders/myfolders/Lab3/PECproduct_type_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;
	
* Export the clean data to a .csv file - PECBusiness_Unit;
proc export data=MyLab3.PECBusiness_Unit outfile='/folders/myfolders/Lab3/PECbusiness_unit_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;