export type SectionType =
  | 'FeaturedSection'
  | 'PosterSection'
  | 'DefaultSection'
  | 'CardSection'
  | 'ListSection'
  | 'CardListSection'
  | 'DefaultGridSection'
  | 'PosterGridSection'
  | 'IconGridSection'
  | 'IconSection'
  | 'LabelSection'
  | 'AvatarSection'
  | 'MessageSection'
  | 'WebSection'
  | 'AchievementSection'
  | 'PageDetailsSection'

export type SectionSize = 'small' | 'medium' | 'large' | 'mini' | 'half'

export type SectionFamily = 'carousel' | 'grid' | 'special'

export interface SectionTypeInfo {
  type: SectionType
  label: string
  description: string
  icon: string
  family: SectionFamily
  /** Item sections pull their content from a collection. */
  needsCollection: boolean
  sizes: SectionSize[]
}

/**
 * The CMS stores type/style/size/grid_size as separate columns. Editors think
 * in finished shapes, so the demo names each combination the way the public
 * API does — see docs/admin-web-scope.md.
 */
export const sectionTypes: SectionTypeInfo[] = [
  {
    type: 'FeaturedSection',
    label: 'Hero',
    description: 'Stort banner med fremhevet innhold',
    icon: 'tabler:star',
    family: 'carousel',
    needsCollection: true,
    sizes: ['small', 'medium']
  },
  {
    type: 'DefaultSection',
    label: 'Standard',
    description: 'Karusell med liggende miniatyrbilder',
    icon: 'tabler:carousel-horizontal',
    family: 'carousel',
    needsCollection: true,
    sizes: ['small', 'medium']
  },
  {
    type: 'PosterSection',
    label: 'Poster',
    description: 'Karusell med stående plakater',
    icon: 'tabler:photo',
    family: 'carousel',
    needsCollection: true,
    sizes: ['small', 'medium']
  },
  {
    type: 'CardSection',
    label: 'Kort',
    description: 'Brede kort for innholdselementer',
    icon: 'tabler:cards',
    family: 'carousel',
    needsCollection: true,
    sizes: ['large', 'mini']
  },
  {
    type: 'ListSection',
    label: 'Liste',
    description: 'Vertikal liste med rader',
    icon: 'tabler:list',
    family: 'carousel',
    needsCollection: true,
    sizes: ['medium']
  },
  {
    type: 'CardListSection',
    label: 'Kortliste',
    description: 'Vertikal liste med kort',
    icon: 'tabler:layout-list',
    family: 'carousel',
    needsCollection: true,
    sizes: ['medium']
  },
  {
    type: 'IconSection',
    label: 'Ikoner',
    description: 'Karusell med runde ikoner',
    icon: 'tabler:circles',
    family: 'carousel',
    needsCollection: true,
    sizes: ['medium']
  },
  {
    type: 'LabelSection',
    label: 'Etiketter',
    description: 'Karusell med tekstetiketter',
    icon: 'tabler:tag',
    family: 'carousel',
    needsCollection: true,
    sizes: ['medium']
  },
  {
    type: 'AvatarSection',
    label: 'Avatarer',
    description: 'Karusell med runde portretter',
    icon: 'tabler:user-circle',
    family: 'carousel',
    needsCollection: true,
    sizes: ['medium']
  },
  {
    type: 'DefaultGridSection',
    label: 'Rutenett',
    description: 'Rutenett med liggende miniatyrbilder',
    icon: 'tabler:grid-dots',
    family: 'grid',
    needsCollection: true,
    sizes: ['half']
  },
  {
    type: 'PosterGridSection',
    label: 'Plakat-rutenett',
    description: 'Rutenett med stående plakater',
    icon: 'tabler:layout-grid',
    family: 'grid',
    needsCollection: true,
    sizes: ['half']
  },
  {
    type: 'IconGridSection',
    label: 'Ikon-rutenett',
    description: 'Rutenett med ikoner og etiketter',
    icon: 'tabler:category',
    family: 'grid',
    needsCollection: true,
    sizes: ['half']
  },
  {
    type: 'MessageSection',
    label: 'Melding',
    description: 'Viser en melding fra meldingssystemet',
    icon: 'tabler:message-2',
    family: 'special',
    needsCollection: false,
    sizes: ['medium']
  },
  {
    type: 'WebSection',
    label: 'Nettside',
    description: 'Bygger inn en ekstern side',
    icon: 'tabler:world',
    family: 'special',
    needsCollection: false,
    sizes: ['medium']
  },
  {
    type: 'AchievementSection',
    label: 'Prestasjoner',
    description: 'Viser brukerens prestasjoner',
    icon: 'tabler:trophy',
    family: 'special',
    needsCollection: false,
    sizes: ['medium']
  },
  {
    type: 'PageDetailsSection',
    label: 'Sidedetaljer',
    description: 'Tittel og beskrivelse for siden',
    icon: 'tabler:file-description',
    family: 'special',
    needsCollection: false,
    sizes: ['medium']
  }
]

export function sectionTypeInfo(type: SectionType): SectionTypeInfo {
  return sectionTypes.find((t) => t.type === type) ?? sectionTypes[0]!
}

export const sectionSizeLabels: Record<SectionSize, string> = {
  small: 'Liten',
  medium: 'Medium',
  large: 'Stor',
  mini: 'Mini',
  half: 'Halv'
}

export const sectionFamilyLabels: Record<SectionFamily, string> = {
  carousel: 'Karuseller og lister',
  grid: 'Rutenett',
  special: 'Spesial'
}

/**
 * Flat, like the `sections` table itself — which fields matter depends on the
 * section type.
 */
export interface PageSection {
  id: string
  type: SectionType
  title: string | null
  description: string | null
  size: SectionSize
  showTitle: boolean
  needsAuthentication: boolean
  // Item sections
  collectionId: string | null
  limit: number | null
  secondaryTitles: boolean
  useContext: boolean
  prependLiveElement: boolean
  // WebSection
  embedUrl: string | null
  // MessageSection
  messageId: string | null
  // AchievementSection
  achievementsSource: string | null
}

export interface Page {
  id: string
  code: string
  status: Status
  title: string
  description: string | null
  applicationCode: string
  sections: PageSection[]
}

export function newSection(type: SectionType): PageSection {
  const info = sectionTypeInfo(type)
  return {
    id: crypto.randomUUID(),
    type,
    title: null,
    description: null,
    size: info.sizes[0]!,
    showTitle: true,
    needsAuthentication: false,
    collectionId: null,
    limit: null,
    secondaryTitles: false,
    useContext: false,
    prependLiveElement: false,
    embedUrl: null,
    messageId: null,
    achievementsSource: null
  }
}

function section(
  id: string,
  type: SectionType,
  title: string | null,
  overrides: Partial<PageSection> = {}
): PageSection {
  return { ...newSection(type), id, title, ...overrides }
}

export const mockPages: Page[] = [
  {
    id: '1',
    code: 'home',
    status: 'published',
    title: 'Hjem',
    description: null,
    applicationCode: 'bccm-mobile',
    sections: [
      section('s1', 'FeaturedSection', 'Påskestevnet 2026', {
        description: 'Se direktesendingene fra Brunstad',
        collectionId: 'col-easter-2026',
        prependLiveElement: true
      }),
      section('s2', 'DefaultSection', 'Fortsett å se', {
        collectionId: 'col-continue',
        secondaryTitles: true
      }),
      section('s3', 'PosterSection', 'Populære serier', {
        collectionId: 'col-popular-shows'
      }),
      section('s4', 'DefaultSection', 'Nye episoder', {
        collectionId: 'col-new-episodes',
        limit: 10
      }),
      section('s5', 'IconGridSection', 'Kategorier', {
        collectionId: 'col-popular-shows'
      })
    ]
  },
  {
    id: '2',
    code: 'kids-home',
    status: 'published',
    title: 'Hjem',
    description: null,
    applicationCode: 'kids-mobile',
    sections: [
      section('s6', 'FeaturedSection', 'Superbook', {
        collectionId: 'col-kids',
        size: 'medium'
      }),
      section('s7', 'PosterGridSection', 'Alle serier', {
        collectionId: 'col-kids'
      })
    ]
  },
  {
    id: '3',
    code: 'live',
    status: 'published',
    title: 'Direkte',
    description: 'Direktesendinger og TV-guide',
    applicationCode: 'live-mobile',
    sections: [
      section('s8', 'MessageSection', null, { messageId: '1' }),
      section('s9', 'FeaturedSection', 'Nå på luften', {
        collectionId: 'col-easter-2026',
        prependLiveElement: true
      }),
      section('s10', 'ListSection', 'I dag', {
        collectionId: 'col-new-episodes'
      })
    ]
  },
  {
    id: '4',
    code: 'search',
    status: 'published',
    title: 'Søk',
    description: null,
    applicationCode: 'bccm-mobile',
    sections: [
      section('s11', 'DefaultGridSection', 'Forslag', {
        collectionId: 'col-popular-shows'
      })
    ]
  },
  {
    id: '5',
    code: 'music',
    status: 'draft',
    title: 'Musikk',
    description: 'Konserter og musikkvideoer',
    applicationCode: 'play-mobile',
    sections: [
      section('s12', 'PageDetailsSection', null),
      section('s13', 'CardSection', 'Konserter', {
        collectionId: 'col-music',
        size: 'large'
      }),
      section('s14', 'WebSection', 'Om musikk', {
        embedUrl: 'https://bcc.media/musikk'
      })
    ]
  }
]
