#!/bin/bash
aws apigateway get-export \
	--rest-api-id q85og2jq9f --stage-name development\
	--export-type swagger \
	--accepts 'application/yaml' \
	--parameters extensions='integrations',extensions='api-gateway',extensions='authorizers' \
	dump.yaml
