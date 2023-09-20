package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"github.com/Masterminds/squirrel"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/jsonlogic"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/lib/pq"
	"strconv"
	"strings"
)

type filterDataSetRow struct {
	Collection string
	ID         int
	UUID       uuid.UUID
}

func itemIdsFromRows(rows *sql.Rows) []common.Identifier {
	var ids []common.Identifier

	for rows.Next() {
		var row filterDataSetRow
		err := rows.Scan(&row.Collection, &row.ID, &row.UUID)
		if err != nil {
			log.L.Debug().Err(err).Msg("couldn't scan")
		}
		identifier := common.Identifier{
			Collection: row.Collection,
		}
		if row.ID != 0 {
			identifier.ID = strconv.Itoa(row.ID)
		} else {
			identifier.ID = row.UUID.String()
		}
		ids = append(ids, identifier)
	}

	_ = rows.Close()
	return ids
}

func addPermissionFilter(query squirrel.SelectBuilder, roles []string) squirrel.SelectBuilder {
	query = query.Where(squirrel.And{
		squirrel.Eq{
			"published": "true",
		},
		squirrel.Expr(fmt.Sprintf("roles && '{%s}'", strings.Join(roles, ","))),
		squirrel.Expr("available_to > now()"),
		squirrel.Expr("available_from < now()"),
	})
	return query
}

// GetItemIDsForFilter returns an array of ids for the collection
func GetItemIDsForFilter(ctx context.Context, db *sql.DB, roles []string, f common.Filter, noLimit bool) ([]common.Identifier, error) {
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

	from := "filter_dataset t"
	q := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar).Select("t.collection", "t.id", "t.uuid").From(from).Where(query.Filter)

	if !noLimit {
		if f.Limit != nil && *f.Limit > 0 {
			limit := *f.Limit
			q = q.Limit(uint64(limit))
		} else {
			q = q.Limit(20)
		}
	}

	//q = parseJoins(q, collection, query.Joins)

	if roles != nil {
		q = addPermissionFilter(q, roles)
	}

	if orderByString != "" {
		q = q.OrderBy(orderByString)
	}

	if ctx.Value("preview") == true {
		queryString, _, err := q.ToSql()
		if err != nil {
			return nil, err
		}
		log.L.Debug().Str("query", queryString).Msg("Querying database for previewing filter")
	}

	rows, err := q.RunWith(db).Query()
	if err != nil {
		queryString, _, _ := q.ToSql()
		log.L.Debug().Str("query", queryString).Err(err).Msg("Error occurred when trying to run query")
		return nil, err
	}
	return itemIdsFromRows(rows), nil
}
