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


--Load the all catalog file
COPY supplier FROM '/home/analyst/eProManager/temp/proposed.csv' with (FORMAT CSV); 


----Get rid of Price Removed and change to decimal type data 
 UPDATE supplier 
 SET "Price" = 0 
 WHERE 
 "Price" = 'Price Removed'
 OR 
 "Price" = 'Call for price'; 
 
--update the supplier table
ALTER TABLE supplier ALTER "Price" TYPE DECIMAL USING ("Price"::DECIMAL);


--This table holds the item attributes for each item and is key to this application
 INSERT INTO Products
("Unique ID","Manufacturer Name","Manufacturer Part Number","Packaging UOM")
 SELECT 
  DISTINCT Sub."Unique ID",
  Sub."Manufacturer Name",
  Sub."Manufacturer Part Number",
  Sub."Packaging UOM"
 FROM 
	 (SELECT  
	 DISTINCT Supplier."Unique ID",
	 Supplier."Manufacturer Name",
	 Supplier."Manufacturer Part Number",
	 Supplier."Packaging UOM" 
	 FROM Supplier
	 LEFT JOIN Products
	 ON Supplier."Unique ID" = Products."Unique ID"
	 WHERE Products."Unique ID" IS NULL) as Sub;
  
---Since we aren't doing anything fancy with new vs old pricing, then just continuously
---add all price items

--Then after insert into Pricing
INSERT INTO Pricing
   ("Unique ID",
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
   Supplier;
