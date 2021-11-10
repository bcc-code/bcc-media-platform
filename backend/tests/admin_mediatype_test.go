package tests

import (
	"context"
	"fmt"
	"testing"

	"github.com/go-resty/resty/v2"
	_ "github.com/lib/pq"
	db "go.bcc.media/brunstadtv/db/sqlc"
	"gopkg.in/guregu/null.v4"
)

var dockerCtx *DockerContext

func TestMain(m *testing.M) {
	dockerCtx = SetupDocker()
	defer dockerCtx.network.Close()
	m.Run()
}

func TestGetEndpointWithWrongType(t *testing.T) {
	sqlDB, dbInternalUrl := SetupDB(dockerCtx)
	adminUrl := SetupAdmin(dockerCtx, dbInternalUrl)

	queries := db.New(sqlDB)
	media, err := queries.InsertMedia(context.Background(), db.InsertMediaParams{
		MediaType:   null.StringFrom("episode"),
		Title:       null.StringFrom("episode"),
		Description: null.StringFrom("episode"),
	})
	if err != nil {
		t.Fatal(err)
	}

	client := resty.New()
	client.RetryCount = 5
	resp, err := client.R().Get(fmt.Sprintf("%s/show/%d", adminUrl, media.ID))
	if err != nil {
		t.Fatal("request failed, err:", err)
	}
	if status := resp.StatusCode(); status != 400 {
		t.Fatalf("Result: %d, Expected: %d", status, 400)
	}
}

func TestPutEndpointWithWrongType(t *testing.T) {
	sqlDB, dbInternalUrl := SetupDB(dockerCtx)
	adminUrl := SetupAdmin(dockerCtx, dbInternalUrl)

	queries := db.New(sqlDB)
	media, err := queries.InsertMedia(context.Background(), db.InsertMediaParams{
		MediaType:   null.StringFrom("episode"),
		Title:       null.StringFrom("episode"),
		Description: null.StringFrom("episode"),
	})
	if err != nil {
		t.Fatal(err)
	}

	client := resty.New()
	client.RetryCount = 5
	r := client.R()
	r.SetBody(db.UpsertMediaParams{
		MediaType: null.StringFrom("episode"),
	})
	resp, err := r.Put(fmt.Sprintf("%s/show/%d", adminUrl, media.ID))
	if err != nil {
		t.Fatal("request failed, err:", err)
	}
	if status := resp.StatusCode(); status != 400 {
		t.Fatalf("Result: %d, Expected: %d", status, 400)
	}
}
