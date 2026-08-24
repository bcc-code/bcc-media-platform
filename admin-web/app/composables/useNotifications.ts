const notifications = ref<PushNotification[]>([...mockNotifications])

export function useNotifications() {
  function add(notification: PushNotification) {
    notifications.value.unshift(notification)
  }

  function update(id: string, data: Partial<PushNotification>) {
    const index = notifications.value.findIndex((n) => n.id === id)
    if (index !== -1) {
      notifications.value[index] = { ...notifications.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    notifications.value = notifications.value.filter((n) => n.id !== id)
  }

  /** Stands in for the send job kicking off. */
  function sendNow(id: string) {
    const now = new Date().toISOString()
    update(id, { scheduleAt: null, sendStarted: now, sendCompleted: now })
  }

  return { notifications, add, update, remove, sendNow }
}
