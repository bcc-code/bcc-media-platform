package jsonlogic

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/Masterminds/squirrel"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
)

// Query is the struct for filter and joins
type Query struct {
	Filter squirrel.Sqlizer
	Joins  []string
}

func arrayToSql(value any) string {
	switch t := value.(type) {
	case string:
		return pq.QuoteLiteral("{" + t + "}")
	}
	return "false"
}

func relativeOrFalse(operator string, property string, value any) (squirrel.Sqlizer, bool) {
	if str, ok := value.(string); ok {
		if strings.HasPrefix(str, "relative:") {
			return squirrel.Expr(fmt.Sprintf("%s %s (NOW() + interval %s)", property, operator, pq.QuoteLiteral(strings.Replace(str, "relative:", "", 1)))), true
		} else if strings.HasPrefix(str, "relativeneg:") {
			return squirrel.Expr(fmt.Sprintf("%s %s (NOW() - interval %s)", property, operator, pq.QuoteLiteral(strings.Replace(str, "relativeneg:", "", 1)))), true
		}
	}
	return squirrel.Eq{
		"1": "0",
	}, false
}

func toSquirrelQuery(operator string, property string, value any) (squirrel.Sqlizer, error) {
	switch operator {
	case "==", "in":
		return squirrel.Eq{
			property: value,
		}, nil
	case "!=", "notin":
		return squirrel.NotEq{
			property: value,
		}, nil
	case "<":
		if rel, ok := relativeOrFalse(operator, property, value); ok {
			return rel, nil
		}
		return squirrel.Lt{
			property: value,
		}, nil
	case "<=":
		if rel, ok := relativeOrFalse(operator, property, value); ok {
			return rel, nil
		}
		return squirrel.LtOrEq{
			property: value,
		}, nil
	case ">":
		if rel, ok := relativeOrFalse(operator, property, value); ok {
			return rel, nil
		}
		return squirrel.Gt{
			property: value,
		}, nil
	case ">=":
		if rel, ok := relativeOrFalse(operator, property, value); ok {
			return rel, nil
		}
		return squirrel.GtOrEq{
			property: value,
		}, nil
	case "is", "@>":
		return squirrel.Expr(fmt.Sprintf("%s @> %s", property, arrayToSql(value))), nil
	case "!is":
		return squirrel.Expr(fmt.Sprintf("NOT (%s @> %s)", property, arrayToSql(value))), nil
	}
	return squirrel.Eq{
		"1": "0",
	}, merry.New("unknown operator")
}

func (q *Query) getSQLStringFromFilter(filter map[string]any) squirrel.Sqlizer {
	for key, values := range filter {
		switch key {
		case "and":
			var filters squirrel.And
			switch t := values.(type) {
			case []any:
				for _, value := range t {
					switch v := value.(type) {
					case map[string]any:
						filters = append(filters, q.getSQLStringFromFilter(v))
					}
				}
			}
			return filters
		case "or":
			var filters squirrel.Or
			switch t := values.(type) {
			case []any:
				for _, value := range t {
					switch v := value.(type) {
					case map[string]any:
						filters = append(filters, q.getSQLStringFromFilter(v))
					}
				}
			}
			return filters
		case "==", "!=", ">", "<", ">=", "<=", "in", "is", "!is":
			var part squirrel.Sqlizer
			switch t := values.(type) {
			case []any:
				if len(t) != 2 {
					return squirrel.Eq{
						"1": "0",
					}
				}
				leftSource := t[0]
				rightSource := t[1]

				var property string

				if propMap, ok := leftSource.(map[string]any); ok {
					property, ok = propMap["var"].(string)
					if ok {
						parts := strings.Split(property, ".")
						if len(parts) == 2 {
							q.Joins = append(q.Joins, parts[0])
						} else {
							property = "t." + pq.QuoteIdentifier(property)
						}
					}
				}

				if property == "" {
					continue
				}

				var err error
				part, err = toSquirrelQuery(key, property, rightSource)

				if err != nil {
					return squirrel.Eq{
						"1": "0",
					}
				}
			}
			return part
		}
	}
	marshalled, _ := json.Marshal(filter)
	log.L.Debug().Str("filter", string(marshalled)).Msg("Invalid filter passed")
	return squirrel.Eq{
		"1": "0",
	}
}

// GetSQLQueryFromFilter returns an SQL string from filter
func GetSQLQueryFromFilter(filter map[string]any) Query {
	q := Query{}
	q.Filter = q.getSQLStringFromFilter(filter)
	return q
}
