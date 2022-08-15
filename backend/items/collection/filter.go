package collection

import (
	"database/sql"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/jsonlogic"
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

// GetItemIDsForFilter returns an array of ids for the collection
func GetItemIDsForFilter(db *sql.DB, collection string, f common.Filter) ([]int, error) {
	if f.Filter == nil {
		return nil, nil
	}

	var filterObject map[string]any
	_ = json.Unmarshal(f.Filter, &filterObject)
	filterString := jsonlogic.GetSQLStringFromFilter(filterObject)

	var orderByString string
	if f.SortBy != "" {
		orderByString = " ORDER BY " + pq.QuoteIdentifier(f.SortBy)
	}
	if orderByString != "" && f.SortByDirection != "" {
		switch f.SortByDirection {
		case "desc":
			orderByString += " DESC"
		case "asc":
			orderByString += " ASC"
		}
	}

	queryString := "SELECT id FROM " + pq.QuoteIdentifier(collection) + " WHERE " + filterString + orderByString

	rows, err := db.Query(queryString)
	if err != nil {
		return nil, err
	}
	return itemIdsFromRows(rows), nil
}
