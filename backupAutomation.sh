#### This Script is about backing up data to a remote server on the daily basis at certain time period

### Author : Akash Mishra


### Backup Automation

#!/bin/bash

REMOTE_DIR="/home/akash/Desktop/remote"

echo "Welcome to Backup Automation"

echo "Intructions: Please put this script in the parent directory where you have your folder to backup"

#read -p "Enter the name of your folder to backup: " folderName

#if [ -d "$folderName" ]
#then
#	echo "It is a valid folder"
#else
#	echo "It is not a valid folder"
#fi


folderName=$1
while [ ! -d "$folderName" ]
do
	#read -p "Enter again: " folderName
	echo "Enter again"
done


# Archive the folder using tar
filename=$(date +'%Y-%m-%d_%H-%M-%S')

tar -cvf "${REMOTE_DIR}/${filename}.tar" "$folderName"

if [ $? -eq 0 ]; then
    echo "Archive done successfully"
else
    echo "Archive failed"
    exit 1
fi

# Compressing the archive
zip "${REMOTE_DIR}/${filename}.zip" "${REMOTE_DIR}/${filename}.tar"

if [ $? -eq 0 ]; then
    echo "Compression done successfully"
else
    echo "Compression failed"
    exit 1
fi

# Clean up the tar file if compression is successful
rm "${REMOTE_DIR}/${filename}.tar"


echo "Uploading to cloud"

bucketName=$2

aws s3 ls

read -p "Do you already have a s3 bucket (Y or N)? " userInp

if [ "$userInp" = "Y" ]; then
	echo "Moving inside Y block"
	aws s3 cp "${REMOTE_DIR}/${filename}.zip" s3://"$bucketName"
	if [ $? -eq 0 ]; then
                echo "Successfully uploaded"
        else
                echo "Error"
        fi
else
	aws s3 mb s3://"$bucketName"
	if [ $? -eq 0 ]; then
		aws s3 cp "${REMOTE_DIR}/${filename}.zip" s3://"$bucketName"
        	if [ $? -eq 0 ]; then
                	echo "Successfully uploaded"
        	else
                	echo "Error"
        	fi
	fi
fi

echo "Script ends"


