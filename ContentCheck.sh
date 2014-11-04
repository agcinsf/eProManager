#!/bin/bash

#This script will run an analysis of content.
#Flag list:
#	-i = Install all databases and delete any data
#	-a = analyze the proposed file
#	-p = proposed file location


if ( ! getopts "iaph" opt); then
	printf	"\nUsage: `basename $0` options:
		       	       -i = Install 
			       -p = Proposed File Location, Campus, Supplier Name
			       -a = Analyze Proposed File 
			       -h = help\n\n";
	exit $E_OPTERROR;
fi

while getopts "iaph" opt; do
     case ${opt} in
         p) fileloc=$2
	    campus=$3
	    supplier=$4
	    dos2unix $fileloc
	    python ./python/create_unique_part.py $fileloc $campus $supplier
	    iconv -c -t UTF8 ./temp/proposed.csv > "./temp/proposed_cleaned.csv"
	    rm ./temp/proposed.csv
	;;
	    
	 i) sudo -u postgres psql -f "./sql/2.CreateDB.sql";;
	 a) sudo -u postgres psql -f "./sql/5.Run_Analysis.sql";;
	 h) echo "h";;
     esac
done
