import json
import os

import boto3


ses_client = boto3.client(
    "ses",
    region_name=os.getenv(
        "AWS_REGION"
    )
)

SENDER_EMAIL = os.getenv(
    "SES_SENDER_EMAIL"
)


def send_email(

    recipient,

    subject,

    body

):

    ses_client.send_email(

        Source=f"Jojo <{SENDER_EMAIL}>",

        Destination={

            "ToAddresses": [

                recipient

            ]

        },

        Message={

            "Subject": {

                "Data": subject

            },

            "Body": {

                "Text": {

                    "Data": body

                }

            }

        }

    )


def lambda_handler(
    event,
    context
):

    for record in event["Records"]:

        message = json.loads(
            record["Sns"]["Message"]
        )

        event_type = message[
            "event_type"
        ]

        payload = message[
            "payload"
        ]

        if event_type == "user_registered":

            send_email(

                payload["email"],

                "Welcome to ProjectHub",

                (
                    f"Hello "
                    f"{payload['full_name']}, "
                    f"welcome to ProjectHub."
                )

            )

        elif event_type == "project_created":

            send_email(

                payload["user_email"],

                "Project Created",

                (
                    f"Your project "
                    f"{payload['project_title']} "
                    f"was created successfully."
                )

            )

        elif event_type == "file_uploaded":

            send_email(

                payload["user_email"],

                "Upload Successful",

                (
                    f"Your "
                    f"{payload['file_type']} "
                    f"upload completed successfully."
                )

            )

    return {

        "statusCode": 200

    }
