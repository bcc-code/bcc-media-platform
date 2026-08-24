<script setup lang="ts">
const props = defineProps<{
  message?: AppMessage
}>()

const emit = defineEmits<{
  submit: [data: MessageDraft & { pageIds: string[] }]
  delete: []
  change: [draft: MessageDraft]
}>()

const isEditing = computed(() => !!props.message)

const active = defineModel<boolean>('active', { default: false })

const severity = ref<MessageSeverity>(props.message?.severity ?? 'info')
const title = ref(props.message?.title ?? '')
const body = ref(props.message?.body ?? '')
const { pages } = usePages()
const { placementsFor } = useMessages()

// Placement lives on the pages, so seed from there rather than from the message.
const pageIds = ref<string[]>(
  props.message ? placementsFor(props.message.id).map((p) => p.id) : []
)

const submitted = ref(false)

const severityItems = [
  { label: 'Info', value: 'info', icon: 'tabler:info-circle' },
  { label: 'Advarsel', value: 'warning', icon: 'tabler:alert-triangle' },
  { label: 'Feil', value: 'error', icon: 'tabler:alert-octagon' }
]

const pageItems = computed(() =>
  pages.value.map((page) => ({
    label: `${page.title} · ${applicationLabel(page.applicationCode)}`,
    value: page.id
  }))
)

const homePageIds = computed(() =>
  pages.value.filter((p) => p.isHome).map((p) => p.id)
)

function placeOnAllHomePages() {
  pageIds.value = [...new Set([...pageIds.value, ...homePageIds.value])]
}

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    body: !body.value.trim() ? 'Meldingstekst er påkrevd' : undefined,
    // Only blocking when it is switched on: an enabled message with no
    // placement is switched on but invisible.
    pageIds:
      active.value && pageIds.value.length === 0
        ? 'Velg minst én side, ellers vises ikke meldingen noe sted'
        : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    severity: severity.value,
    title: title.value.trim(),
    body: body.value.trim(),
    pageIds: [...pageIds.value]
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett meldingen?',
    description: 'Denne handlingen kan ikke angres.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (ok) emit('delete')
}

// The preview follows what is being typed, not what is saved.
watch(
  [severity, title, body],
  () =>
    emit('change', {
      severity: severity.value,
      title: title.value,
      body: body.value
    }),
  { immediate: true }
)
</script>

<template>
  <div class="flex flex-col">
    <div class="flex flex-col gap-4 py-6">
      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Alvorlighet</label>
        <DesignSegmentGroup v-model="severity" :items="severityItems" />
      </div>

      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Planlagt vedlikehold"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="body"
        label="Meldingstekst"
        placeholder="Kort forklaring på hva som skjer og når det er over."
        :rows="3"
        required
        :invalid="!!errors.body"
        :error-text="errors.body"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-2 border-t py-6">
      <div class="flex items-center justify-between">
        <label class="text-body-3 text-text-muted block">Vises på</label>
        <DesignButton
          size="small"
          variant="tertiary"
          icon="tabler:wand"
          @click="placeOnAllHomePages"
        >
          Alle forsider
        </DesignButton>
      </div>
      <DesignToggleChips v-model="pageIds" :items="pageItems" />
      <p class="text-caption-1 text-text-hint mt-1">
        Meldingen legges øverst på sidene du velger. Den vises ingen steder
        uten minst én side.
      </p>
      <p v-if="errors.pageIds" class="text-caption-1 text-semantic-error mt-1">
        {{ errors.pageIds }}
      </p>
    </div>

    <div class="border-border-1 flex items-start justify-between border-t py-6">
      <div>
        <p class="text-title-3 text-text-default">Vis meldingen nå</p>
        <p class="text-body-3 text-text-muted mt-1">
          Flere meldinger kan være aktive samtidig.
        </p>
      </div>
      <DesignSwitch v-model="active" />
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett melding' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/operations')"
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
