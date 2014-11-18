#!/bin/bash

#This script will run an analysis of content.
#Flag list:
#	-i = Install all databases and delete any data
#	-a = analyze the proposed file
#	-p = proposed file location


if ( ! getopts "iahfl" opt); then
	printf	"\nUsage: `basename $0` options:
		       	       -i = Install
			       -a = Analyze vs All Content
			       -f = Full Analysis; CurrentFile location, Spend Location, ProposedFile Location, Campus, Supplier Name
			       -l = Load Catalog File, Campus, Supplier Name
			       -h = help\n\n";
	exit $E_OPTERROR;
fi

while getopts "ifhal" opt; do
     case ${opt} in
	 a) sudo -u postgres psql -f "./sql/5.Run_Analysis.sql";;
	 i) sudo -u postgres psql -f "./sql/2.CreateDB.sql";;
	 f) CurrentFileLoc=$2
	    SpendLoc=$3
 	    ProposedFileLoc=$4
	    Campus=$5
	    SupplierName=$6
	    python ./python/contract_analysis.py $CurrentFileLoc $SpendLoc $ProposedFileLoc $Campus $SupplierName 
	    python ./python/create_unique_part.py $ProposedFileLoc $Campus $SupplierName
	    dos2unix $ProposedFileLoc
	    iconv -c -t UTF8 ./temp/proposed.csv > "./temp/proposed_cleaned.csv"
	    rm ./temp/proposed.csv
	    ;;
	 l) CatalogFileLoc=$2
	    Campus=$3
	    SupplierName=$4
	    python ./python/create_unique_part.py $CatalogFileLoc $Campus $SupplierName
	    sudo -u postgres psql -f "./sql/3.LoadSupplierCatalog.sql"
	    ;;
	 h) echo "h";;
     esac
done
