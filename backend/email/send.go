package email

import (
	"context"
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

	_, err := s.client.Send(message)
	return err
}
