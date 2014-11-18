
--Load the all catalog file
COPY All_catalogs FROM '/home/analyst/Downloads/AllCatalogs.csv' with (FORMAT CSV); 


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



--Split the AllCatalogs table into Products and Pricing
INSERT INTO  
 	Products ("Unique ID",
		  "Manufacturer Name",
		  "Manufacturer Part Number",
		  "Packaging UOM") 
SELECT  
	 DISTINCT "Unique ID",  
	 "Manufacturer Name",  
	 "Manufacturer Part Number",  
	 "Packaging UOM"  
FROM  
	All_Catalogs; 

--Split out the AllCatalogs table in Pricing (Modified from Alexis' Code)
INSERT INTO 
	Pricing ("Unique ID",
		 "Campus",
		 "Supplier",
		 "Part Number", 
		 "Price",
		 "Date Uploaded")

 SELECT
	 "Unique ID", 
	 "Campus/UCOP",
	 "Supplier", 
	 "Part Number",  
	 "Price",
	 "Date Uploaded"
 FROM 
 	All_Catalogs;

  ----Get rid of Price Removed and change to decimal type data 
 UPDATE Pricing 
 SET "Price" = 0 
 WHERE 
 "Price" = 'Price Removed'
 OR 
 "Price" = 'Call for price'; 
 
ALTER TABLE Pricing ALTER "Price" TYPE DECIMAL USING ("Price"::DECIMAL);

