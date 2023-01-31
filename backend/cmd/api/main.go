package main

import (
	"context"
	"database/sql"
	"github.com/gin-contrib/pprof"
	"net/http"
	"os"
	"sort"
	"strings"
	"time"

	"github.com/99designs/gqlgen/graphql"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/ratelimit"
	"github.com/vektah/gqlparser/v2/gqlerror"

	"github.com/bcc-code/brunstadtv/backend/analytics"

	"github.com/bcc-code/brunstadtv/backend/email"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"

	"github.com/bcc-code/brunstadtv/backend/graph/gqltracer"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	cache "github.com/Code-Hex/go-generics-cache"
	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/applications"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	graphadmin "github.com/bcc-code/brunstadtv/backend/graph/admin"
	graphadmingenerated "github.com/bcc-code/brunstadtv/backend/graph/admin/generated"
	graphapi "github.com/bcc-code/brunstadtv/backend/graph/api"
	graphapigenerated "github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	graphpub "github.com/bcc-code/brunstadtv/backend/graph/public"
	graphpubgenerated "github.com/bcc-code/brunstadtv/backend/graph/public/generated"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/items/episode"
	"github.com/bcc-code/brunstadtv/backend/items/page"
	"github.com/bcc-code/brunstadtv/backend/items/season"
	"github.com/bcc-code/brunstadtv/backend/items/section"
	"github.com/bcc-code/brunstadtv/backend/items/show"
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
	"github.com/google/uuid"
	"github.com/graph-gophers/dataloader/v7"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"github.com/samber/lo"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
)

// App global caches
var generalCache = cache.New[string, any]()
var rolesLoaderCache = cache.New[string, *common.FilteredLoaders]()
var profilesLoaderCache = cache.New[uuid.UUID, *common.ProfileLoaders]()

func getLoadersForRoles(db *sql.DB, queries *sqlc.Queries, collectionLoader *dataloader.Loader[int, *common.Collection], roles []string) *common.FilteredLoaders {
	sort.Strings(roles)

	key := strings.Join(roles, "-")

	if loaders, ok := rolesLoaderCache.Get(key); ok {
		return loaders
	}

	rq := queries.RoleQueries(roles)

	loaders := &common.FilteredLoaders{
		ShowFilterLoader:    batchloaders.NewFilterLoader(rq.GetShowIDsWithRoles).Loader,
		SeasonFilterLoader:  batchloaders.NewFilterLoader(rq.GetSeasonIDsWithRoles).Loader,
		EpisodeFilterLoader: batchloaders.NewFilterLoader(rq.GetEpisodeIDsWithRoles).Loader,
		SeasonsLoader:       batchloaders.NewRelationLoader(rq.GetSeasonIDsForShowsWithRoles).Loader,
		SectionsLoader:      batchloaders.NewRelationLoader(rq.GetSectionIDsForPagesWithRoles).Loader,
		EpisodesLoader:      batchloaders.NewRelationLoader(rq.GetEpisodeIDsForSeasonsWithRoles).Loader,
		CollectionItemsLoader: batchloaders.NewListLoader(rq.GetItemsForCollectionsWithRoles, func(i common.CollectionItem) int {
			return i.CollectionID
		}).Loader,
		CollectionItemIDsLoader: collection.NewCollectionItemLoader(db, collectionLoader, roles),
		CalendarEntryLoader:     batchloaders.New(rq.GetCalendarEntries),
		StudyTopicFilterLoader:  batchloaders.NewFilterLoader(rq.GetTopicIDsWithRoles),
		StudyLessonFilterLoader: batchloaders.NewFilterLoader(rq.GetLessonIDsWithRoles),
		StudyTaskFilterLoader:   batchloaders.NewFilterLoader(rq.GetTaskIDsWithRoles),
		StudyLessonsLoader:      batchloaders.NewRelationLoader(rq.GetLessonIDsForTopics),
		StudyTasksLoader:        batchloaders.NewRelationLoader(rq.GetTaskIDsForLessons),

		// Study Relations
		StudyLessonEpisodesLoader: batchloaders.NewRelationLoader(rq.GetEpisodeIDsForLessons),
		EpisodeStudyLessonsLoader: batchloaders.NewRelationLoader(rq.GetLessonIDsForEpisodes),
		StudyLessonLinksLoader:    batchloaders.NewRelationLoader(rq.GetLinkIDsForLessons),
		LinkStudyLessonsLoader:    batchloaders.NewRelationLoader(rq.GetLessonIDsForLinks),
	}

	rolesLoaderCache.Set(key, loaders)

	return loaders
}

func filteredLoaderFactory(db *sql.DB, queries *sqlc.Queries, collectionLoader *dataloader.Loader[int, *common.Collection]) func(ctx context.Context) *common.FilteredLoaders {
	return func(ctx context.Context) *common.FilteredLoaders {
		ginCtx, err := utils.GinCtx(ctx)
		var roles []string
		if err != nil {
			log.L.Error().Err(err).Msg("failed to get gin ctx from context")
			roles = []string{"unknown"}
		} else {
			roles = user.GetRolesFromCtx(ginCtx)
		}
		return getLoadersForRoles(db, queries, collectionLoader, roles)
	}
}

func getLoadersForProfile(queries *sqlc.Queries, profileID uuid.UUID) *common.ProfileLoaders {
	if loaders, ok := profilesLoaderCache.Get(profileID); ok {
		return loaders
	}

	profileQueries := queries.ProfileQueries(profileID)
	loaders := &common.ProfileLoaders{
		ProgressLoader: batchloaders.New(profileQueries.GetProgressForEpisodes, batchloaders.WithMemoryCache(time.Second*5)),
		TaskCompletedLoader: batchloaders.NewFilterLoader(func(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
			return queries.GetAnsweredTasks(ctx, sqlc.GetAnsweredTasksParams{
				ProfileID: profileID,
				Column2:   ids,
			})
		}, batchloaders.WithMemoryCache(time.Second*5)),
		AchievementAchievedAtLoader:   batchloaders.New(profileQueries.GetAchievementsAchievedAt, batchloaders.WithMemoryCache(time.Second*5)),
		GetSelectedAlternativesLoader: batchloaders.New(profileQueries.GetSelectedAlternatives, batchloaders.WithMemoryCache(time.Second*1)),
	}

	profilesLoaderCache.Set(profileID, loaders, cache.WithExpiration(time.Minute*5))

	return loaders
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
		return getLoadersForProfile(queries, p.ID)
	}
}

// Defining the Graphql handler
func graphqlHandler(
	db *sql.DB,
	queries *sqlc.Queries,
	loaders *common.BatchLoaders,
	searchService *search.Service,
	emailService *email.Service,
	urlSigner *signing.Signer,
	config envConfig,
	s3client *s3.Client,
	analyticsSalt string,
) gin.HandlerFunc {
	resolver := graphapi.Resolver{
		Queries:         queries,
		Loaders:         loaders,
		FilteredLoaders: filteredLoaderFactory(db, queries, loaders.CollectionLoader),
		ProfileLoaders:  profileLoaderFactory(queries),
		SearchService:   searchService,
		EmailService:    emailService,
		URLSigner:       urlSigner,
		S3Client:        s3client,
		APIConfig:       config.CDNConfig,
		AWSConfig:       config.AWS,
		RedirectConfig:  config.Redirect,
		AnalyticsIDFactory: func(ctx context.Context) string {
			ginCtx, err := utils.GinCtx(ctx)
			p := user.GetProfileFromCtx(ginCtx)
			if err != nil || p == nil {
				return "anonymous"
			}

			return analytics.GenerateID(p.ID, analyticsSalt)
		},
	}

	tracer := &gqltracer.GraphTracer{}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphapigenerated.NewExecutableSchema(graphapigenerated.Config{Resolvers: &resolver}))
	h.Use(tracer)
	h.SetErrorPresenter(func(ctx context.Context, err error) *gqlerror.Error {
		gqlError := graphql.DefaultErrorPresenter(ctx, err)
		if code := merry.Value(err, "code"); code != nil {
			if gqlError.Extensions == nil {
				gqlError.Extensions = map[string]any{}
			}
			gqlError.Extensions["code"] = code
		}
		if userMessage := merry.UserMessage(err); userMessage != "" {
			gqlError.Message = userMessage
		}
		return gqlError
	})

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func publicGraphqlHandler(loaders *common.BatchLoaders) gin.HandlerFunc {
	resolver := graphpub.Resolver{
		Loaders: &graphpub.Loaders{
			EpisodeLoader: loaders.EpisodeLoader,
			SeasonLoader:  loaders.SeasonLoader,
			ShowLoader:    loaders.ShowLoader,
		},
	}

	tracer := &gqltracer.GraphTracer{}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphpubgenerated.NewExecutableSchema(graphpubgenerated.Config{Resolvers: &resolver}))
	h.Use(tracer)

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func adminGraphqlHandler(config envConfig, db *sql.DB, queries *sqlc.Queries, loaders *common.BatchLoaders) gin.HandlerFunc {

	resolver := graphadmin.Resolver{
		DB:      db,
		Queries: queries,
		Loaders: loaders,
	}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphadmingenerated.NewExecutableSchema(graphadmingenerated.Config{Resolvers: &resolver}))

	directusSecret := config.Secrets.Directus
	if directusSecret == "" {
		log.L.Debug().Msg("No secret for Directus found in environment. Disabling endpoint")
		return func(c *gin.Context) {
			c.AbortWithStatus(404)
			return
		}
	}

	return func(c *gin.Context) {
		headerValue := c.GetHeader("x-api-key")
		if headerValue != directusSecret {
			c.AbortWithStatus(403)
			return
		}

		h.ServeHTTP(c.Writer, c.Request)
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
	var key = "applications"
	cached, ok := generalCache.Get(key)
	if ok {
		return cached.([]common.Application)
	} else {
		apps, err := queries.ListApplications(ctx)
		if err != nil {
			panic(err)
		}
		// Cache with expiration in case the container lives too long.
		generalCache.Set(key, apps, cache.WithExpiration(time.Minute*5))
		return apps
	}
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

func initBatchLoaders(queries *sqlc.Queries) *common.BatchLoaders {
	return &common.BatchLoaders{
		// App
		ApplicationLoader:           batchloaders.New(queries.GetApplications).Loader,
		ApplicationIDFromCodeLoader: batchloaders.NewConversionLoader(queries.GetApplicationIDsForCodes),
		//Redirect
		RedirectLoader:           batchloaders.New(queries.GetRedirects).Loader,
		RedirectIDFromCodeLoader: batchloaders.NewConversionLoader(queries.GetRedirectIDsForCodes),
		// Item
		PageLoader:                         batchloaders.New(queries.GetPages).Loader,
		PageIDFromCodeLoader:               batchloaders.NewConversionLoader(queries.GetPageIDsForCodes),
		SectionLoader:                      batchloaders.New(queries.GetSections).Loader,
		ShowLoader:                         batchloaders.New(queries.GetShows).Loader,
		SeasonLoader:                       batchloaders.New(queries.GetSeasons).Loader,
		EpisodeLoader:                      batchloaders.New(queries.GetEpisodes).Loader,
		EpisodeIDFromLegacyProgramIDLoader: batchloaders.NewConversionLoader(queries.GetEpisodeIDsForLegacyProgramIDs),
		EpisodeIDFromLegacyIDLoader:        batchloaders.NewConversionLoader(queries.GetEpisodeIDsForLegacyIDs),
		LinkLoader:                         batchloaders.New(queries.GetLinks).Loader,
		EventLoader:                        batchloaders.New(queries.GetEvents),
		FilesLoader:                        asset.NewBatchFilesLoader(*queries),
		StreamsLoader:                      asset.NewBatchStreamsLoader(*queries),
		CollectionLoader:                   batchloaders.New(queries.GetCollections).Loader,
		CollectionItemLoader:               collection.NewItemListBatchLoader(*queries),
		CollectionIDFromSlugLoader: &batchloaders.BatchLoader[string, *int]{
			Loader: batchloaders.NewConversionLoader(queries.GetCollectionIDsForCodes),
		},
		EpisodeProgressLoader: batchloaders.NewRelationLoader(queries.GetEpisodeIDsWithProgress),
		// Relations
		SectionsLoader: batchloaders.NewRelationLoader(queries.GetSectionIDsForPages).Loader,
		// Permissions
		ShowPermissionLoader:    show.NewPermissionLoader(*queries),
		SeasonPermissionLoader:  season.NewPermissionLoader(*queries),
		EpisodePermissionLoader: episode.NewPermissionLoader(*queries),
		PagePermissionLoader:    page.NewPermissionLoader(*queries),
		SectionPermissionLoader: section.NewPermissionLoader(*queries),
		FAQCategoryLoader:       batchloaders.NewLoader(queries.GetFAQCategories).Loader,
		QuestionLoader:          batchloaders.NewLoader(queries.GetQuestions).Loader,
		QuestionsLoader:         batchloaders.NewRelationLoader(queries.GetQuestionIDsForCategories).Loader,
		MessageGroupLoader:      batchloaders.NewLoader(queries.GetMessageGroups).Loader,
		// User Data
		ProfilesLoader: batchloaders.NewListLoader(queries.GetProfilesForUserIDs, func(i common.Profile) string {
			return i.UserID
		}).Loader,
		StudyTopicLoader:  batchloaders.New(queries.GetTopics),
		StudyLessonLoader: batchloaders.New(queries.GetLessons),
		StudyTaskLoader:   batchloaders.New(queries.GetTasks),
		StudyQuestionAlternativesLoader: batchloaders.NewListLoader(queries.GetQuestionAlternatives, func(alt common.QuestionAlternative) uuid.UUID {
			return alt.TaskID
		}),
		// Achievements
		AchievementLoader:                  batchloaders.New(queries.GetAchievements),
		AchievementGroupLoader:             batchloaders.New(queries.GetAchievementGroups),
		AchievementsLoader:                 batchloaders.NewRelationLoader(queries.GetAchievementsForProfiles, batchloaders.WithMemoryCache(time.Second*30)),
		UnconfirmedAchievementsLoader:      batchloaders.NewRelationLoader(queries.GetUnconfirmedAchievementsForProfiles, batchloaders.WithMemoryCache(time.Second*30)),
		AchievementGroupAchievementsLoader: batchloaders.NewRelationLoader(queries.GetAchievementsForGroups),

		CompletedTopicsLoader:         batchloaders.NewRelationLoader(queries.GetCompletedTopics),
		CompletedLessonsLoader:        batchloaders.NewRelationLoader(queries.GetCompletedLessons),
		CompletedTasksLoader:          batchloaders.NewRelationLoader(queries.GetCompletedTasks),
		CompletedAndLockedTasksLoader: batchloaders.NewRelationLoader(queries.GetCompletedAndLockedTasks, batchloaders.WithMemoryCache(time.Second*1)),

		ComputedDataLoader: batchloaders.NewListLoader(queries.GetComputedDataForGroups, func(i common.ComputedData) uuid.UUID {
			return i.GroupID
		}),
	}
}

func jwksHandler(config redirectConfig) gin.HandlerFunc {
	pub, _ := jwk.PublicKeyOf(config.JWTPrivateKey)
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
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	config := getEnvConfig()

	log.L.Debug().Msg("Setting up tracing!")
	utils.MustSetupTracing("BTV-API", config.Tracing)
	ctx, span := otel.Tracer("api/core").Start(ctx, "init")

	db := mustConnectToDB(ctx, config.DB)
	rdb := utils.MustCreateRedisClient(ctx, config.Redis)
	urlSigner, err := signing.NewSigner(config.CDNConfig)
	if err != nil {
		if environment.Production() {
			log.L.Panic().Err(err).Send()
		}
	}
	queries := sqlc.New(db)
	queries.SetImageCDNDomain(config.CDNConfig.ImageCDNDomain)
	loaders := initBatchLoaders(queries)
	authClient := auth0.New(config.Auth0)
	membersClient := members.New(config.Members, authClient)
	searchService := search.New(queries, config.Algolia)
	emailService := email.New(config.Email)

	awsConfig, err := awsSDKConfig.LoadDefaultConfig(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to configure AWS SDK")
	}
	awsConfig.Region = config.AWS.Region

	s3Client := s3.NewFromConfig(awsConfig)
	gqlHandler := graphqlHandler(
		db,
		queries,
		loaders,
		searchService,
		emailService,
		urlSigner,
		config,
		s3Client,
		config.AnalyticsSalt,
	)

	log.L.Debug().Msg("Set up HTTP server")
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
	r.Use(user.NewUserMiddleware(queries, membersClient))
	r.Use(user.NewProfileMiddleware(queries, rdb))
	r.Use(applications.ApplicationMiddleware(applicationFactory(queries)))
	r.Use(applications.RoleMiddleware())
	r.Use(ratelimit.Middleware())

	r.POST("/query", gqlHandler)
	r.GET("/", playgroundHandler())
	r.GET("/.well-known/jwks.json", jwksHandler(config.Redirect))
	r.POST("/admin", adminGraphqlHandler(config, db, queries, loaders))
	r.POST("/public", publicGraphqlHandler(loaders))
	r.GET("/versionz", version.GinHandler)

	if os.Getenv("PPROF") == "TRUE" {
		pprof.Register(r, "debug/pprof")
	}

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
