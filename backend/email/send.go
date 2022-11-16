package email

import "github.com/sendgrid/sendgrid-go/helpers/mail"

type Options struct {
	From  Recipient
	To    Recipient
	Title string
}

func SendEmail(options Options) {
	from := mail.NewEmail(options.From.Name, options.From.Email)
	to := mail.NewEmail(options.To.Name, options.To.Email)
}
