package utils

import (
	"context"

	"github.com/samber/lo"
)

// MapWithCtx performs a lo.Map but adds ctx as the 1st param to the map function and ignores index
func MapWithCtx[T any, TOut any](ctx context.Context, list []T, f func(context.Context, T) TOut) []TOut {
	return lo.Map(list, func(element T, _ int) TOut {
		return f(ctx, element)
	})
}
