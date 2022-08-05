package sqlc

import (
	"github.com/samber/lo"
)

func intToInt32(ids []int) []int32 {
	return lo.Map(ids, func(id int, _ int) int32 {
		return int32(id)
	})
}
