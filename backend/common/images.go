package common

// Image contains a language and url
type Image struct {
	Style    string
	Language string
	URL      string
}

// Images is a map of styles with related images
type Images []Image

// GetForLanguages retrieves Image for
func (i Images) GetForLanguages(languages []string) []Image {
	var images []Image
	for _, image := range i {

	}
}
