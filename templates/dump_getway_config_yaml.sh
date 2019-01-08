#!/bin/bash
API_ID=''
aws apigateway get-export \
	--rest-api-id $API_ID --stage-name development\
	--export-type swagger \
	--accepts 'application/yaml' \
	--parameters extensions='integrations',extensions='api-gateway',extensions='authorizers' \
	dump.yaml
