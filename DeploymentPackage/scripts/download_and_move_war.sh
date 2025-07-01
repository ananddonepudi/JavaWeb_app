#!/bin/bash

echo "Downloading JavaWebApp.war from S3..."
aws s3 cp s3://mycode-s3-ad/Jproj/target/JavaWebApp.war /usr/share/tomcat/webapps/
chmod 644 /usr/share/tomcat/webapps/JavaWebApp.war
echo "Download completed."
