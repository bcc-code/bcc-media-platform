package email

import (
	"context"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/microcosm-cc/bluemonday"
	"github.com/sendgrid/sendgrid-go/helpers/mail"
	"go.opentelemetry.io/otel"
)

// SendOptions are options used to define the message sent.
type SendOptions struct {
	From        Recipient
	To          Recipient
	Title       string
	Content     string
	HTMLContent string
}

// SendEmail to the specified receiver.
func (s *Service) SendEmail(ctx context.Context, options SendOptions) error {
	ctx, span := otel.Tracer("email").Start(ctx, "send")
	defer span.End()

	from := mail.NewEmail(options.From.Name, options.From.Email)
	to := mail.NewEmail(options.To.Name, options.To.Email)

	// Simple sanitizing
	p := bluemonday.UGCPolicy()
	html := p.Sanitize(options.HTMLContent)

	message := mail.NewSingleEmail(mail.NewEmail("App", "app@brunstad.tv"), options.Title, to, options.Content, html)

	message.ReplyTo = from

	// Log the email attempt
	log.L.Info().
		Str("from_email", options.From.Email).
		Str("from_name", options.From.Name).
		Str("to_email", options.To.Email).
		Str("to_name", options.To.Name).
		Str("title", options.Title).
		Msg("Attempting to send email via SendGrid")

	response, err := s.client.Send(message)
	
	// Log all SendGrid responses for debugging
	if response != nil {
		log.L.Info().
			Int("status_code", response.StatusCode).
			Str("response_body", response.Body).
			Interface("headers", response.Headers).
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("SendGrid API response")
	}

	// Handle errors
	if err != nil {
		log.L.Error().
			Err(err).
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("SendGrid client error")
		return err
	}

	// Check for HTTP error status codes
	if response != nil && response.StatusCode >= 400 {
		errorMsg := fmt.Sprintf("SendGrid API error: %d - %s", response.StatusCode, response.Body)
		log.L.Error().
			Int("status_code", response.StatusCode).
			Str("response_body", response.Body).
			Str("from_email", options.From.Email).
			Str("to_email", options.To.Email).
			Str("title", options.Title).
			Msg("SendGrid API returned error status")
		return fmt.Errorf(errorMsg)
	}

	// Log successful sends
	log.L.Info().
		Str("from_email", options.From.Email).
		Str("to_email", options.To.Email).
		Str("title", options.Title).
		Msg("Email sent successfully via SendGrid")

	return nil
}
