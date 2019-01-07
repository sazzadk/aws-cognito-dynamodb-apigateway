#!/bin/bash
source ../00_env_vars.sh
LOG="./cognitologs.txt"
echo "" > $LOG
echo "Creating new user pool"

pool_create_res=`aws cognito-idp create-user-pool --pool-name $POOL_NAME`
pools=`aws cognito-idp list-user-pools --max-results 10|egrep '(Id|Name)'`
echo "$pool_create_res" >> $LOG
getid()
{
 #echo "input = $1"
 echo $1|tr ',' '\012'| while IFS= read -r line1
 do
 	read line2
 	id=`echo $line1|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
 	name=`echo $line2|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
 	if [ "$name" = "$POOL_NAME" ]
 	then
 		echo $id
 	fi
 done
}

pool_id=`getid "$pools"`
echo "pool_id = $pool_id" >> $LOG
echo "Adding an app client to the pool"
# Add an app client to the pool
response=`aws cognito-idp create-user-pool-client \
  --user-pool-id $pool_id \
  --explicit-auth-flows 'ADMIN_NO_SRP_AUTH' \
  --client-name $POOL_CLIENT \
  --refresh-token-validity 7 `
echo "$response" >> $LOG
client_id=`echo $response |tr ',' '\012'|grep "ClientId"|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
echo "Client id = $client_id"

# Create a user
echo "Creating user"
response=`aws cognito-idp sign-up --client-id "$client_id" \
    --username "$USERNAME" --password "$PASSWORD" \
    --user-attributes Name=email,Value="$EMAIL"`
echo "$response" >> $LOG
    
# Confirm sign up
response=`aws cognito-idp admin-confirm-sign-up \
	--user-pool-id "$pool_id"\
        --username "$USERNAME"`
echo "$response" >> $LOG
echo "pool_id and client_id exported for generating API tokens"
export pool_id
export client_id

echo "Creating API Tokens"
response=`aws cognito-idp admin-initiate-auth \
        --user-pool-id "$pool_id" \
        --client-id "$client_id" \
        --auth-flow "ADMIN_NO_SRP_AUTH" \
        --auth-parameters USERNAME="$USERNAME",PASSWORD="$PASSWORD"`

token=`echo $response |tr ',' '\012'|grep IdToken|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
echo $token
if [ -f ./apikeys.txt ] 
then
    mv ./apikeys.txt ./apikeys.txt.old
fi
echo "Saving Token info in file"
echo "pool_id=$pool_id" > ./apikeys.txt
echo "client_id=$client_id" >> ./apikeys.txt
echo "token=$token" >> ./apikeys.txt
