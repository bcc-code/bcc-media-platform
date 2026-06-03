package graph

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestAppendStartTag(t *testing.T) {
	start := time.Unix(1513717228, 0)

	t.Run("appends with & when query already present (signed URL)", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?EncodedPolicy=xyz%3D"
		got := appendStartTag(in, start)
		assert.Equal(t, in+"&start=1513717228", got)
	})

	t.Run("appends with ? when no query present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8"
		got := appendStartTag(in, start)
		assert.Equal(t, in+"?start=1513717228", got)
	})
}
