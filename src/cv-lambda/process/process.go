package process

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/config"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

func GetDynamoClient(region string, ctx context.Context) (*dynamodb.Client, error) {
	cfg, err := config.LoadDefaultConfig(ctx, func(o *config.LoadOptions) error {
		o.Region = region
		return nil
	})
	if err != nil {
		return nil, err
	}

	dynamoClient := dynamodb.NewFromConfig(cfg)

	return dynamoClient, nil
}

func GetItemFromTable(
	dynamoClient *dynamodb.Client,
	tableName string,
	key string,
	value string,
	ctx context.Context) (*dynamodb.GetItemOutput, error) {
	out, err := dynamoClient.GetItem(ctx, &dynamodb.GetItemInput{
		TableName: aws.String(tableName),
		Key: map[string]types.AttributeValue{
			key: &types.AttributeValueMemberS{Value: value},
		},
	})

	if err != nil {
		return nil, err
	}

	return out, nil
}
