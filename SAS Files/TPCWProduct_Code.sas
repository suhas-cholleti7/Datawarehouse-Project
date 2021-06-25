* Setup the library;
libname MyLab3 '/folders/myfolders';

* Reading the input file and setting the size for the character fields;
data MyLab3.TPCWproduct;
	infile '/folders/myfolders/Lab3/TPCWproduct.csv' dsd delimiter=';' firstobs=1;
	informat productName $75.;
	informat supplierName $70.;
	informat supplierAttn $70.;
	informat supplierAddress $75.;
	informat supplierCity $30.;
	input productID $ productName $ price1 $ price2 $ unitCost $ supplierName $ supplierAttn $ supplierAddress $ supplierCity $ supplierZipcode $ productTypeID $;
	run;

data MyLab3.TPCWproduct;
	set MyLab3.TPCWproduct;
	city=scan(supplierCity, 1, ',');
	state=scan(supplierCity, 2, ',');
	drop supplierCity;
	rename city=supplierCity
			state=supplierState;
	run;

* Removing semicolons;
data MyLab3.TPCWproduct;
	set MyLab3.TPCWproduct;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
	productID=input(productID, best12.);
	supplierAttn=tranwrd(supplierAttn, 'Attn : ', '');
	productName = tranwrd(productName, 'Equipment', 'Equip');
	productName = tranwrd(productName, 'Equip', 'Equipment');
	supplierName = tranwrd(supplierName, 'Inc.', 'Inc');
	supplierName = tranwrd(supplierName, 'Incorporated', 'Inc');
	supplierName = tranwrd(supplierName, 'Inc', 'Incorporated');
	supplierAddress = tranwrd(supplierAddress, 'Avenue', 'Ave');
	supplierAddress = tranwrd(supplierAddress, 'Ave', 'Avenue');
	supplierAddress = tranwrd(supplierAddress, 'Street', 'St');
	supplierAddress = tranwrd(supplierAddress, 'St', 'Street');
	run;

* Delete duplicates;
proc sort data=MyLab3.TPCWproduct nodupkey;
	by productName price1 price2 unitCost supplierName supplierAttn supplierAddress supplierCity supplierZipcode productTypeID;
	run;

* Print list of PECCustomers;
proc print data=MyLab3.TPCWproduct;
	title 'List of TPCWproduct';
	run;
	
* Export the clean data to a .csv file;
proc export data=MyLab3.TPCWproduct outfile='/folders/myfolders/Lab3/TPCWproduct_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;