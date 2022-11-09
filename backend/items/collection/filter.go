package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"github.com/Masterminds/squirrel"
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

func addPermissionFilter(query squirrel.SelectBuilder, collection string, roles []string) squirrel.SelectBuilder {
	var roleTable string
	var availabilityTable string
	switch collection {
	case "episodes":
		roleTable = "episode_roles"
		availabilityTable = "episode_availability"
	case "season":
		roleTable = "season_roles"
		availabilityTable = "season_availability"
	case "show":
		roleTable = "show_roles"
		availabilityTable = "show_availability"
	default:
		return query
	}
	query = query.Join(fmt.Sprintf("%s roles ON roles.id = t.id", roleTable))
	query = query.Join(fmt.Sprintf("%s availability ON availability.id = t.id", availabilityTable))
	query = query.Where(squirrel.And{
		squirrel.Eq{
			"availability.published": "true",
		},
		squirrel.Expr("availability.available_to > now()"),
		squirrel.Expr("availability.available_from < now()"),
		squirrel.Expr("roles.roles && ?", fmt.Sprintf("{%s}", strings.Join(roles, ","))),
	})
	return query
}

// GetItemIDsForFilter returns an array of ids for the collection
func GetItemIDsForFilter(ctx context.Context, db *sql.DB, roles []string, collection string, f common.Filter) ([]int, error) {
	if f.Filter == nil {
		return nil, nil
	}

	var filterObject map[string]any
	_ = json.Unmarshal(f.Filter, &filterObject)

	var orderByString string
	if f.SortBy != "" {
		orderByString = "t." + pq.QuoteIdentifier(f.SortBy)
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

	if f.Limit != nil && *f.Limit > 0 {
		limit := *f.Limit
		q = q.Limit(uint64(limit))
	}

	q = parseJoins(q, collection, query.Joins)

	if roles != nil {
		q = addPermissionFilter(q, collection, roles)
	}

	q = q.OrderBy(orderByString)

	if ctx.Value("preview") == true {
		queryString, _, err := q.ToSql()
		if err != nil {
			return nil, err
		}
		log.L.Debug().Str("query", queryString).Msg("Querying database for previewing filter")
	}

	rows, err := q.RunWith(db).Query()
	if err != nil {
		return nil, err
	}
	return itemIdsFromRows(rows), nil
}
