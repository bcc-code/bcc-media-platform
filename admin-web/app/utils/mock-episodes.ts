export type EpisodeType = 'episode' | 'standalone'

export interface Episode {
  id: string
  uuid: string
  legacyID: string | null
  status: 'published' | 'unlisted' | 'draft' | 'archived'
  type: EpisodeType
  title: string
  description: string
  imageUrl: string | null
  publishDate: string
  availableFrom: string
  availableTo: string
  ageRating: string
  duration: number
  number: number | null
  season: {
    id: string
    number: number
    show: {
      id: string
      title: string
    }
  } | null
}

export const mockEpisodes: Episode[] = [
  {
    id: '1',
    uuid: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    legacyID: '3001',
    status: 'published',
    type: 'episode',
    title: 'Troens fundament',
    description:
      'En dypere titt på hva det vil si å bygge på et fast fundament.',
    imageUrl: '/images/bibeltimen-s12e04.jpg',
    publishDate: '2026-04-15T10:00:00Z',
    availableFrom: '2026-04-15T10:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: 'A',
    duration: 2820,
    number: 4,
    season: { id: '1', number: 12, show: { id: '1', title: 'Bibeltimen' } }
  },
  {
    id: '2',
    uuid: 'b2c3d4e5-f6a7-8901-bcde-f12345678901',
    legacyID: null,
    status: 'draft',
    type: 'episode',
    title: 'Veien videre',
    description: 'Samtale om å finne retning i livet.',
    imageUrl: '/images/bibeltimen-s12e05.jpg',
    publishDate: '2026-04-22T10:00:00Z',
    availableFrom: '2026-04-22T10:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: '6',
    duration: 2640,
    number: 5,
    season: { id: '1', number: 12, show: { id: '1', title: 'Bibeltimen' } }
  },
  {
    id: '3',
    uuid: 'c3d4e5f6-a7b8-9012-cdef-123456789012',
    legacyID: null,
    status: 'published',
    type: 'episode',
    title: 'Mysteriet i dalen',
    description:
      'Chris og Joy reiser tilbake i tid for å løse et gammelt mysterium.',
    imageUrl: '/images/superbook-s05e01.jpg',
    publishDate: '2026-04-14T08:00:00Z',
    availableFrom: '2026-04-14T08:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: 'A',
    duration: 1440,
    number: 1,
    season: { id: '3', number: 5, show: { id: '2', title: 'Superbook' } }
  },
  {
    id: '4',
    uuid: 'd4e5f6a7-b8c9-0123-defa-234567890123',
    legacyID: null,
    status: 'archived',
    type: 'episode',
    title: 'Den store redningen',
    description: 'Et nytt eventyr venter når vennene må samarbeide.',
    imageUrl: '/images/superbook-s05e02.jpg',
    publishDate: '2026-05-01T08:00:00Z',
    availableFrom: '2026-05-01T08:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: '9',
    duration: 1380,
    number: 2,
    season: { id: '3', number: 5, show: { id: '2', title: 'Superbook' } }
  },
  {
    id: '5',
    uuid: 'e5f6a7b8-c9d0-1234-efab-345678901234',
    legacyID: null,
    status: 'published',
    type: 'episode',
    title: 'Bak kulissene: Påskestevnet',
    description: 'Følg forberedelsene til årets største arrangement.',
    imageUrl: '/images/utsatisforsk-s03e01.jpg',
    publishDate: '2026-04-10T20:00:00Z',
    availableFrom: '2026-04-10T20:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: 'A',
    duration: 2100,
    number: 1,
    season: { id: '5', number: 3, show: { id: '3', title: 'Utsatisforsk' } }
  },
  {
    id: '6',
    uuid: 'f6a7b8c9-d0e1-2345-fabc-456789012345',
    legacyID: null,
    status: 'unlisted',
    type: 'episode',
    title: 'Fellesskap på tvers',
    description: 'Historier om fellesskap fra ulike steder i verden.',
    imageUrl: '/images/utsatisforsk-s03e02.jpg',
    publishDate: '2026-04-20T20:00:00Z',
    availableFrom: '2026-04-20T20:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: '12',
    duration: 1980,
    number: 2,
    season: { id: '5', number: 3, show: { id: '3', title: 'Utsatisforsk' } }
  },
  {
    id: '7',
    uuid: 'a7b8c9d0-e1f2-3456-abcd-567890123456',
    legacyID: null,
    status: 'published',
    type: 'standalone',
    title: 'Konsert: Oslo Live',
    description: 'Opptak fra konserten i Oslo Spektrum.',
    imageUrl: '/images/musikk-oslo.jpg',
    publishDate: '2026-04-08T18:00:00Z',
    availableFrom: '2026-04-08T18:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: 'U',
    duration: 5400,
    number: 3,
    season: { id: '7', number: 1, show: { id: '4', title: 'Musikkvideoer' } }
  },
  {
    id: '8',
    uuid: 'b8c9d0e1-f2a3-4567-bcde-678901234567',
    legacyID: null,
    status: 'draft',
    type: 'standalone',
    title: 'Ny sang: Håp',
    description: 'Musikkvideo for den nye sangen.',
    imageUrl: null,
    publishDate: '2026-05-15T18:00:00Z',
    availableFrom: '2026-05-15T18:00:00Z',
    availableTo: '2099-12-31T23:59:59Z',
    ageRating: '15',
    duration: 240,
    number: 4,
    season: { id: '7', number: 1, show: { id: '4', title: 'Musikkvideoer' } }
  }
]
