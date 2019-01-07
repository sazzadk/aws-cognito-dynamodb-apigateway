#!/bin/bash
source ../00_env_vars.sh
CWATCH_POLICY='AmazonAPIGatewayPushToCloudWatchLogs'
if [ -z "$POLICY_NAME" ]
then
        echo "Please set POLICY_NAME env var to policy name"
        exit 1
fi
if [ -z "$ROLE_NAME" ]
then
        echo "Please set ROLE_NAME env var to policy name"
        exit 1
fi
echo "Detaching role:$ROLE_NAME and policy:$POLICY_NAME"

policy_arn1=`aws iam list-attached-role-policies --role-name $ROLE_NAME|egrep '(PolicyArn)'|grep "$POLICY_NAME" | awk -F' ' '{print $2}'|sed 's/\"//g'`
policy_name1=`aws iam list-attached-role-policies --role-name $ROLE_NAME|egrep '(PolicyName)'|grep "$POLICY_NAME"|awk -F' ' '{print $2}'|sed 's/\"//g'`

policy_arn2=`aws iam list-attached-role-policies --role-name $ROLE_NAME|egrep '(PolicyArn)'|grep "$CWATCH_POLICY" | awk -F' ' '{print $2}'|sed 's/\"//g'`
if [ $policy_arn1 != '' ]
then
        echo "role = $policy_name1 arn = $policy_arn1"
        aws iam detach-role-policy  --role-name $ROLE_NAME --policy-arn $policy_arn1
        echo "Deleting Policy $policy_name1"
        aws iam delete-policy --policy-arn $policy_arn1
else
        echo "Could not detach or delete policy becuase unable to find Policy ARN"
	echo "ARN=$policy_arn"
#        exit 1
fi
if [ $policy_arn2 != '' ]
then
	echo "role = $CWATCH_POLICY arn = $policy_arn2"
	aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $policy_arn2
else
	echo "Could not detach the cloudwatch policy"
	exit 1
fi

echo "Deleting the Role"
aws iam delete-role --role-name $ROLE_NAME
