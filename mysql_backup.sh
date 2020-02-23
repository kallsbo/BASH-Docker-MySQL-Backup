#! /bin/bash
#
# Automated backup of MySQL Databases running on docker
#
# Kristofer Källsbo 2020 www.hackviking.com
#
# Usage: mysql_backup.sh {container name begining} {path} {days of retention}
#
# The script will backup each database and then remove files older then the set
# days of retention. It will only delete files if the new backup completes.
#
# Thanks to Mattias Geniar for the insperation
# https://ma.ttias.be/mysql-back-up-take-a-mysqldump-with-each-database-in-its-own-sql-file/
#

# Check that we found the container
if [ ! -z $1 ]; then
	# Get container ID
	CONTAINER_ID=$(sudo docker container ls -qf "NAME=^$1")

	# Check that we got an ID
	if [ ${#CONTAINER_ID} -lt 1 ]; then
		echo "ERROR: Container not found!" ; exit
	else
		echo "Container ${CONTAINER_ID} found!"
	fi
fi

# Check that we have a path
if [[ ! -d $2 ]]; then
	echo "ERROR: Backup path not found!" ; exit
else
	echo "Backing up to $2"
fi

# Store now
_now=$(date +"%Y.%m.%d")

# List databases
docker exec $CONTAINER_ID mysql -N -e 'show databases' |
while read dbname; do # Loop the result
	# Backup the database
	echo "Starting backup of database $dbname"
	docker exec $CONTAINER_ID mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > $2/"$dbname".$_now.sql.bak
	echo "Backup of $dbname completed!"
	
	# Check for retention paramter
	if [ ! -z $3 ]; then
		# Clear old backups
		find $2/* -mtime +$3 -exec rm {} \;
	fi
done
