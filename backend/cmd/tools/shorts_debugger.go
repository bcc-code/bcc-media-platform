package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

// GraphQLRequest represents the structure of a GraphQL request
type GraphQLRequest struct {
	Query string `json:"query"`
}

// MakeGraphQLRequest sends a GraphQL request and returns the response as a string
func MakeGraphQLRequest(url, bearerToken, query string) (string, error) {
	// Create the request body
	requestBody := GraphQLRequest{
		Query: query,
	}

	jsonBody, err := json.Marshal(requestBody)
	if err != nil {
		return "", fmt.Errorf("error marshaling request: %v", err)
	}

	// Create the HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonBody))
	if err != nil {
		return "", fmt.Errorf("error creating request: %v", err)
	}

	// Set headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", bearerToken))
	req.Header.Set("x-feature-flags", "shorts-with-scores3:enabled")

	// Make the request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("error making request: %v", err)
	}
	defer resp.Body.Close()

	// Read the response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("error reading response: %v", err)
	}

	// Check status code
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("unexpected status code: %d, body: %s", resp.StatusCode, string(body))
	}

	return string(body), nil
}

func ListShorts() gin.HandlerFunc {
	cursor := "eyJzZWVkIjo3MTgxODEzODUxNzAzMTE2NTQ5LCJyYW5kb21Qcm9wb3J0aW9uIjowLCJjdXJyZW50SW5kZXgiOjIwfQ=="
	return func(ctx *gin.Context) {
		shortsIDs := []string{}

		url := "https://api.brunstad.tv/query"
		bearerToken := "<INSERT YOUR OWN>"

		qf, err := os.Open("./query.gql")
		if err != nil {
			fmt.Errorf("%v", err)
			ctx.AbortWithError(500, err)
			return
		}

		queryB, err := io.ReadAll(qf)
		if err != nil {
			fmt.Errorf("%v", err)
			ctx.AbortWithError(500, err)
			return
		}

		for range 10 {
			query := fmt.Sprintf(string(queryB), cursor)

			result, err := MakeGraphQLRequest(url, bearerToken, query)
			if err != nil {
				fmt.Errorf("%v", err)
				ctx.AbortWithError(500, err)
				return
			}

			res := &ShortsRes{}
			err = json.Unmarshal([]byte(result), res)
			if err != nil {
				fmt.Errorf("%v", err)
				ctx.AbortWithError(500, err)
				return
			}

			for _, s := range res.Data.Shorts.Shorts {
				shortsIDs = append(shortsIDs, s.ID)
			}

			cursor = res.Data.Shorts.NextCursor
		}

		ctx.AbortWithStatusJSON(200, shortsIDs)
	}
}

type ShortsRes struct {
	Data struct {
		Shorts struct {
			Shorts []struct {
				ID    string `json:"id"`
				Score int    `json:"score"`
			} `json:"shorts"`
			Cursor     string `json:"cursor"`
			NextCursor string `json:"nextCursor"`
		} `json:"shorts"`
	} `json:"data"`
}
