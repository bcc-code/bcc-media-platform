package email

import (
	"context"
	"fmt"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/microcosm-cc/bluemonday"
	"github.com/resend/resend-go/v2"
	"go.opentelemetry.io/otel"
)

// ResendProvider implements the EmailProvider interface for Resend
type ResendProvider struct {
	client *resend.Client
}

// NewResendProvider creates a new Resend email provider
func NewResendProvider(apiKey string) *ResendProvider {
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

	// Log the email attempt
	log.L.Info().
		Str("provider", "resend").
		Str("from_email", options.From.Email).
		Str("from_name", options.From.Name).
		Str("to_email", options.To.Email).
		Str("to_name", options.To.Name).
		Str("title", options.Title).
		Msg("Attempting to send email")

	// Build the sender
	fromEmail := options.From.Email
	if options.From.Name != "" {
		fromEmail = fmt.Sprintf("%s <%s>", options.From.Name, options.From.Email)
	}

	params := &resend.SendEmailRequest{
		From:    fromEmail,
		To:      []string{options.To.Email},
		Subject: options.Title,
		Html:    html,
		Text:    options.Content,
	}

	// If we have a reply-to name and it's different from the sender, set reply-to
	if options.From.Email != "app@brunstad.tv" {
		replyTo := options.From.Email
		if options.From.Name != "" {
			replyTo = fmt.Sprintf("%s <%s>", options.From.Name, options.From.Email)
		}
		params.ReplyTo = replyTo
	}

	sent, err := p.client.Emails.Send(params)

	// Handle errors
	if err != nil {
		log.L.Error().
			Err(err).
			Str("provider", "resend").
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("Client error")
		return fmt.Errorf("resend API error: %w", err)
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