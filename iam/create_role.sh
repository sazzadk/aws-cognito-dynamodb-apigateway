#!/bin/bash
source  ../00_env_vars.sh
ROLE_DEF="iam_api_role.json"
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
echo "Creating role $ROLE_NAME"
aws iam create-role --role-name ${ROLE_NAME} \
    --assume-role-policy-document file://${ROLE_DEF} --profile $PROFILE

echo "Attaching CloudWatch Log policy to the role"
#Add Policy for API Gateway to write to logs
ROLE_POLICY_ARN="arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
aws iam attach-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-arn "${ROLE_POLICY_ARN}"  --profile ${PROFILE}
echo "Creating dynamodb access policy"
#Create DynamoDB Policy
aws iam create-policy --policy-name ${POLICY_NAME} --policy-document file://iam_api_dynamo_policy.json --profile ${PROFILE}

echo "Attaching dynamodb access policy to the api gateway role"
#Attach Policy for API Gateway to access DynamoDB
ROLE_POLICY_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${POLICY_NAME}"
aws iam attach-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-arn "${ROLE_POLICY_ARN}"  --profile ${PROFILE}
