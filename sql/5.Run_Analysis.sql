--Load the data into the Supplier table (Verified)
DROP TABLE IF EXISTS supplier; 

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

COPY supplier FROM '/home/analyst/Desktop/temp/proposed.csv' with (FORMAT CSV, HEADER);


--Clean the data (VERIFIED)
UPDATE Supplier
SET "Price" = 0
WHERE "Price" = 'Price Removed';
ALTER TABLE Supplier ALTER "Price" TYPE DECIMAL USING ("Price"::DECIMAL);


--Set Index on Unique ID fields
CREATE INDEX ON supplier("Unique ID");

--Clean up the Proposed_Edited file
DELETE FROM Proposed_Edited *;

--Update the Database Statistics
ANALYZE; 


--Run the analysis of the file and insert results into Proposed Editied table.
INSERT INTO Proposed_Edited
SELECT
	S."Part Number",
 	S."Product Description",
 	S."Product Size",
	S."Packaging UOM",
 	S."Price",
 	S."List Price",
 	S."List vs.  Price % Change",
 	S."12 Month Quantity Ordered",
 	S."Average Price per Quantity",
 	S."Total Estimated Impact",
 	S."Product Visible",
 	S."Reason not Visible",
 	S."Included in Product Views",
 	S."Manufacturer Name",
 	S."Manufacturer Part Number",
 	S."Category",
 	S."Category UNSPSC",
 	S."Commodity Code",
 	S."UNSPSC",
 	S."UOM Edited",
 	S."Unique ID",
 	S."Supplier",
 	S."Campus/UCOP",
 	S."Date Uploaded",
 	P."Supplier" as "Other Supplier",
 	P."Part Number" as "Other Part Number",
 	P."Campus/UCOP" as "Other Campus/UCOP",
 	P."Date Uploaded" as "Recent Date",
 	P."Price" as "Other Price",
 	(S."Price" - P."Price") as "Difference",
	(SELECT CASE 
              WHEN (S."Price" - P."Price")>0
                 THEN 'Not Low Price'
              WHEN S."Price" = P."Price"
                 THEN 'Equal'
              Else 'Lowest'
              END ) as "Lowest/Not_Lowest"
        FROM 
        Supplier S
        LEFT JOIN 
        ---This gives us the Pricing for Products with Max Dates
           (SELECT 
            * 
            FROM 
            Pricing
            LEFT JOIN
            ---Overall gets max dates and an identifier from all pricing,
               (SELECT 
                CONCAT("Unique ID","Supplier","Campus/UCOP") as "Identifier",
                Max("Date Uploaded") as "Max Date"
                FROM 
                Pricing
                GROUP BY
                "Identifier") AS Getting_Max_Dates
             ON 
             CONCAT(Pricing."Unique ID",Pricing."Supplier",Pricing."Campus/UCOP") = Getting_Max_Dates."Identifier"
             WHERE 
             Pricing."Date Uploaded" = "Max Date") as P
        ON
        S."Unique ID" = P."Unique ID"
        AND 
	S."Supplier" != P."Supplier"
	GROUP BY
	S."Part Number",
 	S."Product Description",
 	S."Product Size",
	S. "Packaging UOM",
 	S."Price",
 	S."List Price",
 	S."List vs.  Price % Change",
 	S."12 Month Quantity Ordered",
 	S."Average Price per Quantity",
 	S."Total Estimated Impact",
 	S."Product Visible",
 	S."Reason not Visible",
 	S."Included in Product Views",
 	S."Manufacturer Name",
 	S."Manufacturer Part Number",
 	S."Category",
 	S."Category UNSPSC",
 	S."Commodity Code",
 	S."UNSPSC",
 	S."UOM Edited",
 	S."Unique ID",
 	S."Supplier",
 	S."Campus/UCOP",
 	S."Date Uploaded",
 	"Other Supplier",
 	"Other Part Number",
 	"Other Campus/UCOP",
 	"Recent Date",
 	"Other Price";
