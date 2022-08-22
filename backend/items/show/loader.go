package show

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for shows
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Show] {
	return common.NewBatchLoader(queries.GetShows)
}

// NewPermissionLoader returns a loader for permissions
func NewPermissionLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Permissions[int]] {
	return common.NewCustomBatchLoader(queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
		return i.ItemID
	})
}
