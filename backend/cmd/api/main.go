package main

import (
	"context"
	"net/http"
	"os"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/pkg/errors"

	"cloud.google.com/go/profiler"
	gpubsub "cloud.google.com/go/pubsub"
	"github.com/99designs/gqlgen/graphql/playground"
	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/analytics"
	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/bmm"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/directus"
	"github.com/bcc-code/bcc-media-platform/backend/email"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	commonMiddleware "github.com/bcc-code/bcc-media-platform/backend/middleware"
	"github.com/bcc-code/bcc-media-platform/backend/ratelimit"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/bcc-code/bcc-media-platform/backend/unleash"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	userMiddleware "github.com/bcc-code/bcc-media-platform/backend/user/middleware"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bcc-media-platform/backend/version"
	"github.com/bsm/redislock"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"github.com/samber/lo"
	"github.com/sony/gobreaker"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
)

const filteredLoadersCtxKey = "filtered-loaders"
const profileLoadersCtxKey = "profile-loaders"
const personalizedLoadersCtxKey = "personalized-loaders"

func personalizedLoaderFactory(
	queries *sqlc.Queries,
) func(ctx context.Context) *loaders.PersonalizedLoaders {
	return func(ctx context.Context) *loaders.PersonalizedLoaders {
		ginCtx, err := utils.GinCtx(ctx)
		if err != nil {
			return nil
		}

		ls, err := utils.GetOrSetContextWithLock(ctx, personalizedLoadersCtxKey, func() (*loaders.PersonalizedLoaders, error) {
			return loaders.GetPersonalizedLoaders(
				queries,
				user.GetRolesFromCtx(ginCtx),
				common.GetLanguagePreferencesFromCtx(ginCtx),
			), nil
		})
		if err != nil {
			log.L.Error().Err(err).Msg("failed to get personalized loaders for request")
			return nil
		}
		return ls
	}
}

func filteredLoaderFactory(queries *sqlc.Queries) func(ctx context.Context) *loaders.LoadersWithPermissions {
	return func(ctx context.Context) *loaders.LoadersWithPermissions {
		// Without a request to scope to there is nothing to read roles from and
		// nowhere to cache, so fall back to a loader set for a role that grants
		// nothing. GetLoadersForRoles caches per role key, so this is cheap.
		unprivileged := func() *loaders.LoadersWithPermissions {
			return loaders.GetLoadersForRoles(queries, []string{"unknown"})
		}

		ginCtx, err := utils.GinCtx(ctx)
		if err != nil {
			log.L.Error().Err(err).Msg("failed to get gin ctx from context")
			return unprivileged()
		}

		ls, err := utils.GetOrSetContextWithLock(ctx, filteredLoadersCtxKey, func() (*loaders.LoadersWithPermissions, error) {
			// Runs only on a miss, so this is the request's first role-filtered
			// query: any feature flag gating content through a usergroup is
			// about to influence what comes back.
			unleash.ReportRoleCandidates(ginCtx)
			return loaders.GetLoadersForRoles(queries, user.GetRolesFromCtx(ginCtx)), nil
		})
		if err != nil {
			log.L.Error().Err(err).Msg("failed to get filtered loaders for request")
			return unprivileged()
		}
		return ls
	}
}

func profileLoaderFactory(queries *sqlc.Queries) func(ctx context.Context) *loaders.ProfileLoaders {
	return func(ctx context.Context) *loaders.ProfileLoaders {
		ginCtx, err := utils.GinCtx(ctx)
		if err != nil {
			return nil
		}
		p := user.GetProfileFromCtx(ginCtx)
		if p == nil {
			return nil
		}

		ls, err := utils.GetOrSetContextWithLock(ctx, profileLoadersCtxKey, func() (*loaders.ProfileLoaders, error) {
			return getLoadersForProfile(queries, p), nil
		})
		if err != nil {
			log.L.Error().Err(err).Msg("failed to get profile loaders for request")
			return nil
		}
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

func panicHandler(c *gin.Context, err any) {
	stackerr := errors.Errorf("panic recovered: %v", err)
	log.L.Error().
		Stack().
		Err(stackerr).
		Msg("A panic occurred during HTTP request")

	c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
		"error": "Internal Server Error",
	})
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
	utils.MustSetupTracing("BCCM-API", config.Tracing)
	utils.MustSetupMetrics("BCCM-API", config.Tracing)

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

	fileSigner, err := signing.NewCloudFrontSigner(config.CDNConfig)
	if err != nil {
		log.L.Panic().Err(err).Msg("failed to init cloudfront file signer")
	}
	streamSigner, err := streamtoken.NewSigner(config.StreamProxy)
	if err != nil {
		log.L.Panic().Err(err).Msg("failed to init stream-proxy signer")
	}
	queries := sqlc.New(db)
	queries.SetImageCDNDomain(config.CDNConfig.ImageCDNDomain)
	authClient := auth0.New(config.Auth0)

	cb := gobreaker.NewCircuitBreaker(gobreaker.Settings{
		Name:    "Members",
		Timeout: time.Second * 2,
	})
	membersClient := members.New(config.Members, authClient, cb)

	ls := loaders.InitBatchLoaders(queries, membersClient)
	searchService := search.New(queries, config.Search)
	emailService, err := email.New(config.Email)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to initialize email service")
	}

	awsConfig, err := awsSDKConfig.LoadDefaultConfig(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to configure AWS SDK")
	}
	awsConfig.Region = config.AWS.Region

	analyticsService := analytics.NewService(config.Analytics)

	// Feature flags are evaluated by the clients and forwarded to us, so the
	// API reports its own usage of them back to Unleash rather than running an
	// SDK. Inert when unconfigured.
	unleashMetrics := unleash.NewMetricsReporter(config.Unleash)
	go unleashMetrics.Start(ctx)

	s3Client := s3.NewFromConfig(awsConfig)

	var jobPubSubTopic *gpubsub.Topic
	pubSubClient, err := gpubsub.NewClient(ctx, config.PubSub.PubSubProjectID)
	if err != nil {
		log.L.Warn().Err(err).Msg("Failed to create pubSubClient. Jobs will not run")
	} else {
		jobPubSubTopic = pubSubClient.Topic(config.PubSub.PubSubTopicID)
	}

	bmmClient, err := bmm.New(config.BMM)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to create BMM client")
	}
	bmmClient.SetDebug(config.BMM.Debug)

	log.L.Debug().Msg("Set up HTTP server")

	if environment.Production() {
		gin.SetMode(gin.ReleaseMode)
	}
	r := gin.New()

	r.Use(commonMiddleware.AccessLogMiddleware())
	r.Use(gin.CustomRecovery(panicHandler))

	r.Use(utils.GinContextToContextMiddleware())
	r.Use(utils.FeatureFlagReporterMiddleware())
	r.Use(unleash.MetricsMiddleware(unleashMetrics))

	// Two CORS policies: the public API stays wildcard, while the admin
	// endpoints carry an httpOnly refresh cookie and therefore need
	// credentials mode with an explicit origin allowlist. A single
	// engine-level dispatcher (instead of per-group middleware) so OPTIONS
	// preflights are answered even though gin never routes them.
	publicCORS := cors.New(cors.Config{
		AllowAllOrigins: true,
		AllowMethods:    []string{"POST", "GET"},
		AllowHeaders: []string{
			"content-type",
			"authorization",
			"accept-language",
			"x-api-key",
			"x-application",
			"x-feature-flags",
			"x-session-id",
			"x-search-session-id",
			"x-accept-audio-language",
			"x-accept-subtitle-language",
			"x-only-preferred-languages-content",
		},
		AllowCredentials: true,
	})
	// The admin realm carries credentials, so its CORS fails closed: without
	// a configured allowlist, no cross-origin browser access at all (curl and
	// server-to-server calls are unaffected — they don't do CORS).
	adminCORSConfig := cors.Config{
		AllowMethods:     []string{"POST", "OPTIONS"},
		AllowHeaders:     []string{"content-type", "authorization", "accept-language"},
		AllowCredentials: true,
	}
	if len(config.Admin.CORSOrigins) > 0 {
		adminCORSConfig.AllowOrigins = config.Admin.CORSOrigins
	} else {
		log.L.Warn().Msg("ADMIN_CORS_ORIGINS not set. Cross-origin browser access to /admin is disabled")
		adminCORSConfig.AllowOriginFunc = func(string) bool { return false }
	}
	adminCORS := cors.New(adminCORSConfig)
	r.Use(func(c *gin.Context) {
		if c.Request.URL.Path == "/admin" {
			adminCORS(c)
			return
		}
		publicCORS(c)
	})

	r.Use(utils.RequestIDMiddleware)
	r.Use(otelgin.Middleware("api"))

	// The Auth0 middleware chain is scoped to the consumer endpoints; the
	// admin realm below uses this service's own tokens, and ValidateToken
	// would 401 them before they reached the handler.
	pub := r.Group("")
	pub.Use(authClient.ValidateToken())
	pub.Use(commonMiddleware.ApplicationMiddleware(queries))
	pub.Use(commonMiddleware.LanguagePreferencesMiddleware(ls))
	pub.Use(userMiddleware.NewUserMiddleware(queries, remoteCache, ls, authClient))
	pub.Use(userMiddleware.NewFakeUserMiddleware(os.Getenv("FAKE_USER_SECRET")))
	pub.Use(userMiddleware.NewProfileMiddleware(queries, remoteCache))
	pub.Use(commonMiddleware.RoleMiddleware)
	pub.Use(ratelimit.Middleware)

	pub.POST("/query", graphqlHandler(
		db,
		queries,
		ls,
		searchService,
		emailService,
		fileSigner,
		streamSigner,
		config,
		s3Client,
		config.AnalyticsSalt,
		authClient,
		remoteCache,
		analyticsService,
		bmmClient,
		jobPubSubTopic,
	))
	pub.GET("/", playgroundHandler())
	pub.POST("/public", publicGraphqlHandler(ls))
	pub.GET("/topbarsearch/:term", topbarSearchHandler(searchService))
	pub.GET("/versionz", version.GinHandler)

	// Admin realm: /admin serves the admin GraphQL schema, including the
	// `auth` mutations (login proxy to Directus + refresh-cookie session
	// management). Access control is per operation (graphadmin.AuthExtension:
	// x-api-key from the Directus endpoint-tools extension OR an access token
	// this service minted; only auth mutations run unauthenticated). Never
	// behind the Auth0 chain. The admin resolvers read languages from the
	// context, which the user middleware would otherwise provide.
	var directusClient *directus.Client
	if config.Admin.JWTSecret != "" && config.Admin.DirectusURL != "" {
		directusClient, err = directus.NewClient(config.Admin.DirectusURL)
		if err != nil {
			log.L.Panic().Err(err).Msg("failed to init directus login client")
		}
	} else {
		log.L.Warn().Msg("ADMIN_JWT_SECRET or DIRECTUS_URL not set. Admin auth mutations disabled")
	}
	adm := r.Group("")
	adm.Use(func(c *gin.Context) {
		c.Set(user.CtxLanguages, user.GetAcceptedLanguagesFromCtx(c))
	})
	adm.POST("/admin", adminGraphqlHandler(config, db, queries, ls, directusClient, remoteCache))

	pub.GET("/.well-known/jwks.json", <-jwkChan)

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

	log.L.Info().Float64("seconds", time.Since(start).Seconds()).Msg("Time to start")

	err = r.Run(":" + config.Port)
	if err != nil {
		panic(err)
	}
}
