export type MessageSeverity = 'info' | 'warning' | 'error'

/**
 * Where a message appears is NOT stored here. A message only reaches an app
 * through a MessageSection on a page (`sections.message_id`) — see
 * docs/admin-web-scope.md. Placement is derived from pages.
 */
export interface AppMessage {
  id: string
  severity: MessageSeverity
  title: string
  body: string
  active: boolean
  updatedAt: string
  updatedBy: string
}

/** The subset of a message the live preview follows while typing. */
export interface MessageDraft {
  severity: MessageSeverity
  title: string
  body: string
}

export const severityLabels: Record<MessageSeverity, string> = {
  info: 'Info',
  warning: 'Advarsel',
  error: 'Feil'
}

export const severityVariants: Record<
  MessageSeverity,
  'info' | 'warning' | 'error'
> = {
  info: 'info',
  warning: 'warning',
  error: 'error'
}

export const severityIcons: Record<MessageSeverity, string> = {
  info: 'tabler:info-circle',
  warning: 'tabler:alert-triangle',
  error: 'tabler:alert-octagon'
}

export const mockMessages: AppMessage[] = [
  {
    id: '1',
    severity: 'warning',
    title: 'Planlagt vedlikehold',
    body: 'Appen kan være ustabil mellom 02:00 og 04:00 natt til søndag.',
    active: true,
    updatedAt: '2026-08-22T09:30:00Z',
    updatedBy: 'Marit Solberg'
  },
  {
    id: '2',
    severity: 'info',
    title: 'Påskestevnet strømmes direkte',
    body: 'Følg alle møtene fra Brunstad i påsken, direkte i appen.',
    active: true,
    updatedAt: '2026-08-20T13:45:00Z',
    updatedBy: 'Jonas Vik'
  },
  {
    id: '3',
    severity: 'error',
    title: 'Direktesendingen er nede',
    body: 'Vi jobber med å få direktesendingen tilbake. Prøv igjen om litt.',
    active: false,
    updatedAt: '2026-07-02T18:05:00Z',
    updatedBy: 'Marit Solberg'
  },
  {
    id: '4',
    severity: 'info',
    title: 'Ny versjon tilgjengelig',
    body: 'Oppdater appen for å få de nyeste funksjonene.',
    active: false,
    updatedAt: '2026-06-11T11:00:00Z',
    updatedBy: 'Jonas Vik'
  }
]
