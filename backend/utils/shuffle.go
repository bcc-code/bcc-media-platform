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
// MinimumSegmentLength to make sure big batches of shorts still get prioritized more than the rest
// It adds random entries to the segments based on the randomFactor. A factor of 1 adds the same amount of random entries as the segment length.
// If the segment is 10 and the factor is 0.5, 5 random entries will be added to the segment, and so on.
func ShuffleSegmentedArray[T comparable](segments [][]T, minimumSegmentLength int, randomFactor float64, seed int64) []T {
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

		if randomFactor != 0.0 {
			randomLength := int(float64(len(keys)) * randomFactor)
			if randomLength > 0 {
				// append random elements to the segment
				nextKeys := lo.Flatten(source[i+1:])
				nextKeys = shuffle(nextKeys, seed)
				if len(nextKeys) > randomLength {
					nextKeys = nextKeys[:randomLength]
				}
				for x := i + 1; x < segmentCount; x++ {
					source[x] = lo.Filter(source[x], func(i T, _ int) bool {
						return !lo.Contains(nextKeys, i)
					})
				}
				keys = append(keys, nextKeys...)
			}
		}

		keys = shuffle(keys, seed)

		result = append(result, keys...)
	}

	return result
}
