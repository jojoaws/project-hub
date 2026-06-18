import os

from io import BytesIO

import boto3

from PIL import Image


s3_client = boto3.client("s3")


THUMBNAIL_SIZE = (
    300,
    300
)


def lambda_handler(
    event,
    context
):

    for record in event["Records"]:

        bucket = record["s3"]["bucket"]["name"]

        key = record["s3"]["object"]["key"]

        if not key.startswith(
            "project-images/"
        ):

            continue

        response = s3_client.get_object(

            Bucket=bucket,

            Key=key

        )

        image = Image.open(
            response["Body"]
        )

        image.thumbnail(
            THUMBNAIL_SIZE
        )

        buffer = BytesIO()

        image.save(
            buffer,
            format="JPEG"
        )

        buffer.seek(0)

        thumbnail_key = (
            f"thumbnails/{os.path.basename(key)}"
        )

        s3_client.put_object(

            Bucket=bucket,

            Key=thumbnail_key,

            Body=buffer,

            ContentType="image/jpeg"

        )

    return {

        "statusCode": 200

    }
