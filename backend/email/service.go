package email

import (
	"fmt"
	"os"
)

// Config are configurations options for the service
type Config struct {
	Provider         string // "sendgrid" or "resend"
	SendGridAPIKey   string // SendGrid API key
	ResendAPIKey     string // Resend API key
	FromEmail        string // From email address for all providers
}

// Service contains methods for sending emails
type Service struct {
	provider EmailProvider
}

// New returns a new service with the configured email provider
func New(options Config) (*Service, error) {
	var provider EmailProvider

	// Determine which provider to use
	providerType := ProviderTypeFrom(options.Provider)

	switch providerType {
	case ProviderSendGrid:
		apiKey := options.SendGridAPIKey
		if apiKey == "" {
			// Fallback to legacy config field for backward compatibility
			apiKey = os.Getenv("SENDGRID_API_KEY")
		}
		if apiKey == "" {
			return nil, fmt.Errorf("SendGrid API key is required")
		}
		provider = NewSendGridProvider(apiKey, options.FromEmail)
	case ProviderResend:
		apiKey := options.ResendAPIKey
		if apiKey == "" {
			return nil, fmt.Errorf("Resend API key is required")
		}
		provider = NewResendProvider(apiKey, options.FromEmail)
	default:
		return nil, fmt.Errorf("unsupported email provider: %s (supported: sendgrid, resend)", providerType)
	}

	return &Service{
		provider: provider,
	}, nil
}