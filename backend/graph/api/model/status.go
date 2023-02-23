package model

type canBeUnlisted interface {
	Unlisted() bool
}

func statusFrom(i canBeUnlisted) Status {
	if i.Unlisted() {
		return StatusUnlisted
	}
	return StatusPublished
}
