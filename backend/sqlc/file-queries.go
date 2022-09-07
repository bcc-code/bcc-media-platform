package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetFiles returns files
func (q *Queries) GetFiles(ctx context.Context, ids []uuid.UUID) ([]common.ImageFile, error) {
	files, err := q.getFiles(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(files, func(i DirectusFile, _ int) common.ImageFile {
		return common.ImageFile{
			ID:               i.ID,
			Type:             i.Type,
			FilenameDisk:     i.FilenameDisk,
			Title:            i.Title,
			Storage:          i.Storage,
			FilenameDownload: i.FilenameDownload,
		}
	}), nil
}
