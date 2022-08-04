package sqlc

import (
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"time"
)

func (file *DirectusFile) GetImageUrl() string {
	if !file.FilenameDisk.Valid {
		return ""
	}
	return fmt.Sprintf("https://brunstadtv.imgix.net/%s", file.FilenameDisk.ValueOrZero())
}

// GetKey returns the key for this entity
func (i ShowExpanded) GetKey() int {
	return int(i.ID)
}

// GetRoles returns common.Roles for this item
func (i ShowExpanded) GetRoles() common.Roles {
	return common.Roles{
		Access:      i.Usergroups,
		EarlyAccess: i.EarlyAccessGroups,
		Download:    i.DownloadGroups,
	}
}

// GetAvailability returns common.Availability for this item
func (i ShowExpanded) GetAvailability() common.Availability {
	return common.Availability{
		Published: i.Published,
		From:      i.AvailableFrom,
		To:        i.AvailableTo,
	}
}

// GetImage returns uuid.NullUUID for an image
func (i ShowExpanded) GetImage() uuid.NullUUID {
	return i.ImageFileID
}

// GetKey returns the key for this entity
func (i SeasonExpanded) GetKey() int {
	return int(i.ID)
}

// GetRoles returns common.Roles for this item
func (i SeasonExpanded) GetRoles() common.Roles {
	return common.Roles{
		Access:      i.Usergroups,
		EarlyAccess: i.EarlyAccessGroups,
		Download:    i.DownloadGroups,
	}
}

// GetAvailability returns common.Availability for this item
func (i SeasonExpanded) GetAvailability() common.Availability {
	return common.Availability{
		Published: i.Published,
		From:      i.AvailableFrom,
		To:        i.AvailableTo,
	}
}

// GetImage returns uuid.NullUUID for an image
func (i SeasonExpanded) GetImage() uuid.NullUUID {
	return i.ImageFileID
}

// GetKey returns the key for this entity
func (i EpisodeExpanded) GetKey() int {
	return int(i.ID)
}

// GetRoles returns common.Roles for this item
func (i EpisodeExpanded) GetRoles() common.Roles {
	return common.Roles{
		Access:      i.Usergroups,
		EarlyAccess: i.EarlyAccessGroups,
		Download:    i.DownloadGroups,
	}
}

// GetAvailability returns common.Availability for this item
func (i EpisodeExpanded) GetAvailability() common.Availability {
	return common.Availability{
		Published: i.Published,
		From:      i.AvailableFrom,
		To:        i.AvailableTo,
	}
}

// GetImage returns uuid.NullUUID for an image
func (i EpisodeExpanded) GetImage() uuid.NullUUID {
	return i.ImageFileID
}

// GetKey returns the key for this entity
func (i PageExpanded) GetKey() int {
	return int(i.ID)
}

// GetRoles returns common.Roles for this item
func (i PageExpanded) GetRoles() common.Roles {
	return common.Roles{
		Access: []string{"public"},
	}
}

// GetAvailability returns common.Availability for this item
func (i PageExpanded) GetAvailability() common.Availability {
	return common.Availability{
		Published: true,
		From:      time.Now(),
		To:        time.Now().Add(time.Second * 10),
	}
}

// GetKey returns the key for this entity
func (i SectionExpanded) GetKey() int {
	return int(i.ID)
}

// GetRoles returns common.Roles for this item
func (i SectionExpanded) GetRoles() common.Roles {
	return common.Roles{
		Access: i.Roles,
	}
}
