export interface TabItem {
  label: string
  to: string
  icon?: string
}

/**
 * In-page tabs. Each area in the sidebar covers several routes, so the tab bar
 * is what moves between them — see docs/admin-web-scope.md.
 */
export const episodeTabs: TabItem[] = [
  { label: 'Episoder', to: '/episodes', icon: 'tabler:player-play' },
  { label: 'Shorts', to: '/shorts', icon: 'tabler:rectangle-vertical' },
  { label: 'Mediefiler', to: '/assets', icon: 'tabler:movie' },
  // Last because it is the least frequent — shows are rarely created and
  // seasons only once a year.
  { label: 'Serier', to: '/shows', icon: 'tabler:device-tv' }
]

export const calendarTabs: TabItem[] = [
  { label: 'Oppføringer', to: '/calendar/entries', icon: 'tabler:calendar' },
  {
    label: 'Hendelser',
    to: '/calendar/events',
    icon: 'tabler:calendar-event'
  }
]

export const pageTabs: TabItem[] = [
  { label: 'Sider', to: '/pages', icon: 'tabler:file-text' },
  { label: 'Samlinger', to: '/collections', icon: 'tabler:list-details' }
]
