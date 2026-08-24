const messages = ref<AppMessage[]>([...mockMessages])

export function useMessages() {
  const activeMessages = computed(() => messages.value.filter((m) => m.active))

  function add(message: AppMessage) {
    messages.value.unshift(message)
  }

  function update(id: string, data: Partial<AppMessage>) {
    const index = messages.value.findIndex((m) => m.id === id)
    if (index === -1) return
    messages.value[index] = {
      ...messages.value[index]!,
      ...data,
      updatedAt: new Date().toISOString(),
      updatedBy: 'Deg'
    }
  }

  function setActive(id: string, active: boolean) {
    update(id, { active })
  }

  function remove(id: string) {
    messages.value = messages.value.filter((m) => m.id !== id)
  }

  return { messages, activeMessages, add, update, setActive, remove }
}
