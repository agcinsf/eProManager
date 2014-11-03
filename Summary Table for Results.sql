---Idea here is to create a Summary table to understand what is going on with the pricing

DROP TABLE IF EXISTS Summary;
Create Table Summary
(
   "Total Items in Supplier Catalog" int,	
   "Count of Lowest" int,
   "Count of Not Lowest" int,
   "Count of Equal" int,
   "Count of Unique Offerings" int
   );


INSERT INTO Summary
( "Total Items in Supplier Catalog",	
   "Count of Lowest",
   "Count of Not Lowest",
   "Count of Equal",
   "Count of Unique Offerings"
   )
values
(1,1,1,1,1);
   
UPDATE Summary 
SET 
"Total Items in Supplier Catalog"=
(SELECT
Count(*) 
FROM
Supplier),

"Count of Lowest" =
(SELECT       
COUNT(DISTINCT("Part Number")) 
    FROM
          (SELECT
           *
           FROM
           Proposed_Edited
           WHERE
           "Other Supplier" IS NOT NULL) as Filtered
       WHERE
       "Lowest/Not?" = 'Lowest'),

"Count of Not Lowest" =
(SELECT       
COUNT(DISTINCT("Part Number")) 
    FROM
          (SELECT
           *
           FROM
           Proposed_Edited
           WHERE
           "Other Supplier" IS NOT NULL) as Filtered
       WHERE
       "Lowest/Not?" = 'Not Low Price'),

"Count of Equal" =
(SELECT       
COUNT(DISTINCT("Part Number")) 
    FROM
          (SELECT
           *
           FROM
           Proposed_Edited
           WHERE
           "Other Supplier" IS NOT NULL) as Filtered
       WHERE
       "Lowest/Not?" = 'Equal'),

"Count of Unique Offerings" =
(SELECT       
COUNT(DISTINCT("Part Number")) 
    FROM
          (SELECT
           *
           FROM
           Proposed_Edited
           WHERE
           "Other Supplier" IS NULL) as Filtered);

COPY Summary TO '/home/analyst/Desktop/USA.csv' WITH (FORMAT CSV, HEADER)
