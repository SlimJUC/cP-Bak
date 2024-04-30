# Backup Script

This backup script provides a flexible and secure way to backup server files and databases. It supports uploading backups to a remote server via SCP or FTP and includes an option for SSH password authentication. The script is configurable, allowing easy adjustment of server settings, paths, and credentials.

## Features

- **File Backup**: Compresses and backs up specified directories.
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
