package graph

import (
	"database/sql"
	"errors"
	"fmt"
	"testing"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
)

func TestExpectedAbsence(t *testing.T) {
	tests := []struct {
		name string
		err  error
		want bool
	}{
		{"item not found", common.ErrItemNotFound, true},
		{"no access", common.ErrItemNoAccess, true},
		{"not published", common.ErrItemNotPublished, true},
		{"profile not set", common.ErrProfileNotSet, true},

		// Resolvers hand these back wrapped, which is the case that matters:
		// resolverFor returns merry.Wrap(ErrItemNotFound) and ValidateAccess
		// returns merry.Wrap(ErrItemNoAccess).
		{"wrapped not found", merry.Wrap(common.ErrItemNotFound), true},
		{"wrapped no access", merry.Wrap(common.ErrItemNoAccess), true},
		{"doubly wrapped", merry.Wrap(merry.Wrap(common.ErrItemNoAccess)), true},
		{"fmt-wrapped", fmt.Errorf("loading episode: %w", common.ErrItemNotFound), true},

		// Backend failures must not be mistaken for an absence — these are the
		// errors that need to reach the log.
		{"sql no rows", sql.ErrNoRows, false},
		{"connection failure", errors.New("dial tcp: connection refused"), false},
		{"wrapped backend failure", merry.Wrap(errors.New("loader exploded")), false},
		{"nil", nil, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := expectedAbsence(tt.err); got != tt.want {
				t.Errorf("expectedAbsence(%v) = %v, want %v", tt.err, got, tt.want)
			}
		})
	}
}

func TestOmittedAlwaysReturnsNil(t *testing.T) {
	for _, err := range []error{
		nil,
		common.ErrItemNotFound,
		merry.Wrap(common.ErrItemNoAccess),
		errors.New("database is on fire"),
	} {
		if got := omitted(err, "test.field"); got != nil {
			t.Errorf("omitted(%v) = %v, want nil — optional fields must never fail the query", err, got)
		}
	}
}
