<script setup lang="ts">
const route = useRoute()
const { collections, update, remove, usedBy } = useCollections()
const toaster = useToast()

const collection = computed(() =>
  collections.value.find((c) => c.id === route.params.id)
)

useHead({ title: () => collection.value?.name ?? 'Rediger samling' })

const usedIn = computed(() =>
  collection.value ? usedBy(collection.value.id) : []
)

function handleSubmit(data: Collection) {
  update(route.params.id as string, data)
  toaster.value.success({
    title: 'Samling oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/collections')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({ title: 'Samling slettet' })
  navigateTo('/collections')
}
</script>

<template>
  <div v-if="collection" class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/collections" label="Tilbake til samlinger" />
      <h1 class="text-heading-2 text-text-default">Rediger samling</h1>
      <p class="text-caption-1 text-text-hint mt-1 font-mono">
        {{ collection.id }}
      </p>
    </div>

    <DesignBanner v-if="usedIn.length > 0" variant="info" icon="tabler:link">
      Brukt i
      {{ usedIn.length }} seksjon{{ usedIn.length === 1 ? '' : 'er' }}:
      {{
        usedIn
          .map((u) => `${u.page.title} → ${u.section.title ?? 'uten tittel'}`)
          .join(', ')
      }}
    </DesignBanner>

    <CollectionForm
      :collection="collection"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Samlingen ble ikke funnet.
  </div>
</template>
