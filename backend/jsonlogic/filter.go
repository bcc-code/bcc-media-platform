package jsonlogic

import (
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
	"github.com/samber/lo"
	"strconv"
	"strings"
)

// Query is the struct for filter and joins
type Query struct {
	Filter string
	Joins  []string
}

func opToDbOp(operator string) string {
	switch operator {
	case "==":
		return "="
	case "in":
		return "IN"
	default:
		return operator
	}
}

func (q *Query) getValueFromSource(source any) (string, error) {
	switch v := source.(type) {
	case map[string]any:
		if prop, ok := v["var"]; ok {
			switch vt := prop.(type) {
			case string:
				if strings.Contains(vt, ".") {
					parts := strings.Split(vt, ".")
					if len(parts) > 2 {
						return "", merry.New("too many parts")
					}
					q.Joins = append(q.Joins, parts[0])
					return strings.Join(lo.Map(parts, func(s string, _ int) string {
						return pq.QuoteIdentifier(s)
					}), "."), nil
				}
				return "t." + pq.QuoteIdentifier(vt), nil
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

func (q *Query) getSQLStringFromFilter(filter map[string]any) string {
	for key, values := range filter {
		switch key {
		case "and", "or":
			var filters []string
			switch t := values.(type) {
			case []any:
				for _, value := range t {
					switch v := value.(type) {
					case map[string]any:
						filters = append(filters, q.getSQLStringFromFilter(v))
					}
				}
			}
			return "(" + strings.Join(filters, ") "+strings.ToUpper(key)+" (") + ")"
		case "==", "!=", ">", "<", ">=", "<=", "in":
			var left string
			var right string
			switch t := values.(type) {
			case []any:
				if len(t) != 2 {
					return "1 = 0"
				}
				leftSource := t[0]
				rightSource := t[1]

				var err error
				left, err = q.getValueFromSource(leftSource)
				if err != nil {
					return "1 = 0"
				}
				right, err = q.getValueFromSource(rightSource)
				if err != nil {
					return "1 = 0"
				}
			}
			return left + " " + opToDbOp(key) + " " + right
		}
	}
	marshalled, _ := json.Marshal(filter)
	log.L.Debug().Str("filter", string(marshalled)).Msg("Invalid filter passed")
	return "1 = 0"
}

// GetSQLQueryFromFilter returns an SQL string from filter
func GetSQLQueryFromFilter(filter map[string]any) Query {
	q := Query{}
	q.Filter = q.getSQLStringFromFilter(filter)
	return q
}
