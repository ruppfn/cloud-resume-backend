package process

import (
	"bytes"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"
	"io"
	"net/http"
	"net/http/httputil"
	"os"
)

var region = os.Getenv("REGION")
var parameterName = os.Getenv("PARAMETER_NAME")
var repositoryUrl = os.Getenv("POST_URL")
var ssmClient *ssm.SSM
var githubPat *string

func getSSMClient() *ssm.SSM {
	sess := session.Must(session.NewSession())

	return ssm.New(sess, aws.NewConfig().WithRegion(region))
}

func getGithubPat() *string {
	if ssmClient == nil {
		fmt.Println("Initializing SSM Client")
		ssmClient = getSSMClient()
	}

	withDecryption := true
	param, err := ssmClient.GetParameter(&ssm.GetParameterInput{
		Name:           aws.String(parameterName),
		WithDecryption: &withDecryption,
	})

	if err != nil {
		fmt.Println("Couldn't get param: ", parameterName, err)
		panic(err)
	}

	return param.Parameter.Value
}

func RunGithubAction() {
	if githubPat == nil {
		githubPat = getGithubPat()
	}

	body := []byte(`{
		"event_type": "rebuild_front"
	}`)

	req, err := http.NewRequest("POST", repositoryUrl, bytes.NewBuffer(body))
	if err != nil {
		fmt.Println("Couldn't create request", err)
		panic(err)
	}

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", *githubPat))

	client := &http.Client{}

	result, err := client.Do(req)
	if err != nil {
		fmt.Println("Error on POST Request", err)
		panic(err)
	}

	response, err := httputil.DumpResponse(result, true)
	if err != nil {
		fmt.Println("Error dumping response", err)
		panic(err)
	}
	fmt.Println(string(response))

	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			fmt.Println("Couldn't close request body")
		}
	}(result.Body)
}
