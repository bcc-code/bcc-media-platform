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

	// --- Randomization/Deboost Logic ---
	//
	// This CASE expression calculates a pseudo-random value for each row, with optional deboosting if a specific tag is present.
	//
	// Variables:
	//   - args.Filter.DeboostTag:     The tag (string) that triggers deboosting if present in t.tags (array)
	//   - args.Filter.DeboostFactor:  The deboost factor (float64) to apply if the tag is present
	//   - randomFunc:                 The SQL expression/function that produces a random value per row (e.g. random() or seeded value)
	//
	// Logic:
	//   - If the row's tags contain DeboostTag AND DeboostFactor > 0:
	//       - If the random value is less than DeboostFactor, increment the random value by 1 (pushes it to the end)
	//       - Otherwise, keep the random value as is
	//   - Else: just use the random value
	//
	// The result is aliased as 'r' and used for randomized ordering with deboost applied to tagged items.
	selectFields = append(
		selectFields,
		fmt.Sprintf(
			`CASE
				WHEN t.tags @> ARRAY['%s']::varchar[] /* DeboostTag */ AND %f > 0.0 /* DeboostFactor */
					THEN CASE WHEN random() < 1.0 - %f /* DeboostFactor */ THEN random() ELSE random() + 1 END
				ELSE random()
			END AS r`,
			args.Filter.DeboostTag, // Tag to check for deboost
			deboostFactor,          // Deboost factor threshold
			deboostFactor,          // Deboost factor threshold
		),
	)

	q := squirrel.StatementBuilder.
		PlaceholderFormat(squirrel.Dollar).
		Select(selectFields...).
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
