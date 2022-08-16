package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/jsonlogic"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
	"strings"
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

func parseJoins(collection string, joins []string) string {
	var result []string
	for _, join := range joins {
		switch join {
		case "show":
			switch collection {
			case "seasons":
				result = append(result, "JOIN shows show ON show.id = t.show_id")
			case "episodes":
				result = append(result, "JOIN seasons se ON se.id = t.season_id JOIN shows show ON show.id = se.show_id")
			}
		case "season":
			switch collection {
			case "episodes":
				result = append(result, "JOIN seasons season ON season.id = t.season_id")
			}
		case "tags":
			switch collection {
			case "episodes":
				result = append(result, "JOIN episodes_tags et ON et.episodes_id = t.id JOIN tags tags ON tags.id = et.tags_id")
			}
		}
	}
	if len(result) > 0 {
		return " " + strings.Join(result, " ")
	}
	return ""
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
		orderByString = " ORDER BY t." + pq.QuoteIdentifier(f.SortBy)
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

	joins := parseJoins(collection, query.Joins)

	queryString := "SELECT t.id FROM " + pq.QuoteIdentifier(collection) + " t" + joins + " WHERE " + query.Filter + orderByString

	if ctx.Value("preview") == true {
		log.L.Debug().Str("query", queryString).Msg("Querying database for previewing filter")
	}

	rows, err := db.Query(queryString)
	if err != nil {
		return nil, err
	}
	return itemIdsFromRows(rows), nil
}
