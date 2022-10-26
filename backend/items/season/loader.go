package season

import (
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for seasons
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Season] {
	return batchloaders.NewLoader(queries.GetSeasons)
}

// NewPermissionLoader returns a loader for permissions
func NewPermissionLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Permissions[int]] {
	return batchloaders.NewCustomLoader(queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
		return i.ItemID
	})
}
