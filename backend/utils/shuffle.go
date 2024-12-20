package utils

import (
	"math/rand"
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
func ShuffleSegmentedArray[T comparable](source []T, segmentLength int, randomFactor float64, seed int64) []T {

	var result []T

	start := 0

	for {
		end := min(start+segmentLength, len(source))
		end = min(int(randomFactor*float64(segmentLength))+end, len(source))

		keys := source[start:end]

		keys = shuffle(keys, seed)

		result = append(result, keys...)
		if end >= len(source) {
			break
		}
		start = end
	}

	return result
}
