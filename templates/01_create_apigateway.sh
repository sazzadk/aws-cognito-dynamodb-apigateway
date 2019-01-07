#!/bin/bash
source ../00_env_vars.sh
#TEMPLATE="./final_api_gw/01_with_CORS_MoviesAPI-development-swagger-apigateway.yaml"
echo "Creating API Gateway from config file"
aws apigateway import-rest-api \
    --parameters endpointConfigurationTypes='REGIONAL' \
   --fail-on-warnings \
   --body 'file://$TEMPLATE'

echo "Creating Deployment endpoint"
idlist=`aws apigateway get-rest-apis|egrep '(id|name)'`
getid()
{
 #echo "input = $1"
 echo $1|tr ',' '\012'| while IFS= read -r line1
 do
        read line2
        id=`echo $line1|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
        name=`echo $line2|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
        if [ "$name" = "$APINAME" ]
        then
                echo $id
        fi
 done
}
api_id=`getid "$idlist"`
response=`aws apigateway create-deployment --rest-api-id "$api_id" \
	--stage-name "$STAGE" \
	--stage-description "$STAGE" \
	--description "$STAGE"`
echo "$response" > endpoint.txt
url="https://$api_id.execute-api.${REGION}.amazonaws.com/${STAGE}"
echo "Invoke URL is $url"
