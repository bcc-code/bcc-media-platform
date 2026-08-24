/**
 * A video file that has arrived from the export system. The admin never
 * creates these — they show up on their own — so the only job here is
 * confirming one landed and pointing an episode at it.
 */
export interface Asset {
  id: string
  name: string
  mediabankenId: string
  duration: number
  arrivedAt: string
}

export const mockAssets: Asset[] = [
  {
    id: 'a1',
    name: 'Bibeltimen S12E04 - Troens fundament',
    mediabankenId: 'MB-2026-04812',
    duration: 2820,
    arrivedAt: '2026-08-24T06:41:00Z'
  },
  {
    id: 'a2',
    name: 'Bibeltimen S12E05 - Veien videre',
    mediabankenId: 'MB-2026-04813',
    duration: 2640,
    arrivedAt: '2026-08-24T06:44:00Z'
  },
  {
    id: 'a3',
    name: 'Superbook S05E01 - Mysteriet i dalen',
    mediabankenId: 'MB-2026-04790',
    duration: 1440,
    arrivedAt: '2026-08-23T14:02:00Z'
  },
  {
    id: 'a4',
    name: 'Superbook S05E02 - Den store redningen',
    mediabankenId: 'MB-2026-04791',
    duration: 1380,
    arrivedAt: '2026-08-23T14:05:00Z'
  },
  {
    id: 'a5',
    name: 'Utsatisforsk S03E01 - Bak kulissene',
    mediabankenId: 'MB-2026-04702',
    duration: 2100,
    arrivedAt: '2026-08-22T09:18:00Z'
  },
  {
    id: 'a6',
    name: 'Utsatisforsk S03E02 - Fellesskap på tvers',
    mediabankenId: 'MB-2026-04703',
    duration: 1980,
    arrivedAt: '2026-08-22T09:21:00Z'
  },
  {
    id: 'a7',
    name: 'Konsert Oslo Live - full opptak',
    mediabankenId: 'MB-2026-04655',
    duration: 5400,
    arrivedAt: '2026-08-21T16:30:00Z'
  },
  {
    id: 'a8',
    name: 'Musikkvideo - Håp',
    mediabankenId: 'MB-2026-04901',
    duration: 240,
    arrivedAt: '2026-08-24T08:05:00Z'
  },
  {
    id: 'a9',
    name: 'Ungdomspodden EP01 - Identitet',
    mediabankenId: 'MB-2026-04905',
    duration: 3120,
    arrivedAt: '2026-08-24T08:12:00Z'
  }
]

/** Position inside a video, as mm:ss or h:mm:ss. */
export function formatTimecode(seconds: number): string {
  const total = Math.max(0, Math.round(seconds))
  const h = Math.floor(total / 3600)
  const m = Math.floor((total % 3600) / 60)
  const s = total % 60
  const pad = (n: number) => n.toString().padStart(2, '0')
  return h > 0 ? `${h}:${pad(m)}:${pad(s)}` : `${m}:${pad(s)}`
}

export function formatDuration(seconds: number): string {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  if (h > 0) return `${h}t ${m}m`
  if (m > 0) return `${m}m ${s}s`
  return `${s}s`
}
