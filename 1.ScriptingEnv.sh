#!/bin/bash

function setEnv() {

#This code sets up a Ubuntu environment with default tools for analytics
#It also adds directories for data and analytic results
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get -y install git
	sudo apt-get -y install dos2unix
	sudo apt-get -y install postgresql-9.3
	sudo apt-get -y install protobuf-c-compiler
	sudo apt-get -y install libprotobuf-c0-dev
	wget http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.1.0-Linux-x86_64.sh
	sudo chmod 777 Anaconda-2.1.0-Linux-x86_64.sh
	sudo bash Anaconda-2.1.0-Linux-x86_64.sh
	sudo apt-get -y install unzip
	sudo apt-get -y install make
        sudo apt-get -y install libpq-dev
	sudo apt-get -y install postgresql-server-dev-9.3
	wget https://github.com/citusdata/cstore_fdw/archive/master.zip
	unzip master.zip
	touch cstore_fdw-master/CatalogData.cstore
	sudo chmod -R 776 cstore_fdw-master

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
	sudo rm master.zip
}


setEnv
