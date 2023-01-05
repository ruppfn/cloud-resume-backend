package process

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudfront"
	"os"
	"time"
)

var distributionId = os.Getenv("DISTRIBUTION_ID")
var cloudfrontClient *cloudfront.CloudFront

func getCloudfrontClient() *cloudfront.CloudFront {
	sess := session.Must(session.NewSession())

	return cloudfront.New(sess, aws.NewConfig().WithRegion(region))
}

func createInvalidationRequest() {
	now := time.Now()
	resp, err := cloudfrontClient.CreateInvalidation(&cloudfront.CreateInvalidationInput{
		DistributionId: aws.String(distributionId),
		InvalidationBatch: &cloudfront.InvalidationBatch{
			CallerReference: aws.String(fmt.Sprintf("goinvali%s", now.Format("2006/01/02,15:04:05"))),
			Paths: &cloudfront.Paths{
				Quantity: aws.Int64(1),
				Items: []*string{
					aws.String("/*"),
				},
			},
		},
	})

	if err != nil {
		fmt.Println("Couldn't invalidate cloudfront distribution", err)
		panic(err)
	}

	fmt.Println(resp.String())
}

func InvalidateCloudfront() {
	if cloudfrontClient == nil {
		cloudfrontClient = getCloudfrontClient()
	}

	createInvalidationRequest()
}
