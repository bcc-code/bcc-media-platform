<script setup lang="ts">
useHead({ title: 'Sider' })

const { pages, add } = usePages()
const { matchesFilter } = useAppFilter()
const toaster = useToast()

const filteredPages = computed(() =>
  pages.value.filter((p) =>
    matchesFilter(applicationGroupForCode(p.applicationCode))
  )
)

function createPage() {
  const id = crypto.randomUUID()
  add({
    id,
    code: 'ny-side',
    isHome: false,
    status: 'draft',
    title: 'Ny side',
    description: null,
    applicationCode: 'bccm-mobile',
    sections: []
  })
  toaster.value.success({
    title: 'Side opprettet',
    description: 'Gi siden en tittel og kode i innstillingene.'
  })
  navigateTo(`/pages/${id}`)
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">Sider</h1>
      <DesignTabs :items="pageTabs" />
      <div class="flex items-center gap-3">
        <AppSelector />
        <DesignButton icon="tabler:plus" @click="createPage">
          Ny side
        </DesignButton>
      </div>
    </div>

    <section>
      <DesignTable
        :columns="['Tittel', 'Kode', 'App', 'Seksjoner', 'Status']"
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
