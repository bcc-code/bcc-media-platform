package main

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLiveReplayURLPrefix(t *testing.T) {
	assert.Equal(t, "https://live.bcc-connect.org/replay/", liveReplayURLPrefix("https://live.bcc-connect.org"))
	assert.Equal(t, "https://live.bcc-connect.org/replay/", liveReplayURLPrefix("https://live.bcc-connect.org/"))
}

func TestHandleCalendarEntryEvent_IgnoresOtherCollections(t *testing.T) {
	// No queries configured: touching the DB would panic.
	h := &modelHandler{}
	assert.NoError(t, h.handleCalendarEntryEvent(context.Background(), "episodes", "3125"))
}

func TestHandleCalendarEntryEvent_InvalidKey(t *testing.T) {
	h := &modelHandler{}
	assert.Error(t, h.handleCalendarEntryEvent(context.Background(), "calendarentries", "abc"))
}
