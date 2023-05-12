package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/loaders"
	"time"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func mapToSections(items []getSectionsRow) []common.Section {
	return lo.Map(items, func(s getSectionsRow, _ int) common.Section {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(s.Title.RawMessage, &title)
		_ = json.Unmarshal(s.Description.RawMessage, &description)

		t := "item"
		if s.Type.Valid {
			t = s.Type.ValueOrZero()
		}

		var style string
		style = s.Style.ValueOrZero()
		if style == "" {
			style = "default"
		}
		var size string
		if style == "grid" {
			size = s.GridSize.ValueOrZero()
		} else {
			size = s.Size.ValueOrZero()
		}
		var needsAuth null.Bool
		if s.NeedsAuthentication.Valid {
			needsAuth.SetValid(s.NeedsAuthentication.Bool)
		}

		var aspectRatio null.Float
		if s.EmbedAspectRatio.Valid {
			aspectRatio.SetValid(s.EmbedAspectRatio.Float64)
		}

		return common.Section{
			ID:                  int(s.ID),
			Sort:                int(s.Sort.ValueOrZero()),
			PageID:              int(s.PageID),
			ShowTitle:           s.ShowTitle.Bool,
			Title:               title,
			Description:         description,
			Type:                t,
			CollectionID:        s.CollectionID,
			MessageID:           s.MessageID,
			Style:               style,
			Size:                size,
			EmbedUrl:            s.EmbedUrl,
			NeedsAuthentication: needsAuth,
			EmbedAspectRatio:    aspectRatio,
			EmbedHeight:         s.EmbedHeight,
			Options: common.SectionOptions{
				SecondaryTitles:    s.SecondaryTitles,
				ContinueWatching:   s.AdvancedType.String == "continue_watching",
				MyList:             s.AdvancedType.String == "my_list",
				UseContext:         s.UseContext.Bool,
				PrependLiveElement: s.PrependLiveElement.Bool,
			},
		}
	})
}

// GetSections returns a list of sections retrieved by ids
func (q *Queries) GetSections(ctx context.Context, ids []int) ([]common.Section, error) {
	sections, err := q.getSections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToSections(sections), nil
}

// GetKey returns the id for this row
func (row getSectionIDsForPagesRow) GetKey() int {
	return int(row.ID)
}

// GetRelationID returns the relation id for this row
func (row getSectionIDsForPagesRow) GetRelationID() int {
	return int(row.PageID)
}

// GetSectionIDsForPages returns a list of episodes specified by seasons
func (q *Queries) GetSectionIDsForPages(ctx context.Context, ids []int) ([]loaders.Relation[int, int], error) {
	rows, err := q.getSectionIDsForPages(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSectionIDsForPagesRow, _ int) loaders.Relation[int, int] {
		return i
	}), nil
}

// GetSectionIDsForPagesWithRoles returns a list of episodes specified by seasons
func (rq *RoleQueries) GetSectionIDsForPagesWithRoles(ctx context.Context, ids []int) ([]loaders.Relation[int, int], error) {
	rows, err := rq.queries.getSectionIDsForPagesWithRoles(ctx, getSectionIDsForPagesWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSectionIDsForPagesWithRolesRow, _ int) loaders.Relation[int, int] {
		return getSectionIDsForPagesRow(i)
	}), nil
}

// GetPermissionsForSections returns permissions for sections
func (q *Queries) GetPermissionsForSections(ctx context.Context, ids []int) ([]common.Permissions[int], error) {
	rows, err := q.getPermissionsForSections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}

	from, _ := time.Parse("2006-01-02", "1900-01-01")
	to, _ := time.Parse("2006-01-02", "2100-01-01")

	return lo.Map(rows, func(i getPermissionsForSectionsRow, _ int) common.Permissions[int] {
		return common.Permissions[int]{
			ItemID: int(i.ID),
			Type:   common.TypeSection,
			Availability: common.Availability{
				Published: true,
				From:      from,
				To:        to,
			},
			Roles: common.Roles{
				Access: i.Roles,
			},
		}
	}), nil
}

// GetLinks returns links from the database
func (q *Queries) GetLinks(ctx context.Context, ids []int) ([]common.Link, error) {
	links, err := q.getLinks(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(links, func(i getLinksRow, _ int) common.Link {
		var title common.LocaleString
		var desc common.LocaleString

		_ = json.Unmarshal(i.Title.RawMessage, &title)
		_ = json.Unmarshal(i.Description.RawMessage, &desc)

		return common.Link{
			ID:                  int(i.ID),
			Title:               title,
			Description:         desc,
			URL:                 i.Url,
			Type:                i.Type.String,
			Images:              q.getImages(i.Images),
			ComputedDataGroupID: i.ComputeddatagroupID,
		}
	}), nil
}
