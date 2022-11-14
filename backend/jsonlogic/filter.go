package jsonlogic

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	"github.com/Masterminds/squirrel"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
	"github.com/samber/lo"
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
		return squirrel.Lt{
			property: value,
		}, nil
	case "<=":
		return squirrel.LtOrEq{
			property: value,
		}, nil
	case ">":
		return squirrel.Gt{
			property: value,
		}, nil
	case ">=":
		return squirrel.GtOrEq{
			property: value,
		}, nil
	case "is", "@>":
		return squirrel.Expr(fmt.Sprintf("%s @> %s", property, arrayToSql(value))), nil
	}
	return squirrel.Eq{
		"1": "0",
	}, merry.New("unknown operator")
}

func (q *Query) getValueFromSource(source any) (string, error) {
	switch v := source.(type) {
	case map[string]any:
		if prop, ok := v["var"]; ok {
			switch vt := prop.(type) {
			case string:
				return pq.QuoteIdentifier(vt), nil
			}
		}
	case string:
		return pq.QuoteLiteral(v), nil
	case float64:
		return strconv.Itoa(int(v)), nil
	case int:
		return strconv.Itoa(v), nil
	case []any:
		return "(" + strings.Join(lo.Map(v, func(i any, _ int) string {
			if s, ok := i.(string); ok {
				return pq.QuoteLiteral(s)
			}

			return "false"
		}), ",") + ")", nil
	}
	return "", merry.New("unsupported source type")
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
		case "==", "!=", ">", "<", ">=", "<=", "in", "is":
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
