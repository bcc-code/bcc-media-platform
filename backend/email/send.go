package email

import "context"

// SendOptions are options used to define the message sent.
type SendOptions struct {
	From        Recipient
	To          Recipient
	Title       string
	Content     string
	HTMLContent string
}

// SendEmail to the specified receiver using the configured provider.
func (s *Service) SendEmail(ctx context.Context, options SendOptions) error {
	return s.provider.SendEmail(ctx, options)
}