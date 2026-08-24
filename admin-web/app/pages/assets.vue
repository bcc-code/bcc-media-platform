<script setup lang="ts">
useHead({ title: 'Mediefiler' })

// Verification only: files arrive on their own from the export system, so
// there is nothing to trigger here — just confirmation that they landed.
const { assets, linkedEpisode, unlinked } = useAssets()

const filter = ref('')
const onlyUnlinked = ref(false)

const rows = computed(() => {
  const query = filter.value.trim().toLowerCase()
  return assets.value
    .filter((a) => {
      if (onlyUnlinked.value && linkedEpisode(a.id)) return false
      if (!query) return true
      return (
        a.name.toLowerCase().includes(query) ||
        a.mediabankenId.toLowerCase().includes(query)
      )
    })
    .map((asset) => ({ asset, episode: linkedEpisode(asset.id) }))
    .sort((a, b) => b.asset.arrivedAt.localeCompare(a.asset.arrivedAt))
})
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">Mediefiler</h1>
      <DesignTabs :items="episodeTabs" />
    </div>
    <p class="text-body-3 text-text-muted -mt-4">
      Filer som har kommet inn fra eksportsystemet. Koblingen til en episode
      gjøres på episoden.
    </p>

    <button
      v-if="unlinked.length > 0"
      type="button"
      class="cursor-pointer text-left"
      @click="onlyUnlinked = !onlyUnlinked"
    >
      <DesignBanner variant="info" icon="tabler:link-off">
        <span class="flex-1">
          {{ unlinked.length }}
          {{ unlinked.length === 1 ? 'fil er' : 'filer er' }} ikke koblet til en
          episode
        </span>
        <span class="text-caption-1 underline">
          {{ onlyUnlinked ? 'Vis alle' : 'Vis kun disse' }}
        </span>
      </DesignBanner>
    </button>

    <DesignInput
      v-model="filter"
      placeholder="Søk på navn eller Mediabanken-ID..."
      icon="tabler:search"
    />

    <DesignTable
      :columns="['Fil', 'Lengde', 'Kom inn', 'Brukt av']"
      :empty="rows.length === 0 ? 'Ingen filer funnet.' : undefined"
    >
      <AssetRow
        v-for="row in rows"
        :key="row.asset.id"
        :asset="row.asset"
        :episode="row.episode"
      />
    </DesignTable>
  </div>
</template>
