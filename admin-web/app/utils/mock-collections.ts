export type CollectionFilterType = 'select' | 'query'
export type CollectionTarget = 'episodes' | 'shows' | 'seasons' | 'pages'

/** The one advanced type the CMS actually offers. */
export type CollectionAdvancedType = 'continue_watching'

export interface CollectionQuery {
  target: CollectionTarget
  /** Free-text match on the title. */
  titleContains: string | null
  /** Only items published within this many days. */
  publishedWithinDays: number | null
  status: Status[]
  orderBy: 'publish_date_desc' | 'publish_date_asc' | 'title_asc'
  limit: number | null
}

export interface Collection {
  id: string
  name: string
  filterType: CollectionFilterType
  advancedType: CollectionAdvancedType | null
  numberInTitles: boolean
  /** Hand-picked entries, as `${target}:${id}` refs. */
  itemRefs: string[]
  query: CollectionQuery | null
}

export const emptyQuery: CollectionQuery = {
  target: 'episodes',
  titleContains: null,
  publishedWithinDays: null,
  status: ['published'],
  orderBy: 'publish_date_desc',
  limit: 20
}

export const mockCollections: Collection[] = [
  {
    id: 'col-easter-2026',
    name: 'Påskestevnet 2026',
    filterType: 'select',
    advancedType: null,
    numberInTitles: false,
    itemRefs: ['episodes:5', 'episodes:1', 'episodes:6'],
    query: null
  },
  {
    id: 'col-continue',
    name: 'Fortsett å se',
    filterType: 'select',
    advancedType: 'continue_watching',
    numberInTitles: false,
    itemRefs: [],
    query: null
  },
  {
    id: 'col-popular-shows',
    name: 'Populære serier',
    filterType: 'select',
    advancedType: null,
    numberInTitles: false,
    itemRefs: ['shows:1', 'shows:2', 'shows:3'],
    query: null
  },
  {
    id: 'col-new-episodes',
    name: 'Nye episoder',
    filterType: 'query',
    advancedType: null,
    numberInTitles: true,
    itemRefs: [],
    query: {
      target: 'episodes',
      titleContains: null,
      publishedWithinDays: 30,
      status: ['published'],
      orderBy: 'publish_date_desc',
      limit: 20
    }
  },
  {
    id: 'col-kids',
    name: 'For barn',
    filterType: 'query',
    advancedType: null,
    numberInTitles: false,
    itemRefs: [],
    query: {
      target: 'shows',
      titleContains: null,
      publishedWithinDays: null,
      status: ['published', 'unlisted'],
      orderBy: 'title_asc',
      limit: null
    }
  },
  {
    id: 'col-music',
    name: 'Musikk',
    filterType: 'select',
    advancedType: null,
    numberInTitles: false,
    itemRefs: ['episodes:7', 'episodes:8'],
    query: null
  }
]

export function collectionName(id: string | null): string {
  if (!id) return 'Ingen samling'
  return mockCollections.find((c) => c.id === id)?.name ?? id
}

export const collectionTargetLabels: Record<CollectionTarget, string> = {
  episodes: 'Episoder',
  shows: 'Serier',
  seasons: 'Sesonger',
  pages: 'Sider'
}

export const collectionOrderLabels: Record<CollectionQuery['orderBy'], string> =
  {
    publish_date_desc: 'Nyeste først',
    publish_date_asc: 'Eldste først',
    title_asc: 'Tittel A–Å'
  }
