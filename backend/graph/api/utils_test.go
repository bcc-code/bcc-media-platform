package graph

import (
	"bytes"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"testing"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/rs/zerolog"
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

func TestLogOmitted(t *testing.T) {
	tests := []struct {
		name      string
		err       error
		wantEntry bool
	}{
		{"nil error is not an omission", nil, false},
		{"expected absence passes quietly", merry.Wrap(common.ErrItemNoAccess), false},
		{"no profile passes quietly", common.ErrProfileNotSet, false},
		{"a backend failure is recorded", errors.New("database is on fire"), true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			var buf bytes.Buffer
			restore := log.L
			logger := zerolog.New(&buf)
			log.L = &logger
			defer func() { log.L = restore }()

			logOmitted(tt.err, "test.field")

			logged := buf.Len() > 0
			if logged != tt.wantEntry {
				t.Errorf("logged = %v, want %v (output: %q)", logged, tt.wantEntry, buf.String())
			}
			if tt.wantEntry && !strings.Contains(buf.String(), "test.field") {
				t.Errorf("log entry does not name the field: %q", buf.String())
			}
		})
	}
}
