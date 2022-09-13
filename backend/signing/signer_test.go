package signing

import (
	"testing"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
)

type testSignatureProvider struct{}

func (sp testSignatureProvider) SignWithPolicy(url string, pol *sign.Policy) (string, error) {
	return url + "?Policy=DEADBEEF", nil
}

func TestStreamSignature(t *testing.T) {
	// signer := testSignatureProvider{}

	// TODO: Fix this
	t.SkipNow()

	//signed, err := signedStreamURL(signer, "/v1/out/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbb/ccccccccccccccccccc", "domain.com")
	//assert.NoError(t, err)
	// assert.Equal(t, "https://domain.com/v1/out/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbb/ccccccccccccccccccc?EncodedPolicy=Policy%3DDEADBEEF", signed)
}
