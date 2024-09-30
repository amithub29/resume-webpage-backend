import json
import boto3

def get_table_name():
    client = boto3.client("ssm")
    output = client.get_parameter(Name="/resume_website/prod/dynamodb/table_name")
    table_name = output['Parameter']['Value']
    return table_name


def lambda_handler(event, context):

    client = boto3.client("dynamodb")
    table = get_table_name()

    response = client.get_item(
        TableName=table, Key={"p_key": {"S": "counter"}}
    )

    counter = response["Item"]["p_value"]["N"]
    counter = int(counter) + 1

    client.update_item(
        ExpressionAttributeNames={
            "#pv": "p_value",
        },
        ExpressionAttributeValues={
            ":v": {
                "N": str(counter),
            },
        },
        Key={"p_key": {"S": "counter"}},
        ReturnValues="UPDATED_NEW",
        TableName=table,
        UpdateExpression="SET #pv = :v",
    )

    result = {"view_count": counter}

    return {
        "statusCode": 200,
        "body": json.dumps(result),
    }
