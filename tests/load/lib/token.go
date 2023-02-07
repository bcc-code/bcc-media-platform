package lib

import (
	"crypto/rsa"
	"github.com/ansel1/merry/v2"
	"github.com/google/uuid"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"time"
)

func GenerateToken(profileID uuid.UUID, privateKey *rsa.PrivateKey) ([]byte, error) {
	tok, err := jwt.NewBuilder().
		Claim("person_id", profileID).
		Issuer("https://api.brunstad.tv/").
		IssuedAt(time.Now()).
		Expiration(time.Now().Add(30 * time.Second)).
		Build()
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Internal server error. TOKEN-ERROR"))
	}

	// Sign a JWT!
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.RS256, privateKey))
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Internal server error. TOKEN-SIGN-ERROR"))
	}

	return signed, nil
}
