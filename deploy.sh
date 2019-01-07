#!/bin/bash
source ./00_env_vars.sh
cd ./iam
source ./create_role.sh
cd ..
sleep 5
cd ./cognito
source ./create_pool.sh
cd ..
sleep 5
cd ./dynamodb
source ./loaddb.py
sleep 5
cd ..
cd templates
source ./01_create_apigateway.sh
source ./02_attach_usage_plan.sh
cd ..
echo "Stack is ready. Please run test from the test folder"

