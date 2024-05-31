package main

import (
	"database/sql"
	"fmt"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"github.com/pressly/goose/v3"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"testing"
)

func Test_a(t *testing.T) {
	// Add some dummy env vars needed to start the server
	err := os.Setenv("CF_SIGNING_KEY_PATH", "./testdata/cloudfront_signing_key.pem")
	assert.NoError(t, err)

	jwtKey, err := os.ReadFile("./testdata/cloudfront_signing_key.pem")
	assert.NoError(t, err)

	err = os.Setenv("REDIRECT_JWT_KEY", string(jwtKey))
	assert.NoError(t, err)

	err = os.Setenv("AZ_SIGNING_KEY", "<CURRENTLY INVALID KEY BECAUSE I CAN'T BE BOTHERED TO FIGURE OUT HOW TO GENERATE A USELESS VALID ONE>")
	assert.NoError(t, err)

	// Prepare connection string to a new DB
	testDB := uuid.New().String()
	databaseUrl := fmt.Sprintf("postgres://bccm:bccm123@localhost:5432/%s?sslmode=disable", testDB)
	err = os.Setenv("DB_CONNECTION_STRING", databaseUrl)
	assert.NoError(t, err)

	// Create the new DB.
	// We need separate connection because in PG you cannot connect to a db that does not exist yet
	postgresDBUrl := fmt.Sprintf("postgres://bccm:bccm123@localhost:5432/postgres?sslmode=disable")
	rootDbConn, err := sql.Open("postgres", postgresDBUrl)
	assert.NoError(t, err)
	_, err = rootDbConn.Exec(fmt.Sprintf("CREATE DATABASE \"%s\"", testDB))
	assert.NoError(t, err)

	// Connect to the new DB
	mainDbConn, err := sql.Open("postgres", databaseUrl)
	assert.NoError(t, err)

	// Migrate UP
	goose.SetVerbose(true)
	err = goose.Up(mainDbConn, "../../../migrations")
	assert.NoError(t, err)

	// Set up basic data needed for server startup
	_, err = mainDbConn.Exec(`insert into public.applicationgroups (id, user_created, date_created, user_updated, date_updated, label, support_email, firebase_project_id) values ('13cd9f8e-b1c4-4012-b5e8-ce7f6c346875', null, null, null, null, 'Test', 'a@example.com', 'none');`)
	assert.NoError(t, err)

	_, err = mainDbConn.Exec(`insert into public.applications (id, status, user_created, date_created, user_updated, date_updated, name, code, client_version, page_id, "default", search_page_id, standalone_related_collection_id, uuid, group_id, games_page_id) values (3, 'published', null, null, null, null, 'test1', 't1', null, null, true, null, null, '187545b2-ab00-4f0f-8ca3-a850c5ee6add', '13cd9f8e-b1c4-4012-b5e8-ce7f6c346875', null);`)
	assert.NoError(t, err)

	// Get server
	ginE, _ := setup()

	// Run test
	w := httptest.NewRecorder()
	body := strings.NewReader(`
    episodes(ids: ["2685"]) {
        title
        id
    }
}`)
	req, _ := http.NewRequest("POST", "/query", body)
	ginE.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
	assert.Equal(t, "pong", w.Body.String())
}
