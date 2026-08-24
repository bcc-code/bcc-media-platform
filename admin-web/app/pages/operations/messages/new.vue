<script setup lang="ts">
useHead({ title: 'Ny melding' })

const { add, setPlacement } = useMessages()
const toaster = useToast()

const active = ref(true)

const draft = ref<MessageDraft>({ severity: 'info', title: '', body: '' })

const previewMessages = computed(() => [{ id: 'preview', ...draft.value }])

function handleSubmit(data: MessageDraft & { pageIds: string[] }) {
  const { pageIds, ...fields } = data
  const id = crypto.randomUUID()
  add({
    id,
    ...fields,
    active: active.value,
    updatedAt: new Date().toISOString(),
    updatedBy: 'Deg'
  })
  setPlacement(id, pageIds)
  toaster.value.success({
    title: 'Melding opprettet',
    description: active.value
      ? 'Meldingen vises nå i appene.'
      : 'Meldingen er lagret, men vises ikke ennå.'
  })
  navigateTo('/operations')
}
</script>

<template>
  <div class="flex gap-10">
    <div class="flex max-w-2xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/operations" label="Tilbake til drift" />
        <h1 class="text-heading-2 text-text-default">Ny melding</h1>
      </div>

      <MessageForm
        v-model:active="active"
        @submit="handleSubmit"
        @change="draft = $event"
      />
    </div>

    <aside class="hidden lg:block">
      <MessageDevicePreview :messages="previewMessages" />
    </aside>
  </div>
</template>
