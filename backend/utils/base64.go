package utils

import (
	"encoding/base64"
	"encoding/json"
)

// Base64DecodeAndUnmarshal decodes base64 and marshals
func Base64DecodeAndUnmarshal[T any](data string) (*T, error) {
	marshalled, err := base64.StdEncoding.DecodeString(data)
	if err != nil {
		return nil, err
	}
	var result T
	err = json.Unmarshal(marshalled, &result)
	if err != nil {
		return nil, err
	}
	return &result, nil
}

// MarshalAndBase64Encode marshals to json and base64 encodes result
func MarshalAndBase64Encode[T any](data T) (string, error) {
	marshalled, err := json.Marshal(data)
	if err != nil {
		return "", err
	}
	// encode to base64
	return base64.StdEncoding.EncodeToString(marshalled), nil
}
