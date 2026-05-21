export type SectionSize = 'small' | 'medium'
export type GridSectionSize = 'half'
export type CardSectionSize = 'large' | 'mini'

export interface ItemSectionMetadata {
  continueWatching: boolean
  myList: boolean
  secondaryTitles: boolean
  collectionId: string
  useContext: boolean
  prependLiveElement: boolean
  limit: number | null
}

export interface FeaturedSection {
  id: string
  type: 'FeaturedSection'
  title: string | null
  description: string | null
  size: SectionSize
  metadata: ItemSectionMetadata | null
}

export interface PosterSection {
  id: string
  type: 'PosterSection'
  title: string | null
  description: string | null
  size: SectionSize
  metadata: ItemSectionMetadata | null
}

export interface DefaultSection {
  id: string
  type: 'DefaultSection'
  title: string | null
  description: string | null
  size: SectionSize
  metadata: ItemSectionMetadata | null
}

export interface CardSection {
  id: string
  type: 'CardSection'
  title: string | null
  description: string | null
  size: CardSectionSize
  metadata: ItemSectionMetadata | null
}

export interface DefaultGridSection {
  id: string
  type: 'DefaultGridSection'
  title: string | null
  description: string | null
  size: GridSectionSize
  metadata: ItemSectionMetadata | null
}

export interface IconGridSection {
  id: string
  type: 'IconGridSection'
  title: string | null
  description: string | null
  size: GridSectionSize
  metadata: ItemSectionMetadata | null
}

export type PageSection =
  | FeaturedSection
  | PosterSection
  | DefaultSection
  | CardSection
  | DefaultGridSection
  | IconGridSection

export interface Page {
  id: string
  code: string
  title: string
  description: string | null
  applicationCode: string
  sections: PageSection[]
}

const metadata = (
  collectionId: string,
  overrides?: Partial<ItemSectionMetadata>
): ItemSectionMetadata => ({
  continueWatching: false,
  myList: false,
  secondaryTitles: false,
  collectionId,
  useContext: false,
  prependLiveElement: false,
  limit: null,
  ...overrides
})

export const mockPages: Page[] = [
  {
    id: '1',
    code: 'home',
    title: 'Hjem',
    description: null,
    applicationCode: 'bccm-mobile',
    sections: [
      {
        id: 's1',
        type: 'FeaturedSection',
        title: 'Påskestevnet 2026',
        description: 'Se direktesendingene fra Brunstad',
        size: 'medium',
        metadata: metadata('col-easter-2026')
      },
      {
        id: 's2',
        type: 'DefaultSection',
        title: 'Fortsett å se',
        description: null,
        size: 'medium',
        metadata: metadata('col-continue', { continueWatching: true })
      },
      {
        id: 's3',
        type: 'PosterSection',
        title: 'Populaere serier',
        description: null,
        size: 'medium',
        metadata: metadata('col-popular-shows')
      },
      {
        id: 's4',
        type: 'DefaultGridSection',
        title: 'Kategorier',
        description: null,
        size: 'half',
        metadata: metadata('col-categories')
      }
    ]
  },
  {
    id: '2',
    code: 'explore',
    title: 'Utforsk',
    description: null,
    applicationCode: 'bccm-mobile',
    sections: [
      {
        id: 's5',
        type: 'IconGridSection',
        title: 'Alle kategorier',
        description: null,
        size: 'half',
        metadata: metadata('col-all-categories')
      },
      {
        id: 's6',
        type: 'DefaultSection',
        title: 'Nytt denne uken',
        description: null,
        size: 'small',
        metadata: metadata('col-recent-week')
      }
    ]
  },
  {
    id: '3',
    code: 'home',
    title: 'Hjem',
    description: null,
    applicationCode: 'kids-mobile',
    sections: [
      {
        id: 's7',
        type: 'FeaturedSection',
        title: 'Velkommen til Bible Kids',
        description: 'Oppdag innhold for barn',
        size: 'medium',
        metadata: metadata('col-kids-welcome')
      },
      {
        id: 's8',
        type: 'CardSection',
        title: 'Anbefalt for deg',
        description: null,
        size: 'large',
        metadata: metadata('col-kids-recommended')
      }
    ]
  },
  {
    id: '4',
    code: 'home',
    title: 'Hjem',
    description: null,
    applicationCode: 'live-mobile',
    sections: [
      {
        id: 's9',
        type: 'PosterSection',
        title: 'Kommende arrangementer',
        description: null,
        size: 'medium',
        metadata: metadata('col-upcoming-events', { prependLiveElement: true })
      }
    ]
  },
  {
    id: '5',
    code: 'home',
    title: 'Hjem',
    description: null,
    applicationCode: 'play-mobile',
    sections: [
      {
        id: 's10',
        type: 'FeaturedSection',
        title: 'Populaert akkurat nå',
        description: 'Se hva andre ser på',
        size: 'medium',
        metadata: metadata('col-trending')
      },
      {
        id: 's11',
        type: 'DefaultSection',
        title: 'Mest sett',
        description: null,
        size: 'medium',
        metadata: metadata('col-most-watched')
      },
      {
        id: 's12',
        type: 'PosterSection',
        title: 'Alle serier',
        description: null,
        size: 'small',
        metadata: metadata('col-all-shows')
      }
    ]
  }
]
