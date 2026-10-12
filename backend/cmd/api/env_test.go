package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseSearchKeys(t *testing.T) {
	assert.Equal(t, map[string]string{"a": "bcc-members", "b": "public"}, parseSearchKeys(" a:bcc-members , b:public,broken,:x,y:"))
	assert.Empty(t, parseSearchKeys(""))
}
