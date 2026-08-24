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
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Sider</h1>
      <div class="flex items-center gap-2">
        <AppSelector />
      </div>
    </div>

    <section>
      <div class="mb-4 flex items-center justify-between">
        <h2 class="text-title-1 text-text-default">Alle sider</h2>
        <DesignButton icon="tabler:plus" @click="createPage">
          Ny side
        </DesignButton>
      </div>

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
