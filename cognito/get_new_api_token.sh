#!/bin/bash
source ../00_env_vars.sh
if [ -z "$pool_id" ] && [ -z "$client_id" ]
then
	echo "Please set env vars pool_id and client_id and retry"
	exit
else
	echo "Generating a new API token"
	response=`aws cognito-idp admin-initiate-auth \
		--user-pool-id "$pool_id" \
		--client-id "$client_id" \
		--auth-flow "ADMIN_NO_SRP_AUTH" \
		--auth-parameters USERNAME="$USERNAME",PASSWORD="$PASSWORD"`

	token=`echo $response |tr ',' '\012'|grep IdToken|awk -F' ' '{print $2}'|sed 's/[,"]//g'`
	echo $token
fi
