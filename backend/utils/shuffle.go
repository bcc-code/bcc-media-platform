package utils

import (
	"math/rand"

	"github.com/samber/lo"
)

func shuffle[T comparable](collection []T, seed int64) []T {
	r := rand.New(rand.NewSource(seed))
	r.Shuffle(len(collection), func(i, j int) {
		collection[i], collection[j] = collection[j], collection[i]
	})

	return collection
}

// ShuffleSegmentedArray shuffles the segments and flattens to one array and tries to keep segments shuffled within segmentLength
// minimumSegmentLength to make sure big batches of shorts still get prioritized more than the rest
func ShuffleSegmentedArray[T comparable](segments [][]T, minimumSegmentLength int, seed int64) []T {
	var source [][]T
	// deep copy the segments
	for _, segment := range segments {
		source = append(source, append([]T{}, segment...))
	}
	var result []T

	segmentCount := len(source)
	for i := 0; i < segmentCount; i++ {
		keys := source[i]

		if len(keys) < minimumSegmentLength {
			// fill keys from the next segments
			for x := i + 1; x < segmentCount; x++ {
				nextKeys := source[x]
				nextKeys = shuffle(nextKeys, seed)
				newKeys := nextKeys

				for _, key := range nextKeys {
					if len(keys) < minimumSegmentLength {
						keys = append(keys, key)
						newKeys = lo.Filter(newKeys, func(i T, _ int) bool {
							return i != key
						})
					}
				}

				source[x] = newKeys
			}
		}

		keys = shuffle(keys, seed)

		result = append(result, keys...)
	}

	return result
}
