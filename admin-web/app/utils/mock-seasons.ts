export interface Season {
  id: string
  legacyID: string | null
  status: 'published' | 'unlisted' | 'draft' | 'archived'
  ageRating: string
  title: string
  description: string
  imageUrl: string | null
  number: number
  show: {
    id: string
    title: string
  }
}

export const mockSeasons: Season[] = [
  {
    id: '1',
    legacyID: '2001',
    status: 'published',
    ageRating: 'A',
    title: 'Sesong 12',
    description: 'Fokus på tro og fundament',
    imageUrl: '/images/bibeltimen-s12.jpg',
    number: 12,
    show: { id: '1', title: 'Bibeltimen' }
  },
  {
    id: '2',
    legacyID: '2002',
    status: 'unlisted',
    ageRating: '6',
    title: 'Sesong 11',
    description: 'Reisen gjennom Salmene',
    imageUrl: '/images/bibeltimen-s11.jpg',
    number: 11,
    show: { id: '1', title: 'Bibeltimen' }
  },
  {
    id: '3',
    legacyID: null,
    status: 'published',
    ageRating: 'A',
    title: 'Sesong 5',
    description: 'Nye eventyr med Chris og Joy',
    imageUrl: '/images/superbook-s05.jpg',
    number: 5,
    show: { id: '2', title: 'Superbook' }
  },
  {
    id: '4',
    legacyID: null,
    status: 'archived',
    ageRating: 'A',
    title: 'Sesong 4',
    description: 'Historier fra Det gamle testamentet',
    imageUrl: '/images/superbook-s04.jpg',
    number: 4,
    show: { id: '2', title: 'Superbook' }
  },
  {
    id: '5',
    legacyID: null,
    status: 'published',
    ageRating: '9',
    title: 'Sesong 3',
    description: 'Bak kulissene og fellesskap',
    imageUrl: '/images/utsatisforsk-s03.jpg',
    number: 3,
    show: { id: '3', title: 'Utsatisforsk' }
  },
  {
    id: '6',
    legacyID: null,
    status: 'draft',
    ageRating: '12',
    title: 'Sesong 2',
    description: 'Reiser og opplevelser',
    imageUrl: '/images/utsatisforsk-s02.jpg',
    number: 2,
    show: { id: '3', title: 'Utsatisforsk' }
  },
  {
    id: '7',
    legacyID: null,
    status: 'published',
    ageRating: 'U',
    title: 'Sesong 1',
    description: 'Konserter og musikkvideoer',
    imageUrl: '/images/musikk-s01.jpg',
    number: 1,
    show: { id: '4', title: 'Musikkvideoer' }
  },
  {
    id: '8',
    legacyID: null,
    status: 'draft',
    ageRating: '15',
    title: 'Sesong 2',
    description: 'Nye sanger og opptredener',
    imageUrl: null,
    number: 2,
    show: { id: '4', title: 'Musikkvideoer' }
  }
]
