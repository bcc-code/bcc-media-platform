package email

import (
	"context"
)

// EmailProvider defines the interface that all email providers must implement
type EmailProvider interface {
	SendEmail(ctx context.Context, options SendOptions) error
}

// ProviderType represents the available email providers
type ProviderType string

// Email provider constants
const (
	ProviderSendGrid ProviderType = "sendgrid"
	ProviderResend   ProviderType = "resend"
)

// ProviderTypeFrom converts a string to a ProviderType, defaulting to SendGrid
func ProviderTypeFrom(s string) ProviderType {
	switch ProviderType(s) {
	case ProviderResend:
		return ProviderResend
	default:
		// Default to SendGrid for backward compatibility
		return ProviderSendGrid
	}
}