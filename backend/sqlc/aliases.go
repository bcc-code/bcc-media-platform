package sqlc

// EpisodeExpanded contains episode data + translations + permissions
type EpisodeExpanded = EpisodesExpanded

// SeasonExpanded contains season data + translations + permissions
type SeasonExpanded = SeasonsExpanded

// ShowExpanded contains show data + translations + permissions
type ShowExpanded = ShowsExpanded

// PageExpanded contains page data + translations + permissions
type PageExpanded = getPagesRow

// SectionExpanded contains section data + translations + permissions
type SectionExpanded = getSectionsRow

// CollectionItem contains collection item data
type CollectionItem = CollectionsItem

// TagExpanded contains tag and translations
type TagExpanded = getTagsRow
