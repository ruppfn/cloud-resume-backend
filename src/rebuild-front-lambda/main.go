package main

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/ruppfn/cloud-resume-backend/src/rebuild-front-lambda/process"
	"time"
)

func HandleRequest(ctx context.Context) {
	process.RunGithubAction()
	time.Sleep(2 * time.Minute)
	process.InvalidateCloudfront()
}

func main() {
	lambda.Start(HandleRequest)
}
