package common

// Images is a map of styles with related images
type Images map[string]LocaleMap[string]

// ImageStyle is the specific styles
type ImageStyle = string

// ImageStyles
const (
	ImageStyleDefault  = ImageStyle("default")
	ImageStyleIcon     = ImageStyle("icon")
	ImageStyleFeatured = ImageStyle("featured")
	ImageStylePoster   = ImageStyle("poster")
)

// GetForLanguages retrieves Image for
func (i Images) GetForLanguages(languages []string) map[ImageStyle]*string {
	var images = map[ImageStyle]*string{}
	for style, image := range i {
		images[style] = image.GetValueOrNil(languages)
	}
	return images
}

// GetDefault returns the default image for language and style
func (i Images) GetDefault(languages []string, style ImageStyle) *string {
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

// GetStrict returns only an image with the specified style
func (i Images) GetStrict(languages []string, style ImageStyle) *string {
	images := i.GetForLanguages(languages)

	img, ok := images[style]
	if ok {
		return img
	}
	return nil
}
