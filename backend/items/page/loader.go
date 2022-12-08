package page

import (
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewPermissionLoader returns a loader for permissions
func NewPermissionLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Permissions[int]] {
	return batchloaders.NewCustomLoader(queries.GetPermissionsForPages, func(i common.Permissions[int]) int {
		return i.ItemID
	}).Loader
}
