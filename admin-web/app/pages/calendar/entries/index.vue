<script setup lang="ts">
useHead({ title: 'Oppføringer' })

const { calendarEntries } = useCalendarEntries()
const now = useNow({ interval: 60000 })

const sortedEntries = computed(() =>
  [...calendarEntries.value].sort(
    (a, b) => new Date(a.start).getTime() - new Date(b.start).getTime()
  )
)

const groupedByDay = computed(() => {
  const groups: { label: string; date: string; entries: CalendarEntry[] }[] = []

  for (const entry of sortedEntries.value) {
    const date = new Date(entry.start)
    const dateKey = date.toISOString().slice(0, 10)

    const today = now.value.toISOString().slice(0, 10)
    const tomorrow = new Date(now.value.getTime() + 86400000)
      .toISOString()
      .slice(0, 10)

    let label: string
    if (dateKey === today) {
      label = 'I dag'
    } else if (dateKey === tomorrow) {
      label = 'I morgen'
    } else {
      label = date.toLocaleDateString('nb-NO', {
        weekday: 'long',
        day: 'numeric',
        month: 'long'
      })
    }

    const existing = groups.find((g) => g.date === dateKey)
    if (existing) {
      existing.entries.push(entry)
    } else {
      groups.push({ label, date: dateKey, entries: [entry] })
    }
  }

  return groups
})
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Oppføringer</h1>
      <NuxtLink to="/calendar/entries/new">
        <DesignButton icon="tabler:plus"> Ny oppføring </DesignButton>
      </NuxtLink>
    </div>

    <div class="flex flex-col gap-12">
      <section v-for="group in groupedByDay" :key="group.date">
        <h2 class="text-title-2 text-text-muted mb-3 capitalize">
          {{ group.label }}
        </h2>
        <div class="flex flex-col gap-2">
          <NuxtLink
            v-for="entry in group.entries"
            :key="entry.id"
            :to="`/calendar/entries/${entry.id}`"
          >
            <CalendarEntryRow :entry="entry" />
          </NuxtLink>
        </div>
      </section>

      <div
        v-if="sortedEntries.length === 0"
        class="text-body-2 text-text-hint px-4 py-12 text-center"
      >
        Ingen oppføringer i kalenderen.
      </div>
    </div>
  </div>
</template>
