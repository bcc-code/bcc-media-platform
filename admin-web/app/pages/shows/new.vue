<script setup lang="ts">
useHead({ title: 'Ny serie' })

const { add } = useShows()
const toaster = useToast()

const status = ref<Status>('draft')

function handleSubmit(show: Show) {
  add(show)
  toaster.value.success({
    title: 'Serie opprettet',
    description: 'Den nye serien ble opprettet.'
  })
  navigateTo('/shows')
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/shows" label="Tilbake til serier" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny serie</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <ShowForm v-model:status="status" @submit="handleSubmit" />
  </div>
</template>
