package common

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestApplicationGroupSlug(t *testing.T) {
	assert.Equal(t, "bible-kids", Application{GroupLabel: " Bible Kids "}.GroupSlug())
	assert.Equal(t, "kids", Application{GroupLabel: "Kids"}.GroupSlug())
	assert.Equal(t, "", Application{}.GroupSlug())
}

func TestApplicationComputedRoles(t *testing.T) {
	app := Application{Code: "kids-mobile", GroupLabel: "Bible Kids"}
	assert.ElementsMatch(t,
		[]string{"bcc-members", "kids-mobile-bcc-members", "bible-kids-bcc-members"},
		app.ComputedRoles([]string{"bcc-members"}),
	)

	// No group label means no group-prefixed variant.
	noGroup := Application{Code: "kids-mobile"}
	assert.ElementsMatch(t,
		[]string{"bcc-members", "kids-mobile-bcc-members"},
		noGroup.ComputedRoles([]string{"bcc-members"}),
	)
}
