* Setup the library;
libname MyLab3 '/folders/myfolders';

* Reading the input file and setting the size for the character fields;
data MyLab3.PECCustomers;
	infile '/folders/myfolders/Lab3/PECcustomer.csv' dsd delimiter=';' firstobs=2;
	informat name $70.;
	informat address $40.;
	informat city $40.;
	informat custtype $30.;
	input custID $ name $ address $ city $ state $ zip $ custtype $;
	run;

* Convert the short-forms of the address to long ones for uniformity;
data MyLab3.PECCustomers;
	set MyLab3.PECCustomers;
	custtype=tranwrd(custtype, ',', '');
	custtype=tranwrd(custtype, 'COMERCIAL', 'COMMERCIAL');
	custtype=tranwrd(custtype, 'STATELOCALGOVT', 'STATE/LOCAL GOVT');
	custtype=tranwrd(custtype, 'USGOVT', 'US GOVT');
	address=tranwrd(address, 'Rd.', 'Road');
	address=tranwrd(address, 'St.', 'Street');
	address=tranwrd(address, 'Ave.', 'Av');
	address=tranwrd(address, 'Ave', 'Av');
	address=tranwrd(address, 'Av.', 'Av');
	address=tranwrd(address, 'Av', 'Avenue');
	address=tranwrd(address, 'Dr.', 'Drive');
	address=tranwrd(address, ', Road', ' Road');
	address=tranwrd(address, '. Road', ' Road');
	address=tranwrd(address, ', Avenue', ' Avenue');
	address=tranwrd(address, '. Avenue', ' Avenue');
	address=tranwrd(address, ', Street', ' Street');
	address=tranwrd(address, '. Street', ' Street');
	name = tranwrd(name, 'Incorporated', 'Inc');
	name = tranwrd(name, 'Inc.', 'Inc');
	name = tranwrd(name, 'Inc', 'Incorporated');
	name = tranwrd(name, 'Company', 'Co');
	name = tranwrd(name, 'Co.', 'Co');
	name = tranwrd(name, 'Co', 'Company');
	run;
	
/* Appending the leading zero to zip if zip is of 4 digits */
data MyLab3.PECCustomers;
	set MyLab3.PECCustomers;
	if length(strip(zip)) = 4 then zip = strip('0') || strip(substr(zip, 3, 4));
	run;
	
* To split the address to addr1 and addr2;
data MyLab3.PECCustomers;
	set MyLab3.PECCustomers;
	addr1 = scan(strip(address),1,",");
	addr2 = scan(strip(address),2,",");
	starting_char = substr(addr1, 1, 1);
	if starting_char not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then
		do;
			temp = addr2;
			addr2 = addr1;
			addr1 = temp;
		end;
	drop temp;
	drop starting_char;
	drop address;
	run;

* Print list of PECCustomers;
proc print data=MyLab3.PECCustomers;
	title 'List of PECCustomers';
	run;

* Export the clean data to a .csv file;
proc export data=MyLab3.PECCustomers outfile='/folders/myfolders/Lab3/PECcustomer_Clean.csv' dbms=dlm replace;
	delimiter=',';
	run;