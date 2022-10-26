package common

const ReturnAllID = -99999

// Images is a map of styles with related images
type Images map[string]LocaleMap[string]

// GetForLanguages retrieves Image for
func (i Images) GetForLanguages(languages []string) map[string]*string {
	var images = map[string]*string{}
	for style, image := range i {
		images[style] = image.GetValueOrNil(languages)
	}
	return images
}

// GetDefault returns the default image for language and style
func (i Images) GetDefault(languages []string, style string) *string {
	images := i.GetForLanguages(languages)

	img, ok := images[style]
	if ok {
		return img
	}
	if style == "icon" {
		return nil
	}
	img, ok = images["default"]
	if ok {
		return img
	}
	for _, fb := range images {
		return fb
	}
	return nil
}
