<script setup lang="ts">
useHead({ title: 'Ny sesong' })

const { add } = useSeasons()
const toaster = useToast()

const status = ref<Status>('draft')

const route = useRoute()
// Reached from a show page, so it preselects and returns there.
const presetShowId = computed(() =>
  typeof route.query.show === 'string' ? route.query.show : undefined
)
const backTo = computed(() =>
  presetShowId.value ? `/shows/${presetShowId.value}` : '/shows'
)

function handleSubmit(season: Season) {
  add(season)
  toaster.value.success({
    title: 'Sesong opprettet',
    description: 'Den nye sesongen ble opprettet.'
  })
  navigateTo(backTo.value)
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton :to="backTo" label="Tilbake til serien" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny sesong</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <SeasonForm
      v-model:status="status"
      :preset-show-id="presetShowId"
      @submit="handleSubmit"
    />
  </div>
</template>
