package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/ruppfn/cloud-resume-backend/src/cv-lambda/process"
	"os"
)

var dynamodbClient *dynamodb.Client
var region = os.Getenv("REGION")
var tableName = os.Getenv("TABLE_NAME")
var key = os.Getenv("KEY")
var value = os.Getenv("VALUE")

func HandleRequest(ctx context.Context) (process.DynamoData, error) {
	var dynamoData process.DynamoData

	if dynamodbClient == nil {
		fmt.Println("initializing dynamodbClient")
		newClient, err := process.GetDynamoClient(region, ctx)
		if err != nil {
			fmt.Println("Couldn't get the dynamo client")
			return dynamoData, err
		}
		dynamodbClient = newClient
	}

	output, err := process.GetItemFromTable(dynamodbClient, tableName, key, value, ctx)
	if err != nil {
		fmt.Println("Couldn't find the item")
		return dynamoData, err
	}

	err = attributevalue.UnmarshalMap(output.Item, &dynamoData)
	if err != nil {
		fmt.Println("Couldn't unmarshal the result")
		return dynamoData, err
	}

	return dynamoData, nil
}

func main() {
	lambda.Start(HandleRequest)
}
