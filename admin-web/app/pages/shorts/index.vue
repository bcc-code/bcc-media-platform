<script setup lang="ts">
useHead({ title: 'Shorts' })

const { shorts, episodeFor } = useShorts()

const filter = ref('')

const rows = computed(() => {
  const query = filter.value.trim().toLowerCase()
  return shorts.value
    .map((short) => ({ short, episode: episodeFor(short) }))
    .filter(({ short, episode }) => {
      if (!query) return true
      return (
        short.title.toLowerCase().includes(query) ||
        (episode?.title.toLowerCase().includes(query) ?? false)
      )
    })
    .sort((a, b) => b.short.createdAt.localeCompare(a.short.createdAt))
})
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-heading-2 text-text-default">Shorts</h1>
        <p class="text-body-3 text-text-muted mt-1">
          Korte klipp hentet ut av en episode.
        </p>
      </div>
      <NuxtLink to="/shorts/new">
        <DesignButton icon="tabler:plus">Ny short</DesignButton>
      </NuxtLink>
    </div>

    <DesignInput
      v-model="filter"
      placeholder="Søk i shorts..."
      icon="tabler:search"
    />

    <DesignTable
      :columns="['Tittel', 'Fra episode', 'Lengde', 'Status', 'Opprettet']"
      :empty="rows.length === 0 ? 'Ingen shorts funnet.' : undefined"
    >
      <ShortRow
        v-for="row in rows"
        :key="row.short.id"
        :short="row.short"
        :episode="row.episode"
      />
    </DesignTable>
  </div>
</template>
