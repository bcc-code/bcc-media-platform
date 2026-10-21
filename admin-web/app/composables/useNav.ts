export interface TabItem {
  label: string
  to: string
  icon?: string
}

/**
 * Sidebar areas and in-page tabs. Each area in the sidebar covers several
 * routes, so the tab bar is what moves between them — see
 * docs/admin-web-scope.md.
 *
 * Labels are translated, so these are computed rather than module constants:
 * they have to re-resolve when the language changes.
 */
export function useNav() {
  const { t } = useI18n()

  const episodeTabs = computed<TabItem[]>(() => [
    {
      label: t('nav.tabs.episodes'),
      to: '/episodes',
      icon: 'tabler:player-play'
    },
    {
      label: t('nav.tabs.shorts'),
      to: '/shorts',
      icon: 'tabler:rectangle-vertical'
    },
    { label: t('nav.tabs.assets'), to: '/assets', icon: 'tabler:movie' },
    // Last because it is the least frequent — shows are rarely created and
    // seasons only once a year.
    { label: t('nav.tabs.shows'), to: '/shows', icon: 'tabler:device-tv' }
  ])

  const calendarTabs = computed<TabItem[]>(() => [
    {
      label: t('nav.tabs.calendarEntries'),
      to: '/calendar/entries',
      icon: 'tabler:calendar'
    },
    {
      label: t('nav.tabs.calendarEvents'),
      to: '/calendar/events',
      icon: 'tabler:calendar-event'
    }
  ])

  const pageTabs = computed<TabItem[]>(() => [
    { label: t('nav.tabs.pages'), to: '/pages', icon: 'tabler:file-text' },
    {
      label: t('nav.tabs.collections'),
      to: '/collections',
      icon: 'tabler:list-details'
    }
  ])

  const accessTabs = computed<TabItem[]>(() => [
    {
      label: t('nav.tabs.apiKeys'),
      to: '/access/api-keys',
      icon: 'tabler:key'
    },
    {
      label: t('nav.tabs.roles'),
      to: '/access/roles',
      icon: 'tabler:users-group'
    },
    {
      label: t('nav.tabs.auditLog'),
      to: '/access/audit-log',
      icon: 'tabler:history'
    }
  ])

  return { episodeTabs, calendarTabs, pageTabs, accessTabs }
}
