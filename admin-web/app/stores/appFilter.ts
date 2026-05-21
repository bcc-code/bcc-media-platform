const ALL = '__all__'

export const useAppFilterStore = defineStore('app-filter', () => {
  const route = useRoute()
  const router = useRouter()

  const selectedApp = ref<string[]>(parseAppsFromQuery() ?? [ALL])

  const appOptions = [
    { label: 'Alle', value: ALL },
    ...mockApplications.map((app) => ({
      label: applicationLabel(app.code),
      value: app.code
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

  function matchesFilter(applicationCode: string): boolean {
    return (
      selectedApp.value.includes(ALL) ||
      selectedApp.value.includes(applicationCode)
    )
  }

  // Keep URL in sync when navigating to a page that uses the filter
  watch(() => route.path, syncToUrl)

  return { selectedApp, appOptions, setSelection, matchesFilter }
})
