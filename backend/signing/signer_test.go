package signing

import (
	"net/url"
	"strings"
	"testing"

	"github.com/bcc-code/brunstadtv/backend/signing/mocks"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
)

func init() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
}

func TestCloudfrontURLSigner(t *testing.T) {
	c := &mocks.Config{}
	c.On("GetAwsSigningKeyPath").Return("./testdata/example.key")
	c.On("GetAwsSigningKeyID").Return("EXAMPLE KEY ID")

	// Note: This is a publically available key. It is not considered sensitive material
	// From: https://phpseclib.com/docs/rsa-keys
	c.On("GetAzureSigningKeyPath").Return("./testdata/example.key")

	signer, err := NewSigner(c)
	assert.NoError(t, err)

	signedURL, err := signer.SignCloudfrontURL("/v1/out/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbb/ccccccccccccccccccc/ddddd/eeee/fff/gggg", "DOMAIN")
	assert.NoError(t, err)

	parsedURL, err := url.Parse(signedURL)
	assert.NoError(t, err)
	policy := parsedURL.Query().Get("EncodedPolicy")
	assert.Equal(t, parsedURL.Path, "/v1/out/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbb/ccccccccccccccccccc/ddddd/eeee/fff/gggg")
	assert.Equal(t, parsedURL.Host, "DOMAIN")
	assert.True(t, strings.HasPrefix(policy, "Policy="))
}

func TestAzureURLSigner(t *testing.T) {
	c := &mocks.Config{}
	c.On("GetAwsSigningKeyPath").Return("./testdata/example.key")
	c.On("GetAwsSigningKeyID").Return("EXAMPLE KEY ID")

	// Note: This is a publically available key. It is not considered sensitive material
	// From: https://phpseclib.com/docs/rsa-keys
	c.On("GetAzureSigningKeyPath").Return("./testdata/example.key")

	signer, err := NewSigner(c)
	assert.NoError(t, err)

	url, err := url.Parse("https://example.com/blah")
	assert.NoError(t, err)

	withToken, err := signer.SignAzureURL(url, "KEY")
	assert.NoError(t, err)

	tokenURL, err := url.Parse(withToken)
	assert.NoError(t, err)

	token := tokenURL.Query().Get("token")
	parsedToken, err := jwt.Parse([]byte(token), jwt.WithVerify(false))
	assert.NoError(t, err)

	assert.Equal(t, []string{"urn:brunstadtv"}, parsedToken.Audience())
	assert.Equal(t, "https://brunstad.tv", parsedToken.Issuer())
	assert.Equal(t, "KEY", parsedToken.PrivateClaims()["urn:microsoft:azure:mediaservices:contentkeyidentifier"])

}
