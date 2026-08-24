export type CalendarEntryType =
  | 'SimpleCalendarEntry'
  | 'EpisodeCalendarEntry'
  | 'SeasonCalendarEntry'
  | 'ShowCalendarEntry'

/**
 * Start-over playback window. `availableHours` of 0 means the buffer is never
 * available; `start`/`end` override the entry's own times when set.
 */
export interface CalendarEntryBuffer {
  availableHours: number
  start: string | null
  end: string | null
}

interface BaseCalendarEntry {
  id: string
  status: Status
  title: string
  description: string
  start: string
  end: string
  event: CalendarEvent
  imageUrl: string | null
  /** Take the image from the linked episode/season/show instead. */
  imageFromLink: boolean
  buffer: CalendarEntryBuffer
}

export interface SimpleCalendarEntry extends BaseCalendarEntry {
  type: 'SimpleCalendarEntry'
}

export interface EpisodeCalendarEntry extends BaseCalendarEntry {
  type: 'EpisodeCalendarEntry'
  episodeId: string
  isReplay: boolean
}

export interface SeasonCalendarEntry extends BaseCalendarEntry {
  type: 'SeasonCalendarEntry'
  seasonId: string
}

export interface ShowCalendarEntry extends BaseCalendarEntry {
  type: 'ShowCalendarEntry'
  showId: string
}

export type CalendarEntry =
  | SimpleCalendarEntry
  | EpisodeCalendarEntry
  | SeasonCalendarEntry
  | ShowCalendarEntry

export const noBuffer: CalendarEntryBuffer = {
  availableHours: 0,
  start: null,
  end: null
}

const paaskestevne = mockEvents[0]!
const pinsestevne = mockEvents[1]!
const sommerstevne = mockEvents[2]!
const nyttaarsstevne = mockEvents[3]!

/** [id, title, startISO, endISO, event] — the plain live entries. */
type Seed = [string, string, string, string, CalendarEvent]

const simpleSeeds: Seed[] = [
  // Påskestevne
  ['1', 'Åpningsmøte', '2026-04-02T19:30:00Z', '2026-04-02T21:00:00Z', paaskestevne],
  ['2', 'Møte', '2026-04-03T11:00:00Z', '2026-04-03T12:30:00Z', paaskestevne],
  ['3', 'Ungdomsmøte', '2026-04-03T19:00:00Z', '2026-04-03T20:30:00Z', paaskestevne],
  ['4', 'Møte', '2026-04-04T11:00:00Z', '2026-04-04T12:30:00Z', paaskestevne],
  ['5', 'Magasinet', '2026-04-04T19:00:00Z', '2026-04-04T20:00:00Z', paaskestevne],
  ['6', 'Møte', '2026-04-05T11:00:00Z', '2026-04-05T12:30:00Z', paaskestevne],
  // Pinsestevne
  ['7', 'Åpningsmøte', '2026-05-22T19:30:00Z', '2026-05-22T21:00:00Z', pinsestevne],
  ['8', 'Møte', '2026-05-23T11:00:00Z', '2026-05-23T12:30:00Z', pinsestevne],
  ['9', 'Ungdomsmøte', '2026-05-23T19:00:00Z', '2026-05-23T20:30:00Z', pinsestevne],
  ['10', 'Møte', '2026-05-24T11:00:00Z', '2026-05-24T12:30:00Z', pinsestevne],
  ['11', 'Magasinet', '2026-05-24T19:00:00Z', '2026-05-24T20:00:00Z', pinsestevne],
  ['12', 'Møte', '2026-05-25T11:00:00Z', '2026-05-25T12:30:00Z', pinsestevne],
  // Sommerstevne
  ['13', 'Åpningsmøte', '2026-07-15T19:30:00Z', '2026-07-15T21:00:00Z', sommerstevne],
  ['14', 'Møte', '2026-07-16T11:00:00Z', '2026-07-16T12:30:00Z', sommerstevne],
  ['15', 'Ungdomsmøte', '2026-07-16T19:00:00Z', '2026-07-16T20:30:00Z', sommerstevne],
  ['16', 'Møte', '2026-07-17T11:00:00Z', '2026-07-17T12:30:00Z', sommerstevne],
  ['17', 'Magasinet', '2026-07-17T19:00:00Z', '2026-07-17T20:00:00Z', sommerstevne],
  ['18', 'Møte', '2026-07-18T11:00:00Z', '2026-07-18T12:30:00Z', sommerstevne],
  ['19', 'Ungdomsmøte', '2026-07-18T19:00:00Z', '2026-07-18T20:30:00Z', sommerstevne],
  ['20', 'Møte', '2026-07-19T11:00:00Z', '2026-07-19T12:30:00Z', sommerstevne],
  // Nyttårstevne
  ['21', 'Åpningsmøte', '2026-12-30T19:30:00Z', '2026-12-30T21:00:00Z', nyttaarsstevne],
  ['22', 'Møte', '2026-12-31T11:00:00Z', '2026-12-31T12:30:00Z', nyttaarsstevne],
  ['23', 'Nyttårskonsert', '2026-12-31T20:00:00Z', '2026-12-31T22:00:00Z', nyttaarsstevne],
  ['24', 'Møte', '2027-01-01T11:00:00Z', '2027-01-01T12:30:00Z', nyttaarsstevne]
]

function simple([id, title, start, end, event]: Seed): SimpleCalendarEntry {
  return {
    id,
    type: 'SimpleCalendarEntry',
    status: 'published',
    title,
    description: 'Direkte fra Brunstad',
    start,
    end,
    event,
    imageUrl: null,
    imageFromLink: false,
    buffer: { availableHours: 24, start: null, end: null }
  }
}

export const mockCalendarEntries: CalendarEntry[] = [
  ...simpleSeeds.map(simple),

  // Linked entries — these are what the TV guide points at outside live moments.
  {
    id: '25',
    type: 'EpisodeCalendarEntry',
    status: 'published',
    title: 'Bibeltimen: Troens fundament',
    description: 'Reprise fra søndag',
    start: '2026-04-03T14:00:00Z',
    end: '2026-04-03T14:47:00Z',
    event: paaskestevne,
    episodeId: '1',
    isReplay: true,
    imageUrl: null,
    imageFromLink: true,
    buffer: noBuffer
  },
  {
    id: '26',
    type: 'EpisodeCalendarEntry',
    status: 'published',
    title: 'Bak kulissene: Påskestevnet',
    description: 'Følg forberedelsene',
    start: '2026-04-04T14:00:00Z',
    end: '2026-04-04T14:35:00Z',
    event: paaskestevne,
    episodeId: '5',
    isReplay: false,
    imageUrl: null,
    imageFromLink: true,
    buffer: noBuffer
  },
  {
    id: '27',
    type: 'SeasonCalendarEntry',
    status: 'published',
    title: 'Superbook sesong 5',
    description: 'Hele sesongen samlet',
    start: '2026-05-23T15:00:00Z',
    end: '2026-05-23T16:00:00Z',
    event: pinsestevne,
    seasonId: '3',
    imageUrl: null,
    imageFromLink: true,
    buffer: noBuffer
  },
  {
    id: '28',
    type: 'ShowCalendarEntry',
    status: 'draft',
    title: 'Utsatisforsk',
    description: 'Alle episoder',
    start: '2026-07-17T15:00:00Z',
    end: '2026-07-17T16:00:00Z',
    event: sommerstevne,
    showId: '3',
    imageUrl: null,
    imageFromLink: true,
    buffer: noBuffer
  }
]
