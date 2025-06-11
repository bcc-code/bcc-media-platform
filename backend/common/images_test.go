package common

import (
	"reflect"
	"testing"
)

func TestImagesGetForLanguages(t *testing.T) {
	tests := []struct {
		name      string
		images    Images
		languages []string
		want      map[ImageStyle]*string
	}{
		{
			name: "empty images",
			images: Images{},
			languages: []string{"en"},
			want: map[ImageStyle]*string{},
		},
		{
			name: "single image style",
			images: Images{
				"default": LocaleMap[string]{
					"en": "image-en.jpg",
					"no": "image-no.jpg",
				},
			},
			languages: []string{"en"},
			want: map[ImageStyle]*string{
				"default": strPtr("image-en.jpg"),
			},
		},
		{
			name: "multiple image styles",
			images: Images{
				"default": LocaleMap[string]{
					"en": "default-en.jpg",
					"no": "default-no.jpg",
				},
				"poster": LocaleMap[string]{
					"en": "poster-en.jpg",
					"no": "poster-no.jpg",
				},
			},
			languages: []string{"en"},
			want: map[ImageStyle]*string{
				"default": strPtr("default-en.jpg"),
				"poster":  strPtr("poster-en.jpg"),
			},
		},
		{
			name: "fallback to available language",
			images: Images{
				"default": LocaleMap[string]{
					"no": "default-no.jpg",
				},
			},
			languages: []string{"en", "no"},
			want: map[ImageStyle]*string{
				"default": strPtr("default-no.jpg"),
			},
		},
		{
			name: "no matching language",
			images: Images{
				"default": LocaleMap[string]{
					"fr": "default-fr.jpg",
					"de": "default-de.jpg",
				},
			},
			languages: []string{"es"}, // A language not in the map nor in DefaultLanguages
			want: map[ImageStyle]*string{
				"default": nil,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// For the specific test case, temporarily override DefaultLanguages
			if tt.name == "no matching language" {
				originalDefault := DefaultLanguages
				DefaultLanguages = []string{"es"} // Set to something not in our test data
				defer func() { DefaultLanguages = originalDefault }()
			}
			
			got := tt.images.GetForLanguages(tt.languages)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Images.GetForLanguages() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestImagesGetDefault(t *testing.T) {
	tests := []struct {
		name      string
		images    Images
		languages []string
		style     ImageStyle
		want      *string
	}{
		{
			name: "exact style match",
			images: Images{
				"default": LocaleMap[string]{
					"en": "default-en.jpg",
				},
				"poster": LocaleMap[string]{
					"en": "poster-en.jpg",
				},
			},
			languages: []string{"en"},
			style:     "poster",
			want:      strPtr("poster-en.jpg"),
		},
		{
			name: "fallback to default style",
			images: Images{
				"default": LocaleMap[string]{
					"en": "default-en.jpg",
				},
			},
			languages: []string{"en"},
			style:     "poster",
			want:      strPtr("default-en.jpg"),
		},
		{
			name: "icon style returns nil when not found",
			images: Images{
				"default": LocaleMap[string]{
					"en": "default-en.jpg",
				},
			},
			languages: []string{"en"},
			style:     "icon",
			want:      nil,
		},
		{
			name: "fallback to any available image",
			images: Images{
				"featured": LocaleMap[string]{
					"en": "featured-en.jpg",
				},
			},
			languages: []string{"en"},
			style:     "poster",
			want:      strPtr("featured-en.jpg"),
		},
		{
			name:      "empty images",
			images:    Images{},
			languages: []string{"en"},
			style:     "default",
			want:      nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := tt.images.GetDefault(tt.languages, tt.style)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Images.GetDefault() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestImagesGetStrict(t *testing.T) {
	tests := []struct {
		name      string
		images    Images
		languages []string
		style     ImageStyle
		want      *string
	}{
		{
			name: "exact style match",
			images: Images{
				"default": LocaleMap[string]{
					"en": "default-en.jpg",
				},
				"poster": LocaleMap[string]{
					"en": "poster-en.jpg",
				},
			},
			languages: []string{"en"},
			style:     "poster",
			want:      strPtr("poster-en.jpg"),
		},
		{
			name: "style not found",
			images: Images{
				"default": LocaleMap[string]{
					"en": "default-en.jpg",
				},
			},
			languages: []string{"en"},
			style:     "poster",
			want:      nil,
		},
		{
			name:      "empty images",
			images:    Images{},
			languages: []string{"en"},
			style:     "default",
			want:      nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := tt.images.GetStrict(tt.languages, tt.style)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Images.GetStrict() = %v, want %v", got, tt.want)
			}
		})
	}
}

// Helper function to create string pointers
func strPtr(s string) *string {
	return &s
}
