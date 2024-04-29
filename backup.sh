#!/bin/bash

dbs=(
"db1"
"db2"
)

filestore="/path/to/filestore"
backupdir="/path/to/backup/dirrectory"
tmp_path="/tmp/odoo/backups"
remove_after="15" # days

for db in ${dbs[@]}; do
  timestamp=$(date +"%Y-%m-%d_%H-%M-%N")
  tmp_path="$tmp_path_/$db/$timestamp"
  file_name="$backupdir/$db/${db}_$timestamp.zip"
      echo "sudo -u postgres mkdir -p ${tmp_path}"
  sudo -u postgres mkdir -p $tmp_path
      echo "mkdir -p $backupdir/$db"
  mkdir -p $backupdir/$db
      echo $tmp_path/dump.sql
      echo $tmp_path/filestore.zip
      echo $file_name
      echo "cd $tmp_path"
  cd $tmp_path
      echo "sudo -u postgres pg_dump -d $db -f $tmp_path/dump.sql --no-owner"
  sudo -u postgres pg_dump -d $db -f $tmp_path/dump.sql --no-owner
      echo "cd $filestore"
  cd $filestore
      echo "zip -r $tmp_path/filestore.zip $db"
  zip -r $tmp_path/filestore.zip $db
      echo "cd $tmp_path"
  cd $tmp_path
      echo "zip -r $file_name dump.sql filestore.zip"
  zip -r $file_name dump.sql filestore.zip
  rm -r $tmp_path
      echo "find $backupdir/$db -mtime +15 | xargs -d '\n' rm"
  find $backupdir/$db -mtime +$remove_after | xargs -d '\n' rm
done
