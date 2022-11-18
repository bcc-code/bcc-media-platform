package email

import "github.com/sendgrid/sendgrid-go"

// Config are configurations options for the service
type Config struct {
	ApiKey string
}

// Service contains methods for sending emails
type Service struct {
	client *sendgrid.Client
}

// New returns a new service
func New(options Config) *Service {
	return &Service{
		client: sendgrid.NewSendClient(options.ApiKey),
	}
}
