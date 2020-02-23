# BASH-Docker-MySQL-Backup
Script for backing up all MySQL databases running in a docker container.

Usage:
**./docker_musql.sh {container name} {backup path} {optional: days of retention}**

### **container name**
To be able to mach containers in a swarm with defferent endings you only need to supply the begining of the name, enough to match a sigle container.

### **backup path**
Tha absolute path of the folder where to dump the backup files.

### **days of retention (optional)**
Number of days to store the backup. When the script runs it will clear out older backups for each database after backup is performed.

Thanks to [Mattias Geniar](https://ma.ttias.be/mysql-back-up-take-a-mysqldump-with-each-database-in-its-own-sql-file/) for the insperation!
