package email

import (
	"context"
	"fmt"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/microcosm-cc/bluemonday"
	"github.com/sendgrid/sendgrid-go"
	"github.com/sendgrid/sendgrid-go/helpers/mail"
	"go.opentelemetry.io/otel"
)

// SendGridProvider implements the EmailProvider interface for SendGrid
type SendGridProvider struct {
	client    *sendgrid.Client
	fromEmail string
}

// NewSendGridProvider creates a new SendGrid email provider
func NewSendGridProvider(apiKey, fromEmail string) *SendGridProvider {
	// Use default if fromEmail is empty
	if fromEmail == "" {
		fromEmail = "app@brunstad.tv"
	}

	return &SendGridProvider{
		client:    sendgrid.NewSendClient(apiKey),
		fromEmail: fromEmail,
	}
}

// SendEmail sends an email using SendGrid
func (p *SendGridProvider) SendEmail(ctx context.Context, options SendOptions) error {
	ctx, span := otel.Tracer("email").Start(ctx, "sendgrid.send")
	defer span.End()

	from := mail.NewEmail(options.From.Name, options.From.Email)
	to := mail.NewEmail(options.To.Name, options.To.Email)

	// Simple sanitizing
	sanitizer := bluemonday.UGCPolicy()
	html := sanitizer.Sanitize(options.HTMLContent)

	message := mail.NewSingleEmail(mail.NewEmail("App", p.fromEmail), options.Title, to, options.Content, html)
	message.ReplyTo = from

	// Log the email attempt
	log.L.Info().
		Str("provider", "sendgrid").
		Str("from_email", options.From.Email).
		Str("from_name", options.From.Name).
		Str("to_email", options.To.Email).
		Str("to_name", options.To.Name).
		Str("title", options.Title).
		Msg("Attempting to send email")

	response, err := p.client.Send(message)

	// Log all SendGrid responses for debugging
	if response != nil {
		log.L.Info().
			Str("provider", "sendgrid").
			Int("status_code", response.StatusCode).
			Str("response_body", response.Body).
			Interface("headers", response.Headers).
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("API response")
	}

	// Handle errors
	if err != nil {
		log.L.Error().
			Err(err).
			Str("provider", "sendgrid").
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("Client error")
		return err
	}

	// Check for HTTP error status codes
	if response != nil && response.StatusCode >= 400 {
		errorMsg := fmt.Sprintf("API error: %d - %s", response.StatusCode, response.Body)
		log.L.Error().
			Str("provider", "sendgrid").
			Int("status_code", response.StatusCode).
			Str("response_body", response.Body).
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("API returned error status")
		return fmt.Errorf(errorMsg)
	}

	// Log successful sends
	log.L.Info().
		Str("provider", "sendgrid").
		Str("from_email", options.From.Email).
		Str("to_email", options.To.Email).
		Str("title", options.Title).
		Msg("Email sent successfully")

	return nil
}