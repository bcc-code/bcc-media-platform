package utils

import "github.com/samber/lo"

// ShuffleSegmentedArray shuffles the segments and flattens to one array and tries to keep segments shuffled within segmentLength
func ShuffleSegmentedArray[T comparable](segments [][]T, segmentLength int) []T {
	var source [][]T
	// deep copy the segments
	for _, segment := range segments {
		source = append(source, append([]T{}, segment...))
	}
	var result []T

	segmentCount := len(source)
	for i := 0; i < segmentCount; i++ {
		keys := source[i]

		if len(keys) < segmentLength {
			// fill keys from the next segments
			for x := i + 1; x < segmentCount; x++ {
				nextKeys := source[x]
				nextKeys = lo.Shuffle(nextKeys)
				newKeys := nextKeys

				for _, key := range nextKeys {
					if len(keys) < segmentLength {
						keys = append(keys, key)
						newKeys = lo.Filter(newKeys, func(i T, _ int) bool {
							return i != key
						})
					}
				}

				source[x] = newKeys
			}
		}

		keys = lo.Shuffle(keys)

		result = append(result, keys...)
	}

	return result
}
