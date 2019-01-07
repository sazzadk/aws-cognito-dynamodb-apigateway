#!/bin/bash
source ../00_env_vars.sh
LOG="./cognitologs.txt"
echo "getting pool id"
pools=`aws cognito-idp list-user-pools --max-results 10|egrep '(Id|Name)'`
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
echo "deleting user"
if [ -z $pool_id ] 
then
	echo "Could not get pool id"
	exit 1
else
	res=`aws cognito-idp admin-delete-user --user-pool-id "$pool_id" \
		--username "$USERNAME"`
	echo $res >> $LOG
fi
echo "Deleting pool"
res=`aws cognito-idp delete-user-pool --user-pool-id "$pool_id"`
echo "$res" >> $LOG
if [ -f "./token.txt" ] 
then
	rm -f ./token.txt
fi
rm -f ./apikeys*
