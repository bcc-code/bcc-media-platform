import type { Episode, Season, SectionItemType, Show } from '@/graph/generated'

export function isEpisode(item: SectionItemType): item is Episode {
	return 'locked' in item && 'progress' in item
}

export function isSeason(item: SectionItemType): item is Season {
	return 'episodes' in item
}

export function isShow(item: SectionItemType): item is Show {
	return 'seasons' in item
}
