package common

import (
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
	"time"
)

type Visibility struct {
	Status        string
	PublishDate   time.Time
	AvailableFrom *time.Time
	AvailableTo   *time.Time
}

func largestTime(alts []*time.Time) time.Time {
	return utils.LargestTime(lo.Map(lo.Filter(alts, func(t *time.Time, _ int) bool {
		return t != nil
	}), func(t *time.Time, _ int) time.Time {
		return t.UTC()
	})...)
}

func smallestTime(alts []*time.Time) time.Time {
	return utils.LargestTime(lo.Map(lo.Filter(alts, func(t *time.Time, _ int) bool {
		return t != nil
	}), func(t *time.Time, _ int) time.Time {
		return t.UTC()
	})...)
}

func (v *Visibility) Merge(vm Visibility) (r Visibility) {
	r = Visibility{}
	r.Status = MostRestrictiveStatus(v.Status, vm.Status)
	r.PublishDate = utils.LargestTime(v.PublishDate, vm.PublishDate)
	availableFrom := largestTime([]*time.Time{v.AvailableFrom, vm.AvailableFrom})
	if availableFrom != (time.Time{}) {
		r.AvailableFrom = &availableFrom
	}
	availableTo := smallestTime([]*time.Time{v.AvailableTo, vm.AvailableTo})
	if availableTo != (time.Time{}) {
		r.AvailableTo = &availableTo
	}
	return
}
