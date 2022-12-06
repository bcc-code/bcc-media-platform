package utils

import (
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// AsUuid parses string as Uuid, and returns it or an empty uuid.
func AsUuid(s string) uuid.UUID {
	uid, _ := uuid.Parse(s)
	return uid
}

// PointerArrayToArray converts an array of pointers to array
func PointerArrayToArray[K any](collection []*K) []K {
	return lo.Map(lo.Filter(collection, func(i *K, _ int) bool {
		return i != nil
	}), func(i *K, _ int) K {
		return *i
	})
}
