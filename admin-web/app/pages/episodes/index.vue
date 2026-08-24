<script setup lang="ts">
useHead({ title: 'Episoder' })

const { episodes, missingVideo } = useEpisodes()

const filter = ref('')
const statusFilter = ref<string[]>([])
const onlyMissingVideo = ref(false)

const statusOptions = [
  { label: 'Publisert', value: 'published' },
  { label: 'Ikke oppført', value: 'unlisted' },
  { label: 'Utkast', value: 'draft' },
  { label: 'Arkivert', value: 'archived' }
]

const filtered = computed(() =>
  episodes.value.filter((e) => {
    if (onlyMissingVideo.value && e.assetId !== null) return false
    if (
      statusFilter.value.length > 0 &&
      !statusFilter.value.includes(e.status)
    ) {
      return false
    }
    const query = filter.value.trim().toLowerCase()
    if (!query) return true
    return (
      e.title.toLowerCase().includes(query) ||
      (e.season?.show.title.toLowerCase().includes(query) ?? false)
    )
  })
)
</script>

<template>
  <div class="flex min-h-1/2 max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">Episoder</h1>
      <DesignTabs :items="episodeTabs" />
      <NuxtLink to="/episodes/new">
        <DesignButton id="episodes-add" icon="tabler:plus">
          Ny episode
        </DesignButton>
      </NuxtLink>
    </div>

    <button
      v-if="missingVideo.length > 0"
      type="button"
      class="cursor-pointer text-left"
      @click="onlyMissingVideo = !onlyMissingVideo"
    >
      <DesignBanner variant="warning" icon="tabler:movie-off">
        <span class="flex-1">
          {{ missingVideo.length }}
          {{
            missingVideo.length === 1 ? 'episode mangler' : 'episoder mangler'
          }}
          video
        </span>
        <span class="text-caption-1 underline">
          {{ onlyMissingVideo ? 'Vis alle' : 'Vis kun disse' }}
        </span>
      </DesignBanner>
    </button>

    <div id="episodes-filter" class="flex items-center gap-3">
      <div class="flex-1">
        <DesignInput
          v-model="filter"
          placeholder="Søk etter episoder..."
          icon="tabler:search"
        />
      </div>
      <DesignSelect
        v-model="statusFilter"
        :items="statusOptions"
        placeholder="Alle statuser"
      />
    </div>

    <DesignTable
      :columns="['Tittel', 'Video', 'Type', 'Status', 'Publisert']"
      :empty="filtered.length === 0 ? 'Ingen episoder funnet.' : undefined"
    >
      <EpisodeRow
        v-for="episode in filtered"
        :key="episode.id"
        :episode="episode"
      />
    </DesignTable>
  </div>
</template>
