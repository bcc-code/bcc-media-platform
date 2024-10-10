package graph

import (
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
	"testing"
)

func Test_ShortsDeclumping(t *testing.T) {
	type testCase struct {
		declumpingTreshold int
		input              []common.ShortIDWithMeta
		expected           []uuid.UUID
	}

	testCases := []testCase{
		{
			input: []common.ShortIDWithMeta{
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000001"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000002"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000003"),
					ParentEpisodeID: null.IntFrom(2),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000004"),
					ParentEpisodeID: null.IntFrom(2),
				},
			},
			expected: []uuid.UUID{
				uuid.MustParse("00000000-0000-0000-0000-000000000001"),
				uuid.MustParse("00000000-0000-0000-0000-000000000003"),
			},
			declumpingTreshold: 3,
		},
		{
			input: []common.ShortIDWithMeta{
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000001"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000002"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000003"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000004"),
					ParentEpisodeID: null.IntFrom(1),
				},
			},
			expected: []uuid.UUID{
				uuid.MustParse("00000000-0000-0000-0000-000000000001"),
				uuid.MustParse("00000000-0000-0000-0000-000000000004"),
			},
			declumpingTreshold: 3,
		},
		{
			input: []common.ShortIDWithMeta{
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000001"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000002"),
					ParentEpisodeID: null.IntFrom(2),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000003"),
					ParentEpisodeID: null.IntFrom(3),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000004"),
					ParentEpisodeID: null.IntFrom(1),
				},
			},
			expected: []uuid.UUID{
				uuid.MustParse("00000000-0000-0000-0000-000000000001"),
				uuid.MustParse("00000000-0000-0000-0000-000000000002"),
				uuid.MustParse("00000000-0000-0000-0000-000000000003"),
				uuid.MustParse("00000000-0000-0000-0000-000000000004"),
			},
			declumpingTreshold: 3,
		},
		{
			input: []common.ShortIDWithMeta{
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000001"),
					ParentEpisodeID: null.IntFrom(1),
				},
				{
					ID: uuid.MustParse("00000000-0000-0000-0000-000000000002"),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000003"),
					ParentEpisodeID: null.IntFrom(3),
				},
				{
					ID:              uuid.MustParse("00000000-0000-0000-0000-000000000004"),
					ParentEpisodeID: null.IntFrom(4),
				},
			},
			expected: []uuid.UUID{
				uuid.MustParse("00000000-0000-0000-0000-000000000001"),
				uuid.MustParse("00000000-0000-0000-0000-000000000002"),
				uuid.MustParse("00000000-0000-0000-0000-000000000003"),
				uuid.MustParse("00000000-0000-0000-0000-000000000004"),
			},
			declumpingTreshold: 3,
		},
	}

	for _, tc := range testCases {
		res := declumpShorts(tc.input, tc.declumpingTreshold)
		assert.Equal(t, tc.expected, res)
	}
}
