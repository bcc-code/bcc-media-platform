package pubsub

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"time"

	"github.com/gin-gonic/gin"
)

/*
This package parses and validates a signed PubSub http message.
It requies a gin context, to extract the data.

Example pubsub body body format:
```
{
    "message": {
        "attributes": {
            "key": "value"
        },
        "data": "SGVsbG8gQ2xvdWQgUHViL1N1YiEgSGVyZSBpcyBteSBtZXNzYWdlIQ==",
        "messageId": "2070443601311540",
        "message_id": "2070443601311540",
        "publishTime": "2021-02-26T19:13:55.749Z",
        "publish_time": "2021-02-26T19:13:55.749Z",
    },
   "subscription": "projects/myproject/subscriptions/mysubscription"
}
```
*/

// MessageFromCtx that was send to the server from PubSub
func MessageFromCtx(ctx *gin.Context) (*Message, error) {
	msg := &Message{}
	err := ctx.BindJSON(msg)
	if err != nil {
		return nil, err
	}
	return msg, nil
}

// Message represents the body of the message we get from PubSub
type Message struct {
	Message      Msg    `json:"message"`
	Subscription string `json:"subscription"`
}

// Msg is the message encoded in the PubSub data
type Msg struct {
	Attributes  map[string]string `json:"attributes"`
	Data        string            `json:"data"`
	MessageID   string            `json:"messageId"`
	PublishTime time.Time         `json:"publishTime"`
}

// ExtractData from a message into the given struct
func ExtractData[T any](m Message, out *T) error {
	decoded, err := base64.StdEncoding.DecodeString(m.Message.Data)
	if err != nil {
		return err
	}

	return json.Unmarshal(decoded, out)
}

// Validate if the message is signed with the correct key
func (m Message) Validate(sharedKey string) bool {
	var msgHash string

	if hash, ok := m.Message.Attributes["hash"]; ok {
		msgHash = hash
	} else {
		// The message has no hash and can't be validated
		return false
	}

	h := hmac.New(sha256.New, []byte(sharedKey))
	decoded, err := base64.StdEncoding.DecodeString(m.Message.Data)
	if err != nil {
		return false
	}
	h.Write(decoded)

	sha := base64.StdEncoding.EncodeToString(h.Sum(nil))

	// Check if we have the same hash
	return msgHash == sha
}
