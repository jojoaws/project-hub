#!/bin/bash

set -e

echo "Building Lambda packages..."

cd lambda

echo "Removing old packages..."
rm -f function.zip notification.zip

echo "Packaging thumbnail Lambda..."
zip -rq function.zip \
    thumbnail.py \
    PIL \
    boto3 \
    botocore \
    urllib3 \
    dateutil \
    jmespath \
    s3transfer \
    pillow.libs \
    *.dist-info \
    six.py

echo "Packaging notification Lambda..."
zip -rq notification.zip \
    notification.py \
    boto3 \
    botocore \
    urllib3 \
    dateutil \
    jmespath \
    s3transfer \
    *.dist-info \
    six.py

echo "Done."
