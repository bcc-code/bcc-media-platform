package translations_test

// pgtestdb uses the `sql` interfaces to interact with Postgres,you just have to
// bring your own driver. Here we're using the PGX driver in stdlib mode,which
// registers a driver with the name "pgx".
import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	Mocktranslations "github.com/bcc-code/bcc-media-platform/backend/translations/mock"
	"github.com/rs/zerolog"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/translations"
	"github.com/bcc-code/bcc-media-platform/backend/utils/testutils"
	"github.com/stretchr/testify/assert"
)

func TestShowSeasonEpisodeTranslations(t *testing.T) {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	db := testutils.NewDB(t)
	q := sqlc.New(db)

	ctx := context.Background()

	err := testutils.InsertDefaults(ctx, q)
	assert.NoError(t, err)

	s1 := testutils.CreateRandomShow(t, ctx, q)
	testutils.CreateRandomShow(t, ctx, q)

	season1 := testutils.CreateRandomSeason(t, ctx, q, s1.ID)

	testutils.CreateRandomEpisode(t, ctx, q, season1.ID)
	testutils.CreateRandomEpisode(t, ctx, q, season1.ID)
	testutils.CreateRandomEpisode(t, ctx, q, season1.ID)
	testutils.CreateRandomEpisode(t, ctx, q, season1.ID)

	tsMock := Mocktranslations.MockTranslationsProvider{}
	tsMock.EXPECT().SendToTranslation(ctx, "shows", []common.TranslationData{
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description"}`), ID: "1"},
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description"}`), ID: "2"},
	}).Return(nil).Once()

	tsMock.EXPECT().SendToTranslation(ctx, "seasons", []common.TranslationData{
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description"}`), ID: "1"},
	}).Return(nil).Once()

	tsMock.EXPECT().SendToTranslation(ctx, "episodes", []common.TranslationData{
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description","@context":"\u003ca href=\"https://app.bcc.media/episode/1\"\u003eLink to episode\u003c/a\u003e"}`), ID: "1"},
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description","@context":"\u003ca href=\"https://app.bcc.media/episode/2\"\u003eLink to episode\u003c/a\u003e"}`), ID: "2"},
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description","@context":"\u003ca href=\"https://app.bcc.media/episode/3\"\u003eLink to episode\u003c/a\u003e"}`), ID: "3"},
		{Language: "no", Value: json.RawMessage(`{"Title":"title","Description":"description","@context":"\u003ca href=\"https://app.bcc.media/episode/4\"\u003eLink to episode\u003c/a\u003e"}`), ID: "4"},
	}).Return(nil).Once()

	service := translations.NewService(q, &tsMock)

	err = service.SendCollectionToTranslation(ctx, translations.CollectionShows)
	assert.NoError(t, err)

	err = service.SendCollectionToTranslation(ctx, translations.CollectionSeasons)
	assert.NoError(t, err)

	err = service.SendCollectionToTranslation(ctx, translations.CollectionEpisodes)
	assert.NoError(t, err)

	tsMock.AssertExpectations(t)
}
