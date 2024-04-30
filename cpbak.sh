#!/bin/bash
source cpbak.conf

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

# Function to check sshpass support
check_sshpass() {
    if ! command -v sshpass &> /dev/null; then
        echo "sshpass is not installed. Please install it using your package manager to use password-based SSH authentication." >> $log_file
        exit 1
    fi
}

# Function to upload files using SCP with SSH key
upload_scp_key() {
    echo "Moving compressed account files to backup server using SCP (SSH key)..."
    scp "$backup_files"*.zip "$dest_user@$dest_host:$remote_files"
    if [ $? -eq 0 ]; then
        echo "Moved compressed account files to $dest_user@$dest_host:$remote_files" >> $log_file
        rm -f "$backup_files"*.zip
    else
        echo "Error: Failed to move compressed account files" >> $log_file
    fi
}

# Function to upload files using SCP with password
upload_scp_pw() {
    check_sshpass
    echo "WARNING: Using password authentication for SSH is less secure than using SSH keys."
    sshpass -p $ssh_pass scp "$backup_files"*.zip "$dest_user@$dest_host:$remote_files"
    if [ $? -eq 0 ]; then
        echo "Moved compressed account files to $dest_user@$dest_host:$remote_files (password login)" >> $log_file
        rm -f "$backup_files"*.zip
    else
        echo "Error: Failed to move compressed account files (password login)" >> $log_file
    fi
}

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

# Select upload method based on command line argument
if [ "$1" = "ftp" ]; then
    upload_ftp
elif [ "$1" = "pw-login" ]; then
    upload_scp_pw
else
    upload_scp_key
fi
