<script setup lang="ts">
useHead({ title: 'Sesonger' })

const { seasons } = useSeasons()
const { shows } = useShows()

const showFilter = ref<string[]>([])

const showOptions = computed(() =>
  shows.value.map((s) => ({ label: s.title, value: s.title }))
)

const statusFilter = ref<string[]>([])
const statusOptions = [
  { label: 'Publisert', value: 'published' },
  { label: 'Ikke oppført', value: 'unlisted' },
  { label: 'Utkast', value: 'draft' }
]

const filteredSeasons = computed(() =>
  seasons.value.filter((s) => {
    if (showFilter.value.length > 0 && !showFilter.value.includes(s.show.title))
      return false
    if (statusFilter.value.length > 0 && !statusFilter.value.includes(s.status))
      return false
    return true
  })
)
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Sesonger</h1>
      <NuxtLink to="/seasons/new">
        <DesignButton icon="tabler:plus"> Ny sesong </DesignButton>
      </NuxtLink>
    </div>

    <div class="flex items-center gap-3">
      <DesignSelect
        v-model="showFilter"
        :items="showOptions"
        placeholder="Alle serier"
      />
      <DesignSelect
        v-model="statusFilter"
        :items="statusOptions"
        placeholder="Alle statuser"
      />
    </div>

    <DesignTable
      :columns="['Tittel', 'Sesong', 'Status', 'Aldersgrense']"
      :empty="
        filteredSeasons.length === 0 ? 'Ingen sesonger funnet.' : undefined
      "
    >
      <NuxtLink
        v-for="season in filteredSeasons"
        :key="season.id"
        :to="`/seasons/${season.id}`"
        custom
      >
        <template #default="{ navigate }">
          <SeasonRow :season="season" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
