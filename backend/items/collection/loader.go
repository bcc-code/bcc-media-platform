package collection

import (
	"context"
	"database/sql"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// Entry contains the ID and collection of a CollectionItem
type Entry struct {
	ID         string
	Collection common.ItemCollection
	Sort       int
}

// GetBaseCollectionEntries returns entries for the specified collection, without any special filtering
//
// Note: The collection config might specify advanced filtering, like continue watching or my list, which is not handled here
func GetBaseCollectionEntries(
	ctx context.Context,
	db *sql.DB,
	loaders *common.BatchLoaders,
	personalizedLoaders *common.PersonalizedLoaders,
	collectionId int,
	langPreferences common.LanguagePreferences,
	randomSeed null.Int,

) ([]Entry, error) {
	col, err := loaders.CollectionLoader.Get(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.Type {
	case "select":
		items, err := personalizedLoaders.CollectionItemsLoader.Get(ctx, col.ID)
		if err != nil {
			return nil, err
		}
		return lo.Map(items, func(i *common.CollectionItem, _ int) Entry {
			return Entry{
				ID:         i.ItemID,
				Collection: i.Type,
				Sort:       i.Sort,
			}
		}), nil
	case "randomized_query":
		fallthrough
	case "query":
		return processQuery(ctx, db, col, langPreferences, randomSeed)
	}
	return nil, nil
}

func processQuery(ctx context.Context, db *sql.DB, col *common.Collection, langPrefs common.LanguagePreferences, randomSeed null.Int) ([]Entry, error) {

	if col.Filter == nil {
		return nil, fmt.Errorf("no filter provided")
	}

	ginCtx, _ := utils.GinCtx(ctx)
	roles := user.GetRolesFromCtx(ginCtx)

	query := GetSQLForFilter(FilterParams{
		Roles:               roles,
		LanguagePreferences: langPrefs,
		Filter:              *col.Filter,
		NoLimit:             col.AdvancedType.Valid,
		RandomSeed:          randomSeed,
	})
	if query == nil {
		return nil, fmt.Errorf("no filter provided")
	}

	rows, err := query.RunWith(db).Query()

	if err != nil {
		queryString, _, _ := query.ToSql()
		log.L.Debug().Str("query", queryString).Err(err).Msg("Error occurred when trying to run query")
		return nil, err
	}

	identifiers := ItemIdsFromRows(rows)

	return lo.Map(identifiers, func(id common.Identifier, index int) Entry {
		c := common.Collections.Parse(id.Collection)
		if c == nil {
			c = &common.CollectionEpisodes
		}
		return Entry{
			ID:         id.ID,
			Collection: *c,
			Sort:       index,
		}
	}), nil
}
