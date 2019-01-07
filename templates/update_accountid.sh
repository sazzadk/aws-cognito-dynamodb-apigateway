#!/bin/bash
source ../00_env_vars.sh
FROM='111111111111'
ID="$AWS_ACCOUNT_ID"

for i in `find ./ -name "*.yaml" -type f `
do
	echo "Modifying $i"
	sed -i "s/$FROM/$ID/" $i
done
