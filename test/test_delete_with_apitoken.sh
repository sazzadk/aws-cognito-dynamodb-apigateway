#!/bin/bash
source ../00_env_vars.sh
xapikey=''
#token=`source ../cognito/get_new_api_token.sh`
token=''
rest_id=''
item=6
if [ -z $token ]
then
	echo "Please set the xapikey, token and rest_id first"
	exit 1
fi
url="https://${rest_id}.execute-api.${REGION}.amazonaws.com/${STAGE}/movies/$item"
payload='@payload.json'
curl -H "X-API-KEY: $xapikey" \
	-H "Authorization: $token" \
	-H "Content-Type:application/json" \
	-X DELETE  $url 
