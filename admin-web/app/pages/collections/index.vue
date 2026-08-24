<script setup lang="ts">
useHead({ title: 'Samlinger' })

const { collections, matchesForQuery, usedBy } = useCollections()

const filter = ref('')

const rows = computed(() => {
  const needle = filter.value.trim().toLowerCase()
  return collections.value
    .filter((c) => !needle || c.name.toLowerCase().includes(needle))
    .map((collection) => ({
      collection,
      count:
        collection.advancedType !== null
          ? null
          : collection.filterType === 'select'
            ? collection.itemRefs.length
            : collection.query
              ? matchesForQuery(collection.query).length
              : 0,
      usedIn: usedBy(collection.id).length
    }))
})
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-heading-2 text-text-default">Samlinger</h1>
        <p class="text-body-3 text-text-muted mt-1">
          Innholdslister som seksjoner henter fra.
        </p>
      </div>
      <NuxtLink to="/collections/new">
        <DesignButton icon="tabler:plus">Ny samling</DesignButton>
      </NuxtLink>
    </div>

    <DesignInput
      v-model="filter"
      placeholder="Søk i samlinger..."
      icon="tabler:search"
    />

    <DesignTable
      :columns="['Navn', 'Type', 'Innhold', 'Brukt i']"
      :empty="rows.length === 0 ? 'Ingen samlinger funnet.' : undefined"
    >
      <tr
        v-for="row in rows"
        :key="row.collection.id"
        class="border-border-1 hover:bg-surface-indent cursor-pointer border-t"
        @click="navigateTo(`/collections/${row.collection.id}`)"
      >
        <td class="px-4 py-3">
          <p class="text-title-3 text-text-default">{{ row.collection.name }}</p>
          <p class="text-caption-1 text-text-hint mt-0.5 font-mono">
            {{ row.collection.id }}
          </p>
        </td>
        <td class="px-4 py-3">
          <DesignBadge
            v-if="row.collection.advancedType"
            variant="info"
          >
            Personlig
          </DesignBadge>
          <DesignBadge
            v-else-if="row.collection.filterType === 'query'"
            variant="warning"
          >
            Spørring
          </DesignBadge>
          <DesignBadge v-else variant="neutral">Håndplukket</DesignBadge>
        </td>
        <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
          <span v-if="row.count === null">Per bruker</span>
          <span v-else>{{ row.count }} elementer</span>
        </td>
        <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
          <span v-if="row.usedIn > 0">
            {{ row.usedIn }} seksjon{{ row.usedIn === 1 ? '' : 'er' }}
          </span>
          <span v-else class="text-text-hint">Ikke i bruk</span>
        </td>
      </tr>
    </DesignTable>
  </div>
</template>
