#!/bin/bash

dest_host="192.0.0.67" # Backup server IP (Note: Your cpanel server must be able to ssh to backup server. Use ssh-keys)
dest_user="ubuntu" # Backup Server User
day=$(date +%Y-%m-%d)
backup_files='/home/' # Location of cpanel accounts to backup (usually inside /home/)
remote_files='/home/ubuntu/manual-backup/daily' # Path to where you want to save the files backup
remote_dbs='/home/ubuntu/manual-backup/mysql/daily' # Path to where you want to save the database backup




# Backup Account files


for i in $backup_files*/; do            #   This will loop through the home dir
    zip "${i%/}-$day.zip" -r "$i" ;     #   And then compress each account indivually
     done

scp $backup_files*.zip $dest_user@$dest_host:$remote_files # This will move the compressed accounts to the backup server
rm -f /home/*.zip                                          # This will delete the generated archives after moving

# Backup Databases

for DB in $(mysql -e 'show databases' -s --skip-column-names); do # This will loop through databases
    mysqldump $DB > "/tmp/$DB-$day.sql";                               # This will dump the databases info SQL files
done

# Move DB backups to backup server

scp /tmp/*.sql $dest_user@$dest_host:$remote_dbs # This will move the DB files to the backup server
rm -f /tmp/*.sql                                 # This will delete the generated database after moving

