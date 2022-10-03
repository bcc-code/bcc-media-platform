package sqlc

import "os"

var imageCDNDomain = os.Getenv("IMAGE_CDN_DOMAIN")

func (q *Queries) getImageCDNDomain() string {
	return imageCDNDomain
}

// SetImageCDNDomain sets the domain for the image CDN
func (q *Queries) SetImageCDNDomain(domain string) {
	imageCDNDomain = domain
}
