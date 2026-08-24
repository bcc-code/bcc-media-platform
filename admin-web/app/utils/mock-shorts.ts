/**
 * A short is a time range carved out of an episode. In the database that is a
 * clip mediaitem with a parent episode, but the admin only ever sees "a bit of
 * this episode" — see docs/admin-web-scope.md.
 */
export interface Short {
  id: string
  status: Status
  episodeId: string
  title: string
  /** Seconds into the parent episode. */
  startsAt: number
  endsAt: number
  createdAt: string
}

export const mockShorts: Short[] = [
  {
    id: 's1',
    status: 'published',
    episodeId: '1',
    title: 'Hva er et fast fundament?',
    startsAt: 420,
    endsAt: 465,
    createdAt: '2026-08-20T10:15:00Z'
  },
  {
    id: 's2',
    status: 'published',
    episodeId: '5',
    title: 'Rigging av scenen',
    startsAt: 130,
    endsAt: 175,
    createdAt: '2026-08-21T12:40:00Z'
  },
  {
    id: 's3',
    status: 'draft',
    episodeId: '3',
    title: 'Chris og Joy finner kartet',
    startsAt: 200,
    endsAt: 232,
    createdAt: '2026-08-23T15:05:00Z'
  },
  {
    id: 's4',
    status: 'unlisted',
    episodeId: '7',
    title: 'Åpningsnummeret',
    startsAt: 60,
    endsAt: 118,
    createdAt: '2026-08-19T09:00:00Z'
  }
]
