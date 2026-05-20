const calendarEntries = ref<CalendarEntry[]>([...mockCalendarEntries])

export function useCalendarEntries() {
  function add(entry: CalendarEntry) {
    calendarEntries.value.unshift(entry)
  }

  function update(id: string, data: Partial<CalendarEntry>) {
    const index = calendarEntries.value.findIndex((e) => e.id === id)
    if (index !== -1) {
      calendarEntries.value[index] = {
        ...calendarEntries.value[index]!,
        ...data
      } as CalendarEntry
    }
  }

  function remove(id: string) {
    calendarEntries.value = calendarEntries.value.filter((e) => e.id !== id)
  }

  return { calendarEntries, add, update, remove }
}
