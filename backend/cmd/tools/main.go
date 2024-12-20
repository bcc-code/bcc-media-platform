package main

import (
	"context"
	"fmt"
	"os"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
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
	}

	queries := sqlc.New(db)

	router := gin.Default()

	router.POST("assets/clean", DeleteUnusedAssets(queries, "bccm-prod"))
	router.GET("shorts", ListShorts())

	fmt.Print("Running on http://localhost:9933/")
	router.Run("127.0.0.1:9933")
}
