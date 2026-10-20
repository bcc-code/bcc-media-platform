// Asks before leaving a page with unsaved changes: in-app navigation gets the
// confirm dialog, closing or reloading the tab gets the browser's prompt.
export function useLeaveGuard(dirty: MaybeRefOrGetter<boolean>) {
  const confirm = useConfirm()
  const { t } = useI18n()
  // Set after a successful save, so its own redirect isn't questioned.
  const allowed = ref(false)

  const blocking = () => toValue(dirty) && !allowed.value

  onBeforeRouteLeave(() => {
    if (!blocking()) return true
    return confirm({
      title: t('common.leaveGuard.title'),
      description: t('common.leaveGuard.description'),
      confirmLabel: t('common.leaveGuard.confirm'),
      cancelLabel: t('common.leaveGuard.cancel'),
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
