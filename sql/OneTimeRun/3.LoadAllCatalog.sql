
--Load the all catalog file
COPY All_catalogs FROM '/home/analyst/Desktop/AllCatalogs.csv' with (FORMAT CSV); 


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

DROP FOREIGN TABLE IF EXISTS Pricing;  
DROP TABLE IF EXISTS Pricing;
CREATE TABLE Pricing ( 
	  "Unique ID" text,  
	  "Campus" text,
	  "Distributor" text,
	  "Distributor Part Number" text,
	  "Price" text,
	  "Date Uploaded" text   
);

--Split out the AllCatalogs table in Pricing (Modified from Alexis' Code)
INSERT INTO 
	Pricing ("Unique ID",
		 "Campus",
		 "Distributor",
		 "Distributor Part Number", 
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

