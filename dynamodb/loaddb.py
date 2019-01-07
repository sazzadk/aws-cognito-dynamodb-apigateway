#!/usr/bin/python3
import json
import boto3

_file="sample_data.json"
table_name="movies"

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
print ("Creating table, may take a few seconds")
table = dynamodb.create_table(
    TableName=table_name,
    KeySchema=[
        {
            'AttributeName': 'id',
            'KeyType': 'HASH'  #Partition key
        }
    ],
    AttributeDefinitions=[
        {
            'AttributeName': 'id',
            'AttributeType': 'S'
        }
    ],
    ProvisionedThroughput={
        'ReadCapacityUnits': 5,
        'WriteCapacityUnits': 5
    }
)
# Wait until the table exists.
table.meta.client.get_waiter('table_exists').wait(TableName=table_name)
print("Table status:", table.table_status)
table = dynamodb.Table(table_name)

with open(_file) as json_file:
    movies = json.load(json_file)
   
    for movie in movies:
        id = movie['id']
        name = movie['name']
        description = movie['description']
        #print (movie)
        print("Adding movie:", id, name, description)

        table.put_item(
           Item={
               'id': id,
               'name': name,
               'description': description

            }
        )
