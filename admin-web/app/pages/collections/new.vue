<script setup lang="ts">
useHead({ title: 'Ny samling' })

const { add } = useCollections()
const toaster = useToast()

function handleSubmit(collection: Collection) {
  add(collection)
  toaster.value.success({
    title: 'Samling opprettet',
    description: 'Samlingen kan nå brukes i en seksjon.'
  })
  navigateTo('/collections')
}
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/collections" label="Tilbake til samlinger" />
      <h1 class="text-heading-2 text-text-default">Ny samling</h1>
    </div>

    <CollectionForm @submit="handleSubmit" />
  </div>
</template>
