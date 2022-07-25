package jsonlogic

import (
	"encoding/json"
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
			return strings.Join(filters, " "+strings.ToUpper(key)+" ")
		case "==", "!=", ">", "<", ">=", "<=":
			var property string
			var value string
			switch t := values.(type) {
			case []any:
				left := t[0]
				right := t[1]

				switch v := left.(type) {
				case map[string]any:
					if prop, ok := v["var"]; ok {
						switch vt := prop.(type) {
						case string:
							// enough to avoid sql injection?
							property = strings.Replace(vt, " ", "", -1)
						}
					}
				}

				switch v := right.(type) {
				case string:
					marshalled, _ := json.Marshal(v)
					value = string(marshalled)
				}
			}
			// TODO: is it possible for sql injection to happen here?
			return property + " " + opToDbOp(key) + " " + value
		}
	}
	return "1 = 0"
}
