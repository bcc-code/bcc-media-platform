const calendarEvents = ref<CalendarEvent[]>([...mockEvents])

export function useCalendarEvents() {
  function add(event: CalendarEvent) {
    calendarEvents.value.unshift(event)
  }

  function update(id: string, data: Partial<CalendarEvent>) {
    const index = calendarEvents.value.findIndex((e) => e.id === id)
    if (index !== -1) {
      calendarEvents.value[index] = {
        ...calendarEvents.value[index]!,
        ...data
      }
    }
  }

  function remove(id: string) {
    calendarEvents.value = calendarEvents.value.filter((e) => e.id !== id)
  }

  return { calendarEvents, add, update, remove }
}
