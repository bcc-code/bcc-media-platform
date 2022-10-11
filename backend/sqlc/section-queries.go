package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"time"
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
		if t == "item" {
			style = s.Style.ValueOrZero()
		} else {
			style = s.LinkStyle.ValueOrZero()
		}
		if style == "" {
			style = "default"
		}
		var size string
		if style == "grid" {
			size = s.GridSize.ValueOrZero()
		} else {
			size = s.Size.ValueOrZero()
		}

		return common.Section{
			ID:           int(s.ID),
			Sort:         int(s.Sort.ValueOrZero()),
			PageID:       int(s.PageID),
			ShowTitle:    s.ShowTitle.Bool,
			Title:        title,
			Description:  description,
			Type:         t,
			CollectionID: s.CollectionID,
			Style:        style,
			Size:         size,
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
func (q *Queries) GetSectionIDsForPages(ctx context.Context, ids []int) ([]common.Relation[int, int], error) {
	rows, err := q.getSectionIDsForPages(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSectionIDsForPagesRow, _ int) common.Relation[int, int] {
		return i
	}), nil
}

// GetSectionIDsForPagesWithRoles returns a list of episodes specified by seasons
func (q *Queries) GetSectionIDsForPagesWithRoles(ctx context.Context, ids []int, roles []string) ([]common.Relation[int, int], error) {
	rows, err := q.getSectionIDsForPagesWithRoles(ctx, getSectionIDsForPagesWithRolesParams{
		Column1: intToInt32(ids),
		Column2: roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSectionIDsForPagesWithRolesRow, _ int) common.Relation[int, int] {
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

// GetLinksForSections returns links for sections
func (q *Queries) GetLinksForSections(ctx context.Context, ids []int) ([]common.SectionLink, error) {
	rows, err := q.getLinksForSection(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}

	return lo.Map(rows, func(i getLinksForSectionRow, _ int) common.SectionLink {
		var icon null.String
		if i.FilenameDisk.Valid {
			icon = null.StringFrom(q.filenameToImageURL(i.FilenameDisk.String))
		}

		return common.SectionLink{
			ID:        int(i.ID),
			Title:     i.Title,
			SectionID: int(i.SectionID),
			PageID:    i.PageID,
			URL:       i.Url,
			Icon:      icon,
		}
	}), nil
}
