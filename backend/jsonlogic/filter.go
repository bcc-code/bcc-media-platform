package jsonlogic

import (
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
	"strconv"
	"strings"
)

func opToDbOp(operator string) string {
	switch operator {
	case "==":
		return "="
	case "!=":
		return "NOT EQUALS"
	default:
		return operator
	}
}

func getValueFromSource(source any) (string, error) {
	switch v := source.(type) {
	case map[string]any:
		if prop, ok := v["var"]; ok {
			switch vt := prop.(type) {
			case string:
				// enough to avoid sql injection? Columns shouldn't have any spaces anyway heh
				if strings.Contains(vt, " ") {
					return "", merry.New("malformed property string")
				}
				return pq.QuoteIdentifier(vt), nil
			}
		}
	case string:
		return pq.QuoteLiteral(v), nil
	case float64:
		return strconv.Itoa(int(v)), nil
	case int:
		return strconv.Itoa(v), nil
	}
	return "", merry.New("unsupported source type")
}

// GetSQLStringFromFilter returns an SQL string from filter
func GetSQLStringFromFilter(filter map[string]any) string {
	for key, values := range filter {
		switch key {
		case "and", "or":
			var filters []string
			switch t := values.(type) {
			case []any:
				for _, value := range t {
					switch v := value.(type) {
					case map[string]any:
						filters = append(filters, GetSQLStringFromFilter(v))
					}
				}
			}
			return "(" + strings.Join(filters, ") "+strings.ToUpper(key)+" (") + ")"
		case "==", "!=", ">", "<", ">=", "<=":
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
				left, err = getValueFromSource(leftSource)
				if err != nil {
					return "1 = 0"
				}
				right, err = getValueFromSource(rightSource)
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
