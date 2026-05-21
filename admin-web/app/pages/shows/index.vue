<script setup lang="ts">
useHead({ title: 'Serier' })

const { shows } = useShows()

const statusFilter = ref<string[]>([])
const statusOptions = [
  { label: 'Publisert', value: 'published' },
  { label: 'Ikke oppført', value: 'unlisted' },
  { label: 'Utkast', value: 'draft' }
]

const filteredShows = computed(() =>
  shows.value.filter((s) => {
    if (statusFilter.value.length > 0 && !statusFilter.value.includes(s.status))
      return false
    return true
  })
)
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Serier</h1>
      <NuxtLink to="/shows/new">
        <DesignButton icon="tabler:plus">Ny serie</DesignButton>
      </NuxtLink>
    </div>

    <div class="flex items-center gap-3">
      <DesignSelect
        v-model="statusFilter"
        :items="statusOptions"
        placeholder="Alle statuser"
      />
    </div>

    <DesignTable
      :columns="['Tittel', 'Sesonger', 'Episoder', 'Status', 'Type']"
      :empty="filteredShows.length === 0 ? 'Ingen serier funnet.' : undefined"
    >
      <NuxtLink
        v-for="show in filteredShows"
        :key="show.id"
        :to="`/shows/${show.id}`"
        custom
      >
        <template #default="{ navigate }">
          <ShowRow :show="show" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
