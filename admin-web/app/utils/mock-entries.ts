export interface CalendarEvent {
  id: string
  title: string
  start: string
  end: string
  image: string
}

export interface SimpleCalendarEntry {
  id: string
  type: 'SimpleCalendarEntry'
  title: string
  description: string
  start: string
  end: string
  event: CalendarEvent
}

export interface EpisodeCalendarEntry {
  id: string
  type: 'EpisodeCalendarEntry'
  title: string
  description: string
  start: string
  end: string
  isReplay: boolean
  event: CalendarEvent
}

export interface SeasonCalendarEntry {
  id: string
  type: 'SeasonCalendarEntry'
  title: string
  description: string
  start: string
  end: string
  event: CalendarEvent
}

export type CalendarEntry =
  | SimpleCalendarEntry
  | EpisodeCalendarEntry
  | SeasonCalendarEntry

const paaskestevne = mockEvents[0]!
const pinsestevne = mockEvents[1]!
const sommerstevne = mockEvents[2]!
const nyttaarsstevne = mockEvents[3]!

export const mockCalendarEntries: CalendarEntry[] = [
  // Påskestevne — torsdag 2. april
  {
    id: '1',
    type: 'SimpleCalendarEntry',
    title: 'Åpningsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-04-02T19:30:00Z',
    end: '2026-04-02T21:00:00Z',
    event: paaskestevne
  },
  // Påskestevne — fredag 3. april
  {
    id: '2',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-04-03T11:00:00Z',
    end: '2026-04-03T12:30:00Z',
    event: paaskestevne
  },
  {
    id: '3',
    type: 'SimpleCalendarEntry',
    title: 'Ungdomsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-04-03T19:00:00Z',
    end: '2026-04-03T20:30:00Z',
    event: paaskestevne
  },
  // Påskestevne — lørdag 4. april
  {
    id: '4',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-04-04T11:00:00Z',
    end: '2026-04-04T12:30:00Z',
    event: paaskestevne
  },
  {
    id: '5',
    type: 'SimpleCalendarEntry',
    title: 'Magasinet',
    description: 'Direkte fra Brunstad',
    start: '2026-04-04T19:00:00Z',
    end: '2026-04-04T20:00:00Z',
    event: paaskestevne
  },
  // Påskestevne — søndag 5. april
  {
    id: '6',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-04-05T11:00:00Z',
    end: '2026-04-05T12:30:00Z',
    event: paaskestevne
  },

  // Pinsestevne — fredag 22. mai
  {
    id: '7',
    type: 'SimpleCalendarEntry',
    title: 'Åpningsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-05-22T19:30:00Z',
    end: '2026-05-22T21:00:00Z',
    event: pinsestevne
  },
  // Pinsestevne — lørdag 23. mai
  {
    id: '8',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-05-23T11:00:00Z',
    end: '2026-05-23T12:30:00Z',
    event: pinsestevne
  },
  {
    id: '9',
    type: 'SimpleCalendarEntry',
    title: 'Ungdomsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-05-23T19:00:00Z',
    end: '2026-05-23T20:30:00Z',
    event: pinsestevne
  },
  // Pinsestevne — søndag 24. mai
  {
    id: '10',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-05-24T11:00:00Z',
    end: '2026-05-24T12:30:00Z',
    event: pinsestevne
  },
  {
    id: '11',
    type: 'SimpleCalendarEntry',
    title: 'Magasinet',
    description: 'Direkte fra Brunstad',
    start: '2026-05-24T19:00:00Z',
    end: '2026-05-24T20:00:00Z',
    event: pinsestevne
  },
  // Pinsestevne — mandag 25. mai
  {
    id: '12',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-05-25T11:00:00Z',
    end: '2026-05-25T12:30:00Z',
    event: pinsestevne
  },

  // Sommerstevne — tirsdag 15. juli
  {
    id: '13',
    type: 'SimpleCalendarEntry',
    title: 'Åpningsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-15T19:30:00Z',
    end: '2026-07-15T21:00:00Z',
    event: sommerstevne
  },
  // Sommerstevne — onsdag 16. juli
  {
    id: '14',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-16T11:00:00Z',
    end: '2026-07-16T12:30:00Z',
    event: sommerstevne
  },
  {
    id: '15',
    type: 'SimpleCalendarEntry',
    title: 'Ungdomsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-16T19:00:00Z',
    end: '2026-07-16T20:30:00Z',
    event: sommerstevne
  },
  // Sommerstevne — torsdag 17. juli
  {
    id: '16',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-17T11:00:00Z',
    end: '2026-07-17T12:30:00Z',
    event: sommerstevne
  },
  {
    id: '17',
    type: 'SimpleCalendarEntry',
    title: 'Magasinet',
    description: 'Direkte fra Brunstad',
    start: '2026-07-17T19:00:00Z',
    end: '2026-07-17T20:00:00Z',
    event: sommerstevne
  },
  // Sommerstevne — fredag 18. juli
  {
    id: '18',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-18T11:00:00Z',
    end: '2026-07-18T12:30:00Z',
    event: sommerstevne
  },
  {
    id: '19',
    type: 'SimpleCalendarEntry',
    title: 'Ungdomsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-18T19:00:00Z',
    end: '2026-07-18T20:30:00Z',
    event: sommerstevne
  },
  // Sommerstevne — lørdag 19. juli
  {
    id: '20',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-07-19T11:00:00Z',
    end: '2026-07-19T12:30:00Z',
    event: sommerstevne
  },

  // Nyttårstevne — tirsdag 30. desember
  {
    id: '21',
    type: 'SimpleCalendarEntry',
    title: 'Åpningsmøte',
    description: 'Direkte fra Brunstad',
    start: '2026-12-30T19:30:00Z',
    end: '2026-12-30T21:00:00Z',
    event: nyttaarsstevne
  },
  // Nyttårstevne — onsdag 31. desember
  {
    id: '22',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2026-12-31T11:00:00Z',
    end: '2026-12-31T12:30:00Z',
    event: nyttaarsstevne
  },
  {
    id: '23',
    type: 'SimpleCalendarEntry',
    title: 'Nyttårskonsert',
    description: 'Direkte fra Brunstad',
    start: '2026-12-31T20:00:00Z',
    end: '2026-12-31T22:00:00Z',
    event: nyttaarsstevne
  },
  // Nyttårstevne — torsdag 1. januar
  {
    id: '24',
    type: 'SimpleCalendarEntry',
    title: 'Møte',
    description: 'Direkte fra Brunstad',
    start: '2027-01-01T11:00:00Z',
    end: '2027-01-01T12:30:00Z',
    event: nyttaarsstevne
  }
]
