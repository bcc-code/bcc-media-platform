package main

import (
	"bytes"
	"encoding/json"
	"github.com/bcc-code/mediabank-bridge/log"
	"net/http"
)

type apiResult[t any] struct {
	Data   t
	Errors any
}

func executeQuery[t any](endpoint, query string, variables, headers map[string]string) (int, t) {
	body, _ := json.Marshal(map[string]any{
		"query":     query,
		"variables": variables,
	})

	req, _ := http.NewRequest(http.MethodPost, endpoint, bytes.NewReader(body))

	req.Header.Add("Content-Type", "application/json")
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	var result apiResult[t]

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.L.Error().Err(err).Send()
		return 500, result.Data
	}

	_ = json.NewDecoder(res.Body).Decode(&result)

	if result.Errors != nil {
		return 503, result.Data
	}
	return 200, result.Data
}
