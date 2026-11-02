package model

import (
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/samber/lo"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
)

func TestOverrideURL(t *testing.T) {
	now := time.Unix(1_700_000_000, 0)
	const link = "https://live.bcc-connect.org/replay/609"

	cases := []struct {
		name  string
		url   null.String
		until null.Time
		want  *string
	}{
		{name: "no override", want: nil},
		{name: "empty override", url: null.StringFrom(""), want: nil},
		{name: "override without expiry", url: null.StringFrom(link), want: lo.ToPtr(link)},
		{name: "before expiry", url: null.StringFrom(link), until: null.TimeFrom(now.Add(time.Minute)), want: lo.ToPtr(link)},
		{name: "exactly at expiry", url: null.StringFrom(link), until: null.TimeFrom(now), want: nil},
		{name: "after expiry", url: null.StringFrom(link), until: null.TimeFrom(now.Add(-time.Minute)), want: nil},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			e := &common.Episode{OverrideURL: tc.url, OverrideURLUntil: tc.until}
			assert.Equal(t, tc.want, overrideURL(e, now))
		})
	}
}
