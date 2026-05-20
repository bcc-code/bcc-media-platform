<script setup lang="ts">
const route = useRoute()
const { calendarEvents, update, remove } = useCalendarEvents()
const toaster = useToast()

const event = computed(() =>
  calendarEvents.value.find((e) => e.id === route.params.id)
)

useHead({ title: () => event.value?.title ?? 'Rediger hendelse' })

function handleSubmit(data: CalendarEvent) {
  update(data.id, data)
  toaster.value.success({
    title: 'Hendelse oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/calendar/events')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({
    title: 'Hendelse slettet',
    description: 'Hendelsen ble fjernet.'
  })
  navigateTo('/calendar/events')
}
</script>

<template>
  <div v-if="event" class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/calendar/events" label="Tilbake til hendelser" />
      <h1 class="text-heading-2 text-text-default">Rediger hendelse</h1>
    </div>

    <CalendarEventForm
      :event="event"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Hendelsen ble ikke funnet.
  </div>
</template>
