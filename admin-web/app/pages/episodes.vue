<script setup lang="ts">
useHead({ title: 'Episoder' })

const filter = ref('')
const { episodes, fetching, error } = useEpisodes(filter)
</script>

<template>
  <div class="flex min-h-1/2 max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Episoder</h1>
      <DesignButton id="episodes-add" icon="tabler:plus">
        Ny episode
      </DesignButton>
    </div>

    <div id="episodes-filter" class="flex items-center gap-3">
      <DesignInput
        v-model="filter"
        placeholder="Sok etter episoder..."
        icon="tabler:search"
      />
    </div>

    <DesignErrorState v-if="error" v-bind="formatGraphQLError(error)" />

    <DesignLoadingState v-else-if="fetching" />

    <DesignTable
      v-else
      :columns="['ID', 'Tittel', 'Type']"
      :empty="episodes.length === 0 ? 'Ingen episoder funnet.' : undefined"
    >
      <tr
        v-for="episode in episodes"
        :key="episode.id"
        class="border-border-1 hover:bg-surface-indent border-t"
      >
        <td class="text-body-3 text-text-muted px-4 py-3">
          {{ episode.id }}
        </td>
        <td class="text-title-3 text-text-default px-4 py-3">
          {{ episode.title }}
        </td>
        <td class="px-4 py-3">
          <DesignBadge variant="neutral">
            {{ episode.collection }}
          </DesignBadge>
        </td>
      </tr>
    </DesignTable>
  </div>
</template>
