# aws-cognito-dynamodb-apigateway
## Description
A basic tutorial and step by step method to generate API gateway .yaml config files for automating a fully functional framework.
The scripts will create IAM roles, dynamodb tables, Cognito user pools and usage plans. The data and some code are reflective of examples in AWS documenation and the movies database example.

The API gateway is incrementally configured to have a GET method, GET with parameters, PUT and DELETE method with API Keys and Authorization by Cognito.
## AWS components used
* Cognito
* IAM
* Dynamodb
* API Gateway

## Starting the stack
Set environment variables in 00_env_vars.sh
Modify any template to your need as you test the functions under ./templates folder
```
> ./deploy.sh
```
check for error messages along the steps. Basically the build steps are
1 create IAM roles
2 create dynamodb table
3 create Cognito pool, users
4 create api gateway
5 generate api keys and add authorization to api-gateway
6 test

## Additional automation
### There are delete scripts for each component within sub folders

## To do.
Initially, I wanted to use the SAM extension for this exercise and realized that SAM and SAM CLI is still not quite mature to fully automate all the components in a complex APi gateway. Yes, it is great to have a swagger file to play with, but the components it supports so far are limited.
