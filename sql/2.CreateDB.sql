--SQL CODE TO CREATE THE DATABASE AND ASSOCIATED TABLES
--The format comes from SciQuest single catalog extract

CREATE DATABASE CatalogAnalysis;
CREATE EXTENSION cstore_fdw;
CREATE SERVER cstore_server FOREIGN DATA WRAPPER cstore_fdw;

DROP FOREIGN TABLE IF Exists Supplier;
DROP TABLE IF Exists Supplier;
--This table is a temporary table used to hold raw files out of SciQuest
CREATE TABLE Supplier (
	"Part Number" text,  
	"Product Description" text,  
	"Product Size" text,  
	"Packaging UOM" text,  
	"Price" text,  
	"List Price" text,  
	"List vs.  Price % Change" text,  
	"12 Month Quantity Ordered" text,  
	"Average Price per Quantity" text,  
	"Total Estimated Impact" text,  
	"Product Visible" text,  
	"Reason not Visible" text,  
	"Included in Product Views" text,  
	"Manufacturer Name" text,  
	"Manufacturer Part Number" text,  
	"Category" text,  
	"Category UNSPSC" text,  
	"Commodity Code" text,  
	"UNSPSC" text,  
	"UOM Edited" text,  
	"Unique ID" text,  
	"Supplier" text,  
	"Campus/UCOP" text,  
	"Date Uploaded" text
);



--This table is a temp table to hold the initial seed content for BearBuys
CREATE FOREIGN TABLE All_Catalogs (
	"12 Month Quantity Ordered" text, 
	"Average Price per Quantity" text, 
	"Campus/UCOP" text,  
	"Category" text,  
	"Category UNSPSC" text,  
	"Commodity Code" text,  
	"Date Uploaded" text,  
	"Included in Product Views" text,  
	"List Price" text,  
	"List vs.  Price % Change" text,  
	"Manufacturer Name" text,  
	"Manufacturer Part Number" text,  
	"Packaging UOM" text,  
	"Part Number" text,  
	"Price" text,  
	"Product Description" text,  
	"Product Size" text,  
	"Product Visible" text,  
	"Reason not Visible" text,  
	"Supplier" text,  
	"Total Estimated Impact" text,  
	"UNSPSC" text, 
	"UOM Edited" text,  
	"Unique ID" text  
)  
SERVER cstore_server
OPTIONS(filename '/home/analyst/cstore_fdw-master/CatalogData.cstore',
	compression 'pglz');


--This table holds a transform of the supplier table data
DROP TABLE IF EXISTS Proposed_Edited;

Create TABLE Proposed_Edited
(
 "Part Number" text,
 "Product Description" text,
 "Product Size" text,
 "Packaging UOM" text,
 "Price" text,
 "List Price" text,
 "List vs.  Price % Change" text,
 "12 Month Quantity Ordered" text,
 "Average Price per Quantity" text,
 "Total Estimated Impact" text,
 "Product Visible" text,
 "Reason not Visible" text,
 "Included in Product Views" text,
 "Manufacturer Name" text,
 "Manufacturer Part Number" text,
 "Category" text,
 "Category UNSPSC" text,
 "Commodity Code" text,
 "UNSPSC" text,
 "UOM Edited" text,
 "Unique ID" text,
 "Supplier" text,
 "Campus/UCOP" text,
 "Date Uploaded" text,
 "Other Supplier" text,
 "Other Part Number" text,
 "Other Campus/UCOP" text,
 "Recent Date" text,
 "Other Price" text,
 "Difference" text,
 "Lowest/Not?" text
 );
 


--This table holds the item attributes for each item and is key to this application
DROP FOREIGN TABLE IF Exists Products;  
DROP TABLE IF Exists Products; 
CREATE TABLE Products  (  
	 "Unique ID" text, 
	 "Manufacturer Name" text,  
	 "Manufacturer Part Number" text, 
	 "Packaging UOM" text   
);


--This table holds all instances of pricing approved into an ePro environment
DROP FOREIGN TABLE IF EXISTS Pricing;  
DROP TABLE IF EXISTS Pricing;
CREATE TABLE Pricing ( 
	  "Unique ID" text,  
	  "Campus" text,
	  "Supplier" text,
	  "Part Number" text,
	  "Price" text,
	  "Date Uploaded" text   
);


--Create a Concat function in the database
CREATE OR REPLACE FUNCTION CONCAT(text, text,text) 
RETURNS text 
LANGUAGE SQL 
AS $$
  SELECT $1||$2 || $3;
$$;



