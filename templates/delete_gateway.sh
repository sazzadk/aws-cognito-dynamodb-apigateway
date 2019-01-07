#!/bin/bash
source ../00_env_vars.sh
export APINAME="MoviesAPI"
export APIKEY="development-api-plan-key"
export USAGEPLAN="Basic"
idlist=`aws apigateway get-rest-apis|egrep '(id|name)'`
getid()
{
 #echo "input = $1 and $2"
 echo $1|tr ',' '\012'| while IFS= read -r line1
 do
        read line2
        id=`echo $line1|awk -F':' '{print $2}'|sed 's/^[[:space:]]*//'|sed 's/[,"]//g'`
        name=`echo $line2|awk -F':' '{print $2}'|sed 's/^[[:space:]]*//'|sed 's/[,"]//g'`
        if [ "$name" = "${2}" ]
        then
                echo $id
		break
        fi
 done
}
api_id=`getid "$idlist" "$APINAME"`
echo "api id = $api_id"
echo "Deleting stage"
aws apigateway delete-stage \
	--rest-api-id "$api_id" \
	--stage-name "$STAGE"

echo "Deleting rest API"
aws apigateway delete-rest-api \
	--rest-api-id "$api_id"
echo "Deleting API Keys"
keylist=`aws apigateway get-api-keys |egrep '(id|name)'`
key_id=`getid "$keylist" "${APIKEY}"`
echo "Found key = $key_id"
aws apigateway delete-api-key --api-key "$key_id"

echo "Deleting API Usage plan"
plans=`aws apigateway get-usage-plans|egrep '(name|id)'`
plan_id=`getid "$plans" "${USAGEPLAN}"`
echo "Found plan = $plan_id"
aws apigateway delete-usage-plan --usage-plan-id "$plan_id"
