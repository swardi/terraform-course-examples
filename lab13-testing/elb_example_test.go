package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestElbExample(t *testing.T) {
	opts := &terraform.Options{
		// You should update this relative path to point at your elb
		// example directory!
		TerraformDir: "./elb-module/example",
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)

	terraform.Init(t, opts)
	terraform.Apply(t, opts)

	//Get the dns name of the load balancer
	albDNSName := terraform.OutputRequired(t, opts, "alb_dns_name")

	//concat http:// prefix with dns name to make the url
	url := fmt.Sprintf("http://%s", albDNSName)
	// Test that the ALB's default action is working and returns a 404
	expectedStatus := 200
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(t, url, maxRetries, timeBetweenRetries, func(statusCode int, body string) bool {
		return statusCode == expectedStatus
	})
}
