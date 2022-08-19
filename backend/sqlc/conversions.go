package sqlc

import (
	"github.com/samber/lo"
)

func intToInt32(ids []int) []int32 {
	return lo.Map(ids, func(id int, _ int) int32 {
		return int32(id)
	})
}

func int32ToInt(ids []int32) []int {
	return lo.Map(ids, func(id int32, _ int) int {
		return int(id)
	})
}
