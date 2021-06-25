* Setup the library;
libname MyLab3 '/folders/myfolders';

* Reading the input file and setting the size for the character fields;
data MyLab3.TPCWCustomer;
	infile '/folders/myfolders/Lab3/TPCWcustomer.csv' dsd delimiter=';' firstobs=2;
	informat name $50.;
	informat address $70.;
	informat city $40.;
	informat state $45.;
	informat zip $40.;
	informat addr1 $50.;
	informat addr2 $50.;
	informat custtypeDummy $40.;
	informat custtype $40.;
	input custID $ address $ city $ state $ zip $ custtype $ custtypeDummy $;
	run;


* Reassigning the columns to the correct values;
data MyLab3.TPCWCustomer;
	set MyLab3.TPCWCustomer;
	name = address;
	address = city;
	city = state;
	state = zip;
	zip = custtype;
	custtype = custtypeDummy;
	drop custtypeDummy;
	run;

* Convert the short-forms of the address to long ones for uniformity;
data MyLab3.TPCWCustomer;
	set MyLab3.TPCWCustomer;
	address=tranwrd(address, 'Rd.', 'Road');
	address=tranwrd(address, 'St.', 'Street');
	address=tranwrd(address, 'Dr.', 'Drive');
	address=tranwrd(address, ', Road', ' Road');
	address=tranwrd(address, '. Road', ' Road');
	address=tranwrd(address, ' Avenue', ' Av');
	address=tranwrd(address, '. Avenue', ' Av');
	address=tranwrd(address, '. Ave', ' Av');
	address=tranwrd(address, ' Ave', ' Av');
	address=tranwrd(address, ' Av.', ' Av');
	address=tranwrd(address, ' Av', ' Avenue');
	address=tranwrd(address, ', Street', ' Street');
	address=tranwrd(address, ',  Street', ' Street');
	address=tranwrd(address, '. Street', ' Street');
	address=tranwrd(address, '..', ' ');
	custtype=tranwrd(custtype, ',', '');
	custtype=tranwrd(custtype, 'Comm', 'Commercial');
	custtype=tranwrd(custtype, 'Commm', 'Commercial');
	custtype=tranwrd(custtype, 'State', 'State/Local Govt');
	custtype=tranwrd(custtype, 'Govt', 'US Govt');
	custtype=tranwrd(custtype, 'State/Local US Govt', 'State/Local Govt');	
	custtype=tranwrd(custtype, 'Edu', 'Education');
	run;

* To split the address to addr1 and addr2;
data MyLab3.TPCWCustomer;
	set MyLab3.TPCWCustomer;
	addr1 = scan(address,1,",");
	addr2 = scan(address,2,",");
	run;
	
* To clean the addr1 and addr2 attributes;
data MyLab3.TPCWCustomer;
	set MyLab3.TPCWCustomer;
	concat = catx(' ', addr1, addr2);
	addr2 = tranwrd(addr2, 'Street','');
	starting_char = substr(addr1, 3, 1);
	if starting_char not in ('1', '2', '3', '4', '5', '6', '7', '8', '9') then
		do;
			temp = addr2;
			addr2 = addr1;
			addr1 = temp;
		end;
	if (substr(address, 3, 1) not in ('1', '2', '3', '4', '5', '6', '7', '8', '9')) and (index(address, ',') = 0) then
		do;
			addr2 = catx(' ', scan(address, 1, ' '),scan(address, 2, ' '));
			addr1 = catx(' ', scan(address, 3, ' '),scan(address, 4, ' '), scan(address, 5, ' '));
		end;
	addr1=tranwrd(addr1, '.', ' ');
	name = tranwrd(name, 'Incorporated', 'Inc');
	name = tranwrd(name, 'Inc.', 'Inc');
	name = tranwrd(name, 'Inc', 'Incorporated');
	name = tranwrd(name, 'Corporation', 'Corp');
	name = tranwrd(name, 'Corp.', 'Corp');
	name = tranwrd(name, 'Corp', 'Corporation');
	name = tranwrd(name, 'Company', 'Com');
	name = tranwrd(name, 'Co.', 'Com');
	name = tranwrd(name, 'Com', 'Company');
	custtype = tranwrd(custtype, 'Commercial', 'Comm');
	custtype = tranwrd(custtype, 'Commm', 'Comm');
	custtype = tranwrd(custtype, 'Comm', 'Commercial');
	drop concat;
	drop temp;
	drop starting_char;
	drop address;
	run;

/* Appending the leading zero to zip if zip is of 4 digits */
data MyLab3.TPCWCustomer;
	set MyLab3.TPCWCustomer;
	if length(strip(zip)) = 8 then zip = strip(substr(zip, 1, 2)) || strip('0') || strip(substr(zip, 3, 4));
	run;

* Removing quotes;
data MyLab3.TPCWCustomer;
	set MyLab3.TPCWCustomer;
	array chars {*} _character_;
	do _n_ = 1 to dim(chars);
		chars{_n_} = tranwrd(chars{_n_}, '"', '');
		chars{_n_} = strip(chars{_n_});
	end;
run;


* Print list of TPCWCustomer;
proc print data=MyLab3.TPCWCustomer;
	title 'List of TPCWCustomer';
	run;
	
* Export the clean data to a .csv file;
proc export data=MyLab3.TPCWCustomer outfile='/folders/myfolders/Lab3/TPCWCustomer_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;