export type ShowType = 'event' | 'series'
export type Status = 'published' | 'unlisted' | 'draft' | 'archived'

export interface Show {
  id: string
  legacyID: string | null
  status: Status
  type: ShowType
  title: string
  description: string
  imageUrl: string | null
  episodeCount: number
  seasonCount: number
}

export const mockShows: Show[] = [
  {
    id: '1',
    legacyID: '1001',
    status: 'published',
    type: 'series',
    title: 'Bibeltimen',
    description: 'Ukentlig bibelundervisning med fokus på praktisk tro.',
    imageUrl: '/images/bibeltimen.jpg',
    seasonCount: 12,
    episodeCount: 96
  },
  {
    id: '2',
    legacyID: '1002',
    status: 'unlisted',
    type: 'series',
    title: 'Superbook',
    description: 'Animert serie der Chris og Joy reiser tilbake i tid.',
    imageUrl: '/images/superbook.jpg',
    seasonCount: 5,
    episodeCount: 52
  },
  {
    id: '3',
    legacyID: null,
    status: 'published',
    type: 'series',
    title: 'Utsatisforsk',
    description: 'Dokumentarserie som tar deg bak kulissene.',
    imageUrl: '/images/utsatisforsk.jpg',
    seasonCount: 3,
    episodeCount: 22
  },
  {
    id: '4',
    legacyID: null,
    status: 'archived',
    type: 'event',
    title: 'Musikkvideoer',
    description: 'Konserter, musikkvideoer og live-opptredener.',
    imageUrl: '/images/musikkvideoer.jpg',
    seasonCount: 2,
    episodeCount: 7
  },
  {
    id: '5',
    legacyID: null,
    status: 'draft',
    type: 'series',
    title: 'Ungdomspodden',
    description: 'Podcast for ungdom om tro, identitet og hverdagsliv.',
    imageUrl: null,
    seasonCount: 1,
    episodeCount: 0
  }
]
