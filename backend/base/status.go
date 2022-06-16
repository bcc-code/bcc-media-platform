package base

var statusWeight = map[string]int{
	StatusArchived:  3,
	StatusDraft:     2,
	StatusPublished: 1,
}

func MostRestrictiveStatus(statuses ...string) (status string) {
	for _, s := range statuses {
		if statusWeight[s] > statusWeight[status] {
			status = s
		}
	}
	return
}
