package elastic

import (
	"encoding/json"
	"fmt"
	"github.com/bcc-code/mediabank-bridge/log"
)

func toSearchQuery(query string) string {
	// TODO: is this safe enough?
	marshalled, err := json.Marshal(query)
	if err != nil {
		log.L.Error().Err(err).Send()
	}
	return fmt.Sprintf(`{
	"_source": false,
	"query": {
	    "bool": {
	        "should": [
				{
					"multi_match": {
					   "query": %[1]s,
					   "boost": 3,
					   "fields": ["text.no", "text.en"]
					}
				},
				{
					"multi_match": {
					   "query": %[1]s,
					   "fuzziness": "AUTO",
					   "boost": 2,
					   "fields": ["text.no", "text.en"]
					}
				}
            ]
	    }
	},
	"size": 10,
	"from": 0,
	"highlight": {
		"order": "score",
        "phrase_limit": "1024",
		"type": "fvh",
		"boundary_scanner": "word",
		"fields": {
			"text.no": {}
		}
	}
}`, marshalled)
}
