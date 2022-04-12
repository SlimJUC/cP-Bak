# cP-Bak


This is a very simple script to backup /home/$USER on cPanel/WHM 
And Do loop in mysql and backup each database indiviually 

Then it moves the generated backups to remote server (Backup Server)

# Usage

clone the script from repo

make it executable 
  chmod +x cpbak.sh
  
 
Then run it
  bash cpbak.sh
  
Or you can add it to crontab
