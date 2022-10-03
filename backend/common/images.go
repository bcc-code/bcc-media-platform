package common

// Image contains a language and url
type Image struct {
	Language string
	URL      string
}

// Images is a map of styles with related images
type Images map[string]LocaleMap[string]

// GetForLanguages retrieves Image for
func (i Images) GetForLanguages(languages []string) map[string]*string {
	var images map[string]*string
	for style, image := range i {
		images[style] = image.GetValueOrNil(languages)
	}
	return images
}
