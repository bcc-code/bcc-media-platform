package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"github.com/Masterminds/squirrel"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/jsonlogic"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
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
		// Always scan the random field, but throw it away
		var ignoredRandom float64
		err := rows.Scan(&row.Collection, &row.ID, &row.UUID, &ignoredRandom)
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

func addLanguageFilter(query jsonlogic.Query, languagePreferences common.LanguagePreferences) jsonlogic.Query {
	if !languagePreferences.ContentOnlyInPreferredLanguage {
		return query
	}

	filter := squirrel.And{}

	filter = append(filter,
		query.Filter,
		squirrel.Or{
			squirrel.Expr("audio && ?", pq.Array(languagePreferences.PreferredAudioLanguages)),
			squirrel.Expr("subtitles && ?", pq.Array(languagePreferences.PreferredSubtitlesLanguages)),
		},
	)

	query.Filter = filter
	return query
}

type FilterParams struct {
	Roles               []string
	LanguagePreferences common.LanguagePreferences
	Filter              common.Filter
	NoLimit             bool
	Randomized          bool
	Cursor              *utils.RandomizedCursor
}

// GetItemIDsForFilter returns an array of ids for the collection
func GetItemIDsForFilter(ctx context.Context, db *sql.DB,
	args FilterParams,
) ([]common.Identifier, error) {
	if args.Filter.Filter == nil {
		return nil, nil
	}

	var filterObject map[string]any
	_ = json.Unmarshal(args.Filter.Filter, &filterObject)

	var orderByString string
	if args.Filter.SortBy != "" {
		orderByString = "t." + pq.QuoteIdentifier(args.Filter.SortBy)
	}
	if orderByString != "" && args.Filter.SortByDirection != "" {
		switch args.Filter.SortByDirection {
		case "desc":
			orderByString += " DESC"
		case "asc":
			orderByString += " ASC"
		}
	}

	query := jsonlogic.GetSQLQueryFromFilter(filterObject)
	query = addLanguageFilter(query, args.LanguagePreferences)

	from := "filter_dataset t"
	selectFields := []string{"t.collection", "t.id", "t.uuid"}
	// Always apply the complex randomization logic, regardless of randomized flag
	selectFields = append(selectFields, fmt.Sprintf(`CASE
    WHEN t.tags @> ARRAY['%s']::varchar[] AND %f > 0.0
      THEN CASE WHEN random() < %f THEN random() ELSE random() + 1 END
    ELSE random()
  END AS r`, args.Filter.DeboostTag, args.Filter.DeboostFactor, args.Filter.DeboostFactor))
	q := squirrel.StatementBuilder.
		PlaceholderFormat(squirrel.Dollar).
		Select(selectFields...).
		From(from).
		Where(query.Filter)

	if !args.NoLimit {
		if args.Filter.Limit != nil && *args.Filter.Limit > 0 {
			limit := *args.Filter.Limit
			q = q.Limit(uint64(limit))
		} else {
			q = q.Limit(20)
		}
	}

	//q = parseJoins(q, collection, query.Joins)

	if args.Roles != nil {
		q = addPermissionFilter(q, args.Roles)
	}

	// Always append random order as last if randomized
	if args.Randomized {
		if orderByString != "" {
			q = q.OrderBy(orderByString, "r")
		} else {
			q = q.OrderBy("r")
		}
	} else if orderByString != "" {
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
