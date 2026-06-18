import json
import os

import boto3


sns_client = boto3.client(
    "sns",
    region_name=os.getenv(
        "AWS_REGION"
    )
)

SNS_TOPIC_ARN = os.getenv(
    "SNS_TOPIC_ARN"
)


def publish_event(

    event_type: str,

    payload: dict

):

    sns_client.publish(

        TopicArn=SNS_TOPIC_ARN,

        Message=json.dumps({

            "event_type": event_type,

            "payload": payload

        })

    )
