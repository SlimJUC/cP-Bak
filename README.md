# cP-Bak | cPanel/WHM Server Backup Script

This cPanel / WHM backup script provides a flexible and secure way to backup server files and databases. It supports uploading backups to a remote server via SCP or FTP and includes an option for SSH password authentication. The script is configurable, allowing easy adjustment of server settings, paths, and credentials.

## Features

- **File Backup**: Compresses and backs up users in home directories in cPanel server.
- **Database Backup**: Dumps MySQL databases into SQL files.
- **Flexible Upload Options**: Supports file transfer via SCP (using SSH keys or password) and FTP.
- **Configurable**: All settings are centralized in a configuration file for ease of management.
- **Secure**: Warns about the security implications of using password-based SSH authentication.

## Prerequisites

Before using this backup script, ensure the following prerequisites are met:

- **Linux Environment**: The script is designed to run on Linux.
- **MySQL Server**: Required for database backups.
- **Zip**: Ensure `zip` is installed to handle file compression.
- **SSHpass**: Required for password-based SSH authentication (`sshpass` must be installed if using this method).
- **LFTP**: Necessary for FTP transfers.
- **SSH Client**: Required for SCP transfers.

You can install the necessary packages using the following commands (for Ubuntu-based systems):

```bash
sudo apt-get update
sudo apt-get install zip mysql-client sshpass lftp openssh-client
```

## Configuration

Update The `cpbak.conf` file.

Change permission to file:

```bash
chmod +x # To make the file executable.
```

Here are a list of config parameters:

Here are the configuration parameters you need to set:

- dest_host: Destination host for `SCP` or `FTP`.
- dest_user: Username for `SCP` or `FTP`.
- ssh_pass: Password for `SSH` (use only if necessary, not recommended).
- ftp_host: FTP server address.
- ftp_user: FTP username.
- ftp_pass: FTP password.
- backup_files: Directory to backup.
- remote_files: Remote directory for storing file backups.
- remote_dbs: Remote directory for storing database backups.
- log_file: Path to the log file.

## Usage
To use the backup script, execute it with the desired option:
```bash
# Default (SCP using SSH keys)
./backup_script.sh

# SCP with password (not secure)
./backup_script.sh pw-login

# FTP
./backup_script.sh ftp
```

