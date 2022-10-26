package export

import (
	"context"
	"database/sql"
	"embed"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"path/filepath"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/applications"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/export/sqlexport"
	graphapi "github.com/bcc-code/brunstadtv/backend/graph/api"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
	_ "github.com/glebarez/go-sqlite"
	"github.com/samber/lo"

	"github.com/pressly/goose/v3"
)

//go:embed sqlc/migrations/*.sql
var embedMigrations embed.FS

func NewHandler(resolvers graphapi.Resolver, queries *sqlc.Queries) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		export(ctx, resolvers, queries)
	}
}

func initDB() (*sql.DB, string, error) {
	dir, err := ioutil.TempDir("", "test-")
	if err != nil {
		return nil, "", err
	}

	fn := filepath.Join(dir, "db")

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

func exportShows(ctx context.Context, r graphapi.Resolver, liteQueries sqlexport.Queries) ([]int, error) {
	filteredLoaders := r.FilteredLoaders(ctx)

	showIDs, err := common.GetFromLoaderForKey(ctx, filteredLoaders.ShowsLoader, common.ReturnAllID)

	if err != nil {
		err = merry.Wrap(err)
		return nil, err
	}

	shows, err := common.GetManyFromLoader(ctx, r.Loaders.ShowLoader, utils.PointerIntArrayToIntArray(showIDs))
	if err != nil {
		err = merry.Wrap(err)
		return nil, err
	}

	for _, s := range shows {
		de := sql.NullString{}
		de.Scan(s.DefaultEpisode)

		err := liteQueries.InsertShow(ctx, sqlexport.InsertShowParams{
			ID:             int64(s.ID),
			Type:           s.Type,
			LegacyID:       s.LegacyID.NullInt64,
			Title:          string(s.Title.AsJSON()),
			Description:    string(s.Description.AsJSON()),
			Image:          s.Image.NullString,
			DefaultEpisode: de,
		})

		if err != nil {
			err = merry.Wrap(err)
			return nil, err
		}
	}

	return utils.PointerIntArrayToIntArray(showIDs), nil
}

func exportSeasons(ctx context.Context, r graphapi.Resolver, liteQueries sqlexport.Queries, showIDs []int) ([]int, error) {
	filteredLoaders := r.FilteredLoaders(ctx)

	// TODO: Refactor? common.GetManyFromLoader is refusing to fit nicely.
	thunk := filteredLoaders.SeasonsLoader.LoadMany(ctx, showIDs)
	seasonIDsResult, errs := thunk()

	if len(errs) > 0 {
		log.L.Error().Errs("errs", errs)
		err := merry.New("err getting season IDs")
		return nil, err
	}

	seasonIDs := lo.Map(lo.Flatten(seasonIDsResult), func(i *int, _ int) int { return *i })
	seasons, err := common.GetManyFromLoader(ctx, r.Loaders.SeasonLoader, seasonIDs)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	for _, s := range seasons {
		tagIds, _ := json.Marshal(s.TagIDs)
		err := liteQueries.InsertSeason(ctx, sqlexport.InsertSeasonParams{
			ID:          int64(s.ID),
			LegacyID:    s.LegacyID.NullInt64,
			TagIds:      string(tagIds),
			Number:      int64(s.Number),
			AgeRating:   s.AgeRating,
			Title:       string(s.Title.AsJSON()),
			Description: string(s.Description.AsJSON()),
			ShowID:      int64(s.ShowID),
			Image:       s.Image.NullString,
		})

		if err != nil {
			log.L.Debug().Err(err).Msg("Err while inserting season")
		}
	}
	return seasonIDs, err
}

func exportEpisodes(ctx context.Context, r graphapi.Resolver, liteQueries sqlexport.Queries, seasonIDs []int) ([]int, error) {
	filteredLoaders := r.FilteredLoaders(ctx)

	// TODO: Refactor? common.GetManyFromLoader is refusing to fit nicely.
	thunk := filteredLoaders.EpisodesLoader.LoadMany(ctx, seasonIDs)
	episodesIDsResult, errs := thunk()

	if len(errs) > 0 {
		log.L.Error().Errs("errs", errs)
		err := merry.New("err getting episode IDs")
		return nil, err
	}

	episodeIDs := lo.Map(lo.Flatten(episodesIDsResult), func(i *int, _ int) int { return *i })
	episodes, err := common.GetManyFromLoader(ctx, r.Loaders.EpisodeLoader, episodeIDs)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	for _, e := range episodes {
		err := liteQueries.InsertEpisode(ctx, sqlexport.InsertEpisodeParams{
			ID:               int64(e.ID),
			LegacyID:         e.LegacyID.NullInt64,
			LegacyProgramID:  e.LegacyProgramID.NullInt64,
			AgeRating:        e.AgeRating,
			Title:            string(e.Title.AsJSON()),
			Description:      string(e.Description.AsJSON()),
			ExtraDescription: string(e.ExtraDescription.AsJSON()),
			Image:            e.Image.NullString,
			ProductionDate:   sql.NullString{String: e.PublishDate.Format(time.RFC1123), Valid: true},
			SeasonID:         e.SeasonID.NullInt64,
			Duration:         int64(e.Duration),
			Number:           e.Number.Int64,
		})

		if err != nil {
			log.L.Debug().Err(err).Msg("Err while inserting season")
		}
	}
	return seasonIDs, err
}

func exportCurrentApplication(ctx *gin.Context, r graphapi.Resolver, liteQueries sqlexport.Queries) error {
	app, err := applications.GetFromCtx(ctx)
	if err != nil {
		return err
	}

	return liteQueries.InsertApplication(ctx, sqlexport.InsertApplicationParams{
		ID:            int64(app.ID),
		Code:          app.Code,
		ClientVersion: app.ClientVersion,
		DefaultPageID: app.DefaultPageID.NullInt64,
	})
}

func exportSections(ctx context.Context, r graphapi.Resolver, liteQueries sqlexport.Queries, queries sqlc.Queries) ([]int, []int, error) {
	filteredLoaders := r.FilteredLoaders(ctx)
	pages, err := queries.ListPages(ctx)
	if err != err {
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
	sections, err := common.GetManyFromLoader(ctx, r.Loaders.SectionLoader, sectionIDs)
	if err != nil {
		return nil, nil, merry.Wrap(err)
	}

	allowedPageIDs := map[int]interface{}{}
	neededCollectionIDs := map[int]interface{}{}
	for _, s := range sections {

		allowedPageIDs[s.ID] = nil
		neededCollectionIDs[int(s.CollectionID.ValueOrZero())] = nil

		liteQueries.InsertSection(ctx, sqlexport.InsertSectionParams{
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
	}

	return lo.Keys(allowedPageIDs), lo.Keys(neededCollectionIDs), nil
}

func exportPages(ctx context.Context, r graphapi.Resolver, liteQueries sqlexport.Queries, pageIDs []int) error {
	pages, err := common.GetManyFromLoader(ctx, r.Loaders.PageLoader, pageIDs)
	if err != nil {
		return merry.Wrap(err)
	}

	for _, p := range pages {
		img := sql.NullString{}
		img.Scan(p.Images.GetDefault([]string{"no"}, "default"))

		liteQueries.InsertPage(ctx, sqlexport.InsertPageParams{
			ID:          int64(p.ID),
			Code:        p.Code,
			Title:       string(p.Title.AsJSON()),
			Description: string(p.Description.AsJSON()),
			Image:       img,
		})
	}

	return nil
}

func exportCollections(ctx context.Context, r graphapi.Resolver, liteQueries sqlexport.Queries, collectionIDs []int) error {
	filteredLoaders := r.FilteredLoaders(ctx)
	collections, err := common.GetManyFromLoader(ctx, r.Loaders.CollectionLoader, collectionIDs)
	if err != nil {
		return merry.Wrap(err)
	}

	for _, c := range collections {
		entries, err := collection.GetCollectionEntries(ctx, r.Loaders, filteredLoaders, c.ID)
		if err != nil {
			return merry.Wrap(err)
		}

		entryIDs := lo.Map(entries, func(e collection.Entry, _ int) int { return e.ID })
		entryIDsJSON, _ := json.Marshal(entryIDs)

		liteQueries.InsertCollection(ctx, sqlexport.InsertCollectionParams{
			ID:              int64(c.ID),
			Name:            c.Name,
			Type:            c.Type,
			CollectionItems: string(entryIDsJSON),
		})
	}
	return nil
}

// TODO: This is a placeholder function
// Needs to be extracted/disconnected from gin
func export(gctx *gin.Context, r graphapi.Resolver, queries *sqlc.Queries) {
	ctx := gctx.Request.Context()

	db, dbPath, err := initDB()
	if err != nil {
		spew.Dump(err)
		return
	}

	err = migrate(db)
	if err != nil {
		spew.Dump(err)
		return
	}
	liteQueries := sqlexport.New(db)

	showIDs, err := exportShows(ctx, r, *liteQueries)
	if err != nil {
		spew.Dump(err)
		return
	}

	seasonIDs, err := exportSeasons(ctx, r, *liteQueries, showIDs)
	if err != nil {
		spew.Dump(err)
		return
	}

	_, err = exportEpisodes(ctx, r, *liteQueries, seasonIDs)
	if err != nil {
		spew.Dump(err)
		return
	}

	// Just the current app for now. We can look into expanding later
	err = exportCurrentApplication(gctx, r, *liteQueries)
	if err != nil {
		spew.Dump(err)
		return
	}

	pagesToExport, collectionsToExport, err := exportSections(ctx, r, *liteQueries, *queries)
	if err != nil {
		spew.Dump(err)
		return
	}

	err = exportPages(ctx, r, *liteQueries, pagesToExport)
	if err != nil {
		spew.Dump(err)
		return
	}

	err = exportCollections(ctx, r, *liteQueries, collectionsToExport)
	if err != nil {
		spew.Dump(err)
		return
	}

	gctx.JSON(http.StatusOK, gin.H{"path": dbPath})

}
