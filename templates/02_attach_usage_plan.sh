#!/bin/bash
source ../00_env_vars.sh
stage="$STAGE"
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


echo "Creating API Key for GET method"
response=`aws apigateway create-api-key \
	--name "$APIKEY" \
	--description 'Used for development' \
	--enabled --stage-keys restApiId="$api_id",stageName="$stage"`
echo $response > keylog.txt
key_id=`cat ./keylog.txt |tr ',' '\012'|grep "id" |awk -F' ' '{print $3}'|sed 's/[,"]//g'`
echo "key_id = $key_id"
echo "Creating usage plan for throttling"
response=`aws apigateway create-usage-plan \
	--name "$USAGEPLAN" \
	--description "Limited use rates for dev" \
	--api-stage apiId="$api_id",stage="$stage" \
	--throttle burstLimit=1,rateLimit=2 \
	--quota limit=100,offset=0,period=MONTH`

echo $response >> keylog.txt
plan_id=`echo $response|tr ',' '\012'|grep "id"|awk -F' ' '{print $3}'|sed 's/[,"]//g'`
echo "Adding API key to the usage plan just created"
echo "plan_id = $plan_id"
aws apigateway create-usage-plan-key --usage-plan-id $plan_id --key-type "API_KEY" --key-id $key_id
