package export

import (
	"context"
	"database/sql"
	"embed"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"os"
	"path"
	"path/filepath"
	"time"

	"gopkg.in/guregu/null.v4"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/cloudevents/sdk-go/v2/event"
	"github.com/google/uuid"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/export/sqlexport"
	"github.com/bcc-code/bcc-media-platform/backend/items/collection"
	"github.com/bcc-code/bcc-media-platform/backend/items/show"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	_ "github.com/glebarez/go-sqlite"
	"github.com/samber/lo"

	"github.com/pressly/goose/v3"
)

// SQLiteExportDBVersion is in semver format (https://semver.org/)
// What constitutes the various levels of change:
// * Anything with a pre-release tag is a wildcard. You can do whatever you want
// * Patch version is when the changes could not possibly break existing queries:
//   - Cosmetic changes, like comments
//   - Adding a constraint, index (since this is a change from the generator side)
//   - Adding a view
//   - Adding a table
//   - NOTE: Adding a field is explicitly excluded from patch level changes as that can break `SELECT * FROM` style queries
//   - NOTE: This is unikely to be used, and should only be if the change is really and clearly "tame".
//
// * Minor changes are changes like:
//   - Adding a field
//   - Changing a view/stored procedure while maintaining the In/Out signature
//   - NOTE: You should be quick to bump the minor version if there is any suspicion that the change could have impact on existing queries, but is stil (on "paper") backwards compatible
//   - NOTE: Changing column types is a major change, because of static langs
//
// * Major change: Everything else
const SQLiteExportDBVersion = "v0.0.5"

type CDNConfig interface {
	GetVOD2Domain() string
}

type serviceProvider interface {
	GetDatabase() *sql.DB
	GetQueries() *sqlc.Queries
	GetLoaders() *loaders.BatchLoaders
	GetLoadersForRoles(roles []string) *loaders.LoadersWithPermissions
	GetPersonalizedLoaders(roles []string, langPreferences common.LanguagePreferences) *loaders.PersonalizedLoaders
	GetS3Client() *s3.Client
	GetURLSigner() *signing.Signer
	GetCDNConfig() CDNConfig
}

type serviceProviderAPI interface {
	GetCDNConfig() CDNConfig
	GetDatabase() *sql.DB
	GetLoaders() *loaders.BatchLoaders
	GetFilteredLoaders(ctx context.Context) *loaders.LoadersWithPermissions
	GetPersonalizedLoaders(ctx context.Context) *loaders.PersonalizedLoaders
	GetQueries() *sqlc.Queries
	GetURLSigner() *signing.Signer
	GetS3Client() *s3.Client
}

// Embed the migrations into the binary
//
//go:embed sqlc/migrations/*.sql
var embedMigrations embed.FS

func initDB() (*sql.DB, string, error) {
	dir := os.TempDir()
	filename, _ := uuid.NewUUID()
	fn := filepath.Join(dir, fmt.Sprintf("%s.db", filename))

	log.L.Info().Str("dbPath", fn).Msg("SQLite DB created")
	db, err := sql.Open("sqlite", fn)
	if err != nil {
		return nil, "", merry.Wrap(err)
	}

	return db, fn, nil
}

func migrate(db *sql.DB) error {
	goose.SetBaseFS(embedMigrations)

	if err := goose.SetDialect("sqlite"); err != nil {
		return merry.Wrap(err)
	}

	err := goose.Up(db, "sqlc/migrations")
	return merry.Wrap(err)
}

func exportShows(ctx context.Context, q *sqlc.Queries, l *loaders.BatchLoaders, roleLoaders *loaders.LoadersWithPermissions, liteQueries *sqlexport.Queries, userRoles []string) ([]int, error) { // q serviceProvider, liteQueries *sqlexport.Queries, userRoles []string) ([]int, error) {
	showIDs, err := q.ListAllPermittedShowIDs(ctx, userRoles)
	if err != nil {
		err = merry.Wrap(err)
		return nil, err
	}

	shows, err := l.ShowLoader.GetMany(ctx, showIDs)
	if err != nil {
		err = merry.Wrap(err)
		return nil, err
	}

	for _, s := range shows {
		eID, err := show.DefaultEpisodeID(ctx, roleLoaders, s)
		if err != nil {
			return nil, err
		}

		defEpisode := sql.NullInt64{}
		if eID != nil {
			e := int64(*eID)
			_ = defEpisode.Scan(e)
		}

		imagesJson, _ := json.Marshal(s.Images)

		err = liteQueries.InsertShow(ctx, sqlexport.InsertShowParams{
			ID:             int64(s.ID),
			Type:           s.Type,
			LegacyID:       s.LegacyID.NullInt64,
			Title:          string(s.Title.AsJSON()),
			Description:    string(s.Description.AsJSON()),
			Images:         string(imagesJson),
			DefaultEpisode: defEpisode,
		})

		if err != nil {
			err = merry.Wrap(err)
			return nil, err
		}
	}

	return showIDs, nil
}

func exportSeasons(ctx context.Context, l *loaders.BatchLoaders, filteredLoaders *loaders.LoadersWithPermissions, liteQueries *sqlexport.Queries, showIDs []int) ([]int, error) {
	thunk := filteredLoaders.SeasonsLoader.LoadMany(ctx, showIDs)
	seasonIDsResult, errs := thunk()

	if len(errs) > 0 {
		log.L.Error().Errs("errs", errs)
		err := merry.New("err getting season IDs")
		return nil, err
	}

	seasonIDs := lo.Map(lo.Flatten(seasonIDsResult), func(i *int, _ int) int { return *i })
	seasons, err := l.SeasonLoader.GetMany(ctx, seasonIDs)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	for _, s := range seasons {
		tagIds, _ := json.Marshal(s.TagIDs)
		imagesJson, _ := json.Marshal(s.Images)

		err := liteQueries.InsertSeason(ctx, sqlexport.InsertSeasonParams{
			ID:          int64(s.ID),
			LegacyID:    s.LegacyID.NullInt64,
			TagIds:      string(tagIds),
			Number:      int64(s.Number),
			AgeRating:   s.AgeRating,
			Title:       string(s.Title.AsJSON()),
			Description: string(s.Description.AsJSON()),
			ShowID:      int64(s.ShowID),
			Images:      string(imagesJson),
		})

		if err != nil {
			log.L.Debug().Err(err).Msg("Err while inserting season")
		}
	}
	return seasonIDs, err
}

func exportEpisodes(ctx context.Context, batchLoaders *loaders.BatchLoaders, filteredLoaders *loaders.LoadersWithPermissions, liteQueries *sqlexport.Queries, seasonIDs []int) ([]int, error) {
	thunk := filteredLoaders.EpisodesLoader.LoadMany(ctx, seasonIDs)
	episodesIDsResult, errs := thunk()

	if len(errs) > 0 {
		log.L.Error().Errs("errs", errs)
		err := merry.New("err getting episode IDs")
		return nil, err
	}

	episodeIDs := lo.Map(lo.Flatten(episodesIDsResult), func(i *int, _ int) int { return *i })
	episodes, err := batchLoaders.EpisodeLoader.GetMany(ctx, episodeIDs)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	for _, e := range episodes {
		imagesJson, _ := json.Marshal(e.Images)
		err := liteQueries.InsertEpisode(ctx, sqlexport.InsertEpisodeParams{
			ID:               int64(e.ID),
			LegacyID:         e.LegacyID.NullInt64,
			LegacyProgramID:  e.LegacyProgramID.NullInt64,
			AgeRating:        e.AgeRating,
			Title:            string(e.Title.AsJSON()),
			Description:      string(e.Description.AsJSON()),
			ExtraDescription: string(e.ExtraDescription.AsJSON()),
			Images:           string(imagesJson),
			ProductionDate:   sql.NullString{String: e.PublishDate.Format(time.RFC1123), Valid: true},
			SeasonID:         e.SeasonID.NullInt64,
			Duration:         int64(e.Duration),
			Number:           e.Number.Int64,
		})

		if err != nil {
			log.L.Debug().Err(err).Msg("Err while inserting season")
		}
	}
	return episodeIDs, err
}

func exportStreams(ctx context.Context, ls *loaders.BatchLoaders, urlSigner *signing.Signer, cdnConfig CDNConfig, liteQueries *sqlexport.Queries, episodeIDs []int) error {

	episodes, err := ls.EpisodeLoader.GetMany(ctx, episodeIDs)
	if err != nil {
		return err
	}

	var assetIDEpisodes = map[int][]int{}

	addEpisodeToAsset := func(assetID int, episodeID int) {
		if _, ok := assetIDEpisodes[assetID]; !ok {
			assetIDEpisodes[assetID] = []int{}
		}
		if !lo.Contains(assetIDEpisodes[assetID], episodeID) {
			assetIDEpisodes[assetID] = append(assetIDEpisodes[assetID], episodeID)
		}
	}

	var assetIDs = map[int]*string{}
	for _, e := range episodes {
		if e.AssetID.Valid {
			assetIDs[int(e.AssetID.Int64)] = nil
			addEpisodeToAsset(int(e.AssetID.Int64), e.ID)
		}
		for key, v := range e.Assets {
			lang := key
			assetIDs[v] = &lang
			addEpisodeToAsset(v, e.ID)
		}
	}

	streams, err := ls.AssetStreamsLoader.GetMany(ctx, lo.Keys(assetIDs))
	if err != nil {
		return err
	}

	streamsFlat := lo.Flatten(streams)

	for _, s := range streamsFlat {
		if s == nil {
			continue
		}

		ss, err := model.StreamFrom(ctx, urlSigner, cdnConfig, s)
		if err != nil {
			log.L.Debug().Err(err).Msg("Err while singing stream url")
		}

		audios, _ := json.Marshal(s.AudioLanguages)
		subs, _ := json.Marshal(s.SubtitleLanguages)
		videoLanguage := sql.NullString{}
		if l, ok := assetIDs[s.AssetID]; ok && l != nil {
			videoLanguage.Valid = true
			videoLanguage.String = *l
		}

		for _, eID := range assetIDEpisodes[s.AssetID] {
			err = liteQueries.InsertStream(ctx, sqlexport.InsertStreamParams{
				ID:                int64(s.ID),
				EpisodeID:         int64(eID),
				AudioLanguages:    string(audios),
				SubtitleLanguages: string(subs),
				Type:              s.Type,
				Url:               ss.URL,
				VideoLanguage:     videoLanguage,
			})
			if err != nil {
				log.L.Debug().Err(err).Msg("Err while inserting stream")
			}
		}
	}

	return nil
}

func exportCurrentApplication(ctx context.Context, liteQueries *sqlexport.Queries, app *common.Application) error {
	return liteQueries.InsertApplication(ctx, sqlexport.InsertApplicationParams{
		ID:            int64(app.ID),
		Code:          app.Code,
		ClientVersion: app.ClientVersion,
		DefaultPageID: app.DefaultPageID.NullInt64,
	})
}

func exportSections(ctx context.Context, q *sqlc.Queries, batchLoaders *loaders.BatchLoaders, filteredLoaders *loaders.LoadersWithPermissions, liteQueries *sqlexport.Queries) ([]int, []int, error) {
	pages, err := q.ListPages(ctx)
	if err != nil {
		return nil, nil, err
	}

	allPageIDs := lo.Map(pages, func(p common.Page, _ int) int { return p.ID })
	thunk := filteredLoaders.SectionsLoader.LoadMany(ctx, allPageIDs)
	sectionIDsResult, errs := thunk()
	if len(errs) > 0 {
		log.L.Error().Errs("errs", errs)
		err := merry.New("err getting section IDs")
		return nil, nil, err
	}

	sectionIDs := lo.Map(lo.Flatten(sectionIDsResult), func(i *int, _ int) int { return *i })
	sections, err := batchLoaders.SectionLoader.GetMany(ctx, sectionIDs)
	if err != nil {
		return nil, nil, merry.Wrap(err)
	}

	allowedPageIDs := map[int]interface{}{}
	neededCollectionIDs := map[int]interface{}{}
	for _, s := range sections {

		allowedPageIDs[s.PageID] = nil
		if s.CollectionID.Valid {
			neededCollectionIDs[int(s.CollectionID.ValueOrZero())] = nil
		}

		err := liteQueries.InsertSection(ctx, sqlexport.InsertSectionParams{
			ID:           int64(s.ID),
			Sort:         int64(s.Sort),
			PageID:       int64(s.PageID),
			Type:         s.Type,
			ShowTitle:    s.ShowTitle,
			Title:        string(s.Title.AsJSON()),
			Description:  string(s.Description.AsJSON()),
			Style:        s.Style,
			Size:         s.Size,
			CollectionID: s.CollectionID.NullInt64,
		})

		if err != nil {
			err = merry.Wrap(err)
			return nil, nil, err
		}
	}

	return lo.Keys(allowedPageIDs), lo.Keys(neededCollectionIDs), nil
}

func exportPages(ctx context.Context, l *loaders.BatchLoaders, liteQueries *sqlexport.Queries, pageIDs []int) error {
	pages, err := l.PageLoader.GetMany(ctx, pageIDs)
	if err != nil {
		return merry.Wrap(err)
	}

	for _, p := range pages {
		images, _ := json.Marshal(p.Images)

		err := liteQueries.InsertPage(ctx, sqlexport.InsertPageParams{
			ID:          int64(p.ID),
			Code:        p.Code,
			Title:       string(p.Title.AsJSON()),
			Description: string(p.Description.AsJSON()),
			Images:      string(images),
		})

		if err != nil {
			err = merry.Wrap(err)
			return err
		}
	}

	return nil
}

type collectionEntry struct {
	ID   string
	Type string
}

func exportCollections(ctx context.Context, db *sql.DB, batchLoaders *loaders.BatchLoaders, personalizedLoaders *loaders.PersonalizedLoaders, liteQueries *sqlexport.Queries, collectionIDs []int) error {
	collections, err := batchLoaders.CollectionLoader.GetMany(ctx, collectionIDs)
	if err != nil {
		return merry.Wrap(err)
	}

	for _, c := range collections {
		if c == nil {
			continue
		}
		//entries, err := collection.GetBaseCollectionEntries(ctx, q.GetLoaders(), personalizedLoaders, c.ID)

		entries, err := collection.GetBaseCollectionEntries(
			ctx,
			db,
			batchLoaders,
			personalizedLoaders,
			c.ID,
			common.LanguagePreferences{ContentOnlyInPreferredLanguage: false},
			null.NewInt(0, false),
		)
		if err != nil {
			return merry.Wrap(err)
		}

		liteEntries := lo.Map(entries, func(e collection.Entry, _ int) collectionEntry {
			return collectionEntry{
				ID:   e.ID,
				Type: e.Collection.Value,
			}
		})
		liteEntriesJSON, _ := json.Marshal(liteEntries)

		err = liteQueries.InsertCollection(ctx, sqlexport.InsertCollectionParams{
			ID:              int64(c.ID),
			Name:            c.Title.Get([]string{"no"}),
			CollectionItems: string(liteEntriesJSON),
		})

		if err != nil {
			err = merry.Wrap(err)
			return err
		}
	}
	return nil
}

func HandleExportMessage(ctx context.Context, s serviceProvider, e event.Event) error {
	type ExportData struct {
		ExportID string `json:"exportId"`
	}

	// TODO: Get from DB
	langPreferences := common.LanguagePreferences{
		ContentOnlyInPreferredLanguage: false,
		PreferredAudioLanguages:        []string{"no"},
		PreferredSubtitlesLanguages:    []string{},
	}
	// TODO: Get from DB
	app := &common.Application{
		ID:            0,
		Code:          "test",
		ClientVersion: "test",
		DefaultPageID: null.NewInt(0, false),
	}
	q := s.GetQueries()

	// Unmarshal event data
	var exportData ExportData
	if err := json.Unmarshal(e.Data(), &exportData); err != nil {
		log.L.Error().Err(err).Msg("failed to unmarshal event data")
		return merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	parsedId, err := uuid.Parse(exportData.ExportID)
	if err != nil {
		return err
	}

	// try to get an entry with the exportID
	fetchedEntry, err := q.GetExportById(ctx, parsedId)
	if err != nil {
		return err
	}

	url, err := doExport(
		ctx,
		fetchedEntry.UserGroups,
		langPreferences,
		app,
		"<TEMP BUCKET NAME>",
		q,
		s.GetLoaders(),
		s.GetLoadersForRoles(fetchedEntry.UserGroups),
		s.GetPersonalizedLoaders(fetchedEntry.UserGroups, langPreferences),
		s.GetURLSigner(),
		s.GetCDNConfig(),
		s.GetS3Client(),
	)
	if err != nil {
		return err
	}

	// add a url
	err = q.UpdateExportURL(ctx, sqlc.UpdateExportURLParams{
		Url: url,
		ID:  parsedId,
	})
	if err != nil {
		return err
	}
	// change the status to ready
	err = q.UpdateExportStatus(ctx, sqlc.UpdateExportStatusParams{
		Status: model.ExportStatusReady.String(),
		ID:     parsedId,
	})
	if err != nil {
		return err
	}

	return nil

}

// DoExport exports some key data into a SQLite DB and uploads that to the provided S3 bucket
// It then returns a pre-signed link to the file that remains valid for 1 hour
//
// The rest if the functions in this file are not exported because they are currently dependent on each other and
// are basically split only on order to understand the flow better.
func DoExport(ctx context.Context, q serviceProviderAPI, bucketName string, userRoles []string) (string, error) {
	gctx, err := utils.GinCtx(ctx)
	if err != nil {
		return "", merry.Wrap(err)
	}

	langPreferences := common.GetLanguagePreferencesFromCtx(gctx)
	app, err := common.GetApplicationFromCtx(gctx)
	if err != nil {
		return "", err
	}

	return doExport(
		ctx,
		userRoles,
		langPreferences,
		app,
		bucketName,
		q.GetQueries(),
		q.GetLoaders(),
		q.GetFilteredLoaders(ctx),
		q.GetPersonalizedLoaders(ctx),
		q.GetURLSigner(),
		q.GetCDNConfig(),
		q.GetS3Client(),
	)
}

func doExport(
	ctx context.Context,
	userRoles []string,
	langPreferences common.LanguagePreferences,
	app *common.Application,
	bucketName string,
	q *sqlc.Queries,
	batchLoaders *loaders.BatchLoaders,
	roleLoaders *loaders.LoadersWithPermissions,
	personalizedLoaders *loaders.PersonalizedLoaders,
	urlSigner *signing.Signer,
	cdnConfig CDNConfig,
	s3Client *s3.Client,
) (string, error) {
	db, dbPath, err := initDB()
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "initDB").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}
	defer func() {
		_ = os.Remove(dbPath)
	}()

	err = migrate(db)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "migrate").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}
	liteQueries := sqlexport.New(db)

	showIDs, err := exportShows(ctx, q, batchLoaders, roleLoaders, liteQueries, userRoles)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportShow").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	seasonIDs, err := exportSeasons(ctx, batchLoaders, roleLoaders, liteQueries, showIDs)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportSeasons").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	episodeIDs, err := exportEpisodes(ctx, batchLoaders, roleLoaders, liteQueries, seasonIDs)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportEpisodes").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	err = exportStreams(ctx, batchLoaders, urlSigner, cdnConfig, liteQueries, episodeIDs)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportStreams").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	// Just the current app for now. We can look into expanding later
	err = exportCurrentApplication(ctx, liteQueries, app)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportCurrentApplication").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	pagesToExport, collectionsToExport, err := exportSections(ctx, q, batchLoaders, roleLoaders, liteQueries)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportCurrentSections").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	err = exportPages(ctx, batchLoaders, liteQueries, pagesToExport)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportPages").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	err = exportCollections(ctx, db, batchLoaders, personalizedLoaders, liteQueries, collectionsToExport)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportCollections").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	err = db.Close()
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "exportDBClose").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	f, err := os.Open(dbPath)
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "os.Open(dbPath)").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	s3DestinationPath := aws.String(path.Join("/sqliteexport", filepath.Base(dbPath)))

	_, err = s3Client.PutObject(ctx, &s3.PutObjectInput{
		Body:         f,
		Bucket:       aws.String(bucketName),
		CacheControl: aws.String("Cache-Control: private, max-age=604800, immutable"),
		Key:          s3DestinationPath,
	})
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "s3 PutObject").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}

	presignClient := s3.NewPresignClient(s3Client, s3.WithPresignExpires(1*time.Hour))

	res, err := presignClient.PresignGetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(bucketName),
		Key:    s3DestinationPath,
	})
	if err != nil {
		log.L.Error().Err(err).Str("exportStep", "Presign Object").Msg("")
		return "", merry.Wrap(err, merry.WithUserMessage("Unable to generate export file"))
	}
	return res.URL, nil
}
