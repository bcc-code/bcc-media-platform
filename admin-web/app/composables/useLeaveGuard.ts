// Asks before leaving a page with unsaved changes: in-app navigation gets the
// confirm dialog, closing or reloading the tab gets the browser's prompt.
export function useLeaveGuard(dirty: MaybeRefOrGetter<boolean>) {
  const confirm = useConfirm()
  // Set after a successful save, so its own redirect isn't questioned.
  const allowed = ref(false)

  const blocking = () => toValue(dirty) && !allowed.value

  onBeforeRouteLeave(() => {
    if (!blocking()) return true
    return confirm({
      title: 'Du har ulagrede endringer',
      description:
        'Endringene går tapt hvis du forlater siden. Vil du forlate den?',
      confirmLabel: 'Forlat siden',
      cancelLabel: 'Bli på siden',
      intent: 'danger'
    })
  })

  useEventListener(window, 'beforeunload', (e: BeforeUnloadEvent) => {
    if (blocking()) e.preventDefault()
  })

  return {
    allowLeave() {
      allowed.value = true
    }
  }
}
