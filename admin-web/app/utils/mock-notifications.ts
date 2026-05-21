export interface PushNotification {
  id: string
  applicationCode: string
  title: string
  body: string
  status: 'sent' | 'scheduled' | 'draft' | 'failed'
  recipientCount: number
  recipientGroup: string
  sentAt: string | null
  scheduledAt: string | null
  createdAt: string
}

export const mockNotifications: PushNotification[] = [
  {
    id: '1',
    applicationCode: 'bccm-mobile',
    title: 'Ny episode tilgjengelig',
    body: 'Se den nyeste episoden av Utsatisforsk nå!',
    status: 'sent',
    recipientCount: 12430,
    recipientGroup: 'Alle',
    sentAt: '2026-04-15T10:30:00Z',
    scheduledAt: null,
    createdAt: '2026-04-15T10:00:00Z'
  },
  {
    id: '2',
    applicationCode: 'bccm-mobile',
    title: 'Livestream starter snart',
    body: 'Påskestevnet starter kl. 19:00',
    status: 'scheduled',
    recipientCount: 0,
    recipientGroup: 'Alle',
    sentAt: null,
    scheduledAt: '2026-04-18T17:00:00Z',
    createdAt: '2026-04-14T09:00:00Z'
  },
  {
    id: '3',
    applicationCode: 'live-mobile',
    title: 'Ukentlig oppsummering',
    body: 'Her er ukens mest populaere innhold',
    status: 'draft',
    recipientCount: 0,
    recipientGroup: 'Abonnenter',
    sentAt: null,
    scheduledAt: null,
    createdAt: '2026-04-16T14:00:00Z'
  },
  {
    id: '4',
    applicationCode: 'kids-mobile',
    title: 'Nye episoder av Superbook',
    body: 'Tre nye episoder er klare!',
    status: 'sent',
    recipientCount: 3400,
    recipientGroup: 'Alle',
    sentAt: '2026-04-14T12:00:00Z',
    scheduledAt: null,
    createdAt: '2026-04-14T10:00:00Z'
  },
  {
    id: '5',
    applicationCode: 'play-mobile',
    title: 'Ny funksjon: Offline modus',
    body: 'Last ned innhold og se det uten nett',
    status: 'sent',
    recipientCount: 8200,
    recipientGroup: 'Alle',
    sentAt: '2026-04-13T08:00:00Z',
    scheduledAt: null,
    createdAt: '2026-04-12T16:00:00Z'
  },
  {
    id: '6',
    applicationCode: 'play-web',
    title: 'Vedlikeholdsvindu',
    body: 'Appen vil vaere utilgjengelig i kort tid',
    status: 'failed',
    recipientCount: 0,
    recipientGroup: 'Alle',
    sentAt: null,
    scheduledAt: null,
    createdAt: '2026-04-10T12:00:00Z'
  }
]
