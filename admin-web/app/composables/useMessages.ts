const messages = ref<AppMessage[]>([...mockMessages])

export function useMessages() {
  const { pages, setSections } = usePages()

  /**
   * A message only reaches an app through a MessageSection on a page, so
   * placement is read out of the pages rather than stored on the message.
   */
  function placementsFor(messageId: string): Page[] {
    return pages.value.filter((page) =>
      page.sections.some(
        (s) => s.type === 'MessageSection' && s.messageId === messageId
      )
    )
  }

  function isPlaced(messageId: string): boolean {
    return placementsFor(messageId).length > 0
  }

  /** Enabled but placed nowhere — switched on, yet invisible to users. */
  const unplacedActive = computed(() =>
    messages.value.filter((m) => m.active && !isPlaced(m.id))
  )

  /** What a user actually sees: enabled *and* placed somewhere. */
  const liveMessages = computed(() =>
    messages.value.filter((m) => m.active && isPlaced(m.id))
  )

  function setPlacement(messageId: string, pageIds: string[]) {
    // Re-read each page inside the loop: setSections replaces the object.
    for (const pageId of pages.value.map((p) => p.id)) {
      const page = pages.value.find((p) => p.id === pageId)
      if (!page) continue

      const has = page.sections.some(
        (s) => s.type === 'MessageSection' && s.messageId === messageId
      )
      const wanted = pageIds.includes(pageId)
      if (has === wanted) continue

      if (wanted) {
        // Banners belong at the top of the page.
        const section = { ...newSection('MessageSection'), messageId }
        setSections(pageId, [section, ...page.sections])
      } else {
        setSections(
          pageId,
          page.sections.filter(
            (s) => !(s.type === 'MessageSection' && s.messageId === messageId)
          )
        )
      }
    }
  }

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
    // Take its sections down with it, or pages keep a dangling reference.
    setPlacement(id, [])
    messages.value = messages.value.filter((m) => m.id !== id)
  }

  return {
    messages,
    liveMessages,
    unplacedActive,
    placementsFor,
    isPlaced,
    setPlacement,
    add,
    update,
    setActive,
    remove
  }
}
