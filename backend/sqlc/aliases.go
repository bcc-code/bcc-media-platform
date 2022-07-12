package sqlc

// EpisodeExpanded contains episode data + translations + permissions
type EpisodeExpanded = GetEpisodesWithTranslationsByIDRow

// SeasonExpanded contains season data + translations + permissions
type SeasonExpanded = GetSeasonsWithTranslationsByIDRow

// ShowExpanded contains show data + translations + permissions
type ShowExpanded = GetShowsWithTranslationsByIDRow
