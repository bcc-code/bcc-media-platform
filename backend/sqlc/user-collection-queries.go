package sqlc

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetUserCollections returns user-collections by ids
func (q *Queries) GetUserCollections(ctx context.Context, ids []uuid.UUID) ([]common.UserCollection, error) {
	rows, err := q.getUserCollections(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUserCollectionsRow, _ int) common.UserCollection {
		return common.UserCollection{
			ID:                 i.ID,
			ApplicationGroupID: i.ApplicationgroupID,
			ProfileID:          i.ProfileID,
			Title:              i.Title,
			CreatedAt:          i.CreatedAt,
			UpdatedAt:          i.UpdatedAt,
			Metadata:           common.UserCollectionMetadata{MyList: i.MyList},
		}
	}), nil
}

// GetUserCollectionEntries returns entries by id
func (q *Queries) GetUserCollectionEntries(ctx context.Context, ids []uuid.UUID) ([]common.UserCollectionEntry, error) {
	rows, err := q.getUserCollectionEntries(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUserCollectionEntriesRow, _ int) common.UserCollectionEntry {
		return common.UserCollectionEntry{
			ID:           i.ID,
			CollectionID: i.CollectionID,
			UpdatedAt:    i.UpdatedAt,
			CreatedAt:    i.CreatedAt,
			Type:         i.Type,
			ItemID:       i.ItemID,
			Sort:         int(i.Sort),
		}
	}), nil
}

// GetUserCollectionIDsForProfileIDs returns collection ids for profiles
func (q *Queries) GetUserCollectionIDsForProfileIDs(ctx context.Context, profileIDs []uuid.UUID) ([]loaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getUserCollectionIDsForProfileIDs(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUserCollectionIDsForProfileIDsRow, _ int) loaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetUserCollectionEntryIDsForUserCollectionIDs returns entry ids for collection ids
func (q *Queries) GetUserCollectionEntryIDsForUserCollectionIDs(ctx context.Context, collectionIDs []uuid.UUID) ([]loaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getUserCollectionEntryIDsForUserCollectionIDs(ctx, collectionIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUserCollectionEntryIDsForUserCollectionIDsRow, _ int) loaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetMyListCollectionForProfileIDs returns the id for the profile my list collection
func (q *Queries) GetMyListCollectionForProfileIDs(ctx context.Context, profileIDs []uuid.UUID) ([]loaders.Conversion[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getMyListCollectionForProfileIDs(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getMyListCollectionForProfileIDsRow, _ int) loaders.Conversion[uuid.UUID, uuid.UUID] {
		return conversion[uuid.UUID, uuid.UUID]{
			source: i.ParentID,
			result: i.ID,
		}
	}), nil
}
