package email

import (
	"context"
	"fmt"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/microcosm-cc/bluemonday"
	"github.com/resend/resend-go/v2"
	"go.opentelemetry.io/otel"
)

// analyzeResendError attempts to provide more meaningful error messages based on common Resend API errors
func analyzeResendError(err error, fromEmail string) string {
	if err == nil {
		return ""
	}

	errMsg := err.Error()
	lowerErr := strings.ToLower(errMsg)

	// Check for common Resend error patterns
	switch {
	case strings.Contains(lowerErr, "unknown error"):
		// This is likely a domain verification issue
		return fmt.Sprintf("Domain verification required: The domain '%s' may not be verified in your Resend account", extractDomain(fromEmail))
	case strings.Contains(lowerErr, "unauthorized"):
		return "Invalid API key or insufficient permissions"
	case strings.Contains(lowerErr, "forbidden"):
		return "Access denied - check API key permissions"
	case strings.Contains(lowerErr, "not found"):
		return "Resource not found - check API configuration"
	case strings.Contains(lowerErr, "rate limit"):
		return "Rate limit exceeded - too many requests"
	case strings.Contains(lowerErr, "domain"):
		return fmt.Sprintf("Domain issue with '%s' - ensure domain is verified in Resend", extractDomain(fromEmail))
	default:
		return fmt.Sprintf("Resend API error: %s", errMsg)
	}
}

// extractDomain extracts the domain part from an email address
func extractDomain(email string) string {
	parts := strings.Split(email, "@")
	if len(parts) == 2 {
		return parts[1]
	}
	return email
}

// ResendProvider implements the EmailProvider interface for Resend
type ResendProvider struct {
	client *resend.Client
}

// NewResendProvider creates a new Resend email provider
func NewResendProvider(apiKey string) *ResendProvider {
	// Log API key status (without exposing the actual key)
	keyLength := len(apiKey)
	keyPrefix := ""
	if keyLength > 8 {
		keyPrefix = apiKey[:8] + "..."
	}

	log.L.Info().
		Int("key_length", keyLength).
		Str("key_prefix", keyPrefix).
		Bool("key_empty", apiKey == "").
		Msg("Initializing Resend provider")

	return &ResendProvider{
		client: resend.NewClient(apiKey),
	}
}

// SendEmail sends an email using Resend
func (p *ResendProvider) SendEmail(ctx context.Context, options SendOptions) error {
	ctx, span := otel.Tracer("email").Start(ctx, "resend.send")
	defer span.End()

	// Simple sanitizing
	sanitizer := bluemonday.UGCPolicy()
	html := sanitizer.Sanitize(options.HTMLContent)

	// Log the email attempt with actual addresses that will be used
	log.L.Info().
		Str("provider", "resend").
		Str("from_email", options.From.Email).
		Str("from_name", options.From.Name).
		Str("to_email", options.To.Email).
		Str("to_name", options.To.Name).
		Str("title", options.Title).
		Msg("Attempting to send email")

	// Build the sender - always use verified Resend domain for from address
	fromEmail := "api@mailer.bcc.media"

	params := &resend.SendEmailRequest{
		From:    fromEmail,
		To:      []string{options.To.Email},
		Subject: options.Title,
		Html:    html,
		Text:    options.Content,
	}

	// Always set reply-to to the original sender since we're using onboarding@resend.dev as from
	replyTo := options.From.Email
	if options.From.Name != "" {
		replyTo = fmt.Sprintf("%s <%s>", options.From.Name, options.From.Email)
	}
	params.ReplyTo = replyTo

	// Log the API request parameters (without sensitive data)
	log.L.Debug().
		Str("provider", "resend").
		Str("from", params.From).
		Strs("to", params.To).
		Str("subject", params.Subject).
		Str("reply_to", params.ReplyTo).
		Int("html_length", len(params.Html)).
		Int("text_length", len(params.Text)).
		Msg("Sending email to Resend API")

	// Test connectivity to Resend API before sending
	log.L.Debug().Msg("Attempting to reach Resend API endpoint")

	sent, err := p.client.Emails.Send(params)

	// Handle errors
	if err != nil {
		analyzedError := analyzeResendError(err, options.From.Email)

		// Log detailed error information
		log.L.Error().
			Err(err).
			Str("provider", "resend").
			Str("from_email", options.From.Email).
			Str("from_domain", extractDomain(options.From.Email)).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Str("error_type", fmt.Sprintf("%T", err)).
			Str("error_message", err.Error()).
			Str("analyzed_error", analyzedError).
			Msg("Client error")
		return fmt.Errorf(analyzedError)
	}

	// Log successful sends
	log.L.Info().
		Str("provider", "resend").
		Str("email_id", sent.Id).
		Str("from_email", options.From.Email).
		Str("to_email", options.To.Email).
		Str("title", options.Title).
		Msg("Email sent successfully")

	return nil
}
