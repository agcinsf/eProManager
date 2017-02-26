#!/bin/bash

function setEnv() {

#This code sets up a Ubuntu environment with default tools for analytics
#It also adds directories for data and analytic results
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get -y install git
	sudo apt-get -y install dos2unix
	sudo apt-get -y install python-dev
	sudo apt-get -y install python-pip
	sudo chmod 777 /home/analyst/anaconda/lib/python2.7/site-packages/

	#Need to get fuzzy 
	#wget https://pypi.python.org/packages/source/F/Fuzzy/Fuzzy-1.0.tar.gz
	#pip install -e https://pypi.python.org/packages/source/F/Fuzzy/Fuzzy-1.0.tar.gz
	sudo apt-get -y install postgresql-9.3
	sudo apt-get -y install protobuf-c-compiler
	sudo apt-get -y install libprotobuf-c0-dev
	
	#Anaconda Python needs to be installed Manually
	#Go to the home page and download it.
	#Then use bash on the file and it will install.

	sudo apt-get -y install unzip
	sudo apt-get -y install make
        sudo apt-get -y install libpq-dev
	sudo apt-get -y install postgresql-server-dev-9.3
	wget https://github.com/citusdata/cstore_fdw/archive/master.zip
	unzip master.zip
	sudo rm master.zip
	touch cstore_fdw-master/CatalogData.cstore
	sudo chmod -R 777 cstore_fdw-master
	sudo apt-get install google-drive-ocamlfuse


	#Install coopr.pyomo
	pip install coopr
	pip install coopr.extras

	cd cstore_fdw-master
	PATH=/usr/lib/postgresql/9.3/bin:$PATH make
	sudo PATH=/usr/local/pgsql/bin/:$PATH make install
	sudo sed -i "s/shared_pre.*/shared_preload_libraries = 'cstore_fdw'/g" /etc/postgresql/9.3/main/postgresql.conf
	sudo sed -i "s/\#shared_pre.*/shared_preload_libraries = 'cstore_fdw'/g" /etc/postgresql/9.3/main/postgresql.conf
	sudo sed -i "s/\#password_encryption.*/password_encryption = 'on'/g" /etc/postgresql/9.3/main/postgresql.conf

	cd
	sudo /etc/init.d/postgresql restart
	
	#Create a Google Drive mount
	mkdir /Desktop/Google-Drive
	google-drive-ocamlfuse /Desktop/Google-Drive

	
}


setEnv
