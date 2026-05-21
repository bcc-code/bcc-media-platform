export function useAppFilter() {
  const store = useAppFilterStore()
  return {
    selectedApp: computed({
      get: () => store.selectedApp,
      set: (v: string[]) => store.setSelection(v)
    }),
    appOptions: store.appOptions,
    matchesFilter: store.matchesFilter
  }
}
