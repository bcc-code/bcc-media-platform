package main

import (
	"cloud.google.com/go/profiler"
	"context"
	"database/sql"
	"encoding/json"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/brunstadtv/backend/applications"
	"github.com/bcc-code/brunstadtv/backend/loaders"
	"github.com/bcc-code/brunstadtv/backend/memorycache"
	"github.com/bcc-code/brunstadtv/backend/remotecache"
	"github.com/bcc-code/brunstadtv/backend/user/middleware"
	"github.com/bsm/redislock"
	"github.com/gin-contrib/pprof"
	"github.com/sony/gobreaker"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/bcc-code/brunstadtv/backend/email"
	"github.com/bcc-code/brunstadtv/backend/ratelimit"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"

	"github.com/99designs/gqlgen/graphql/playground"
	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/signing"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/brunstadtv/backend/version"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"github.com/samber/lo"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
)

const filteredLoadersCtxKey = "filtered-loaders"
const profileLoadersCtxKey = "profile-loaders"
const applicationLoadersCtxKey = "application-loaders"

func filteredLoaderFactory(db *sql.DB, queries *sqlc.Queries, collectionLoader *loaders.Loader[int, *common.Collection]) func(ctx context.Context) *common.FilteredLoaders {
	return func(ctx context.Context) *common.FilteredLoaders {
		ginCtx, err := utils.GinCtx(ctx)
		var roles []string
		if err != nil {
			log.L.Error().Err(err).Msg("failed to get gin ctx from context")
			roles = []string{"unknown"}
		} else {
			roles = user.GetRolesFromCtx(ginCtx)
		}
		if ls := ginCtx.Value(filteredLoadersCtxKey); ls != nil {
			return ls.(*common.FilteredLoaders)
		}
		ls := getLoadersForRoles(db, queries, collectionLoader, roles)
		ginCtx.Set(filteredLoadersCtxKey, ls)
		return ls
	}
}

func profileLoaderFactory(queries *sqlc.Queries) func(ctx context.Context) *common.ProfileLoaders {
	return func(ctx context.Context) *common.ProfileLoaders {
		ginCtx, err := utils.GinCtx(ctx)
		if err != nil {
			return nil
		}
		p := user.GetProfileFromCtx(ginCtx)
		if p == nil {
			return nil
		}
		if ls := ginCtx.Value(profileLoadersCtxKey); ls != nil {
			return ls.(*common.ProfileLoaders)
		}
		ls := getLoadersForProfile(queries, p.ID)
		ginCtx.Set(profileLoadersCtxKey, ls)
		return ls
	}
}

// Defining the Playground handler
func playgroundHandler() gin.HandlerFunc {
	h := playground.Handler("GraphQL", "/query")

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func getApplications(ctx context.Context, queries *sqlc.Queries) []common.Application {
	apps, err := memorycache.GetOrSet(ctx, "applications", queries.ListApplications, cache.WithExpiration(time.Minute*2))
	if err != nil {
		log.L.Panic().Err(err).Send()
	}
	return apps
}

func applicationFactory(queries *sqlc.Queries) func(ctx context.Context, code string) *common.Application {
	return func(ctx context.Context, code string) *common.Application {
		apps := getApplications(ctx, queries)

		app, found := lo.Find(apps, func(i common.Application) bool {
			return i.Code == strings.ToLower(strings.TrimSpace(code))
		})
		if found {
			return &app
		}
		app, found = lo.Find(apps, func(i common.Application) bool {
			return i.Default
		})
		if found {
			return &app
		}
		return nil
	}
}

func jwksHandler(config *redirectConfig) gin.HandlerFunc {
	pub, _ := jwk.PublicKeyOf(config.GetPrivateKey())
	_ = pub.Set(jwk.AlgorithmKey, jwa.RS256)
	_ = pub.Set(jwk.KeyUsageKey, jwk.ForSignature)
	_ = pub.Set(jwk.KeyIDKey, config.KeyID)
	keySet := jwk.NewSet()
	_ = keySet.AddKey(pub)

	return func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, keySet)
	}
}

func main() {
	ctx := context.Background()
	start := time.Now()
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	if err := profiler.Start(profiler.Config{
		MutexProfiling: true,
	}); err != nil {
		log.L.Warn().Err(err).Msg("Failed to start profiler")
	}

	config := getEnvConfig()

	log.L.Info().Msg("Setting up tracing!")
	utils.MustSetupTracing("BTV-API", config.Tracing)

	ctx, span := otel.Tracer("api/core").Start(ctx, "init")
	db, dbChan := utils.MustCreateDBClient(ctx, config.DB)

	redisClient, rdbChan := utils.MustCreateRedisClient(ctx, config.Redis)
	locker := redislock.New(redisClient)
	remoteCache := remotecache.New(redisClient, locker)

	jwkChan := lo.Async(func() gin.HandlerFunc {
		handler := jwksHandler(config.Redirect)
		log.L.Info().Msg("JWK generated")
		return handler
	})
	urlSigner, err := signing.NewSigner(config.CDNConfig)
	if err != nil {
		if environment.Production() {
			log.L.Panic().Err(err).Send()
		} else {
			log.L.Error().Err(err).Send()
		}
	}
	queries := sqlc.New(db)
	queries.SetImageCDNDomain(config.CDNConfig.ImageCDNDomain)
	authClient := auth0.New(config.Auth0)

	cb := gobreaker.NewCircuitBreaker(gobreaker.Settings{
		Name:    "Members",
		Timeout: time.Second * 2,
	})
	membersClient := members.New(config.Members, authClient, cb)

	ls := initBatchLoaders(queries, membersClient)
	searchService := search.New(queries, config.Algolia)
	emailService := email.New(config.Email)

	awsConfig, err := awsSDKConfig.LoadDefaultConfig(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to configure AWS SDK")
	}
	awsConfig.Region = config.AWS.Region

	s3Client := s3.NewFromConfig(awsConfig)

	log.L.Debug().Msg("Set up HTTP server")

	if environment.Production() {
		gin.SetMode(gin.ReleaseMode)
	}
	r := gin.Default()

	r.Use(utils.GinContextToContextMiddleware())
	r.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		AllowMethods:     []string{"POST", "GET"},
		AllowHeaders:     []string{"content-type", "authorization", "accept-language", "x-api-key"},
		AllowCredentials: true,
	}))

	r.Use(otelgin.Middleware("api"))
	r.Use(authClient.ValidateToken())
	r.Use(applications.ApplicationMiddleware(applicationFactory(queries)))
	r.Use(middleware.NewUserMiddleware(queries, remoteCache, ls, authClient))
	if environment.Test() {
		// Get the user object from headers
		r.Use(func(ctx *gin.Context) {
			if v, ok := ctx.Get(auth0.CtxAuthenticated); !ok || v.(bool) != true {
				return
			}

			userStr := ctx.GetHeader("x-user-data")
			if userStr != "" {
				var u common.User
				_ = json.Unmarshal([]byte(userStr), &u)
				ctx.Set(user.CtxUser, &u)
				ctx.Set(user.CtxImpersonating, true)
			}
		})
	}
	r.Use(middleware.NewProfileMiddleware(queries, remoteCache))
	r.Use(applications.RoleMiddleware())
	r.Use(ratelimit.Middleware())

	r.POST("/query", graphqlHandler(
		db,
		queries,
		ls,
		searchService,
		emailService,
		urlSigner,
		config,
		s3Client,
		config.AnalyticsSalt,
		authClient,
		remoteCache,
	))
	r.GET("/", playgroundHandler())
	r.POST("/admin", adminGraphqlHandler(config, db, queries, ls))
	r.POST("/public", publicGraphqlHandler(ls))
	r.GET("/versionz", version.GinHandler)

	if os.Getenv("PPROF") == "TRUE" {
		pprof.Register(r, "debug/pprof")
	}

	r.GET("/.well-known/jwks.json", <-jwkChan)

	err = <-dbChan
	if err != nil {
		panic(err)
	}
	err = <-rdbChan
	if err != nil {
		panic(err)
	}

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	span.End()

	log.L.Info().Msgf("Time to start: %d", time.Now().Sub(start).Nanoseconds())

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
