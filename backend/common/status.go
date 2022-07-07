package common

// Status is a global enum for directus status
type Status string

// Status constants
const (
	StatusDraft     = Status("draft")
	StatusPublished = Status("published")
	StatusArchived  = Status("archived")
)

var statusWeight = map[Status]int{
	StatusArchived:  3,
	StatusDraft:     2,
	StatusPublished: 1,
}

// MostRestrictiveStatus returns the most restrictive status
func MostRestrictiveStatus(statuses ...Status) (status Status) {
	for _, s := range statuses {
		if statusWeight[s] > statusWeight[status] {
			status = s
		}
	}
	return
}
