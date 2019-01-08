#!/bin/bash
ID='111111111111'
host='RESTAPIID'
FROM="$AWS_ACCOUNT_ID"

for i in `find ./ -name "*.yaml" -type f `
do
	echo "Modifying $i"
	sed -i "s/$FROM/$ID/" $i
	sed -i "s/$host/RESTAPIID/" $i
done
