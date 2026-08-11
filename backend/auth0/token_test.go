package auth0

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// sendTokenRequest used to call http.Post, which ignores the context entirely
// and runs on http.DefaultClient — no timeout at all. Since GetToken gates every
// Management API call, a hung Auth0 endpoint would block indefinitely.
func TestSendTokenRequestHonoursContextCancellation(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Hold the request open until the client gives up, but never longer than
		// this test could reasonably need — Close waits on outstanding handlers.
		select {
		case <-r.Context().Done():
		case <-time.After(500 * time.Millisecond):
		}
	}))
	defer srv.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 50*time.Millisecond)
	defer cancel()

	start := time.Now()
	_, err := sendTokenRequest(ctx, map[string]string{"grant_type": "client_credentials"}, srv.URL)
	elapsed := time.Since(start)

	require.Error(t, err, "a cancelled context should abort the request")
	assert.Less(t, elapsed, 300*time.Millisecond, "request did not stop when the context was cancelled")
}

func TestSendTokenRequestParsesResponse(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "application/json", r.Header.Get("Content-Type"))
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"access_token":"tok","expires_in":3600,"token_type":"Bearer"}`))
	}))
	defer srv.Close()

	got, err := sendTokenRequest(context.Background(), map[string]string{}, srv.URL)
	require.NoError(t, err)
	assert.Equal(t, "tok", got.AccessToken)
	assert.WithinDuration(t, time.Now().Add(time.Hour), got.ExpiresAt, time.Minute)
}

func TestSendTokenRequestSurfacesNon2xx(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusUnauthorized)
		_, _ = w.Write([]byte(`{"error":"access_denied"}`))
	}))
	defer srv.Close()

	_, err := sendTokenRequest(context.Background(), map[string]string{}, srv.URL)
	require.Error(t, err)
	// merry.WithMessage replaces the text with the response body, so the status
	// code is what identifies the failure.
	assert.Equal(t, http.StatusUnauthorized, merry.HTTPCode(err))
	assert.Contains(t, err.Error(), "access_denied")
}
