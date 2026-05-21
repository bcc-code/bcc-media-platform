<script setup lang="ts">
useHead({ title: 'Hendelser' })

const { calendarEvents } = useCalendarEvents()

const sortedEvents = computed(() =>
  [...calendarEvents.value].sort(
    (a, b) => new Date(a.start).getTime() - new Date(b.start).getTime()
  )
)
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Hendelser</h1>
      <NuxtLink to="/calendar/events/new">
        <DesignButton icon="tabler:plus"> Ny hendelse </DesignButton>
      </NuxtLink>
    </div>

    <DesignTable
      :columns="['Tittel', 'Start', 'Slutt', 'Varighet']"
      :empty="sortedEvents.length === 0 ? 'Ingen hendelser.' : undefined"
    >
      <NuxtLink
        v-for="event in sortedEvents"
        :key="event.id"
        :to="`/calendar/events/${event.id}`"
        custom
      >
        <template #default="{ navigate }">
          <CalendarEventRow :event="event" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
