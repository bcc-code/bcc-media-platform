/**
 * `events` is a small collection: status, start, end and translations. There
 * is deliberately no image here — images live on the calendar entries.
 */
export interface CalendarEvent {
  id: string
  status: Status
  title: string
  start: string
  end: string
}

export const mockEvents: CalendarEvent[] = [
  {
    id: 'e1',
    status: 'published',
    title: 'Påskestevne',
    start: '2026-04-02T00:00:00Z',
    end: '2026-04-05T23:59:59Z'
  },
  {
    id: 'e2',
    status: 'published',
    title: 'Pinsestevne',
    start: '2026-05-22T00:00:00Z',
    end: '2026-05-25T23:59:59Z'
  },
  {
    id: 'e3',
    status: 'published',
    title: 'Sommerstevne',
    start: '2026-07-15T00:00:00Z',
    end: '2026-07-19T23:59:59Z'
  },
  {
    id: 'e4',
    status: 'draft',
    title: 'Nyttårstevne',
    start: '2026-12-30T00:00:00Z',
    end: '2027-01-01T23:59:59Z'
  }
]
