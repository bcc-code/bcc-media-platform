package sqlc

import (
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
)

func (file *DirectusFile) GetImageUrl() string {
	if !file.FilenameDisk.Valid {
		return ""
	}
	return fmt.Sprintf("https://brunstadtv.imgix.net/%s", file.FilenameDisk.ValueOrZero())
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
