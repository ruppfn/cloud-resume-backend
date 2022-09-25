package main

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/ruppfn/cloud-resume-backend/src/cv-lambda/process"
	"net/http"
	"os"
)

var dynamodbClient *dynamodb.Client
var region = os.Getenv("REGION")
var tableName = os.Getenv("TABLE_NAME")
var key = os.Getenv("KEY")
var value = os.Getenv("VALUE")

func HandleRequest(ctx context.Context) (events.APIGatewayProxyResponse, error) {
	if dynamodbClient == nil {
		fmt.Println("initializing dynamodbClient")
		newClient, err := process.GetDynamoClient(region, ctx)
		if err != nil {
			fmt.Println("Couldn't get the dynamo client")
			return internalServerError(err)
		}
		dynamodbClient = newClient
	}

	output, err := process.GetItemFromTable(dynamodbClient, tableName, key, value, ctx)
	if err != nil {
		fmt.Println("Couldn't find the item")
		return internalServerError(err)
	}

	var dynamoData process.DynamoData

	err = attributevalue.UnmarshalMap(output.Item, &dynamoData)
	if err != nil {
		fmt.Println("Couldn't unmarshal the result")
		return internalServerError(err)
	}

	jsonData, err := json.Marshal(dynamoData)

	response := events.APIGatewayProxyResponse{
		Body:            string(jsonData),
		StatusCode:      http.StatusOK,
		IsBase64Encoded: false,
	}

	return response, nil
}

func internalServerError(err error) (events.APIGatewayProxyResponse, error) {
	fmt.Println("ERROR: ", err)
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusInternalServerError,
	}, nil
}

func main() {
	lambda.Start(HandleRequest)
}
