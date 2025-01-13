package translations_test

// pgtestdb uses the `sql` interfaces to interact with Postgres, you just have to
// bring your own driver. Here we're using the PGX driver in stdlib mode, which
// registers a driver with the name "pgx".
import (
	"context"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/translations"
	"github.com/bcc-code/bcc-media-platform/backend/utils/testutils"
	"github.com/stretchr/testify/assert"
)

type mockTranslationService struct {
	t *testing.T
}

func (m *mockTranslationService) SendToTranslation(ctx context.Context, collection string, data []common.TranslationData) error {
	m.t.Helper()
	assert.Len(m.t, data, 2)
	assert.Equal(m.t, "shows", collection)
	assert.Equal(m.t, "no", data[0].Language)
	assert.Equal(m.t, "no", data[1].Language)
	assert.Equal(m.t, "1", data[0].ID)
	assert.Equal(m.t, "2", data[1].ID)
	return nil
}

func (m *mockTranslationService) ProcessWebhook(ctx context.Context, url string, hookData []byte) (collection string, data []common.TranslationData, err error) {
	m.t.Helper()
	return "", nil, nil
}

func TestShowTranslations(t *testing.T) {
	db := testutils.NewDB(t)
	q := sqlc.New(db)

	ctx := context.Background()

	err := testutils.InsertDefaults(ctx, q)
	assert.NoError(t, err)

	res, err := testutils.CreateRandomShow(ctx, q)
	assert.NoError(t, err)
	assert.NotNil(t, res)

	res, err = testutils.CreateRandomShow(ctx, q)
	assert.NoError(t, err)
	assert.NotNil(t, res)

	tsMock := &mockTranslationService{t: t}

	service := translations.NewService(q, tsMock)
	err = service.SendCollectionToTranslation(ctx, translations.CollectionShows)
	assert.NoError(t, err)
}
