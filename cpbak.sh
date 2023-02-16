#!/bin/bash

# Backup server configuration
dest_host="192.0.0.67"
dest_user="ubuntu"

# Backup directory configuration
backup_files="/home/"
remote_files="/home/ubuntu/manual-backup/daily"
remote_dbs="/home/ubuntu/manual-backup/mysql/daily"

# Log file configuration
log_file="/var/log/backup.log"

# Get the current date in YYYY-MM-DD format
day=$(date +%Y-%m-%d)

# Backup account files
echo "Backing up cPanel accounts..."
for i in $backup_files*/; do
    zip_file="${i%/}-$day.zip"
    zip -r "$zip_file" "$i"
    if [ $? -eq 0 ]; then
        echo "Compressed $i to $zip_file" >> $log_file
    else
        echo "Error: Failed to compress $i" >> $log_file
    fi
done

# Move compressed account files to backup server
echo "Moving compressed account files to backup server..."
scp "$backup_files"*.zip "$dest_user@$dest_host:$remote_files"
if [ $? -eq 0 ]; then
    echo "Moved compressed account files to $dest_user@$dest_host:$remote_files" >> $log_file
    rm -f "$backup_files"*.zip
else
    echo "Error: Failed to move compressed account files" >> $log_file
fi

# Backup databases
echo "Backing up databases..."
for db in $(mysql -e 'show databases' -s --skip-column-names); do
    sql_file="/tmp/$db-$day.sql"
    mysqldump "$db" > "$sql_file"
    if [ $? -eq 0 ]; then
        echo "Dumped $db to $sql_file" >> $log_file
    else
        echo "Error: Failed to dump $db" >> $log_file
    fi
done

# Move database backup files to backup server
echo "Moving database backup files to backup server..."
scp /tmp/*.sql "$dest_user@$dest_host:$remote_dbs"
if [ $? -eq 0 ]; then
    echo "Moved database backup files to $dest_user@$dest_host:$remote_dbs" >> $log_file
    rm -f /tmp/*.sql
else
    echo "Error: Failed to move database backup files" >> $log_file
fi
