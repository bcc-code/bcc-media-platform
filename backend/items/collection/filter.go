package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/Masterminds/squirrel"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/jsonlogic"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
)

func itemIdsFromRows(rows *sql.Rows) []int {
	var ids []int

	for rows.Next() {
		var id int
		_ = rows.Scan(&id)
		ids = append(ids, id)
	}

	_ = rows.Close()
	return ids
}

func parseJoins(query squirrel.SelectBuilder, collection string, joins []string) squirrel.SelectBuilder {
	for _, join := range joins {
		switch join {
		case "show":
			switch collection {
			case "seasons":
				query = query.Join("shows show ON show.id = t.show_id")
			case "episodes":
				query = query.Join("seasons season ON season.id = t.season_id JOIN shows show ON show.id = season.show_id")
			}
		case "season":
			switch collection {
			case "episodes":
				query = query.Join("seasons season ON season.id = t.season_id")
			}
		case "tags":
			switch collection {
			case "episodes":
				query = query.Join("episodes_tags episodes_tags ON episodes_tags.episodes_id = t.id JOIN tags tags ON tags.id = episodes_tags.tags_id")
			}
		}
	}
	return query
}

// GetItemIDsForFilter returns an array of ids for the collection
func GetItemIDsForFilter(ctx context.Context, db *sql.DB, collection string, f common.Filter) ([]int, error) {
	if f.Filter == nil {
		return nil, nil
	}

	var filterObject map[string]any
	_ = json.Unmarshal(f.Filter, &filterObject)

	var orderByString string
	if f.SortBy != "" {
		orderByString = pq.QuoteIdentifier(f.SortBy)
	}
	if orderByString != "" && f.SortByDirection != "" {
		switch f.SortByDirection {
		case "desc":
			orderByString += " DESC"
		case "asc":
			orderByString += " ASC"
		}
	}

	query := jsonlogic.GetSQLQueryFromFilter(filterObject)

	q := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar).Select("t.id").From(collection + " t").Where(query.Filter)

	q = parseJoins(q, collection, query.Joins)

	queryString, args, err := q.OrderBy(orderByString).ToSql()
	if err != nil {
		return nil, err
	}

	if ctx.Value("preview") == true {
		log.L.Debug().Str("query", queryString).Msg("Querying database for previewing filter")
	}

	rows, err := db.Query(queryString, args...)
	if err != nil {
		return nil, err
	}
	return itemIdsFromRows(rows), nil
}
