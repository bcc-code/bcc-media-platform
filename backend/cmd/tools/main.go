package main

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
	"os"
)

func main() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	ctx := context.Background()

	db, dbErr := utils.MustCreateDBClient(ctx, utils.DatabaseConfig{
		ConnectionString: os.Getenv("DB_CONNECTION_STRING"),
	})
	err := <-dbErr
	if err != nil {
		panic(err)
		return
	}

	queries := sqlc.New(db)

	router := gin.Default()

	router.POST("assets/clean", DeleteUnusedAssets(queries, "bccm-prod"))
}
