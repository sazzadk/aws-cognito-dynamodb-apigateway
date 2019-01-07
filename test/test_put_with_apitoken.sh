#!/bin/bash
source ../00_env_vars.sh
xapikey=''
rest_id=''
region="$REGION"
#token=`source ../cognito/get_new_api_token.sh`
token=''
url="https://${rest_id}.execute-api.${REGION}.amazonaws.com/${STAGE}/movies"
payload='@payload.json'
curl -H "X-API-KEY: $xapikey" \
	-H "Authorization: $token" \
	-H "Content-Type:application/json" \
	-X PUT  $url \
	-d $payload
