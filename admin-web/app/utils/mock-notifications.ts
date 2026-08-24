export type NotificationAction = 'none' | 'deep_link' | 'clear_cache'

/**
 * Title and body live on a notification template in the database; the admin
 * never sees that indirection. Audience is an application group plus zero or
 * more saved target rules — see docs/admin-web-scope.md.
 */
export interface PushNotification {
  id: string
  title: string
  body: string
  appGroupId: string
  targetIds: string[]
  highPriority: boolean
  action: NotificationAction
  deepLink: string | null
  scheduleAt: string | null
  sendStarted: string | null
  sendCompleted: string | null
  recipientCount: number
  createdAt: string
}

/** What the form hands back; the page decides how to persist it. */
export interface NotificationSubmit {
  title: string
  body: string
  appGroupId: string
  targetIds: string[]
  highPriority: boolean
  action: NotificationAction
  deepLink: string | null
  scheduleAt: string | null
  sendNow: boolean
}

/** The preview follows what is being typed, not what is saved. */
export interface NotificationDraft {
  title: string
  body: string
  appGroupId: string
  highPriority: boolean
}

/** Derived from the send timestamps rather than stored as an enum. */
export type NotificationState = 'draft' | 'scheduled' | 'sending' | 'sent'

export function notificationState(
  notification: PushNotification
): NotificationState {
  if (notification.sendCompleted) return 'sent'
  if (notification.sendStarted) return 'sending'
  if (notification.scheduleAt) return 'scheduled'
  return 'draft'
}

export const notificationStateConfig: Record<
  NotificationState,
  { label: string; variant: 'success' | 'info' | 'neutral' | 'warning' }
> = {
  sent: { label: 'Sendt', variant: 'success' },
  sending: { label: 'Sender…', variant: 'warning' },
  scheduled: { label: 'Planlagt', variant: 'info' },
  draft: { label: 'Utkast', variant: 'neutral' }
}

export const mockNotifications: PushNotification[] = [
  {
    id: '1',
    title: 'Ny episode tilgjengelig',
    body: 'Se den nyeste episoden av Utsatisforsk nå!',
    appGroupId: 'bccm',
    targetIds: [],
    highPriority: false,
    action: 'deep_link',
    deepLink: 'bccm://episode/1',
    scheduleAt: null,
    sendStarted: '2026-08-22T10:30:00Z',
    sendCompleted: '2026-08-22T10:32:00Z',
    recipientCount: 12430,
    createdAt: '2026-08-22T10:00:00Z'
  },
  {
    id: '2',
    title: 'Livestream starter snart',
    body: 'Påskestevnet starter kl. 19:00',
    appGroupId: 'live',
    targetIds: ['t3'],
    highPriority: true,
    action: 'none',
    deepLink: null,
    scheduleAt: '2026-09-18T17:00:00Z',
    sendStarted: null,
    sendCompleted: null,
    recipientCount: 0,
    createdAt: '2026-08-21T09:00:00Z'
  },
  {
    id: '3',
    title: 'Ukentlig oppsummering',
    body: 'Her er ukens mest populære innhold',
    appGroupId: 'play',
    targetIds: [],
    highPriority: false,
    action: 'none',
    deepLink: null,
    scheduleAt: null,
    sendStarted: null,
    sendCompleted: null,
    recipientCount: 0,
    createdAt: '2026-08-23T14:00:00Z'
  },
  {
    id: '4',
    title: 'Nye episoder av Superbook',
    body: 'Tre nye episoder er klare!',
    appGroupId: 'kids',
    targetIds: ['t1', 't2'],
    highPriority: false,
    action: 'deep_link',
    deepLink: 'kids://show/2',
    scheduleAt: null,
    sendStarted: '2026-08-20T12:00:00Z',
    sendCompleted: '2026-08-20T12:01:00Z',
    recipientCount: 3400,
    createdAt: '2026-08-20T10:00:00Z'
  },
  {
    id: '5',
    title: 'Vi savner deg',
    body: 'Det har skjedd mye siden sist. Ta en titt!',
    appGroupId: 'bccm',
    targetIds: ['t4'],
    highPriority: false,
    action: 'none',
    deepLink: null,
    scheduleAt: null,
    sendStarted: '2026-08-19T08:00:00Z',
    sendCompleted: null,
    recipientCount: 2140,
    createdAt: '2026-08-19T07:30:00Z'
  },
  {
    id: '6',
    title: 'Oppdater appen',
    body: 'Du bruker en gammel versjon. Oppdater for nye funksjoner.',
    appGroupId: 'play',
    targetIds: ['t5'],
    highPriority: false,
    action: 'clear_cache',
    deepLink: null,
    scheduleAt: null,
    sendStarted: null,
    sendCompleted: null,
    recipientCount: 0,
    createdAt: '2026-08-18T12:00:00Z'
  }
]
