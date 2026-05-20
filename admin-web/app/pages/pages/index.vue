<script setup lang="ts">
useHead({ title: 'Sider' })

const { matchesFilter } = useAppFilter()

const filteredPages = computed(() => {
  return mockPages.filter((p) => matchesFilter(p.applicationCode))
})
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Sider</h1>
      <div class="flex items-center gap-2">
        <AppSelector />
      </div>
    </div>

    <section>
      <div class="mb-4 flex items-center justify-between">
        <h2 class="text-title-1 text-text-default">Alle sider</h2>
        <DesignButton icon="tabler:plus">Ny side</DesignButton>
      </div>

      <DesignTable
        :columns="['Tittel', 'Kode', 'Seksjoner']"
        :empty="
          filteredPages.length === 0
            ? 'Ingen sider funnet for denne appen.'
            : undefined
        "
      >
        <PageRow v-for="page in filteredPages" :key="page.id" :page="page" />
      </DesignTable>
    </section>
  </div>
</template>
