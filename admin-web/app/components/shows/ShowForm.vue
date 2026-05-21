<script setup lang="ts">
const props = defineProps<{
  show?: Show
}>()

const emit = defineEmits<{
  submit: [data: Show]
  delete: []
}>()

const isEditing = computed(() => !!props.show)

const status = defineModel<Status>('status', { default: 'draft' })

const title = ref(props.show?.title ?? '')
const description = ref(props.show?.description ?? '')
const type = ref<ShowType>(props.show?.type ?? 'series')
const imageUrl = ref(props.show?.imageUrl ?? '')

const submitted = ref(false)

const typeItems = [
  { label: 'Serie', value: 'series', icon: 'tabler:device-tv' },
  { label: 'Arrangement', value: 'event', icon: 'tabler:calendar-event' }
]

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    id: props.show?.id ?? crypto.randomUUID(),
    legacyID: props.show?.legacyID ?? null,
    title: title.value.trim(),
    description: description.value.trim(),
    type: type.value,
    status: status.value,
    imageUrl: imageUrl.value.trim() || null,
    seasonCount: props.show?.seasonCount ?? 0,
    episodeCount: props.show?.episodeCount ?? 0
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett serien?',
    description: 'Denne handlingen kan ikke angres.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (ok) emit('delete')
}
</script>

<template>
  <div class="flex flex-col">
    <div class="flex flex-col gap-4 py-6">
      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Navn på serien"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="description"
        label="Beskrivelse"
        placeholder="Kort beskrivelse av serien"
        :rows="3"
      />
      <DesignInput
        v-model="imageUrl"
        label="Bilde-URL"
        placeholder="/images/show.jpg"
        type="url"
      />
    </div>

    <div class="border-border-1 flex gap-8 border-t py-6">
      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Type</label>
        <DesignSegmentGroup v-model="type" :items="typeItems" />
      </div>
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/shows')"
      >
        Avbryt
      </DesignButton>
      <div v-if="isEditing" class="ml-auto">
        <DesignButton
          variant="tertiary"
          intent="danger"
          icon="tabler:trash"
          @click="handleDelete"
        >
          Slett
        </DesignButton>
      </div>
    </div>
  </div>
</template>
