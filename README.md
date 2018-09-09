FCloud Docker Backup to Google Cloud
==============

To be able to backup home folders to Google Cloud.

Build
-----

./create-local-release.sh

Usage
-----

Environment variables to set:
- HOST_NAME: The hostname of the machine. Used in the path where the backup is saved.
- BUCKET: The name of the bucket in Google Cloud.
- JSON_KEY: The path to the file containing the Google Cloud key. (Default: /google-cloud-key.json)

Volume to mount:
- /backupRoot: The directory with sub-directories to save in separate tgz files.

The tar files will be saved in gs://$BUCKET/$HOST_NAME/$NOW/$DIR.tar.gz

Usage Example
-----

```
# Compile
./create-local-release.sh

# Create fake home directories
HOST_HOME_DIR=$(mktemp -d)
mkdir $HOST_HOME_DIR/user1
mkdir $HOST_HOME_DIR/user2
echo Testing > $HOST_HOME_DIR/user1/f1.txt
echo Testing > $HOST_HOME_DIR/user1/f2.txt
echo Testing > $HOST_HOME_DIR/user2/f3.txt

# Create the key
HOST_JSON_KEY=$(mktemp)
cat > $HOST_JSON_KEY << _EOF
{
  "type": "service_account",
  "project_id": "xxxxxx",
  "private_key_id": "xxxxxx",
  "private_key": "-----BEGIN PRIVATE KEY-----\nxxxxxx\n-----END PRIVATE KEY-----\n",
  "client_email": "xxxxxx@xxxxxx.iam.gserviceaccount.com",
  "client_id": "xxxxxx",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/xxxxxx%40xxxxxx.iam.gserviceaccount.com"
}
_EOF

# Execute 
docker run -ti --rm \
  --env HOST_NAME=$(hostname -f) \
  --env BUCKET=backup-bucket \
	--volume $HOST_JSON_KEY:/google-cloud-key.json \
	--volume $HOST_HOME_DIR:/backupRoot \
	fcloud-docker-backup-to-google-cloud:master-SNAPSHOT

```
