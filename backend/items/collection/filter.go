package collection

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"math"
	"strconv"
	"strings"

	"github.com/Masterminds/squirrel"
	"github.com/google/uuid"
	"github.com/lib/pq"
	"gopkg.in/guregu/null.v4"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/jsonlogic"
	"github.com/bcc-code/bcc-media-platform/backend/log"
)

type filterDataSetRow struct {
	Collection string
	ID         int
	UUID       uuid.UUID
}

func ItemIdsFromRows(rows *sql.Rows) []common.Identifier {
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
	RandomSeed          null.Int
}

// GetItemIDsForFilter returns an array of ids for the collection
func GetSQLForFilter(args FilterParams) *squirrel.SelectBuilder {
	if args.Filter.Filter == nil {
		return nil
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

	if args.RandomSeed.Valid {
		// Use deterministic randomization with seed from cursor
		// PostgreSQL setseed() expects a value between -1 and 1
		seed := float64(args.RandomSeed.Int64) / math.MaxInt64 // Convert int64 to float between -1 and 1
		// We'll need to set the seed before the main query
		from = fmt.Sprintf("(SELECT setseed(%f)) seed_setter, filter_dataset t", seed)
	}

	// Convert % value to a [-1, 1] float
	deboostFactor := args.Filter.DeboostFactor / 100.0

	// Randomization with optional per-tag deboost. DeboostTag and DeboostFactor
	// are parameterized to keep CMS-authored values from breaking out of the
	// SQL literal.
	const deboostExpr = `CASE
			WHEN t.tags @> ARRAY[?]::varchar[] AND ? > 0.0
				THEN CASE WHEN random() < 1.0 - ? THEN random() ELSE random() + 1 END
			ELSE random()
		END AS r`

	q := squirrel.StatementBuilder.
		PlaceholderFormat(squirrel.Dollar).
		Select(selectFields...).
		Column(squirrel.Expr(deboostExpr, args.Filter.DeboostTag, deboostFactor, deboostFactor)).
		From(from).
		Where(query.Filter)

	if !args.NoLimit && !args.RandomSeed.Valid {
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
	if args.RandomSeed.Valid {
		if orderByString != "" {
			q = q.OrderBy(orderByString, "r")
		} else {
			q = q.OrderBy("r")
		}
	} else if orderByString != "" {
		q = q.OrderBy(orderByString)
	}

	return &q

	/*
	 */
}
