<script setup lang="ts">
useHead({ title: 'Ny hendelse' })

const { add } = useCalendarEvents()
const toaster = useToast()

const status = ref<Status>('draft')

function handleSubmit(event: CalendarEvent) {
  add(event)
  toaster.value.success({
    title: 'Hendelse opprettet',
    description: 'Den nye hendelsen ble opprettet.'
  })
  navigateTo('/calendar/events')
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/calendar/events" label="Tilbake til hendelser" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny hendelse</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <CalendarEventForm v-model:status="status" @submit="handleSubmit" />
  </div>
</template>
