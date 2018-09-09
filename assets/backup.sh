#!/bin/bash

set -e

# Check the environment variables are present 
if [ -z "$HOST_NAME" ]; then
	echo HOST_NAME environment is not set
	exit 1
fi
if [ -z "$BUCKET" ]; then
	echo BUCKET environment is not set
	exit 1
fi

if [ -z "$JSON_KEY" ]; then
	export JSON_KEY=/google-cloud-key.json
fi
if [ ! -f $JSON_KEY ]; then
  echo Key file $JSON_KEY is missing
	exit 1
fi

BACKUP_ROOT=/backupRoot
PATH=$PATH:/usr/local/sbin
NOW=$(date +%Y-%m-%d-%H-%M-%S)

# Ensure key permissions
chmod 600 $JSON_KEY

# Log in Google Cloud
gcloud auth activate-service-account --key-file $JSON_KEY

# Users
cd $BACKUP_ROOT
for DIR in $(ls)
do
  tar -zc $DIR | /usr/bin/gsutil cp - gs://$BUCKET/$HOST_NAME/$NOW/$DIR.tar.gz
done
