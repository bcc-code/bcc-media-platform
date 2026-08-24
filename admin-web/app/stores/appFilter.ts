const ALL = '__all__'

export const useAppFilterStore = defineStore('app-filter', () => {
  const route = useRoute()
  const router = useRouter()

  const selectedApp = ref<string[]>(parseAppsFromQuery() ?? [ALL])

  // Filters on application group rather than individual app codes — that is
  // the level the admin thinks in, and what notifications target.
  const appOptions = [
    { label: 'Alle', value: ALL },
    ...mockApplicationGroups.map((group) => ({
      label: group.label,
      value: group.id
    }))
  ]

  function parseAppsFromQuery(): string[] | null {
    const query = route.query.apps
    if (!query) return null
    const values = Array.isArray(query) ? query : [query]
    return values.filter((v): v is string => typeof v === 'string')
  }

  function setSelection(value: string[]) {
    selectedApp.value = value
    syncToUrl()
  }

  function syncToUrl() {
    const apps = selectedApp.value.includes(ALL) ? undefined : selectedApp.value
    router.replace({ query: { ...route.query, apps } })
  }

  function matchesFilter(appGroupId: string): boolean {
    return (
      selectedApp.value.includes(ALL) || selectedApp.value.includes(appGroupId)
    )
  }

  // Keep URL in sync when navigating to a page that uses the filter
  watch(() => route.path, syncToUrl)

  return { selectedApp, appOptions, setSelection, matchesFilter }
})
