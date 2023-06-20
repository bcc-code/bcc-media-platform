package main

import (
	"bytes"
	"encoding/json"
	"github.com/bcc-code/mediabank-bridge/log"
	"net/http"
)

type apiResult struct {
	Data   any
	Errors any
}

func executeQuery(endpoint, query string, variables map[string]string) int {
	body, _ := json.Marshal(map[string]any{
		"query":     query,
		"variables": variables,
	})

	req, _ := http.NewRequest(http.MethodPost, endpoint, bytes.NewReader(body))

	req.Header.Add("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.L.Error().Err(err).Send()
		return 500
	}

	var result apiResult
	_ = json.NewDecoder(res.Body).Decode(&result)

	if result.Errors != nil {
		return 503
	}
	return 200
}
