import boto3
import urllib.request
import tempfile
import json

def get_secret():

    secret_name = "first_secret"
    region_name = "us-east-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )
    get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    secret = get_secret_value_response['SecretString']
    return(json.loads(secret))
    
    
def lambda_handler(event, context):
    print('enter lambda_handler')
    secrets=get_secret()
    print(type(secrets))
    
    url=secrets['url'] + secrets['color'] + secrets['filename']
    bucket = secrets['bucket']
    
    key = secrets['key'] + secrets['filename'] 

    s3 = boto3.client('s3')
    temppath = tempfile.gettempdir()
    urllib.request.urlretrieve(url, temppath+'/tempfile')
    s3.put_object(Bucket=bucket, Key=key, Body=open(temppath+'/tempfile','rb'))
    print('end')
