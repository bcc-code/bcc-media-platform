/**
 * A target is a saved audience rule. Authoring these is rare and technical, so
 * the admin picks from existing ones rather than building rules by hand.
 */
export interface NotificationTarget {
  id: string
  label: string
  deviceOs: string[] | null
  languages: string[] | null
  inactiveDaysMin: number | null
  inactiveDaysMax: number | null
  minBuild: number | null
  maxBuild: number | null
}

export const mockTargets: NotificationTarget[] = [
  {
    id: 't1',
    label: 'Kun iOS',
    deviceOs: ['ios'],
    languages: null,
    inactiveDaysMin: null,
    inactiveDaysMax: null,
    minBuild: null,
    maxBuild: null
  },
  {
    id: 't2',
    label: 'Kun Android',
    deviceOs: ['android'],
    languages: null,
    inactiveDaysMin: null,
    inactiveDaysMax: null,
    minBuild: null,
    maxBuild: null
  },
  {
    id: 't3',
    label: 'Norsktalende',
    deviceOs: null,
    languages: ['no'],
    inactiveDaysMin: null,
    inactiveDaysMax: null,
    minBuild: null,
    maxBuild: null
  },
  {
    id: 't4',
    label: 'Inaktive i 30+ dager',
    deviceOs: null,
    languages: null,
    inactiveDaysMin: 30,
    inactiveDaysMax: null,
    minBuild: null,
    maxBuild: null
  },
  {
    id: 't5',
    label: 'Gammel appversjon',
    deviceOs: null,
    languages: null,
    inactiveDaysMin: null,
    inactiveDaysMax: null,
    minBuild: null,
    maxBuild: 420
  }
]

/** Plain-language summary of the rule, so the admin can see what it does. */
export function targetSummary(target: NotificationTarget): string {
  const parts: string[] = []
  if (target.deviceOs?.length) {
    parts.push(target.deviceOs.map((os) => os.toUpperCase()).join(' / '))
  }
  if (target.languages?.length) {
    parts.push(`språk: ${target.languages.join(', ')}`)
  }
  if (target.inactiveDaysMin !== null) {
    parts.push(`inaktiv i minst ${target.inactiveDaysMin} dager`)
  }
  if (target.inactiveDaysMax !== null) {
    parts.push(`inaktiv i høyst ${target.inactiveDaysMax} dager`)
  }
  if (target.minBuild !== null) parts.push(`build ≥ ${target.minBuild}`)
  if (target.maxBuild !== null) parts.push(`build ≤ ${target.maxBuild}`)
  return parts.join(' · ') || 'Ingen begrensning'
}

export function targetLabel(id: string): string {
  return mockTargets.find((t) => t.id === id)?.label ?? id
}
