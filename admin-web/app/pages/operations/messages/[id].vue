<script setup lang="ts">
const route = useRoute()
const { messages, update, remove, setPlacement } = useMessages()
const toaster = useToast()

const message = computed(() =>
  messages.value.find((m) => m.id === route.params.id)
)

useHead({ title: () => message.value?.title ?? 'Rediger melding' })

const active = ref(message.value?.active ?? false)
watch(
  () => message.value?.active,
  (value) => {
    if (value !== undefined) active.value = value
  }
)

const draft = ref<MessageDraft>({
  severity: message.value?.severity ?? 'info',
  title: message.value?.title ?? '',
  body: message.value?.body ?? ''
})

const previewMessages = computed(() => [{ id: 'preview', ...draft.value }])

function handleSubmit(data: MessageDraft & { pageIds: string[] }) {
  const { pageIds, ...fields } = data
  const id = route.params.id as string
  update(id, { ...fields, active: active.value })
  setPlacement(id, pageIds)
  toaster.value.success({
    title: 'Melding oppdatert',
    description: active.value
      ? 'Endringene vises nå i appene.'
      : 'Meldingen er lagret, men vises ikke.'
  })
  navigateTo('/operations')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({ title: 'Melding slettet' })
  navigateTo('/operations')
}
</script>

<template>
  <div v-if="message" class="flex gap-10">
    <div class="flex max-w-2xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/operations" label="Tilbake til drift" />
        <div class="flex items-center justify-between gap-4">
          <h1 class="text-heading-2 text-text-default">Rediger melding</h1>
          <DesignStatusIndicator
            :variant="message.active ? 'success' : 'neutral'"
          >
            {{ message.active ? 'Vises nå' : 'Skjult' }}
          </DesignStatusIndicator>
        </div>
      </div>

      <MessageForm
        v-model:active="active"
        :message="message"
        @submit="handleSubmit"
        @delete="handleDelete"
        @change="draft = $event"
      />
    </div>

    <aside class="hidden lg:block">
      <MessageDevicePreview :messages="previewMessages" />
    </aside>
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Meldingen ble ikke funnet.
  </div>
</template>
