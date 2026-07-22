package main

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/bcc-code/bcc-media-platform/backend/loaders"

	"cloud.google.com/go/pubsub"
	"github.com/99designs/gqlgen/graphql"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/analytics"
	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/directus"
	"github.com/bcc-code/bcc-media-platform/backend/email"
	gqlextension "github.com/99designs/gqlgen/graphql/handler/extension"
	graphadmin "github.com/bcc-code/bcc-media-platform/backend/graph/admin"
	graphadmingenerated "github.com/bcc-code/bcc-media-platform/backend/graph/admin/generated"
	graphapi "github.com/bcc-code/bcc-media-platform/backend/graph/api"
	graphapigenerated "github.com/bcc-code/bcc-media-platform/backend/graph/api/generated"
	apiextension "github.com/bcc-code/bcc-media-platform/backend/graph/extension"
	"github.com/bcc-code/bcc-media-platform/backend/graph/gqltracer"
	graphpublic "github.com/bcc-code/bcc-media-platform/backend/graph/public"
	graphpublicgenerated "github.com/bcc-code/bcc-media-platform/backend/graph/public/generated"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bmm-sdk-golang"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	pkgerrors "github.com/pkg/errors"
	"github.com/vektah/gqlparser/v2/gqlerror"
	"strconv"
	"strings"
)

// Defining the Graphql handler
func graphqlHandler(
	db *sql.DB,
	queries *sqlc.Queries,
	loaders *loaders.BatchLoaders,
	searchService *search.Service,
	emailService *email.Service,
	fileSigner *signing.CloudFrontSigner,
	streamSigner *streamtoken.Signer,
	legacyStreamSigner *signing.CloudFrontStreamSigner,
	livestreamSigner *signing.CloudFrontSigner,
	config envConfig,
	s3client *s3.Client,
	analyticsSalt string,
	authClient *auth0.Client,
	remoteCache *remotecache.Client,
	analyticsClient *analytics.Service,
	bmmClient *bmm.APIClient,
	jobPubSubTopic *pubsub.Topic,
) gin.HandlerFunc {
	resolver := graphapi.Resolver{
		DB:                    db,
		Queries:               queries,
		Loaders:               loaders,
		FilteredLoaders:       filteredLoaderFactory(queries),
		ProfileLoaders:        profileLoaderFactory(queries),
		PersonalizedLoaders:   personalizedLoaderFactory(queries),
		SearchService:         searchService,
		EmailService:          emailService,
		FileSigner:            fileSigner,
		StreamURLSigner:       streamSigner,
		LegacyStreamSigner:    legacyStreamSigner,
		LivestreamSigner:      livestreamSigner,
		PrimaryStreamProvider: config.StreamProxy.PrimaryProvider,
		S3Client:              s3client,
		APIConfig:             config.CDNConfig,
		AWSConfig:             config.AWS,
		RedirectConfig:        config.Redirect,
		AuthClient:            authClient,
		RemoteCache:           remoteCache,
		AnalyticsClient:       analyticsClient,
		BMMClient:             bmmClient,
		BackgroundWorkerTopic: jobPubSubTopic,
		AnalyticsIDFactory: func(ctx context.Context) string {
			ginCtx, err := utils.GinCtx(ctx)
			p := user.GetProfileFromCtx(ginCtx)
			if err != nil || p == nil {
				return "anonymous"
			}
			u := user.GetFromCtx(ginCtx)

			aID := analytics.GenerateID(p.ID, analyticsSalt)
			if u.IsActiveBCC() {
				return aID
			}
			return "ext-" + aID
		},
	}

	tracer := &gqltracer.GraphTracer{}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphapigenerated.NewExecutableSchema(graphapigenerated.Config{Resolvers: &resolver}))
	h.Use(tracer)
	h.Use(gqlextension.FixedComplexityLimit(1000))
	h.Use(apiextension.DepthLimit{Max: 15})

	h.SetRecoverFunc(func(ctx context.Context, err interface{}) error {
		// Wrap the panic error with a stack trace using pkg/errors
		stackerr := pkgerrors.Errorf("panic recovered: %v", err)
		log.L.Error().
			Stack().
			Err(stackerr).
			Msg("A panic occurred during GraphQL resolve")

		return fmt.Errorf("Internal Server Error")
	})

	h.SetErrorPresenter(func(ctx context.Context, err error) *gqlerror.Error {
		gqlError := graphql.DefaultErrorPresenter(ctx, err)
		if code := merry.Value(err, "code"); code != nil {
			if gqlError.Extensions == nil {
				gqlError.Extensions = map[string]any{}
			}
			gqlError.Extensions["code"] = code
		}
		if userMessage := merry.UserMessage(err); userMessage != "" {
			log.L.Warn().Err(gqlError).Msg("GraphQL exception: " + userMessage)
			gqlError.Message = userMessage
		} else {
			if _, ok := err.(*gqlerror.Error); ok {
				return gqlError
			}
			ev := log.L.Error().Err(err).Str("path", gqlError.Path.String())
			if graphql.HasOperationContext(ctx) {
				ev = ev.Str("operation", graphql.GetOperationContext(ctx).OperationName)
			}
			ev.Msg("GraphQL resolver error")
			gqlError.Message = "error occurred"
		}
		return gqlError
	})

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func publicGraphqlHandler(loaders *loaders.BatchLoaders) gin.HandlerFunc {
	resolver := graphpublic.Resolver{
		Loaders: &graphpublic.Loaders{
			EpisodeLoader: loaders.EpisodeLoader,
			SeasonLoader:  loaders.SeasonLoader,
			ShowLoader:    loaders.ShowLoader,
		},
	}

	tracer := &gqltracer.GraphTracer{}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphpublicgenerated.NewExecutableSchema(graphpublicgenerated.Config{Resolvers: &resolver}))
	h.Use(tracer)
	h.Use(gqlextension.FixedComplexityLimit(500))
	h.Use(apiextension.DepthLimit{Max: 10})

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func adminGraphqlHandler(config envConfig, db *sql.DB, queries *sqlc.Queries, loaders *loaders.BatchLoaders, tokenValidator *directus.TokenValidator) gin.HandlerFunc {
	resolver := graphadmin.Resolver{
		DB:      db,
		Queries: queries,
		Loaders: loaders,
	}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphadmingenerated.NewExecutableSchema(graphadmingenerated.Config{Resolvers: &resolver}))
	h.Use(gqlextension.FixedComplexityLimit(5000))
	h.Use(apiextension.DepthLimit{Max: 20})

	directusSecret := config.Secrets.Directus

	if directusSecret == "" && tokenValidator == nil {
		log.L.Debug().Msg("No Directus secret or JWT secret found in environment. Disabling endpoint")
		return func(c *gin.Context) {
			c.AbortWithStatus(404)
		}
	}

	return func(c *gin.Context) {
		// Legacy server-to-server access via the shared secret header.
		if directusSecret != "" && c.GetHeader("x-api-key") == directusSecret {
			h.ServeHTTP(c.Writer, c.Request)
			return
		}

		// Per-user access via a Directus-issued access token.
		if tokenValidator != nil && authorizeDirectusUser(c, queries, tokenValidator) {
			h.ServeHTTP(c.Writer, c.Request)
			return
		}

		c.AbortWithStatus(403)
	}
}

// logFieldDirectusUserID is the structured-log field for the Directus user id
// on the /admin endpoint.
const logFieldDirectusUserID = "directus_user_id"

// authorizeDirectusUser validates the Directus access token from the
// Authorization header and confirms the user is allowed to use the admin API.
// It returns true when the request should be allowed through.
func authorizeDirectusUser(c *gin.Context, queries *sqlc.Queries, v *directus.TokenValidator) bool {
	scheme, token, ok := strings.Cut(c.GetHeader("Authorization"), " ")
	if !ok || !strings.EqualFold(scheme, "Bearer") {
		return false
	}

	claims, err := v.Validate(token)
	if err != nil {
		log.L.Debug().Err(err).Msg("Rejected Directus admin token")
		return false
	}

	// This is the frontend for the Directus admin, so require Directus admin
	// access; app access alone (restricted/API-only users) is not enough.
	if !claims.AdminAccess {
		log.L.Warn().Str(logFieldDirectusUserID, claims.UserID).Msg("Directus user without admin access attempted admin API access")
		return false
	}

	userID, err := uuid.Parse(claims.UserID)
	if err != nil {
		log.L.Warn().Err(err).Str(logFieldDirectusUserID, claims.UserID).Msg("Directus token has an invalid user id")
		return false
	}

	// Look the user up so a deactivated account is rejected even while a
	// short-lived token is still cryptographically valid.
	dbUser, err := queries.GetDirectusUserByID(c.Request.Context(), userID)
	if err != nil {
		log.L.Warn().Err(err).Str(logFieldDirectusUserID, claims.UserID).Msg("Directus user from token could not be loaded")
		return false
	}
	if dbUser.Status != "active" {
		log.L.Warn().Str(logFieldDirectusUserID, claims.UserID).Str("status", dbUser.Status).Msg("Directus user is not active")
		return false
	}

	return true
}

func topbarSearchHandler(searchService *search.Service) gin.HandlerFunc {
	return func(c *gin.Context) {
		term := c.Param("term")
		if term == "" {
			c.JSON(400, gin.H{"error": "Search term is required"})
			return
		}

		sizeStr := c.DefaultQuery("size", "20")
		size := 20
		if s, err := strconv.Atoi(sizeStr); err == nil && s > 0 {
			size = s
			if size > 50 {
				size = 50
			}
		}

		results, err := searchService.TopbarSearch(c, term, size)
		if err != nil {
			log.L.Error().Err(err).Str("term", term).Msg("Topbar search failed")
			c.JSON(500, gin.H{"error": "Search failed"})
			return
		}

		c.JSON(200, results)
	}
}
