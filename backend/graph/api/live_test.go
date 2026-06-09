package graph

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestAppendTimeShiftTags(t *testing.T) {
	start := time.Unix(1513717228, 0)
	end := time.Unix(1513720828, 0)

	t.Run("start only, appends with & when the signed query is already present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?EncodedPolicy=xyz%3D"
		got := appendTimeShiftTags(in, start, nil)
		assert.Equal(t, in+"&start=1513717228", got)
	})

	t.Run("start only, appends with ? when no query present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8"
		got := appendTimeShiftTags(in, start, nil)
		assert.Equal(t, in+"?start=1513717228", got)
	})

	t.Run("start and end, appends with & when the signed query is already present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?EncodedPolicy=xyz%3D"
		got := appendTimeShiftTags(in, start, &end)
		assert.Equal(t, in+"&start=1513717228&end=1513720828", got)
	})

	t.Run("start and end, appends start with ? and end with & when no query present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8"
		got := appendTimeShiftTags(in, start, &end)
		assert.Equal(t, in+"?start=1513717228&end=1513720828", got)
	})
}

func TestClampStart(t *testing.T) {
	now := time.Unix(1_700_000_000, 0)
	cutoff := now.Add(-maxLivestreamStartAge)

	t.Run("recent start is left untouched", func(t *testing.T) {
		start := now.Add(-30 * time.Minute)
		assert.Equal(t, start, clampStart(start, now))
	})

	t.Run("start older than the cap is clamped to the cutoff", func(t *testing.T) {
		start := now.Add(-3 * time.Hour)
		assert.Equal(t, cutoff, clampStart(start, now))
	})

	t.Run("start exactly at the cap is left untouched", func(t *testing.T) {
		assert.Equal(t, cutoff, clampStart(cutoff, now))
	})

	t.Run("future start is left untouched", func(t *testing.T) {
		start := now.Add(10 * time.Minute)
		assert.Equal(t, start, clampStart(start, now))
	})
}

func TestLivestreamExpiresAt(t *testing.T) {
	now := time.Unix(1_700_000_000, 0)

	t.Run("no program in progress falls back to the default expiry", func(t *testing.T) {
		assert.Equal(t, now.Add(livestreamURLExpiry), livestreamExpiresAt(nil, now))
	})

	t.Run("expiry is capped at 2h past the start time", func(t *testing.T) {
		start := now.Add(-30 * time.Minute)
		assert.Equal(t, start.Add(maxLivestreamURLAgeFromStart), livestreamExpiresAt(&start, now))
	})

	t.Run("a start at the clamp floor still yields a future expiry", func(t *testing.T) {
		// start clamped to 90m ago -> expiry 90m ago + 2h = 30m from now.
		start := now.Add(-maxLivestreamStartAge)
		assert.Equal(t, now.Add(30*time.Minute), livestreamExpiresAt(&start, now))
	})
}
