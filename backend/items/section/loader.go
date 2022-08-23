package section

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewPermissionLoader returns a loader for permissions
func NewPermissionLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Permissions[int]] {
	return common.NewCustomBatchLoader(queries.GetPermissionsForSections, func(i common.Permissions[int]) int {
		return i.ItemID
	})
}
