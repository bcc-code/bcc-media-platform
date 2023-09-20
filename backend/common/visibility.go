package common

import (
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
	"time"
)

type Visibility struct {
	Published     bool
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
	r.Published = vm.Published && v.Published
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
