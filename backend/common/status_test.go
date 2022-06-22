package common

import "testing"

func TestMostRestrictiveStatus(t *testing.T) {
	statuses := []string{StatusDraft, StatusPublished}
	status := MostRestrictiveStatus(statuses...)
	if status != StatusDraft {
		t.Fatalf("Most restrictive status not retrieved. Got %s, expected %s", status, StatusDraft)
	}

	statuses = []string{StatusPublished, StatusArchived, StatusDraft}
	status = MostRestrictiveStatus(statuses...)
	if status != StatusArchived {
		t.Fatalf("Most restrictive status not retrieved. Got %s, expected %s", status, StatusArchived)
	}
}
