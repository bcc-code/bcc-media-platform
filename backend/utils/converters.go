package utils

import (
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// AsUuid parses string as Uuid, and returns it or an empty uuid.
func AsUuid(s string) uuid.UUID {
	uid, err := uuid.Parse(s)
	if err != nil {
		log.L.Error().Err(merry.Wrap(err)).Msg("Failed to parse UUID")
	}
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

// MapWith function
func MapWith[T any, R any](collection []T, with func(T) R) []R {
	return lo.Map(collection, func(i T, _ int) R {
		return with(i)
	})
}
