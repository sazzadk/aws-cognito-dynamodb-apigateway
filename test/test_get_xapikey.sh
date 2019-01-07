#!/bin/bash
source ../00_env_vars.sh
xapikey=""
rest_id=""
if [ -z $xapikey ] 
then
	echo "Please get the API Key first"
	exit 1
fi
region="$REGION"
url="https://${rest_id}.execute-api.${REGION}.amazonaws.com/${STAGE}/movies"
curl -H "X-API-KEY: $xapikey" $url
