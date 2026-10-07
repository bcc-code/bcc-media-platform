package graph

import (
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// Every language code the backend normalises to must be a valid LanguageCode,
// otherwise Episode.videoLanguages silently drops it.
func TestKnownLanguageCodesAreValidEnumValues(t *testing.T) {
	for _, code := range utils.KnownLanguageCodes() {
		if !model.LanguageCode(code).IsValid() {
			t.Errorf("language code %q is missing from the LanguageCode enum", code)
		}
	}
}
